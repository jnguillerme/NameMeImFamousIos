//
//  chNewQuestionViewController.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 26/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMHelper.h"
#import "nmifQuestion.h"
#import "nmifMenuAskQuestionTableView.h"

@interface chNewQuestionViewController : UIViewController<GMHelperDelegate, GMRestoreViewDelegate, nmifMenuAskQuestionTableViewDelegate> {
    nmifMenuAskQuestionTableView *menuTableView;
    NSString *questionAsked;
}

@property NSInteger questionNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblQuestion;
@property (weak, nonatomic) IBOutlet UITextField *textFieldQuestion;

@property (strong, nonatomic) nmifQuestion* question;
@property (strong, nonatomic) NSString * questionLabel;

-(IBAction)textFieldQuestionReturn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblOpponentStatus;
@property (weak, nonatomic) IBOutlet UITableView *tvMenu;

@property (weak, nonatomic) IBOutlet UIButton *btnParam;
-(void) setQuestionNumberToNext;
@end
