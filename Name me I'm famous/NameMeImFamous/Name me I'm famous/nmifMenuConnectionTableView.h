//
//  nmifMenuConnectionTableView.h
//  Name me I'm famous
//
//  Created by Jino on 05/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifMenuTableView.h"

@protocol nmifMenuConnectionTableViewDelegate
-(void) onConnect;
-(void) onForgotPassword;
@end

@interface nmifMenuConnectionTableView : nmifMenuTableView

@end
