//
//  nmifMenuAskQuestionTableView.m
//  Name me I'm famous
//
//  Created by Jino on 11/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifMenuAskQuestionTableView.h"

@implementation nmifMenuAskQuestionTableView

-(void) onAsk
{
    id <nmifMenuAskQuestionTableViewDelegate> askQuestionDelegate = (id<nmifMenuAskQuestionTableViewDelegate>)delegate;
    [askQuestionDelegate onAsk];
}

-(void) onShowQuestionHistory
{
    id <nmifMenuAskQuestionTableViewDelegate> askQuestionDelegate = (id<nmifMenuAskQuestionTableViewDelegate>)delegate;
    [askQuestionDelegate onShowQuestionHistory];
}

@end
