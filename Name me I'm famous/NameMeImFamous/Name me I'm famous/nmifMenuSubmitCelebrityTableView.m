//
//  nmifMenuSubmitCelebrityTableView.m
//  Name me I'm famous
//
//  Created by Jino on 07/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifMenuSubmitCelebrityTableView.h"

@implementation nmifMenuSubmitCelebrityTableView

-(void) onCelebritySubmit
{
    id <nmifMenuCelebritySubmitTableViewDelegate> celebrityChoiceDelegate = (id<nmifMenuCelebritySubmitTableViewDelegate>)delegate;
    [celebrityChoiceDelegate onCelebritySubmit];
}
@end
