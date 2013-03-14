//
//  nmifServerCommands.m
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 04/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "nmifServerCommands.h"

@implementation nmifServerCommands

NSString *const K_SERVER_IP = @"192.168.0.6";
//89.226.34.6
NSString * const K_NEW_RANDOM_GAME_URL = @"http://192.168.0.6:8081/newRandomGame";
//89.226.34.6
NSString * const K_CREATE_PLAYER_ACCOUNT_URL = @"http://192.168.0.6:8081/createPlayerAccount";
NSString * const K_LOGIN_PLAYER_ACCOUNT_URL  = @"http://192.168.0.6:8081/loginPlayerAccount";
NSString * const K_LOGOUT_PLAYER_ACCOUNT_URL  = @"http://192.168.0.6:8081/logoutPlayerAccount";
NSString * const K_FORGOT_PASSWORD_URL = @"http://192.168.0.6/forgotPassword";
NSString * const K_PING_PLAYER_ACCOUNT_URL  = @"http://192.168.0.6:8081/pingPlayerAccount";


// commands received on the stream
NSString * const K_NOTIFICATION_ON = @"notifymeon";
NSString * const K_NOTIFICATION_OFF = @"notifymeoff";
NSString * const K_NOTIFICATION_ACK = @"notifyack";
NSString * const K_NEWGAME = @"newgame";
NSString * const K_GAMESINPROGRESS = @"getmygamesinprogress";
NSString * const K_NEW_GAMEINPROGRESS = @"newgameinprogress";
NSString * const K_NEW_GAMEINPROGRESS_END = @"newgameinprogressend";
NSString * const K_GET_CELEBRITY_LIST = @"getcelebritylist";
NSString * const K_NEW_CELEBRITY = @"newcelebrity";
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
NSString * const K_OPPONENT_STATUS_UPDATED = @"opponentstatusupdated";
NSString * const K_GAME_OVER = @"gameover";
NSString * const K_START_TYPING = @"starttyping";
NSString * const K_STOP_TYPING = @"stoptyping";

NSUInteger const K_STREAM_COMMAND_IDX = 0;
NSUInteger const K_STREAM_PARAM_IDX = 1;

NSString * const K_VIEW_KEY = @"NMIF.VIEW.CURRENT";
NSString * const K_OPPONENT_NAME = @"NMIF.GM.OPPONENTNAME";
NSString * const K_CELEBRITY_PICKED_UP_BY_ME = @"NMIF.GM.CELEBRITYPICKEDUPBYME";
NSString * const K_CELEBRITY_PICKED_UP_BY_OPPONENT = @"NMIF.GM.CELEBRITYPICKEDUPBYOPPONENT";

@end