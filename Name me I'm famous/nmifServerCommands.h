//
//  nmifServerCommands.h
//  Name me I'm famous
//
//  Created by Jino on 20/02/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#ifndef Name_me_I_m_famous_nmifServerCommands_h
#define Name_me_I_m_famous_nmifServerCommands_h

//89.226.34.6
// AMAZON: 54.247.53.94
NSString * const K_NEW_RANDOM_GAME_URL = @"http://54.247.53.94:8081/newRandomGame";

// commands received on the stream
NSString * const K_NOTIFICATION_ON = @"notifymeon";
NSString * const K_NOTIFICATION_OFF = @"notifymeoff";
NSString * const K_NOTIFICATION_ACK = @"notifyack";
NSString * const K_NEWGAME = @"newgame";
NSString * const K_GAMESINPROGRESS = @"getmygamesinprogress";
NSString * const K_NEW_GAMEINPROGRESS = @"newgameinprogress";
NSString * const K_NEW_GAMEINPROGRESS_QUESTION = @"newgameinprogressquestion";
NSString * const K_NEW_GAMEINPROGRESS_END = @"newgameinprogressend";
NSString * const K_GET_MY_GAMES_HISTORY = @"getmygameshistory";
NSString * const K_NEW_HISTORICAL_GAME = @"newhistoricalgame";
NSString * const K_GET_CELEBRITY_LIST = @"getcelebritylist";
NSString * const K_GET_AVAILABLE_PACKAGES = @"getavailablepackages";
NSString * const K_GET_TOP_CELEBRITY_LIST = @"gettopcelebritylist";
NSString * const K_TOP_CELEBRITY = @"topcelebrity";
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
NSString * const K_QUIT_GAME = @"quitgame";
NSString * const K_OPPONENT_QUIT_GAME = @"opponentquit";
NSString * const K_NEW_PACKAGE = @"newpackage";
NSString * const K_UPDATE_PACKAGE = @"updatepackage";
NSString * const K_CELEBRITY_LIST_END = @"celebritylistend";
NSString * const K_INVITE_FRIEND = @"invite";
NSString * const K_INVITE_FRIEND_ACK = @"inviteack";
NSString * const K_INVITE_RECEIVED = @"newinvite";
NSString * const K_DISCONNECTED = @"disconnected";
NSString * const K_ERROR = @"error";

NSUInteger const K_STREAM_COMMAND_IDX = 0;
NSUInteger const K_STREAM_PARAM_IDX = 1;

NSString * const K_VIEW_KEY = @"NMIF.VIEW.CURRENT";
NSString * const K_OPPONENT_NAME = @"NMIF.GM.OPPONENTNAME";
NSString * const K_CELEBRITY_PICKED_UP_BY_ME = @"NMIF.GM.CELEBRITYPICKEDUPBYME";
NSString * const K_CELEBRITY_PICKED_UP_BY_OPPONENT = @"NMIF.GM.CELEBRITYPICKEDUPBYOPPONENT";



#endif
