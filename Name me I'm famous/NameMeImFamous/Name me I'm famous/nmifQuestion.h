//
//  nmifQuestion.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 26/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface nmifQuestion : NSObject

@property (strong, nonatomic) NSString* questionID;
@property (strong, nonatomic) NSString* question;
@property (strong, nonatomic) NSString* answer;

-(nmifQuestion*)initWithQuestionID:(NSString*)questionID andQuestion:(NSString*)question;
-(nmifQuestion*)initWithQuestion:(NSString*)question;
-(nmifQuestion*)initWithQuestion:(NSString*)question andAnswer:(NSString*)answer;
-(nmifQuestion*)initWithQuestionID:(NSString*)questionID andQuestion:(NSString*)question andAnswer:(NSString*)answer;

@end
