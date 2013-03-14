//
//  nmifMenuConnectionTableView.m
//  Name me I'm famous
//
//  Created by Jino on 05/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifMenuConnectionTableView.h"

@implementation nmifMenuConnectionTableView

-(void)onConnect
{
    id <nmifMenuConnectionTableViewDelegate> connectionDelegate = (id<nmifMenuConnectionTableViewDelegate>)delegate;
    [connectionDelegate onConnect];
}

-(void)onForgotPassword
{
    id <nmifMenuConnectionTableViewDelegate> connectionDelegate = (id<nmifMenuConnectionTableViewDelegate>)delegate;
    [connectionDelegate onForgotPassword];
}
@end
