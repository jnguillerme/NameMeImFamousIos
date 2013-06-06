//
//  nmifMenuNewPlayerTableView.m
//  Name me I'm famous
//
//  Created by Jino on 05/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifMenuNewPlayerTableView.h"

@implementation nmifMenuNewPlayerTableView

-(void)onNewPlayer
{
    id <nmifMenuNewPlayerTableViewDelegate> newPlayerDelegate = (id<nmifMenuNewPlayerTableViewDelegate>)delegate;
    [newPlayerDelegate onNewPlayer];
}
@end
