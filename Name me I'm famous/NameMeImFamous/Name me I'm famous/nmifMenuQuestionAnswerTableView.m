//
//  nmifMenuQuestionAnswerTableView.m
//  Name me I'm famous
//
//  Created by Jino on 05/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifMenuQuestionAnswerTableView.h"

@implementation nmifMenuQuestionAnswerTableView

-(void) onSubmitCelebrity
{
    id <nmifMenuQuestionAnswerTableViewDelegate> questionAnswerDelegate = (id<nmifMenuQuestionAnswerTableViewDelegate>)delegate;
    [questionAnswerDelegate onSubmitCelebrity];
}
-(void) onNextQuestion
{
    id <nmifMenuQuestionAnswerTableViewDelegate> questionAnswerDelegate = (id<nmifMenuQuestionAnswerTableViewDelegate>)delegate;
    [questionAnswerDelegate onNextQuestion];
}
@end
