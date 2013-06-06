//
//  nmifMenuNewGameTableView.h
//  Name me I'm famous
//
//  Created by Jino on 05/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifMenuTableView.h"

@protocol nmifMenuNewGameTableViewDelegate
-(void) onNewGame;
-(void) onNewPlayer;
@end

@interface nmifMenuNewGameTableView : nmifMenuTableView

@end
