//
//  GMHelper.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 04/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GMHelperDelegate

-(void) onNewRandomGameSuccess;
-(void) onNewRandomGameFailed:(NSString*)error;
-(void) onNewRandomGame:(NSString*)opponent;
-(void) onPickupCelebritySuccess:(NSString*)celebrity;
-(void) onPickupCelebrityError:(NSString*)error;
-(void) onCelebrityPickedUpByOpponent:(NSString*)celebrity;
-(void) onAskQuestionSuccess:(NSString *)questionID;
-(void) onAskQuestionError:(NSString *)error;
-(void) onQuestionAsked:(NSString*) questionID withQuestion:(NSString*)question;
-(void) onQuestionAnswered:(NSString*) questionID withAnswer:(NSString*)answer;
-(void) onAnswer:(NSString*)answer;
-(void) onCelebritySubmitted:(NSString*)celebritySubmitted withStatus:(NSString*)status;
-(void) onCelebritySubmittedByOpponent:(NSString*)celebritySubmitted withStatus:(NSString*)status;
-(void) onNewTurn:(BOOL)myTurn;
-(void) onGameOver:(BOOL)Iwon;

@end

@interface GMHelper : NSObject<NSStreamDelegate> {
    id <GMHelperDelegate> delegate;
    NSString *sessionID;
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}

+ (GMHelper*) sharedInstance;

@property (nonatomic, retain) id <GMHelperDelegate> delegate;
@property (nonatomic, retain) NSString *sessionID;
@property (nonatomic, retain) NSString *opponentName;



// methods
-(void) newRandomGame:(id <GMHelperDelegate>)GMDelegate;
-(void) pickupCelebrity:(NSString*)celebrity withDelegate:(id <GMHelperDelegate>)GMDelegate;
-(void) askQuestion:(NSString*)question withDelegate:(id <GMHelperDelegate>)GMDelegate;
-(void) answerQuestion:(NSString*)questionID withAnswer:answer withDelegate:(id <GMHelperDelegate>)GMDelegate;
-(void) submitCelebrity:(NSString*)celebrityName withDelegate:(id <GMHelperDelegate>)GMDelegate;
-(void) notifyDelegateOfRequestError:(NSString*)error withUrl:(NSString*)url;
-(void) subscribeToNotifications;
-(void) endTurn:(id <GMHelperDelegate>)GMDelegate;
@end
