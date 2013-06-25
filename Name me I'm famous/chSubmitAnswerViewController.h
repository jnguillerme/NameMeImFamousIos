//
//  chSubmitAnswerViewController.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 23/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMHelper.h"
#import "nmifCelebrityListViewController.h"
#import "nmifMenuSubmitCelebrityTableView.h"

@interface chSubmitAnswerViewController : UIViewController<GMHelperDelegate, GMRestoreViewDelegate, nmifCelebrityChoiceDelegate, nmifMenuCelebritySubmitTableViewDelegate> {
    BOOL IWon;
    NSString* celebrityToFind;
    nmifMenuSubmitCelebrityTableView *menuTableView;
};

@property (weak, nonatomic) IBOutlet UITextField *tfCelebrity;

@property (weak, nonatomic) IBOutlet UILabel *lblOpponentStatus;
@property (weak, nonatomic) IBOutlet UITableView *tvMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnParam;

@end
