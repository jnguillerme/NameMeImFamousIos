//
//  chViewController.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 26/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nmifAppDelegate.h"
#import "nmifMenuNewGameTableView.h"
#import "GMHelper.h"

@interface chViewController : UIViewController<FBAppDelegate, PAMHelperDelegate, GMHelperDelegate, nmifMenuNewGameTableViewDelegate> {
    nmifMenuTableView *menuTableView;
}

@property (weak, nonatomic) IBOutlet UITableView *tvMenu;
@end
