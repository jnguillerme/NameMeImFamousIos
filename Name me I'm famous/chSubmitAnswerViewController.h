//
//  chSubmitAnswerViewController.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 23/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMHelper.h"

@interface chSubmitAnswerViewController : UIViewController<GMHelperDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tfCelebrity;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property BOOL IWon;

@end
