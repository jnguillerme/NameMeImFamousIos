//
//  nmifMenuAnswerQuestionTableView.m
//  Name me I'm famous
//
//  Created by Jino on 11/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifMenuAnswerQuestionTableView.h"

@implementation nmifMenuAnswerQuestionTableView

-(void) onAnswerYes
{
    id <nmifMenuAnswerQuestionTableViewDelegate> answerQuestionDelegate = (id<nmifMenuAnswerQuestionTableViewDelegate>)delegate;
    [answerQuestionDelegate onAnswerYes];
}

-(void) onAnswerNo
{
    id <nmifMenuAnswerQuestionTableViewDelegate> answerQuestionDelegate = (id<nmifMenuAnswerQuestionTableViewDelegate>)delegate;
    [answerQuestionDelegate onAnswerNo];
}

-(void) onAnswerMaybe
{
    id <nmifMenuAnswerQuestionTableViewDelegate> answerQuestionDelegate = (id<nmifMenuAnswerQuestionTableViewDelegate>)delegate;
    [answerQuestionDelegate onAnswerMaybe];
}

@end
