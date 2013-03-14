//
//  nmifMenuAnswerQuestionTableView.h
//  Name me I'm famous
//
//  Created by Jino on 11/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifMenuTableView.h"

@protocol nmifMenuAnswerQuestionTableViewDelegate
-(void) onAnswerYes;
-(void) onAnswerNo;
-(void) onAnswerMaybe;
@end

@interface nmifMenuAnswerQuestionTableView : nmifMenuTableView

@end
