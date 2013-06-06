//
//  GMHelper.m
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 04/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GMHelper.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "MBProgressHUD.h"
#import "Celebrity.h"
#import "nmifCelebrity.h"
#import "nmifGame.h"
#import "nmifCommand.h"
#import "nmifHistoricalGame.h"
#include "nmifServerCommands.h"

@implementation GMHelper

@synthesize delegate;
@synthesize sessionID;
@synthesize games = _games;
@synthesize historicalGames = _historicalGames;
@synthesize fGamesInProgressLoaded;
@synthesize activeGameID;
@synthesize fCelebrityLoaded;
@synthesize topCelebrities = _topCelebrities;
@synthesize questionHistory = _questionHistory;

NSString * const K_QUESTION_HISTORY_KEY = @"NMIF.QUESTIONASKED.HISTORY";

static GMHelper * sharedHelper = 0;

+ (GMHelper*) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[GMHelper alloc] init];
    }
    return sharedHelper;
}

-(NSMutableDictionary*) games {
    if (_games == nil) {
        _games = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return _games;
}
-(void) setGames:(NSMutableDictionary *)games {
    _games = games;
}

-(NSMutableArray*) historicalGames {
    if (_historicalGames == nil) {
        _historicalGames = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _historicalGames;
}
-(void) setHistoricalGames:(NSMutableArray *)historicalGames {
    _historicalGames = historicalGames;
}

-(NSMutableArray*) topCelebrities {
    if (_topCelebrities == nil) {
        _topCelebrities = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _topCelebrities;
}
-(void) setTopCelebrities:(NSMutableArray *)topCelebrities {
    _topCelebrities = topCelebrities;
}

-(NSMutableArray*) questionHistory {
    if (_questionHistory == nil) {
        _questionHistory = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _questionHistory;
}
-(void) setQuestionHistory:(NSMutableArray *)questionHistory {
    _questionHistory = questionHistory;
}
-(id) init {
    self = [super init];
    if (self) {
        sessionID = nil;
        [self loadFromLocalStore];
        [self loadQuestionHistory];
    }
    return self;
}
-(NSString*) gameStatus
{
    NSString *status = @"";
    
    if ([self hasGameInProgress]) {
        NSString *storedStatus = [self gameInProgress];
        if ([storedStatus compare:@"celebrityChoiceViewID"] == NSOrderedSame) {
            status = NSLocalizedString(@"CELEBRITY_CHOICE_VIEW", nil);
        } else if ([storedStatus compare:@"askQuestionViewID"] == NSOrderedSame) {
            status = NSLocalizedString(@"ASK_QUESTION_VIEW", nil);
        } else if ([storedStatus compare:@"questionAnsweredViewID"] == NSOrderedSame) {
            status = NSLocalizedString(@"QUESTION_ANSWERED_VIEW", nil);
        } else if ([storedStatus compare:@"submitCelebrityViewID"] == NSOrderedSame) {
            status = NSLocalizedString(@"SUBMIT_CELEBRITE_VIEW", nil);
        } else if ([storedStatus compare:@"answerQuestionViewID"] == NSOrderedSame) {
            status = NSLocalizedString(@"ANSWER_QUESTION_VIEW", nil);
        }
    }
 
    
    return status;
}

#pragma mark - CoreData management
-(NSManagedObjectContext*) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

-(NSManagedObjectModel*) managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return managedObjectModel;
}

-(NSPersistentStoreCoordinator*) persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"nmif.sqlite"];

    NSError *error = nil;
/*    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
  */  
    
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /* ERROR for store creation HANDLING */
    }
    
    return persistentStoreCoordinator;
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - local data storage management
-(void) loadFromLocalStore
{
   /* if ([self hasLocalDataForKey:K_OPPONENT_NAME]) {
        _opponentName = [self localDataForKey:K_OPPONENT_NAME];
    }
    if ([self hasLocalDataForKey:K_CELEBRITY_PICKED_UP_BY_ME]) {
        _celebrityPickedUpByMe = ([[self localDataForKey:K_CELEBRITY_PICKED_UP_BY_ME] compare:@"1"] == NSOrderedSame );
    }
    if ([self hasLocalDataForKey:K_CELEBRITY_PICKED_UP_BY_OPPONENT]) {
        _celebrityPickedUpByOpponent = ([[self localDataForKey:K_CELEBRITY_PICKED_UP_BY_OPPONENT] compare:@"1"] == NSOrderedSame );
    }
*/
        //@synthesize questionList = _questionList;


}
- (void) saveGameInProgress:(NSString*)view
{
    [self storeLocalData:view forKey:K_VIEW_KEY];
}
- (bool) hasGameInProgress
{
    return [self hasLocalDataForKey:K_VIEW_KEY];
}
- (void) clearGameInProgress
{
    [self clearLocalDataForKey:K_VIEW_KEY];
}

- (NSString*) gameInProgress
{
   return [self localDataForKey:K_VIEW_KEY];
}

- (void) storeLocalData:(NSString*) data forKey:(NSString*)key
{
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:data forKey:[NSString stringWithFormat:@"%@_%@", key, activeGameID]];
    [standardUserDefaults synchronize];
}

