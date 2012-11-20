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

NSString * const K_LOGIN_KEY = @"KompLoginKey";
NSString * const K_PASSWORD_KEY = @"KompPasswordKey";

NSString * const K_CREATE_PLAYER_ACCOUNT_URL = @"http://89.226.34.6:8081/createPlayerAccount";
NSString * const K_LOGIN_PLAYER_ACCOUNT_URL  = @"http://89.226.34.6:8081/loginPlayerAccount";
NSString * const K_LOGOUT_PLAYER_ACCOUNT_URL  = @"http://89.226.34.6:8081/logoutPlayerAccount";
NSString * const K_PING_PLAYER_ACCOUNT_URL  = @"http://89.226.34.6:8081/pingPlayerAccount";

@synthesize delegate;
@synthesize sessionID;

static PAMHelper * sharedHelper = 0;

+ (PAMHelper*) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[PAMHelper alloc] init];
    }
    return sharedHelper;
}

#pragma mark - xmlHttpRequest send

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

- (void) loginAccount:(NSString*)login withPassword:(NSString*)password withDelegate:(id <PAMHelperDelegate>)PAMDelegate
{
    NSURL *url = [NSURL URLWithString:K_LOGIN_PLAYER_ACCOUNT_URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:login  forKey:@"login"];
    [request setPostValue:password  forKey:@"password"];

    self.delegate = PAMDelegate;

    [request setDelegate:self];
    [request startAsynchronous];    
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
    
    if ([success compare:@"0"] == NSOrderedSame) {
        NSString *errorMsg = [responseDict objectForKey:@"error"]; 
        [self notifyDelegateOfRequestError:errorMsg withUrl:url];
     
    } else { 
        if ([url compare:K_CREATE_PLAYER_ACCOUNT_URL] == NSOrderedSame) {           // account successfully created        
            [delegate onAccountCreationSuccess];
        } else if ([url compare:K_LOGIN_PLAYER_ACCOUNT_URL] == NSOrderedSame) {
            // update session IDs
            [self setSessionID:[responseDict objectForKey:@"ID"]];
            [[GMHelper sharedInstance] setSessionID:[responseDict objectForKey:@"ID"]];
            
            // subscribe to notifications
            [[GMHelper sharedInstance] subscribeToNotifications];
            
            // start ping
            [NSTimer scheduledTimerWithTimeInterval:100 target:self selector:@selector(ping) userInfo:nil repeats:YES];
            // notify delegate
            [delegate onLoginSuccess];                        
        } else if ([url compare:K_LOGOUT_PLAYER_ACCOUNT_URL] == NSOrderedSame) {
            [delegate onLogoutSuccess];            
        }
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = request.error;
    NSString * url = [[request url] absoluteString]; 
    [self notifyDelegateOfRequestError:[error localizedDescription] withUrl:url];
}

-(void) notifyDelegateOfRequestError:(NSString *)error withUrl:(NSString *)url 
{
    if ([url compare:K_CREATE_PLAYER_ACCOUNT_URL] == NSOrderedSame) {           // account successfully created        
        [delegate onAccountCreationFailed:error];
    } else if ([url compare:K_LOGIN_PLAYER_ACCOUNT_URL] == NSOrderedSame) {
        [delegate onLoginFailed:error];            
    } else if ([url compare:K_LOGOUT_PLAYER_ACCOUNT_URL] == NSOrderedSame) {
        [delegate onLogoutFailed:error];            
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
    [self loginAccount:[standardUserDefaults objectForKey:K_LOGIN_KEY] withPassword:[standardUserDefaults objectForKey:K_PASSWORD_KEY] withDelegate:PAMDelegate];   
}

-(void) clearCredentials
{
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults removeObjectForKey:K_LOGIN_KEY];
    [standardUserDefaults removeObjectForKey:K_PASSWORD_KEY];
    [standardUserDefaults synchronize];
}


@end
