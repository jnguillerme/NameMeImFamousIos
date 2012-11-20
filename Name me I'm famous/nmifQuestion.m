//
//  nmifQuestion.m
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 26/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "nmifQuestion.h"

@implementation nmifQuestion

@synthesize question = _question;
@synthesize answer = _answer;
@synthesize questionID = _questionID;

-(nmifQuestion*)initWithQuestionID:(NSString*)questionID andQuestion:(NSString*)question
{
    self.questionID = questionID;
    self.question = question;
    self.answer = @"";
    return self;
}

-(nmifQuestion*)initWithQuestion:(NSString*)question {
    self.question = question;
    self.answer = @"";
    self.questionID = @"";
    return self;
}

-(nmifQuestion*)initWithQuestion:(NSString*)question andAnswer:(NSString*)answer {
    self.question = question;
    self.answer = answer;
    self.questionID = @"";
    return self;
}
@end
