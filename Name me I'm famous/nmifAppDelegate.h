//
//  nmifAppDelegate.h
//  Name me I'm famous
//
//  Created by Jino on 12/11/2012.
//  Copyright (c) 2012 nmif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAMHelper.h"

@interface nmifAppDelegate : UIResponder <UIApplicationDelegate, PAMHelperDelegate>

@property (strong, nonatomic) UIWindow *window;



/// Facebook support
//extern NSString *const FBSessionStateChangedNotification;

//- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
@end

