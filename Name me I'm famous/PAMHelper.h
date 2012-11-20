//
//  PAMHelper.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 25/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PAMHelperDelegate
- (void)onAccountCreationSuccess;
- (void)onLoginSuccess;
- (void)onLogoutSuccess;

- (void)onAccountCreationFailed:(NSString*)error;
- (void)onLoginFailed:(NSString*)error;
- (void)onLogoutFailed:(NSString*)error;
@end


@interface PAMHelper : NSObject {    
    id <PAMHelperDelegate> delegate;
    NSString *sessionID;
}
 
// player account management constants
extern NSString * const K_LOGIN_KEY;
extern NSString * const K_PASSWORD_KEY;

extern NSString * const K_CREATE_PLAYER_ACCOUNT_URL;
extern NSString * const K_LOGIN_PLAYER_ACCOUNT_URL;
extern NSString * const K_LOGOUT_PLAYER_ACCOUNT_URL;
extern NSString * const K_PING_PLAYER_ACCOUNT_URL;

+ (PAMHelper*) sharedInstance;

@property (nonatomic, retain) id <PAMHelperDelegate> delegate;
@property (nonatomic, retain) NSString *sessionID;


// methods
- (void) createAccount:(NSString*)login withPassword:(NSString*)password withFullName:(NSString*)fullName withEMail:(NSString*)email withDelegate:(id <PAMHelperDelegate>)delegate;
- (void) loginAccount:(NSString*)login withPassword:(NSString*)password withDelegate:(id <PAMHelperDelegate>)delegate;
- (void) logoutAccount:(id <PAMHelperDelegate>)PAMDelegate;
- (void) saveCredentials:(NSString*)login withPassword:(NSString*)password;
- (bool) hasStoredCredentials;
- (void) authenticateLocalUser:(id <PAMHelperDelegate>)delegate;
- (void) clearCredentials;

-(void) notifyDelegateOfRequestError:(NSString*)error withUrl:(NSString*)url;



@end
