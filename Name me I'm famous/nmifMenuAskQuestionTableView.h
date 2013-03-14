//
//  nmifMenuAskQuestionTableView.h
//  Name me I'm famous
//
//  Created by Jino on 11/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifMenuTableView.h"

@protocol nmifMenuAskQuestionTableViewDelegate
-(void) onAsk;
-(void) onShowQuestionHistory;
@end

@interface nmifMenuAskQuestionTableView : nmifMenuTableView

@end