- (NSString*) localDataForKey:(NSString*)key
{
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    return [standardUserDefaults objectForKey:[NSString stringWithFormat:@"%@_%@", key, activeGameID]];
}
- (void) clearLocalDataForKey:(NSString*)key
{
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults removeObjectForKey:[NSString stringWithFormat:@"%@_%@", key, activeGameID]];
    [standardUserDefaults synchronize];
}
- (bool) hasLocalDataForKey:(NSString*)key
{
    return ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@", key, activeGameID]] != nil);
}


-(void) subscribeToNotifications:(id <GMHelperDelegate>)GMDelegate {
    self.delegate = GMDelegate;
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    //89.226.34.6, 5001
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"54.247.53.94",5001, &readStream, &writeStream);
    
    inputStream = (__bridge NSInputStream*)readStream;
    outputStream = (__bridge NSOutputStream*)writeStream;
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
    
    [self startNotifications];
}

-(void) unsubscribeFromNotifications {
    
    [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream close];
    [outputStream close];
}

#pragma mark - xmlHttpRequest send
-(void) newRandomGame:(id <GMHelperDelegate>)GMDelegate {
    self.delegate = GMDelegate;

    // then request a new random game	
    NSURL *url = [NSURL URLWithString:K_NEW_RANDOM_GAME_URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:sessionID  forKey:@"ID"];
        
    [request setDelegate:self];
    [request startAsynchronous];    
}

#pragma mark - xmlHttpRequest answers

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *responseDict = [responseString JSONValue];
    NSString *success = [responseDict objectForKey:@"success"];
    NSString * url = [[request url] absoluteString]; 
    
    if ([success compare:@"0"] == NSOrderedSame) {
        NSString *errorMsg = [responseDict objectForKey:@"error"]; 
        [self notifyDelegateOfRequestError:errorMsg withUrl:url];
        
    } else { 
        if ([url compare:K_NEW_RANDOM_GAME_URL] == NSOrderedSame) {           // random game request successfully created  - let start socket to get notifications
            /*[self setOpponentName:[responseDict objectForKey:@"opponentName"]];
            [delegate onNewRandomGameSuccess];*/
        }    
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = request.error;
    NSString * url = [[request url] absoluteString]; 
    [self notifyDelegateOfRequestError:[error localizedDescription] withUrl:url];
}

-(void) notifyDelegateOfRequestError:(NSString *)error withUrl:(NSString *)url 
{
    if ([url compare:K_NEW_RANDOM_GAME_URL] == NSOrderedSame) {           // account successfully created        
        [delegate onNewRandomGameFailed:error];
    }
}

