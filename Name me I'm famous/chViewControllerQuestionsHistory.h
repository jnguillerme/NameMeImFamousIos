//
//  chViewControllerQuestionsHistory.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 06/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMHelper.h"

@interface chViewControllerQuestionsHistory : UIViewController<UITableViewDelegate, UITableViewDataSource, GMHelperDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tvQuestions;
@property (strong, nonatomic) NSArray* questionList;
@end
