//
//  chWaitForQuestionViewController.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 30/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMHelper.h"

@interface chWaitForQuestionViewController : UIViewController<GMHelperDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblQuestionAsked;

@property (strong, nonatomic) NSString *questionID;
@property BOOL IWon;
@end
