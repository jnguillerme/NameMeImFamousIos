//
//  nmifCommand.m
//  Name me I'm famous
//
//  Created by Jino on 15/02/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifCommand.h"

@implementation nmifCommand

@synthesize command;
@synthesize params;

-(id) initWithCommand:(NSString*)theCommand andParams:(NSArray*)theParams
{
    command = theCommand;
    params = [[NSArray alloc] initWithArray:theParams];

    return self;
}

-(NSString*) getParamAtPosition:(NSUInteger)index
{
    NSString *param = nil;
    if (index < [params count]) {
        param = [params objectAtIndex:index];
    }
    
    return param;
}
@end