#pragma mark - NSStream commands
-(void) writeToOutputStream:(NSString*)stringData
{
    NSData *data = [[NSData alloc] initWithData:[stringData dataUsingEncoding:NSUTF8StringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];    
}
#pragma mark - commands sent to server
-(void) startNotifications {
    [self writeToOutputStream:[NSString stringWithFormat:@"%@:%@$", K_NOTIFICATION_ON, sessionID]];
}

-(void)getCelebrityList {
    NSNumber *lastCelebrityID= [[NSNumber alloc] initWithInt:0];
    
    NSManagedObjectContext *context = [self managedObjectContext];

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Celebrity" inManagedObjectContext:context];
    [request setEntity:entity];
    
    // specify that the request should return dictionnaries
    [request setResultType:NSDictionaryResultType];
    
    // create an expression for the key path
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"id"];
    
    // create an expression to represent the minimum value at the key path 'id'
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"max:" arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    // create an expression description using the maxExpression and returning an int
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    
    // the name is the key that will be used in the dictionnary for the return value
    [expressionDescription setName:@"maxId"];
    [expressionDescription setExpression:maxExpression];
    [expressionDescription setExpressionResultType:NSInteger32AttributeType];
    
    // set the request's properties to fetch just the property represented by the expression
    [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    
    // execute the fetch
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (objects == nil) {
        NSLog(@"Get max celebrity id from core data failed: %@", error);
    } else {
        if ([objects count] > 0) {
            lastCelebrityID = [[objects objectAtIndex:0] valueForKey:@"maxId"];
        }
    }
     
    [self writeToOutputStream:[NSString stringWithFormat:@"%@:%@:%d$", K_GET_CELEBRITY_LIST, sessionID, [lastCelebrityID intValue]]];
}

-(void) getAvailablePackages
{
    [self writeToOutputStream:[NSString stringWithFormat:@"%@:%@$", K_GET_AVAILABLE_PACKAGES, sessionID]];
}

-(void) sendPackageUpdate:(Role*)updatedRole
{
    [self writeToOutputStream:[NSString stringWithFormat:@"%@:%@:%@:%@$", K_UPDATE_PACKAGE, sessionID, updatedRole.role, [updatedRole.active stringValue]]];
}
-(void) getTopCelebrityList
{
    [self writeToOutputStream:[NSString stringWithFormat:@"%@:%@$", K_GET_TOP_CELEBRITY_LIST, sessionID]];
}

-(void) getMyGamesHistory
{
    [self writeToOutputStream:[NSString stringWithFormat:@"%@:%@$", K_GET_MY_GAMES_HISTORY, sessionID]];
}
-(void) getGamesInProgress
{
    [self writeToOutputStream:[NSString stringWithFormat:@"%@:%@$", K_GAMESINPROGRESS, sessionID]];
}
-(void) pickupCelebrity:(NSString*)celebrity withDelegate:(id <GMHelperDelegate>)GMDelegate
{
    self.delegate = GMDelegate;
    [self writeToOutputStream:[NSString stringWithFormat:@"%@:%@:%@:%@$", K_PICKUP_CELEBRITY, sessionID, activeGameID, celebrity]];
}

-(void) askQuestion:(NSString *)question withDelegate:(id <GMHelperDelegate>)GMDelegate
{
    self.delegate = GMDelegate;
    [self writeToOutputStream:[NSString stringWithFormat:@"%@:%@:%@:%@$", K_ASK_QUESTION, sessionID, activeGameID, question]];
}

-(void) answerQuestion:(NSString*)questionID withAnswer:answer withDelegate:(id <GMHelperDelegate>)GMDelegate
{
    self.delegate = GMDelegate;
    [self writeToOutputStream:[NSString stringWithFormat:@"%@:%@:%@:%@:%@$", K_ANSWER_QUESTION, sessionID,  activeGameID, questionID, answer]];
}

-(void) submitCelebrity:(NSString*)celebrityName withDelegate:(id <GMHelperDelegate>)GMDelegate
{
    self.delegate = GMDelegate;
    [self writeToOutputStream:[NSString stringWithFormat:@"%@:%@:%@:%@$", K_SUBMIT_CELEBRITY, sessionID,  activeGameID, celebrityName]];
}

-(void) endTurn:(id <GMHelperDelegate>)GMDelegate
{
    self.delegate = GMDelegate;
    [self writeToOutputStream:[NSString stringWithFormat:@"%@:%@:%@$", K_END_TURN, sessionID, activeGameID]];
}

-(void) startTyping {
    [self writeToOutputStream:[NSString stringWithFormat:@"%@:%@:%@$", K_START_TYPING, sessionID,  activeGameID]];
}

-(void) stopTyping {
    [self writeToOutputStream:[NSString stringWithFormat:@"%@:%@:%@$", K_STOP_TYPING, sessionID,  activeGameID]];
}

-(void)quitGame
{
    [self writeToOutputStream:[NSString stringWithFormat:@"%@:%@:%@$", K_QUIT_GAME, sessionID,  activeGameID]];
    [self gameOver];
}

#pragma mark - game handling
-(void) gameOver
{
    [self.games removeObjectForKey:activeGameID];
    activeGameID = nil;
}

-(void) addGameInProgress:(NSString*)gameID withOpponent:(NSString*)opponent withToken:(NSString*)opponentHasToken andCelebrityName:(NSString*)celebrityName andCelebrityPickedUpByOpponent:(NSString*)celebrityPickedUpByOpponent andPackages:(NSString*)packages
{
    nmifGame * gip  = [[nmifGame alloc] init:gameID withOpponent:opponent andCelebrity:celebrityName andToken:([opponentHasToken compare:@"false"] == NSOrderedSame) andCelebrityPickedUpByOpponent:([celebrityPickedUpByOpponent compare:@"true"] == NSOrderedSame) andPackages:packages];
    [[self games] setObject:gip forKey:gameID];
}


-(void) addToQuestionList:(NSString*)questionID withQuestion:(NSString*)question forGameID:(NSString*)gameID
{
    [[[self.games objectForKey:gameID] questionList] setValue:[[nmifQuestion alloc] initWithQuestionID:questionID andQuestion:question]  forKey:questionID];
}

-(void) updateQuestionListWithAnswer:(NSString*)questionID withAnswer:(NSString*)answer forGameID:gameID
{
    nmifQuestion* question = [[[self.games objectForKey:gameID] questionList] objectForKey:questionID];
    question.answer = answer;

    [ [[self.games objectForKey:gameID] questionList] setValue:question forKey:questionID];
}

-(void) resetQuestionList
{
    [ [[self.games objectForKey:activeGameID] questionList] removeAllObjects];
}

-(void) addCelebrityToDatastore:(int)id withCelebrityName:(NSString*)celebrityName andRole:(NSString*)celebrityRole
{
    NSManagedObjectContext *context = [self managedObjectContext];
    Celebrity *celebrity = [NSEntityDescription insertNewObjectForEntityForName:@"Celebrity" inManagedObjectContext:context];
    Role *role = [self getRole:celebrityRole];
    
    celebrity.id = [NSNumber numberWithInt:id];
    celebrity.name = celebrityName;
    celebrity.role = role;
    [role addCelebritiesObject:celebrity];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Failed to save celebrity: %@", [error localizedDescription]);
    }
}

