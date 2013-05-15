//
//  nmifGame.m
//  Name me I'm famous
//
//  Created by Jino on 13/02/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifGame.h"


@implementation nmifGame

@synthesize gameID = _gameID;
@synthesize opponentName = _opponentName;
@synthesize opponentStatus = _opponentStatus;
@synthesize questionList = _questionList;
@synthesize celebrityPickedUpByMe = _celebrityPickedUpByMe;
@synthesize celebrityPickedUpByOpponent = _celebrityPickedUpByOpponent;
@synthesize opponentCelebrity = _opponentCelebrity;
@synthesize myTurn = _myTurn;
@synthesize packages = _packages;

-(NSString *) gameID
{
    if (_gameID == nil) {
        _gameID = [NSString alloc];
    }
    return _gameID;
}
-(void) setGameID:(NSString *)gameID
{
    _gameID = gameID;
}
-(NSString *) opponentName
{
    if (_opponentName == nil) {
        _opponentName = [NSString alloc];
    }
    return _opponentName;
}
-(void) setOpponentName:(NSString *)opponentName
{
    _opponentName = opponentName;
 //  [self storeLocalData:_opponentName forKey:K_OPPONENT_NAME];
}

-(BOOL) celebrityPickedUpByMe
{
    return _celebrityPickedUpByMe;
}
-(void) setCelebrityPickedUpByMe:(BOOL)celebrityPickedUpByMe
{
    _celebrityPickedUpByMe = celebrityPickedUpByMe;
    if (_celebrityPickedUpByMe) {
    //    [self storeLocalData:@"1" forKey:K_CELEBRITY_PICKED_UP_BY_ME];
    } else {
      //  [self storeLocalData:@"0" forKey:K_CELEBRITY_PICKED_UP_BY_ME];
    }
}

-(BOOL) celebrityPickedUpByOpponent
{
    return _celebrityPickedUpByOpponent;
}
-(void) setCelebrityPickedUpByOpponent:(BOOL)celebrityPickedUpByOpponent
{
    _celebrityPickedUpByOpponent = celebrityPickedUpByOpponent;
    if (_celebrityPickedUpByOpponent) {
        //[self storeLocalData:@"1" forKey:K_CELEBRITY_PICKED_UP_BY_OPPONENT];
    } else {
       // [self storeLocalData:@"0" forKey:K_CELEBRITY_PICKED_UP_BY_OPPONENT];
    }
}
-(NSMutableDictionary*)questionList {
    if (!_questionList) {
        _questionList = [[NSMutableDictionary alloc] init];
    }
    return _questionList;
}
-(void)setQuestionList:(NSArray *)ql {
    _questionList = [ql copy];
    
    //store _questionList count
    // loop through the list and store KEY.1, KEY.2 ....
}

-(NSString*)opponentStatus {
    return _opponentStatus;
}
-(void)setOpponentStatus:(NSString *)opponentStatus {
    if ([opponentStatus compare:@"not connected"] == NSOrderedSame) {
        _opponentStatus = NSLocalizedString(@"STATUS_NOT_CONNECTED", nil);
    } else if ([opponentStatus compare:@"typing"] == NSOrderedSame) {
        _opponentStatus = NSLocalizedString(@"STATUS_TYPING", nil);;
    } else {
        _opponentStatus = NSLocalizedString(@"STATUS_CONNECTED", nil);
    }
}

-(id)init:(NSString*)ID withOpponent:(NSString *)opponent andPackages:(NSString *)packages
{
    self.gameID = ID;
    self.opponentName = opponent;
    self.celebrityPickedUpByOpponent = false;
    self.celebrityPickedUpByMe = false;
    [self setOpponentStatus:@"connected"];
    pendingEvents = [[NSMutableArray alloc] init];
    
    self.packages = [packages componentsSeparatedByString:@","];

    return self;
}

-(id) init:(NSString*)ID withOpponent:(NSString *)opponent andCelebrity:(NSString*)celebrity andToken:(BOOL)hasToken andCelebrityPickedUpByOpponent:(BOOL)celebrityPickedUpByOpponent andPackages:(NSString *)packages
{
    self.gameID = ID;
    self.opponentName = opponent;
    self.celebrityPickedUpByOpponent = celebrityPickedUpByOpponent;
    self.celebrityPickedUpByMe = (celebrity != nil && celebrity.length > 0);
    self.opponentCelebrity = celebrity;
    self.myTurn = hasToken;
    [self setOpponentStatus:@"connected"];
    pendingEvents = [[NSMutableArray alloc] init];
    
    self.packages = [packages componentsSeparatedByString:@","];

    return self;
}

-(void) addPendingEvents:(NSString*)command withParams:(NSArray*)params
{
    [pendingEvents addObject:[[nmifCommand alloc] initWithCommand:command andParams:params]];
}
-(void) addPendingEvents:(nmifCommand*)command
{
    [pendingEvents addObject:command];
}
-(NSArray*) getPendingEvents
{
    return pendingEvents;
}
-(void) removePendingEvents
{
    [pendingEvents removeAllObjects];
}

@end
