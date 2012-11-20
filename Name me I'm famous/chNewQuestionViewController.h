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

@interface chNewQuestionViewController : UIViewController<GMHelperDelegate>

@property NSInteger questionNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblQuestion;
@property (weak, nonatomic) IBOutlet UITextField *textFieldQuestion;

@property (strong, nonatomic) nmifQuestion* question;
@property (strong, nonatomic) NSString * questionLabel;

-(IBAction)textFieldQuestionReturn:(id)sender;
-(IBAction) backgroundTouched:(id)sender;

-(void) setQuestionNumberToNext;
@end
