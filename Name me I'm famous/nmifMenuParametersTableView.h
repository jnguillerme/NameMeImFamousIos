//
//  nmifMenuParametersTableView.h
//  Name me I'm famous
//
//  Created by Jino on 05/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifMenuTableView.h"

@protocol nmifMenuParametersTableViewDelegate
-(void) onPackageManagement;
-(void) onGameInProgress;
-(void) onGiveUpGame;
-(void) onDisconnect;
@end

@interface nmifMenuParametersTableView : nmifMenuTableView

@end
