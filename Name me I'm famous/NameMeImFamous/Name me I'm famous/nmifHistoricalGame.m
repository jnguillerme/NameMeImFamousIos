//
//  nmifHistoricalGame.m
//  Name me I'm famous
//
//  Created by Jino on 15/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifHistoricalGame.h"

@implementation nmifHistoricalGame

@synthesize gameDate;
@synthesize opponent;
@synthesize gameResult;
@synthesize myCelebrity;
@synthesize myOpponentCelebrity;

-(id) initWithDate:(NSString*)theDate andOpponent:(NSString*)theOpponent andWinnerIsMe:(NSString*)Iwon andMyCelebrity:(NSString*)theMyCelebrity andMyOpponentCelebrity:(NSString*)theMyOpponentCelebrity
{
    self.gameDate = [NSString stringWithString:theDate];
    self.opponent = [NSString stringWithString:theOpponent];
    self.gameResult = ([Iwon compare:@"true"] == NSOrderedSame) ? NSLocalizedString(@"WON", nil) : NSLocalizedString(@"LOST", nil);
    self.myCelebrity = [NSString stringWithString:theMyCelebrity];
    self.myOpponentCelebrity = [NSString stringWithString:theMyOpponentCelebrity];

    return self;
}

-(NSString*) getTitleForIndex:(NSUInteger)index
{
    NSString *title = nil;
    
    if (index ==0) {
        title = NSLocalizedString(@"OPPONENT", nil);
    } else if (index == 1) {
        title = NSLocalizedString(@"RESULT", nil);
    } else if (index == 2) {
        title = NSLocalizedString(@"MY_CELEBRITY", nil);
    } else if (index == 3) {
        title = NSLocalizedString(@"MY_OPPONENT_CELEBRITY", nil);
    }
    return title;
}

-(NSString*) getValueForIndex:(NSUInteger)index
{
    NSString *value = nil;
    
    if (index ==0) {
        value = [NSString stringWithString:self.opponent];
    } else if (index == 1) {
        value = [NSString stringWithString:self.gameResult];
    } else if (index == 2) {
        value = [NSString stringWithString:self.myCelebrity];
    } else if (index == 3) {
        value = [NSString stringWithString:self.myOpponentCelebrity];
    }
    return value;
}
@end
