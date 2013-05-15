//
//  PAMHelper.m
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 25/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PAMHelper.h"
#import "GMHelper.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"

@implementation PAMHelper

NSString * const K_LOGIN_KEY = @"NMIF.LOGIN.KEY";
NSString * const K_PASSWORD_KEY = @"NMIF.PASSWORD.KEY";
NSString * const K_DEVICE_TOKEN_KEY = @"NMIF.DEVICETOKEN.KEY";
//89.226.34.6
// AMZON 54.247.53.94
NSString * const K_CREATE_PLAYER_ACCOUNT_URL = @"http://54.247.53.94:8081/createPlayerAccount";
NSString * const K_LOGIN_PLAYER_ACCOUNT_URL  = @"http://54.247.53.94:8081/loginPlayerAccount";
NSString * const K_LOGOUT_PLAYER_ACCOUNT_URL  = @"http://54.247.53.94:8081/logoutPlayerAccount";
NSString * const K_FORGOT_PASSWORD_URL = @"http://54.247.53.94:8081/forgotPassword";
NSString * const K_PING_PLAYER_ACCOUNT_URL  = @"http://54.247.53.94:8081/pingPlayerAccount";

@synthesize delegate;
@synthesize sessionID;
@synthesize deviceToken = _deviceToken;

static PAMHelper * sharedHelper = 0;

+ (PAMHelper*) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[PAMHelper alloc] init];
    }
    return sharedHelper;
}

-(NSString*) deviceToken
{
    if (_deviceToken == nil) {
        NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
        return [standardUserDefaults objectForKey:K_DEVICE_TOKEN_KEY];
    } else {
        return _deviceToken;
    }
}

-(void) setDeviceToken:(NSString *)deviceToken
{
    _deviceToken = deviceToken;
    
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:_deviceToken forKey:K_DEVICE_TOKEN_KEY];
    [standardUserDefaults synchronize];
}

-(id) init {
    self = [super init];
    if (self) {
        sessionID = nil;
        fConnectionInProgress = false;
    }
    return self;
}

#pragma mark - xmlHttpRequest send

-(BOOL) isConnected {
    return (fConnectionInProgress || sessionID != nil);
}
- (void) createAccount:(NSString*)login withPassword:(NSString*)password withFullName:(NSString*)fullName withEMail:(NSString*)email withDelegate:(id <PAMHelperDelegate>)PAMDelegate
{
    NSURL *url = [NSURL URLWithString:K_CREATE_PLAYER_ACCOUNT_URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:login  forKey:@"login"];
    [request setPostValue:password  forKey:@"password"];
    [request setPostValue:email  forKey:@"email"];
    [request setPostValue:fullName  forKey:@"fullName"];
 
    self.delegate = PAMDelegate;
    
    [request setDelegate:self];
    [request startAsynchronous];
}


- (void) loginAccount:(NSString*)login withPassword:(NSString*)password andAccountType:(NSString*)accountType withDelegate:(id <PAMHelperDelegate>)PAMDelegate
{
    if (!self.isConnected) {
        NSURL *url = [NSURL URLWithString:K_LOGIN_PLAYER_ACCOUNT_URL];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue:login  forKey:@"login"];
        [request setPostValue:password  forKey:@"password"];
        [request setPostValue:accountType  forKey:@"accountType"];
        [request setPostValue:[self deviceToken] forKey:@"deviceToken"];
	    
        self.accountType = accountType;
        self.delegate = PAMDelegate;
        
        [request setDelegate:self];
        
        fConnectionInProgress = true;
        [request startAsynchronous];
    }
}

- (void) logoutAccount:(id <PAMHelperDelegate>)PAMDelegate
{
    NSURL *url = [NSURL URLWithString:K_LOGOUT_PLAYER_ACCOUNT_URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:sessionID  forKey:@"ID"];
    
    self.delegate = PAMDelegate;
    
    [request setDelegate:self];
    [request startAsynchronous];     
}

- (void) forgotPassword:(NSString*)login withDelegate:(id <PAMHelperDelegate>)myDelegate
{
    NSURL *url = [NSURL URLWithString:K_FORGOT_PASSWORD_URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:login  forKey:@"login"];

    self.delegate = myDelegate;
    
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void) ping
{
    NSURL *url = [NSURL URLWithString:K_PING_PLAYER_ACCOUNT_URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:sessionID  forKey:@"ID"];
        
    [request setDelegate:self];
    [request startAsynchronous];        
}


