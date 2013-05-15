//
//  nmifMenuInviteTableView.m
//  Name me I'm famous
//
//  Created by Jino on 24/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifMenuInviteTableView.h"

@implementation nmifMenuInviteTableView

-(void) onInvite
{
    id <nmifMenuInviteTableViewDelegate> gameOverDelegate = (id<nmifMenuInviteTableViewDelegate>)delegate;
    [gameOverDelegate onInvite];
}
@end
