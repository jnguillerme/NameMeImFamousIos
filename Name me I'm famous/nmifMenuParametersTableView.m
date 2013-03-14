//
//  nmifMenuParametersTableView.m
//  Name me I'm famous
//
//  Created by Jino on 05/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifMenuParametersTableView.h"

@implementation nmifMenuParametersTableView

-(void)onPackageManagement
{
    id <nmifMenuParametersTableViewDelegate> parametersDelegate = (id<nmifMenuParametersTableViewDelegate>)delegate;
    [parametersDelegate onPackageManagement];
}

-(void)onGameInProgress
{
    id <nmifMenuParametersTableViewDelegate> parametersDelegate = (id<nmifMenuParametersTableViewDelegate>)delegate;
    [parametersDelegate onGameInProgress];
}

-(void)onGiveUpGame
{
    id <nmifMenuParametersTableViewDelegate> parametersDelegate = (id<nmifMenuParametersTableViewDelegate>)delegate;
    [parametersDelegate onGiveUpGame];
}
-(void)onDisconnect
{
    id <nmifMenuParametersTableViewDelegate> parametersDelegate = (id<nmifMenuParametersTableViewDelegate>)delegate;
    [parametersDelegate onDisconnect];
}
@end
