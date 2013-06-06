//
//  nmifGameInProgressViewController.h
//  Name me I'm famous
//
//  Created by Jino on 19/02/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMHelper.h"
#import "nmifGameInProgressTableView.h"
#import "nmifMenuTableView.h"

@interface nmifGameInProgressViewController : UIViewController<GMHelperDelegate, nmifMenuTableViewDelegate, nmifGameInProgressTableViewDelegate> {
    nmifMenuTableView *menuTableView;
    nmifGameInProgressTableView *gipTableView;
}
@property (weak, nonatomic) IBOutlet UITableView *tvMenu;
@property (weak, nonatomic) IBOutlet UITableView *tvGameInProgress;

@property (weak, nonatomic) IBOutlet UILabel *lblNmifTitle;

@property (weak, nonatomic) IBOutlet UIButton *btnParam;

@end
