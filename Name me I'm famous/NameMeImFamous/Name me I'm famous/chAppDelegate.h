//
//  chAppDelegate.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 26/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAMHelper.h"

@interface chAppDelegate : UIResponder <UIApplicationDelegate, PAMHelperDelegate>

@property (strong, nonatomic) UIWindow *window;



/// Facebook support
//extern NSString *const FBSessionStateChangedNotification;

//- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
@end
