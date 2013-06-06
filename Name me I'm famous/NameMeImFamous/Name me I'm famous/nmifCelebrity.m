//
//  nmifCelebrity.m
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 26/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "nmifCelebrity.h"

@implementation nmifCelebrity

@synthesize celebrityName = _celebrityName;
@synthesize questions = _questions;

-(NSMutableArray*)questions {
    if (_questions == nil) {
        _questions = [[NSMutableArray alloc] init];
    }
    return _questions;
}
-(void) setQuestions:(NSMutableArray *)questions {
    _questions = questions;
}

static nmifCelebrity* sharedCelebrity = 0;

+(nmifCelebrity*) sharedInstance {
    if ( !sharedCelebrity ) {
        sharedCelebrity = [[nmifCelebrity alloc] init];
    }
    return sharedCelebrity;
}

-(id) initWithName:(NSString*)name andRole:(NSString*)role
{
    [self setCelebrityName:name];
    [self setCelebrityRole:role];
    
    return self;
}

-(void) addQuestion:(nmifQuestion*)withQuestion {
    [self.questions addObject:withQuestion];
}
@end
