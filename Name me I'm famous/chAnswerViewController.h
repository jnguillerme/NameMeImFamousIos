//
//  chAnswerViewController.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 26/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nmifQuestion.h"

@interface chAnswerViewController : UIViewController

@property (strong, nonatomic) nmifQuestion* question;
@property (weak, nonatomic) IBOutlet UILabel *lblQuestion;

@end
