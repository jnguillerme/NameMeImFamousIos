//
//  nmifMenuSubmitCelebrityTableView.h
//  Name me I'm famous
//
//  Created by Jino on 07/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifMenuTableView.h"

@protocol nmifMenuCelebritySubmitTableViewDelegate
-(void) onCelebritySubmit;
-(void) onShowQuestionHistory;
@end

@interface nmifMenuSubmitCelebrityTableView : nmifMenuTableView

@end
