//
//  nmifMenuNewGameTableView.m
//  Name me I'm famous
//
//  Created by Jino on 05/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifMenuNewGameTableView.h"

@implementation nmifMenuNewGameTableView


-(void)onNewGame
{
    id <nmifMenuNewGameTableViewDelegate> newGameDelegate = (id<nmifMenuNewGameTableViewDelegate>)delegate;
    [newGameDelegate onNewGame];
}

-(void)onNewPlayer
{
    id <nmifMenuNewGameTableViewDelegate> newGameDelegate = (id<nmifMenuNewGameTableViewDelegate>)delegate;
    [newGameDelegate onNewPlayer];
}
@end
