//
//  nmifCommand.h
//  Name me I'm famous
//
//  Created by Jino on 15/02/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface nmifCommand : NSObject {
    NSString * command;
    NSArray* params;
}

-(id) initWithCommand:(NSString*)theCommand andParams:(NSArray*)theParams;
-(NSString*) getParamAtPosition:(NSUInteger)index;


@property (nonatomic, readonly) NSString *command;
@property (nonatomic, readonly) NSArray *params;

@end
