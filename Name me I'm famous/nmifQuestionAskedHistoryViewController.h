//
//  nmifQuestionAskedHistoryViewController.h
//  Name me I'm famous
//
//  Created by Jino on 19/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol nmifQuestionChoiceDelegate
- (void)setQuestionAsked:(NSString*)question;
@end

@interface nmifQuestionAskedHistoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    NSString *questionSelected;
}

@property (weak, nonatomic) IBOutlet UITableView *tvQuestionAsked;
@end
