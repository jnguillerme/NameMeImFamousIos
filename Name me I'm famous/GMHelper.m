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

@implementation GMHelper

NSString * const K_NEW_RANDOM_GAME_URL = @"http://89.226.34.6:8081/newRandomGame";

// commands received on the stream
NSString * const K_NOTIFICATION_ON = @"notifymeon";
NSString * const K_NOTIFICATION_OFF = @"notifymeoff";
NSString * const K_NOTIFICATION_ACK = @"notifyack";
NSString * const K_NEWGAME = @"newgame";
NSString * const K_PICKUP_CELEBRITY = @"pickupcelebrity";
NSString * const K_PICKUP_CELEBRITY_ACK = @"pickupcelebrityack";
NSString * const K_PICKUP_CELEBRITY_ERROR = @"pickupcelebrityerror";
NSString * const K_ASK_QUESTION = @"askquestion";
NSString * const K_ASK_QUESTION_ACK = @"askquestionack";
NSString * const K_ASK_QUESTION_ERROR = @"askquestionerror";
NSString * const K_CELEBRITY_PICKUP_BY_OPPONENT = @"celebritypickupbyopponent";
NSString * const K_QUESTION_ASKED = @"questionasked";
NSString * const K_QUESTION_ANSWERED = @"questionanswered";
NSString * const K_QUESTION_ANSWERED_ACK = @"questionansweredack";
NSString * const K_SUBMIT_CELEBRITY = @"submitcelebrity";
NSString * const K_CELEBRITY_SUBMITTED = @"celebritysubmitted";
NSString * const K_CELEBRITY_SUBMITTED_BY_OPPONENT = @"celebritysubmittedbyopponent";
NSString * const K_ANSWER_QUESTION = @"answerquestion";
NSString * const K_END_TURN = @"endturn";
NSString * const K_NEW_TURN = @"newturn";
NSString * const K_GAME_OVER = @"gameover";

NSUInteger const K_STREAM_COMMAND_IDX = 0;
NSUInteger const K_STREAM_PARAM_IDX = 1;

@synthesize delegate;
@synthesize sessionID;
@synthesize opponentName;
@synthesize questionList = _questionList;

-(NSMutableDictionary*)questionList {
    if (!_questionList) {
        _questionList = [[NSMutableDictionary alloc] init];
    }
    return _questionList;
}
-(void)setQuestionList:(NSArray *)ql {
    _questionList = [ql copy];
}

static GMHelper * sharedHelper = 0;

+ (GMHelper*) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[GMHelper alloc] init];        
    }
    return sharedHelper;
}

-(void) subscribeToNotifications {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"89.226.34.6", 5001, &readStream, &writeStream);
    
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
    NSData *data = [[NSData alloc] initWithData:[stringData dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];    
}
-(void) startNotifications {
    [self writeToOutputStream:[NSString stringWithFormat:@"%@:%@", K_NOTIFICATION_ON, sessionID]];
}

-(void) pickupCelebrity:(NSString*)celebrity withDelegate:(id <GMHelperDelegate>)GMDelegate
{
    self.delegate = GMDelegate;
    [self writeToOutputStream:[NSString stringWithFormat:@"%@:%@:%@", K_PICKUP_CELEBRITY, sessionID, celebrity]];
}

-(void) askQuestion:(NSString *)question withDelegate:(id <GMHelperDelegate>)GMDelegate
{
    self.delegate = GMDelegate;
    [self writeToOutputStream:[NSString stringWithFormat:@"%@:%@:%@", K_ASK_QUESTION, sessionID, question]];    
}

-(void) answerQuestion:(NSString*)questionID withAnswer:answer withDelegate:(id <GMHelperDelegate>)GMDelegate
{
    self.delegate = GMDelegate;
    [self writeToOutputStream:[NSString stringWithFormat:@"%@:%@:%@:%@", K_ANSWER_QUESTION, sessionID, questionID, answer]];        
}

-(void) submitCelebrity:(NSString*)celebrityName withDelegate:(id <GMHelperDelegate>)GMDelegate
{
    self.delegate = GMDelegate;
    [self writeToOutputStream:[NSString stringWithFormat:@"%@:%@:%@", K_SUBMIT_CELEBRITY, sessionID, celebrityName]];
}

-(void) endTurn:(id <GMHelperDelegate>)GMDelegate
{
    self.delegate = GMDelegate;
    [self writeToOutputStream:[NSString stringWithFormat:@"%@:%@", K_END_TURN, sessionID]];
}

