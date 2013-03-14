//
//  nmifAppDelegate.m
//  Name me I'm famous
//
//  Created by Jino on 12/11/2012.
//  Copyright (c) 2012 nmif. All rights reserved.
//

#import "nmifAppDelegate.h"
#import "PAMHelper.h"
#import "chNewGameViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation nmifAppDelegate

@synthesize window = _window;


NSString *const FBSessionStateChangedNotification =@"335852886514062:FBSessionStateChangedNotification";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // let the device know we want to receive push notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    [[PAMHelper sharedInstance] logoutAccount:self];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([[PAMHelper sharedInstance] hasStoredCredentials]) {
        [[PAMHelper sharedInstance] authenticateLocalUser:self];
    } else {
        [[self.window.rootViewController navigationController] popToRootViewControllerAnimated:TRUE];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[PAMHelper sharedInstance] logoutAccount:self];
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}
- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

- (void)onLoginSuccess
{
    // RESUME GAME IN PROGRESS
    [[self.window.rootViewController navigationController] performSegueWithIdentifier:@"chooseCelebrityName" sender:[self.window.rootViewController navigationController]];
}

- (void)onLoginFailed:(NSString*)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Login failed" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
- (void)onLogoutSuccess
{
    [self closeFBSession];
}

- (void)onLogoutFailed:(NSString*)error
{
}

#pragma GMHelperDelegate
-(void)onNewCelebrity:(NSString *)name withRole:(NSString *)role
{
    // ADD TO LOCAL DATABASE
}

///
// FACEBOOK support
///
/*
 * Callback for session changes.
 */

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                /// should DEFINE a FBDelegate within nmifAppDelegate for view controller to implement
                
                // get user name
                [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser>*user, NSError* error) {
                    if (!error) {
                        [fbDelegate facebookDidLogin:user.name];
                    }
                }];

            }
            break;        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FBSessionStateChangedNotification object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openFBSessionWithAllowLoginUI:(BOOL)allowLoginUI withDelegate:(id<FBAppDelegate>)delegate
{
    fbDelegate = delegate;
  /*  return [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:allowLoginUI completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
        [self sessionStateChanged:session state:state error:error];
    }];*/
    
    NSDictionary *infoDict =  [[NSBundle mainBundle] infoDictionary];
    FBSession *mySession = [[FBSession alloc] initWithAppID:[infoDict objectForKey:@"FacebookAppID"] permissions:nil urlSchemeSuffix:@"fb335852886514062" tokenCacheStrategy:nil];
    [FBSession setActiveSession:mySession];
    [mySession openWithBehavior:FBSessionLoginBehaviorForcingWebView completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
        [self sessionStateChanged:session state:state error:error];
    }];
    
    return true;
}

/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

/*
 * Closes a Facebook session
 */
- (void) closeFBSession {
    if (FBSession.activeSession.isOpen ) {
        [FBSession.activeSession closeAndClearTokenInformation];
    }
}

-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"My token is %@", deviceToken);
}

-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

@end
		