-(Role*) getRole:(NSString*) roleName
{
    Role *role = nil;
    NSManagedObjectContext *context = [self managedObjectContext];

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Role" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(role = %@)", roleName];
    [request setPredicate:predicate];
    
    // execute the fetch
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (objects == nil) {
        NSLog(@"Get rolefrom core data failed: %@", error);
    } else {
        if ([objects count] == 0) {
            role = [self createRole:roleName withActive:YES];
        } else {
            role = [objects objectAtIndex:0];
        }
    }
    
    return role;
}

-(Role*) createRole:(NSString*) roleName withActive:(bool)bActive
{
    NSLog(@"new role: %@", roleName);
    Role *newRole;
    NSNumber *active = [[NSNumber alloc] initWithBool:bActive];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    newRole = [NSEntityDescription insertNewObjectForEntityForName:@"Role" inManagedObjectContext:context];
    
    [newRole setActive:active];
    [newRole setRole:roleName];
    
    
    NSError *error = nil;
    [context save:&error];
    
    return newRole;
}
-(void) clearDataStore
{
    [self clearDataStoreCelebrity];
    [self clearDataStoreRole];
    fCelebrityLoaded = false;
    
}
-(void) clearDataStoreCelebrity
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Celebrity" inManagedObjectContext:context];
    [request setEntity:entity];
    
    // execute the fetch
    NSError *error = nil;
    NSArray *celebrities = [context executeFetchRequest:request error:&error];
    Celebrity *celebrity;
    
    for (celebrity in celebrities) {
        [context deleteObject:celebrity];
    }
    
    if (![context save:&error]) {
        NSLog(@"Failed to delete celebrities: %@", [error localizedDescription]);
    }
}
-(void) clearDataStoreRole
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Role" inManagedObjectContext:context];
    [request setEntity:entity];
    
    // execute the fetch
    NSError *error = nil;
    NSArray *roles = [context executeFetchRequest:request error:&error];
    Role *role;
    
    for (role in roles) {
        [context deleteObject:role];
    }

    if (![context save:&error]) {
        NSLog(@"Failed to delete roles: %@", [error localizedDescription]);
    }
}
-(bool) enablePackage:(NSString*)packageName isAvailable:(bool)bAvailable
{
    bool bPackageUpdated = false;
    Role *role = nil;
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Role" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(role = %@)", packageName];
    [request setPredicate:predicate];
    
    // execute the fetch
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (objects == nil) {
        NSLog(@"Get role from core data failed: %@", error);
    } else {
        if ([objects count] == 0) {
            role = [self createRole:packageName withActive:bAvailable];
        } else {
            NSNumber *enable = [[NSNumber alloc] initWithBool:bAvailable];
            if (role.active != enable) {
                role.active = enable;
                bPackageUpdated = [context save:&error];
            }
        }
    }
    
    return bPackageUpdated;
}

