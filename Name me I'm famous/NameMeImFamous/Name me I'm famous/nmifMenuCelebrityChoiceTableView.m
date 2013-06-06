//
//  nmifMenuCelebrityChoiceTableView.m
//  Name me I'm famous
//
//  Created by Jino on 05/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifMenuCelebrityChoiceTableView.h"

@implementation nmifMenuCelebrityChoiceTableView

-(void) onCelebrityPickedUp
{
    id <nmifMenuCelebrityChoiceTableViewDelegate> celebrityChoiceDelegate = (id<nmifMenuCelebrityChoiceTableViewDelegate>)delegate;
    [celebrityChoiceDelegate onCelebrityPickedUp];
}
@end
