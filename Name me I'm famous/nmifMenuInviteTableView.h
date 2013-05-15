//
//  nmifMenuInviteTableView.h
//  Name me I'm famous
//
//  Created by Jino on 24/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifMenuTableView.h"

@protocol nmifMenuInviteTableViewDelegate
-(void) onInvite;
@end

@interface nmifMenuInviteTableView : nmifMenuTableView

@end
