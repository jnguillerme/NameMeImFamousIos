//
//  chQuestionAnswerViewController.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 26/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nmifQuestion.h"
#import "GMHelper.h"
#import "nmifMenuQuestionAnswerTableView.h"

@interface chQuestionAnswerViewController : UIViewController<GMHelperDelegate, GMRestoreViewDelegate, nmifMenuQuestionAnswerTableViewDelegate>
{
    nmifMenuQuestionAnswerTableView *menuTableView;
}
@property (weak, nonatomic) IBOutlet UILabel *lblQuestion;
@property (weak, nonatomic) IBOutlet UILabel *lblAnswer;
@property (weak, nonatomic) IBOutlet UILabel *lblOpponentStatus;
@property (weak, nonatomic) IBOutlet UITableView *tvMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnParam;

@property (strong, nonatomic) nmifQuestion* question;
@end
