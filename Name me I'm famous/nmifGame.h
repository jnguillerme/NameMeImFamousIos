//
//  nmifGame.h
//  Name me I'm famous
//
//  Created by Jino on 13/02/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "nmifCommand.h"

@interface nmifGame : NSObject {
    NSMutableArray* pendingEvents;
}

@property (nonatomic, retain) NSString *gameID;
@property (nonatomic, retain) NSString *opponentName;
@property (nonatomic, retain) NSString *opponentStatus;
@property (nonatomic, retain) NSString *opponentCelebrity;
@property bool myTurn;
@property (nonatomic, retain) NSMutableDictionary* questionList;
@property BOOL celebrityPickedUpByMe;
@property BOOL celebrityPickedUpByOpponent;
@property NSArray *packages;

-(id) init:(NSString*)ID withOpponent:(NSString*)opponent andPackages:(NSString*)packages;
-(id) init:(NSString*)ID withOpponent:(NSString *)opponent andCelebrity:(NSString*)celebrity andToken:(BOOL)hasToken andCelebrityPickedUpByOpponent:(BOOL)celebrityPickedUpByOpponent andPackages:(NSString*)packages;
-(void) addPendingEvents:(NSString*)command withParams:(NSArray*)params;
-(void) addPendingEvents:(nmifCommand*)command;
-(NSArray*) getPendingEvents;
-(void) removePendingEvents;

@end
