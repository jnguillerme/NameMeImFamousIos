//
//  nmifMenuGameOverTableView.m
//  Name me I'm famous
//
//  Created by Jino on 11/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifMenuGameOverTableView.h"

@implementation nmifMenuGameOverTableView

-(void) onPlayAgain
{
    id <nmifMenuGameOverTableViewDelegate> gameOverDelegate = (id<nmifMenuGameOverTableViewDelegate>)delegate;
    [gameOverDelegate onPlayAgain];
}

@end
