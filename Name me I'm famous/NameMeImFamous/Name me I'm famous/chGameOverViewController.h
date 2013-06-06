//
//  chGameOverViewController.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 05/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nmifMenuGameOverTableView.h"

@interface chGameOverViewController : UIViewController<nmifMenuGameOverTableViewDelegate> {
    nmifMenuGameOverTableView *menuTableView;
}

@property BOOL gameWon;
@property (weak, nonatomic) IBOutlet UILabel *lblGameStatus;
@property (weak, nonatomic) NSString* celebrityToFind;
@property (weak, nonatomic) IBOutlet UITableView *tvMenu;
@end
