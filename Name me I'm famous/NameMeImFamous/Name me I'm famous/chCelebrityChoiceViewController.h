//
//  chCelebrityChoiceViewController.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 26/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMHelper.h"
#import "nmifCelebrityListViewController.h"
#import "nmifMenuCelebrityChoiceTableView.h"

@interface chCelebrityChoiceViewController : UIViewController<GMHelperDelegate, GMRestoreViewDelegate, nmifCelebrityChoiceDelegate, nmifMenuCelebrityChoiceTableViewDelegate> {
    nmifMenuCelebrityChoiceTableView *menuTableView;
}

@property (weak, nonatomic) IBOutlet UILabel *lblOpponentFound;

@property (weak, nonatomic) IBOutlet UITextField *lblCelebrityName;
@property (weak, nonatomic) IBOutlet UILabel *lblOpponentStatus;

@property (weak, nonatomic) IBOutlet UITableView *tvMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnParam;

@end
