//
//  nmifCelebrity.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 26/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nmifQuestion.h"

@interface nmifCelebrity : NSObject

@property (strong, nonatomic) NSString *celebrityName;
@property (strong, nonatomic) NSMutableArray* questions;

+(nmifCelebrity*)sharedInstance;
-(void) addQuestion:(nmifQuestion*)withQuestion;

@end