-(void) gameOver
{
    [self resetQuestionList];
    self.opponentName = @"";
}
-(void) addToQuestionList:(NSString*)questionID withQuestion:(NSString*)question
{
    [[self questionList] setValue:[[nmifQuestion alloc] initWithQuestionID:questionID andQuestion:question]  forKey:questionID];
}

-(void) updateQuestionListWithAnswer:(NSString*)questionID withAnswer:(NSString*)answer
{
    nmifQuestion* question = [[self questionList] objectForKey:questionID];
    question.answer = answer;

    [ [self questionList] setValue:question forKey:questionID];
}

-(void) resetQuestionList
{
    [ [self questionList] removeAllObjects];    
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
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        if (nil != output) {                            
                            NSLog(@"server said %@", output);
                            
                            NSArray	*outputMessages = [output componentsSeparatedByString:@"$"];
                            
                            for (NSString* message in outputMessages) {
                                NSLog(@"processing message %@", message);
                                NSArray	*outputToken = [message componentsSeparatedByString:@":"];
                                if ([outputToken count] >= 2) {
                                    NSString* param2 = nil;
                                    if ([outputToken count] >= 3) {
                                        param2 = [[outputToken objectAtIndex:K_STREAM_PARAM_IDX+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                    }
                                    [self decodeCommand:[[outputToken objectAtIndex:K_STREAM_COMMAND_IDX] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                                             withParam1:[[outputToken objectAtIndex:K_STREAM_PARAM_IDX] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                                             withParam2:param2];
                                }
                            }
                        }
                    }
                }                        
            }
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host");
            break;
            
        case NSStreamEventEndEncountered:
            break;
            
        default:
            break;
    }
}

// decode the command received and call the delegate
-(void) decodeCommand:(NSString*)command withParam1:(NSString*)param1 withParam2:(NSString*)param2
{
    if ([command compare:K_NOTIFICATION_ACK] == NSOrderedSame) {
    
    } else if ([command compare:K_NEWGAME] == NSOrderedSame) {
        self.opponentName = param1;
        [delegate onNewRandomGame:self.opponentName];
    } else if ([command compare:K_PICKUP_CELEBRITY_ACK] == NSOrderedSame) {
        [delegate onPickupCelebritySuccess:param1];
    } else if ([command compare:K_PICKUP_CELEBRITY_ERROR] == NSOrderedSame) {
        [delegate onPickupCelebrityError:param1]; 
    } else if ([command compare:K_CELEBRITY_PICKUP_BY_OPPONENT] == NSOrderedSame) {
        [delegate onCelebrityPickedUpByOpponent:param1];
    } else if ([command compare:K_ASK_QUESTION_ACK] == NSOrderedSame) {
        [self addToQuestionList:param1 withQuestion:param2];
        [delegate onAskQuestionSuccess:[param1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    } else if ([command compare:K_ASK_QUESTION_ERROR] == NSOrderedSame) {
        [delegate onAskQuestionError:param1];
    } else if ([command compare:K_QUESTION_ASKED] == NSOrderedSame) {
        [delegate onQuestionAsked:param1 withQuestion:param2];
    } else if ([command compare:K_QUESTION_ANSWERED] == NSOrderedSame) {
        [self updateQuestionListWithAnswer:param1 withAnswer:param2];
        [delegate onQuestionAnswered:[param1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] withAnswer:param2];                                
    } else if ([command compare:K_QUESTION_ANSWERED_ACK] == NSOrderedSame) {
        [delegate onQuestionAnsweredAck];
    } else if ([command compare:K_CELEBRITY_SUBMITTED] == NSOrderedSame) {
        [delegate onCelebritySubmitted:param1 withStatus:param2];
    } else if ([command compare:K_CELEBRITY_SUBMITTED_BY_OPPONENT] == NSOrderedSame) {
        [delegate onCelebritySubmittedByOpponent:param1 withStatus:param2];
    } else if ([command compare:K_NEW_TURN] == NSOrderedSame) {
        if ([param1 compare:@"0"] == NSOrderedSame) { 
            [delegate onNewTurn:NO];
        } else {
            [delegate onNewTurn:YES];        
        }
    }else if ([command compare:K_GAME_OVER] == NSOrderedSame) {
        [self gameOver];
        if ([param1 compare:@"youwon"] == NSOrderedSame) { 
            [delegate onGameOver:YES];
        } else if ([param1 compare:@"youlost"] == NSOrderedSame) {
            [delegate onGameOver:NO];                                    
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GAME_OVER", nil) message:NSLocalizedString(@"OPPONENT_DISCONNECTED", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [delegate onOpponentDisconnected];
        }
    }
}

@end
