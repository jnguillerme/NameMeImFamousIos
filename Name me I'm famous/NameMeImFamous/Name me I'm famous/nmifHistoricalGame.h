//
//  nmifHistoricalGame.h
//  Name me I'm famous
//
//  Created by Jino on 15/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface nmifHistoricalGame : NSObject

@property (nonatomic, retain) NSString *gameDate;
@property (nonatomic, retain) NSString *opponent;
@property (nonatomic, retain) NSString *gameResult;
@property (nonatomic, retain) NSString *myCelebrity;
@property (nonatomic, retain) NSString *myOpponentCelebrity;

-(NSString*) getTitleForIndex:(NSUInteger)index;
-(NSString*) getValueForIndex:(NSUInteger)index;

-(id) initWithDate:(NSString*)theDate andOpponent:(NSString*)theOpponent andWinnerIsMe:(NSString*)Iwon andMyCelebrity:(NSString*)theMyCelebrity andMyOpponentCelebrity:(NSString*)theMyOpponentCelebrity;

@end
