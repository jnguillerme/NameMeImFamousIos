//
//  chNewGameViewController.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 26/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMHelper.h"
#import "PAMHelper.h"

@interface chNewGameViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, GMHelperDelegate, PAMHelperDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tvMenu;
@property (nonatomic, retain) NSArray *menu;
@end