#pragma mark - xmlHttpRequest answers

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *responseDict = [responseString JSONValue];
    NSString *success = [responseDict objectForKey:@"success"];
    NSString * url = [[request url] absoluteString]; 
    NSLog(@"xmlHttpRequest %@ replied %@", url, responseString);
    if ([success compare:@"0"] == NSOrderedSame) {
        NSString *errorMsg = [responseDict objectForKey:@"error"]; 
        [self notifyDelegateOfRequestError:errorMsg withUrl:url];
     
    } else { 
        if ([url compare:K_CREATE_PLAYER_ACCOUNT_URL] == NSOrderedSame) {           // account successfully created        
            [delegate onAccountCreationSuccess];
        } else if ([url compare:K_LOGIN_PLAYER_ACCOUNT_URL] == NSOrderedSame) {
            // update session IDs
            fConnectionInProgress = false;
            [self setSessionID:[responseDict objectForKey:@"ID"]];
            [[GMHelper sharedInstance] setSessionID:[responseDict objectForKey:@"ID"]];
            
            // subscribe to notifications
            [[GMHelper sharedInstance] subscribeToNotifications:(id<GMHelperDelegate>)delegate];
            
            // start ping
      //      [NSTimer scheduledTimerWithTimeInterval:100 target:self selector:@selector(ping) userInfo:nil repeats:YES];
            // notify delegate
            [delegate onLoginSuccess];                        
        } else if ([url compare:K_LOGOUT_PLAYER_ACCOUNT_URL] == NSOrderedSame) {
            // unsubscribe from notification
            [[GMHelper sharedInstance] unsubscribeFromNotifications];
            sessionID = nil;
            [[GMHelper sharedInstance] setSessionID:nil];
            [delegate onLogoutSuccess];            
        } else if ([url compare:K_FORGOT_PASSWORD_URL] == NSOrderedSame) {
            [delegate onPasswordReset:[responseDict objectForKey:@"email"]];
        }
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = request.error;
    NSString * url = [[request url] absoluteString]; 
    [self notifyDelegateOfRequestError:[error localizedDescription] withUrl:url];
}

-(NSString*) decodeLoginError:(NSString*)error {
    NSString * errorMessage =  [NSString stringWithFormat:@"LOGIN_FAILED_%@", error];
    return NSLocalizedString(errorMessage, nil);
}
-(NSString*) decodeAccountCreationError:(NSString*)error {
    NSString * errorMessage =  [NSString stringWithFormat:@"ACCOUNT_CREATION_FAILED_%@", error];
    return NSLocalizedString(errorMessage, nil);
}
-(void) notifyDelegateOfRequestError:(NSString *)error withUrl:(NSString *)url 
{
    if ([url compare:K_CREATE_PLAYER_ACCOUNT_URL] == NSOrderedSame) {           // account successfully created        
        [delegate onAccountCreationFailed:[self decodeAccountCreationError:error]];
    } else if ([url compare:K_LOGIN_PLAYER_ACCOUNT_URL] == NSOrderedSame) {
        fConnectionInProgress = false;
        [delegate onLoginFailed:[self  decodeLoginError:error]];
    } else if ([url compare:K_LOGOUT_PLAYER_ACCOUNT_URL] == NSOrderedSame) {
        [delegate onLogoutSuccess];     // doesn't make sense to have logout fail - so tell the application the logout was successful
    } else if ([url compare:K_FORGOT_PASSWORD_URL] == NSOrderedSame) {
        [delegate onPasswordResetFailed:error];
    }
}
#pragma mark - local data storage management

- (void) saveCredentials:(NSString*)login withPassword:(NSString*)password
{
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:login forKey:K_LOGIN_KEY];
    [standardUserDefaults setObject:password forKey:K_PASSWORD_KEY];
    [standardUserDefaults synchronize];
}

- (bool) hasStoredCredentials
{
    return ([[NSUserDefaults standardUserDefaults] objectForKey:K_LOGIN_KEY] != nil);
}

- (void) authenticateLocalUser:(id <PAMHelperDelegate>)PAMDelegate
{
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [self loginAccount:[standardUserDefaults objectForKey:K_LOGIN_KEY] withPassword:[standardUserDefaults objectForKey:K_PASSWORD_KEY] andAccountType:@"internal" withDelegate:PAMDelegate];
}

-(void) clearCredentials
{
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults removeObjectForKey:K_LOGIN_KEY];
    [standardUserDefaults removeObjectForKey:K_PASSWORD_KEY];
    [standardUserDefaults synchronize];
}

@end