#pragma mark - NSStreamDelegate
-(void) stream:(NSStream *)theStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");	
            break;
            
        case NSStreamEventHasBytesAvailable:
            if (theStream == inputStream) {
                uint8_t buffer[1024]	;
                int len;
                
                while ([inputStream hasBytesAvailable]) {
                    bool bLastMessageIsComplete = NO;
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        NSString *output;
                        if ([streamBuffer length] > 0) {
                            output = [streamBuffer stringByAppendingString:[[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding]];
                            streamBuffer = @"";
                        } else {
                            output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding];
                        }
                        if (nil != output) {
                            NSLog(@"server said %@", output);
                            
                            if ([output hasSuffix:@"$"]) { //last message is incomplete
                                bLastMessageIsComplete = YES;
                            }
                            
                            NSArray	*outputMessages = [output componentsSeparatedByString:@"$"];
                            int nbMessagesToProcess = (bLastMessageIsComplete ? [outputMessages count] : [outputMessages count] -1);
                            for (int i=0; i < nbMessagesToProcess; i++) {
                                NSString* message = [outputMessages objectAtIndex:i];
                                NSLog(@"processing message %@", message);
                                NSArray	*outputToken = [message componentsSeparatedByString:@":"];
                                if ([outputToken count] >= 2) {
                                    NSString* param2 = nil;
                                    NSString* param3 = nil;
                                    NSString* param4 = nil;
                                    NSString* param5 = nil;
                                    NSString* param6 = nil;
                                    
                                    if ([outputToken count] >= 3) {
                                        param2 = [[outputToken objectAtIndex:K_STREAM_PARAM_IDX+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                        if ([outputToken count] >= 4) {
                                            param3 = [[outputToken objectAtIndex:K_STREAM_PARAM_IDX+2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                            if ([outputToken count] >= 5) {
                                                param4 = [[outputToken objectAtIndex:K_STREAM_PARAM_IDX+3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                                if ([outputToken count] >= 6) {
                                                    param5 = [[outputToken objectAtIndex:K_STREAM_PARAM_IDX+4] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                                    if ([outputToken count] >= 7) {
                                                        param6 = [[outputToken objectAtIndex:K_STREAM_PARAM_IDX+5] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                                    }
                                                }
                                            }

                                        }
                                    }
                                    
                                    [self decodeCommand:[[outputToken objectAtIndex:K_STREAM_COMMAND_IDX] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                                             withParam1:[[outputToken objectAtIndex:K_STREAM_PARAM_IDX] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                                             withParam2:param2 withParam3:param3 withParam4:param4 withParam5:param5 withParam6:param6];
                                }                                
                            }
                            
                            if (!bLastMessageIsComplete) {
                                streamBuffer = [[NSString alloc] initWithString:[outputMessages objectAtIndex:[outputMessages count] - 1]];
                            }
                        }
                    }
                }                        
            }
            break;
            
        case NSStreamEventErrorOccurred:
            if ([delegate respondsToSelector:@selector(onConnectionFailed)]) {
                [delegate onConnectionFailed];
            }
            break;
            
        case NSStreamEventEndEncountered:
            break;
            
        default:
            break;
    }
}

// decode the command received and call the delegate
-(void) decodeCommand:(NSString*)command withParam1:(NSString*)param1 withParam2:(NSString*)param2 withParam3:(NSString*)param3 withParam4:(NSString*)param4 withParam5:(NSString*)param5 withParam6:(NSString*)param6
{
    if ([command compare:K_NOTIFICATION_ACK] == NSOrderedSame) {
        [self onCommandNotificationAck];
    } else if ([command compare:K_NEWGAME] == NSOrderedSame) {
        [self onCommandNewGame:param1 withOpponent:param2 andPackages:param3];
    } else if ([command compare:K_NEW_GAMEINPROGRESS] == NSOrderedSame) {
        [self onCommandNewGameInProgress:param1 withOpponent:param2 withToken:param3 andCelebrityName:param4 andCelebrityPickedUpByOpponent:param5 andPackages:param6];
    } else if ([command compare:K_NEW_GAMEINPROGRESS_QUESTION] == NSOrderedSame) {
        [self onCommandNewGameInProgressQuestion:param1 withQuestionID:param2 withQuestionAsked:param3 andAnswer:param4];
    }else if ([command compare:K_NEW_GAMEINPROGRESS_END] == NSOrderedSame) {
        [self onCommandNewGameInProgressEnd];
    } else if ([command compare:K_NEW_CELEBRITY] == NSOrderedSame) {
        [self onCommandNewCelebrity:param1 withName:param2 andRole:param3];
    } else if ([command compare:K_PICKUP_CELEBRITY_ACK] == NSOrderedSame) {
        [self onCommandPickupCelebrityAck:param1 withCelebrity:param2];
    } else if ([command compare:K_PICKUP_CELEBRITY_ERROR] == NSOrderedSame) {
        [self onCommandPickupCelebrityError:param1 withError:param2];
    } else if ([command compare:K_CELEBRITY_PICKUP_BY_OPPONENT] == NSOrderedSame) {
        [self onCommandCelebrityPickupByOpponent:param1 withCelebrity:param2];
    } else if ([command compare:K_ASK_QUESTION_ACK] == NSOrderedSame) {
        [self onCommandAskQuestionAck:param1 withQuestionID:param2 andQuestion:param3];
    } else if ([command compare:K_ASK_QUESTION_ERROR] == NSOrderedSame) {
        [self onCommandAskQuestionError:param1 withError:param2];
    } else if ([command compare:K_QUESTION_ASKED] == NSOrderedSame) {
        [self onCommandQuestionAsked:param1 withQuestionID:param2 andQuestion:param3];
    } else if ([command compare:K_QUESTION_ANSWERED] == NSOrderedSame) {
        [self onCommandQuestionAnswered:param1 withQuestionID:param2 andAnswer:param3];
    } else if ([command compare:K_QUESTION_ANSWERED_ACK] == NSOrderedSame) {
        [self onCommandQuestionAnsweredAck:param1];
    } else if ([command compare:K_CELEBRITY_SUBMITTED] == NSOrderedSame) {
        [self onCommandCelebritySubmitted:param1 withCelebrity:param2 andStatus:param3];
    } else if ([command compare:K_CELEBRITY_SUBMITTED_BY_OPPONENT] == NSOrderedSame) {
        [self onCommandCelebritySubmittedByOpponent:param1 withOpponent:param2 andStatus:param3];
    } else if ([command compare:K_NEW_TURN] == NSOrderedSame) {
        [self onCommandNewTurn:param1 withMyTurn:param2];
    } else if ([command compare:K_OPPONENT_STATUS_UPDATED] == NSOrderedSame) {
        [self onCommandOpponentStatusUpdated:param1 withStatus:param2];
    } else if ([command compare:K_GAME_OVER] == NSOrderedSame) {
        [self onCommandGameOver:param1 withGameResult:param2 andCelebrityToFind:param3];
    } else if ([command compare:K_OPPONENT_QUIT_GAME] == NSOrderedSame) {
        [self onCommandOpponentQuit:param1];
    } else if ([command compare:K_NEW_PACKAGE] == NSOrderedSame) {
        [self onCommandNewPackage:param1 isAvailable:param2];
    } else if ([command compare:K_CELEBRITY_LIST_END] == NSOrderedSame) {
        [self onCommandCelebrityListEnd];
    } else if ([command compare:K_TOP_CELEBRITY] == NSOrderedSame) {
        [self onCommandTopCelebrity:param1 withName:param2 andRole:param3];
    } else if ([command compare:K_NEW_HISTORICAL_GAME] == NSOrderedSame) {
        [self onCommandNewHistoricalGame:param1 withOpponent:param2 andWinnerIsMe:param3 andMyCelebrity:param4 andMyOpponentCelebrity:param5];
    }


}

#pragma mark - Process commands from the server
-(void) onCommandNotificationAck
{
    fGamesInProgressLoaded = false;
    fCelebrityLoaded = false;
    
    [self getGamesInProgress];
    [self getAvailablePackages];
    [self getCelebrityList];
    [self getTopCelebrityList];
    [self getMyGamesHistory];
}
-(void) onCommandNewGame:(NSString*)gameID withOpponent:(NSString*)opponent andPackages:(NSString*)packages
{
    activeGameID = gameID;
    [self.games setObject:[[nmifGame alloc] init:gameID withOpponent:opponent andPackages:packages] forKey:activeGameID];
    [delegate onNewRandomGame];
}
-(void) onCommandNewGameInProgress:(NSString*)gameID withOpponent:(NSString*)opponent withToken:(NSString*)token andCelebrityName:(NSString*)celebrityName andCelebrityPickedUpByOpponent:(NSString*)celebrityPickedUpByOpponent andPackages:(NSString*)packages
{
    [self addGameInProgress:gameID withOpponent:opponent withToken:token andCelebrityName:celebrityName andCelebrityPickedUpByOpponent:celebrityPickedUpByOpponent andPackages:packages];
}
-(void) onCommandNewGameInProgressQuestion:(NSString*)gameID withQuestionID:(NSString*)questionID withQuestionAsked:(NSString*)questionAsked andAnswer:(NSString*)answer
{
    nmifQuestion *question = [[nmifQuestion alloc] initWithQuestionID:questionID andQuestion:questionAsked andAnswer:answer];
    [[[self.games objectForKey:gameID] questionList] setValue:question forKey:questionID];
}

-(void) onCommandNewGameInProgressEnd
{
    self.fGamesInProgressLoaded = true;
    if ([delegate respondsToSelector:@selector(onGamesInProgressLoaded)]) {
        [delegate onGamesInProgressLoaded];
    }
}
-(void) onCommandNewCelebrity:(NSString*)celebrityID withName:(NSString*)name andRole:(NSString*)role
{
    [self addCelebrityToDatastore:[celebrityID intValue] withCelebrityName:name andRole:role];
}
-(void) onCommandCelebrityListEnd
{
    self.fCelebrityLoaded = true;
    if ([delegate respondsToSelector:@selector(onCelebrityListEnd)]) {
        [delegate onCelebrityListEnd];
    }
}
-(void) onCommandTopCelebrity:(NSString*)position withName:(NSString*)name andRole:(NSString*)role
{
    nmifCelebrity *c = [[nmifCelebrity alloc] initWithName:name andRole:role];   
    [self.topCelebrities insertObject:c atIndex:[position intValue]];
}

-(void) onCommandPickupCelebrityAck:(NSString*)gameID withCelebrity:(NSString*)celebrity
{
    [[self.games objectForKey:gameID] setCelebrityPickedUpByMe:true];
    [[self.games objectForKey:gameID] setOpponentCelebrity:celebrity];
    
    if ([gameID compare:activeGameID] == NSOrderedSame) {
        [delegate onPickupCelebritySuccess:celebrity];
    } else {
        NSArray *params = [[NSArray alloc] initWithObjects:gameID, celebrity, nil];
        [[self.games objectForKey:gameID] addPendingEvents:K_CELEBRITY_PICKED_UP_BY_ME withParams:params];
    }
}
-(void) onCommandPickupCelebrityError:(NSString*)gameID withError:(NSString*)error
{
    if ([gameID compare:activeGameID] == NSOrderedSame) {
        [delegate onPickupCelebrityError:error];
    }
}
-(void) onCommandCelebrityPickupByOpponent:(NSString*)gameID withCelebrity:(NSString*)celebrity
{
    [[self.games objectForKey:gameID] setCelebrityPickedUpByOpponent:true];
    if ([gameID compare:activeGameID] == NSOrderedSame && [delegate respondsToSelector:@selector(onCelebrityPickedUpByOpponent:)]) {
        [delegate onCelebrityPickedUpByOpponent:celebrity];
    } else {
        NSArray *params = [[NSArray alloc] initWithObjects:gameID, celebrity, nil];
        [[self.games objectForKey:gameID] addPendingEvents:K_CELEBRITY_PICKED_UP_BY_OPPONENT withParams:params];
    }
}
-(void) onCommandAskQuestionAck:(NSString*)gameID withQuestionID:(NSString*)questionID andQuestion:(NSString*)question
{
    [self addToQuestionList:questionID withQuestion:question forGameID:gameID];
    [delegate onAskQuestionSuccess:[questionID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
}
-(void) onCommandAskQuestionError:(NSString*)gameID withError:(NSString*)error
{
    if ([gameID compare:activeGameID] == NSOrderedSame) {
        [delegate onAskQuestionError:error];
    } else {
        NSArray * params = [[NSArray alloc] initWithObjects:gameID, error, nil];
        [[self.games objectForKey:gameID] addPendingEvents:K_ASK_QUESTION_ERROR withParams:params];
    }
}
-(void) onCommandQuestionAsked:(NSString*)gameID withQuestionID:(NSString*)questionID andQuestion:(NSString*)question
{
    if ([gameID compare:activeGameID] == NSOrderedSame) {
        [delegate onQuestionAsked:questionID withQuestion:question];
    } else  {
        NSArray * params = [[NSArray alloc] initWithObjects:gameID, questionID, question, nil];
        [[self.games objectForKey:gameID] addPendingEvents:K_QUESTION_ASKED withParams:params];
    }
}
-(void) onCommandQuestionAnswered:(NSString*)gameID withQuestionID:(NSString*)questionID andAnswer:(NSString*)answer
{
    [self updateQuestionListWithAnswer:questionID withAnswer:answer forGameID:gameID];
    if ([gameID compare:activeGameID] == NSOrderedSame) {
        [delegate onQuestionAnswered:[questionID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] withAnswer:answer];
    } else {
        NSArray * params = [[NSArray alloc] initWithObjects:gameID, questionID, answer, nil];
        [[self.games objectForKey:gameID] addPendingEvents:K_QUESTION_ANSWERED withParams:params];
    }

    
}
-(void) onCommandQuestionAnsweredAck:(NSString*)gameID
{
    if ([gameID compare:activeGameID] == NSOrderedSame) {
        [delegate onQuestionAnsweredAck];
    } else {
        NSArray * params = [[NSArray alloc] initWithObjects:gameID, nil];
        [[self.games objectForKey:gameID] addPendingEvents:K_QUESTION_ANSWERED_ACK withParams:params];
    }
}
-(void) onCommandCelebritySubmitted:(NSString*)gameID withCelebrity:(NSString*)celebrity andStatus:(NSString*)status
{
    if ([gameID compare:activeGameID] == NSOrderedSame) {
        [delegate onCelebritySubmitted:celebrity withStatus:status];
    } else {
        NSArray * params = [[NSArray alloc] initWithObjects:gameID, celebrity, status, nil];
        [[self.games objectForKey:gameID] addPendingEvents:K_CELEBRITY_SUBMITTED withParams:params];
    }
}
-(void) onCommandCelebritySubmittedByOpponent:(NSString*)gameID withOpponent:(NSString*)opponent andStatus:(NSString*)status
{
    if ([gameID compare:activeGameID] == NSOrderedSame) {
        [delegate onCelebritySubmittedByOpponent:opponent withStatus:status];
    } else {
        NSArray * params = [[NSArray alloc] initWithObjects:gameID, opponent, status, nil];
        [[self.games objectForKey:gameID] addPendingEvents:K_CELEBRITY_SUBMITTED_BY_OPPONENT withParams:params];
    }
}
-(void) onCommandOpponentStatusUpdated:(NSString*)gameID withStatus:(NSString*)status
{
    [[self.games objectForKey:gameID] setOpponentStatus:status];
    if ([gameID compare:activeGameID] == NSOrderedSame) {
        [delegate onOpponentStatusUpdated];
    }
   
}
-(void) onCommandNewTurn:(NSString*)gameID withMyTurn:(NSString*)myTurn
{
    bool fMyTurn = YES;
    if ([myTurn compare:@"0"] == NSOrderedSame) {
        fMyTurn = NO;
    }
    if ([gameID compare:activeGameID] == NSOrderedSame) {
        [delegate onNewTurn:fMyTurn];
    } else {
        NSArray * params = [[NSArray alloc] initWithObjects:gameID, myTurn, nil];
        [[self.games objectForKey:gameID] addPendingEvents:K_NEW_TURN withParams:params];
    }
}

-(void) onCommandGameOver:(NSString*)gameID withGameResult:(NSString*)gameResult andCelebrityToFind:(NSString*)celebrity
{
    if ([gameID compare:activeGameID] == NSOrderedSame) {
        if ([gameResult compare:@"youwon"] == NSOrderedSame) {
            [delegate onGameWon];
        } else if ([gameResult compare:@"youlost"] == NSOrderedSame) {
            [delegate onGameLost:celebrity];
        }
    } else {
        [[self.games objectForKey:gameID] addPendingEvents:K_GAME_OVER withParams: [[NSArray alloc] initWithObjects:gameID, gameResult, celebrity, nil]];
    }
}

-(void) onCommandOpponentQuit:(NSString*)gameID
{
    if ([gameID compare:activeGameID] == NSOrderedSame) {
        NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"OPPONENT_HAS_QUIT", nil), [self opponentName]];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NMIF", nil) message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [self gameOver];
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        UIViewController<GMRestoreViewDelegate> *VC = (UIViewController<GMRestoreViewDelegate>*)[storyBoard instantiateViewControllerWithIdentifier:@"gameInProgressViewID"];
        [delegate onOpponentQuit:VC];
    } else {
        [[self.games objectForKey:gameID] addPendingEvents:K_OPPONENT_QUIT_GAME withParams: [[NSArray alloc] initWithObjects:gameID, nil]];
    }
}

-(void) onCommandNewPackage:(NSString*)packageName isAvailable:(NSString*)bAvailable
{
    if ([bAvailable compare:@"true"] == NSOrderedSame) {
        [self enablePackage:packageName isAvailable:YES];
    } else {
        [self enablePackage:packageName isAvailable:NO];
    }
}

-(void) onCommandNewHistoricalGame:(NSString*)gameDate withOpponent:(NSString*)theOpponent andWinnerIsMe:(NSString*)Iwon andMyCelebrity:(NSString*)myCelebrity andMyOpponentCelebrity:(NSString*)myOpponentCelebrity
{
    nmifHistoricalGame *theHistoricalGame = [[nmifHistoricalGame alloc] initWithDate:gameDate andOpponent:theOpponent andWinnerIsMe:Iwon andMyCelebrity:myCelebrity andMyOpponentCelebrity:myOpponentCelebrity];
    [[self historicalGames] addObject:theHistoricalGame];
}

#pragma mark - active game interaction
-(void) celebrityWasPickedUpByMe {
    [[self.games objectForKey:activeGameID] setCelebrityPickedUpByMe:true];
}
-(void) celebrityWasPickedUpByOpponent {
    [[self.games objectForKey:activeGameID] setCelebrityPickedUpByOpponent:true];
}
-(bool) wasCelebrityPickedUpByMe {
    return [[self.games objectForKey:activeGameID] celebrityPickedUpByMe];
}
-(bool) wasCelebrityPickedUpByOpponent {
    return [[self.games objectForKey:activeGameID] celebrityPickedUpByOpponent];
}

-(NSString*) opponentName {
    return [[self.games objectForKey:activeGameID] opponentName];
}
-(NSString*) opponentStatus {
    return [[self.games objectForKey:activeGameID] opponentStatus];
}
-(NSString*) opponentCelebrity {
    return [[self.games objectForKey:activeGameID] opponentCelebrity];
}
-(NSMutableDictionary*) questions {
    return [[self.games objectForKey:activeGameID] questionList];
}
-(NSArray*) packages {
    return [[self.games objectForKey:activeGameID] packages];
}
-(bool)myTurn
{
    return [[self.games objectForKey:activeGameID] myTurn];
}
-(void) replayPendingEvents
{
    NSArray *commands = [[self.games objectForKey:activeGameID] getPendingEvents];
    
    nmifCommand *c;
    for (c in commands) {
        [self decodeCommand:[c command] withParam1:[c getParamAtPosition:0] withParam2:[c getParamAtPosition:1] withParam3:[c getParamAtPosition:2] withParam4:[c getParamAtPosition:3] withParam5:[c getParamAtPosition:4] withParam6:[c getParamAtPosition:5]];
    }
    
    [[self.games objectForKey:activeGameID] removePendingEvents];

}

-(void) addQuestionToHistory:(NSString*)theQuestion
{
    [self.questionHistory addObject:theQuestion];
    NSString *theKey = [NSString stringWithFormat:@"%@.%d", K_QUESTION_HISTORY_KEY, [self.questionHistory count]];

    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:theQuestion forKey:theKey];
    [standardUserDefaults synchronize];
}

-(void) loadQuestionHistory
{
    int i = 1;
    NSString * theQuestion = nil;
    NSUserDefaults* standardUserDefaults = [NSUserDefaults standardUserDefaults];

    while ((theQuestion = [standardUserDefaults objectForKey:[NSString stringWithFormat:@"%@.%d", K_QUESTION_HISTORY_KEY, i]]) != nil ) {
        [self.questionHistory addObject:theQuestion];
         i++;
    }
}

@end
