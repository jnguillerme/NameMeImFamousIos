//
//  GMHelper.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 04/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nmifQuestion.h"
#import "Role.h"
#import "MosquittoClient.h"

@protocol GMRestoreViewDelegate
- (void) restorePrivateData;
@end


@protocol GMHelperDelegate<NSObject>

-(void) onConnectionFailed;
-(void) onGamesInProgressLoaded;
-(void) onNewRandomGameSuccess;
-(void) onNewRandomGameFailed:(NSString*)error;
-(void) onNewRandomGame;
-(void) onNewGameInProgress;
-(void) onPickupCelebritySuccess:(NSString*)celebrity;
-(void) onPickupCelebrityError:(NSString*)error;
-(void) onCelebrityPickedUpByOpponent:(NSString*)celebrity;
-(void) onAskQuestionSuccess:(NSString *)questionID;
-(void) onAskQuestionError:(NSString *)error;
-(void) onQuestionAsked:(NSString*) questionID withQuestion:(NSString*)question;
-(void) onQuestionAnswered:(NSString*) questionID withAnswer:(NSString*)answer;
-(void) onQuestionAnsweredAck;
-(void) onAnswer:(NSString*)answer;
-(void) onCelebritySubmitted:(NSString*)celebritySubmitted withStatus:(NSString*)status;
-(void) onCelebritySubmittedByOpponent:(NSString*)celebritySubmitted withStatus:(NSString*)status;
-(void) onNewTurn:(BOOL)myTurn;
-(void) onGameOver:(BOOL)Iwon;
-(void) onOpponentDisconnected;
-(void) onOpponentStatusUpdated;
-(void) onNewCelebrity:(NSString*)celebrity withRole:(NSString*)role;
-(void) onCelebrityListEnd;
-(void) onGameWon;
-(void) onGameLost:(NSString*)celebrity;
-(void) onOpponentQuit:(UIViewController<GMRestoreViewDelegate> *)VC;
-(void) onInviteSuccess;
-(void) onInviteFailed:(NSString*)error;


@end

@interface GMHelper : NSObject</*NSStreamDelegate,*/ MosquittoClientDelegate> {
    id <GMHelperDelegate> delegate;
    NSString *sessionID;
//    NSInputStream *inputStream;
 //   NSOutputStream *outputStream;
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
    NSString * activeGameID;
    
    NSString * streamBuffer;
    
    MosquittoClient *mosquittoClient;
}

+ (GMHelper*) sharedInstance;

@property (nonatomic, retain) id <GMHelperDelegate> delegate;
@property (nonatomic, retain) NSString *sessionID;
@property (nonatomic, retain) NSMutableDictionary* games;
@property (nonatomic, retain) NSMutableArray* historicalGames;
@property (nonatomic) bool fGamesInProgressLoaded;
@property (nonatomic, retain) NSString *activeGameID;
@property (nonatomic) bool fCelebrityLoaded;
@property (nonatomic, retain) NSMutableArray *questionHistory;

@property (nonatomic, retain) NSMutableArray *topCelebrities;
@property (nonatomic, retain) NSMutableDictionary *pendingEventsForGameNotYetCreated;

// methods
-(void) newRandomGame:(id <GMHelperDelegate>)GMDelegate;
-(void) pickupCelebrity:(NSString*)celebrity withDelegate:(id <GMHelperDelegate>)GMDelegate;
-(void) askQuestion:(NSString*)question withDelegate:(id <GMHelperDelegate>)GMDelegate;
-(void) answerQuestion:(NSString*)questionID withAnswer:answer withDelegate:(id <GMHelperDelegate>)GMDelegate;
-(void) submitCelebrity:(NSString*)celebrityName withDelegate:(id <GMHelperDelegate>)GMDelegate;
-(void) notifyDelegateOfRequestError:(NSString*)error withUrl:(NSString*)url;
-(void) subscribeToNotifications;
-(void) endTurn:(id <GMHelperDelegate>)GMDelegate;
-(NSString*) gameStatus;
-(void) replayPendingEvents;
-(void) quitGame;
-(void) gameOver;
-(void) invite:(NSString*)friend withDelegate:(id <GMHelperDelegate>)GMDelegate;

-(void) subscribeToNotifications:(id<GMHelperDelegate>)GMDelegate;
-(void) unsubscribeFromNotifications;
-(void) startTyping;
-(void) stopTyping;

-(bool) wasCelebrityPickedUpByOpponent;
-(void) celebrityWasPickedUpByOpponent;
-(bool) wasCelebrityPickedUpByMe;
-(void) celebrityWasPickedUpByMe;
-(NSString*) opponentName;
-(NSString*) opponentStatus;
-(NSString*) opponentCelebrity;
-(NSMutableDictionary*) questions;
-(NSArray*) packages;
-(bool) myTurn;

-(NSManagedObjectContext*) managedObjectContext;
- (void) saveGameInProgress:(NSString*)view;
- (bool) hasGameInProgress;
- (void) clearGameInProgress;
- (NSString*) gameInProgress;
- (void) storeLocalData:(NSString*) data forKey:(NSString*)key;
- (NSString*) localDataForKey:(NSString*)key;
- (void) clearLocalDataForKey:(NSString*)key;
- (bool) hasLocalDataForKey:(NSString*)key;
- (void) clearDataStore;

-(void) addQuestionToHistory:(NSString*)theQuestion;

-(bool) enablePackage:(NSString*)packageName isAvailable:(bool)bAvailable;
-(void) sendPackageUpdate:(Role*)updatedRole;
@end
