//
//  chWaitForQuestionViewController.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 30/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMHelper.h"
#import "nmifMenuAnswerQuestionTableView.h"

@interface chWaitForQuestionViewController : UIViewController<GMHelperDelegate, GMRestoreViewDelegate, nmifMenuAnswerQuestionTableViewDelegate> {
    NSString* celebrityToFind;
    BOOL IWon;
    nmifMenuAnswerQuestionTableView *menuTableView;
    NSString *questionAsked;
};

@property (weak, nonatomic) IBOutlet UILabel *lblQuestionAsked;
@property (weak, nonatomic) IBOutlet UILabel *lblOpponentStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblOpponentCelebrity;
@property (weak, nonatomic) IBOutlet UITableView *tvMenu;

@property (weak, nonatomic) IBOutlet UIButton *btnParam;
@property (strong, nonatomic) NSString *questionID;
@end
