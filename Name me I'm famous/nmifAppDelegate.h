//
//  nmifAppDelegate.h
//  Name me I'm famous
//
//  Created by Jino on 12/11/2012.
//  Copyright (c) 2012 nmif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAMHelper.h"
#import "GMHelper.h"

@protocol FBAppDelegate
- (void)facebookDidLogin:(NSString*)userName;
@end

@interface nmifAppDelegate : UIResponder <UIApplicationDelegate, PAMHelperDelegate, GMHelperDelegate> {
    id <FBAppDelegate> fbDelegate;
}
@property (strong, nonatomic) UIWindow *window;

/// Facebook support
extern NSString *const FBSessionStateChangedNotification;
- (BOOL)openFBSessionWithAllowLoginUI:(BOOL)allowLoginUI withDelegate:(id<FBAppDelegate>)delegate;
- (void)closeFBSession;

@property BOOL fbConnection;

@end

