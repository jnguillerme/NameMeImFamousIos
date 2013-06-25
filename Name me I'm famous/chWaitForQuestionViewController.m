//
//  chWaitForQuestionViewController.m
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 30/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "chWaitForQuestionViewController.h"
#import "chNewQuestionViewController.h"
#import "MBProgressHUD.h"
#import "chGameOverViewController.h"
#import "nmifBackgroundLayer.h"

@interface chWaitForQuestionViewController ()

@end

@implementation chWaitForQuestionViewController
@synthesize lblQuestionAsked = _lblQuestionAsked;
@synthesize questionID = _questionID;
@synthesize btnParam;

NSString * const K_QUESTION_TO_ANSWER_KEY = @"NMIF.ANSWERQUESTIONVIEWID.QUESTION";
NSString * const K_QUESTION_ID_TO_ANSWER_KEY = @"NMIF.ANSWERQUESTIONVIEWID.QUESTIONID";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        IWon = false;
        celebrityToFind= nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CAGradientLayer *bgLayer = [nmifBackgroundLayer blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    //  opponent status / btn param position
    CGRect frame = self.btnParam.frame;
    CGFloat xPosition = self.view.bounds.origin.x + self.view.bounds.size.width - (self.btnParam.bounds.size.width);
    CGFloat yPosition = self.view.bounds.origin.y + self.view.bounds.size.height - (self.btnParam.bounds.size.height * 1.5);
    frame.origin = CGPointMake(xPosition, yPosition);
    self.btnParam.frame = frame;
    
    frame = self.lblOpponentStatus.frame;
    xPosition = frame.origin.x;
    yPosition = self.view.bounds.origin.y + self.view.bounds.size.height - (self.btnParam.bounds.size.height * 1.5) + frame.size.height / 2;
    frame.origin = CGPointMake(xPosition, yPosition);
    self.lblOpponentStatus.frame = frame;
    
    
    // menu
    id<nmifMenuTableViewDelegate> theDelegate = (id<nmifMenuTableViewDelegate>)self;
    menuTableView = [[nmifMenuAnswerQuestionTableView alloc] initWithDelegate:theDelegate];
    self.tvMenu.delegate = menuTableView;
    self.tvMenu.dataSource = menuTableView;
    
    [menuTableView addMenuItem:NSLocalizedString(@"YES", nil) withDescription:NSLocalizedString(@"YES_DESCRIPTION", nil) andImage:@"yes.png" andAction:@selector(onAnswerYes) andDelegate:theDelegate];
    [menuTableView addMenuItem:NSLocalizedString(@"NO", nil) withDescription:NSLocalizedString(@"NO_DESCRIPTION", nil) andImage:@"no.png" andAction:@selector(onAnswerNo) andDelegate:theDelegate];
    [menuTableView addMenuItem:NSLocalizedString(@"MAYBE", nil) withDescription:NSLocalizedString(@"MAYBE_DESCRIPTION", nil) andImage:@"maybe.png" andAction:@selector(onAnswerMaybe) andDelegate:theDelegate];
    
    [self.tvMenu reloadData];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = [NSString stringWithFormat:NSLocalizedString(@"WAIT_FOR_QUESTION", nil), [[GMHelper sharedInstance] opponentName]];
    
    [[GMHelper sharedInstance] setDelegate:self];
    
    self.lblOpponentCelebrity.text = [NSString stringWithFormat:NSLocalizedString(@"OPPONENT_CELEBRITY", nil), [[GMHelper sharedInstance] opponentName], [[GMHelper sharedInstance] opponentCelebrity]];
    self.lblOpponentStatus.text = [NSString stringWithFormat:NSLocalizedString(@"OPPONENT_STATUS", nil), [[GMHelper sharedInstance] opponentName], [[GMHelper sharedInstance] opponentStatus]];
    
    [[GMHelper sharedInstance] saveGameInProgress:@"answerQuestionViewID"];
    [[GMHelper sharedInstance] replayPendingEvents];    
}

- (void) viewWillAppear:(BOOL)animated
{
    [[self  navigationController] setNavigationBarHidden:YES animated:YES];
    self.lblOpponentStatus.text = [NSString stringWithFormat:NSLocalizedString(@"OPPONENT_STATUS", nil), [[GMHelper sharedInstance] opponentName], [[GMHelper sharedInstance] opponentStatus]];
    
    if (questionAsked != nil) {
        [[self lblQuestionAsked] setText:[NSString stringWithFormat:NSLocalizedString(@"OPPONENT_ASK", nil), [[GMHelper sharedInstance] opponentName], questionAsked]];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}
-(void) viewDidAppear:(BOOL)animated
{
    [[GMHelper sharedInstance] setDelegate:self];
    [[GMHelper sharedInstance] replayPendingEvents];
}
- (void) answer:(NSString*)withAnswer
{    
    [[GMHelper sharedInstance] answerQuestion:self.questionID withAnswer:withAnswer withDelegate:self];
}

- (void)viewDidUnload
{
    [self setLblQuestionAsked:nil];
    [self setLblOpponentStatus:nil];
    [self setTvMenu:nil];
    [self setBtnParam:nil];
    [self setLblOpponentCelebrity:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([MBProgressHUD HUDForView:self.view] != nil) {
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint location = [touch locationInView:touch.view];
    
        if (CGRectContainsPoint(self.btnParam.frame, location)) {
            [self performSegueWithIdentifier:@"paramFromWaitForQuestion" sender:self];
        }
    }    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[GMHelper sharedInstance] clearLocalDataForKey:K_QUESTION_TO_ANSWER_KEY];
    if ([segue.identifier isEqualToString:@"gameOver"]) {
        if ([segue.destinationViewController isKindOfClass:[chGameOverViewController class]] == YES) {
            [segue.destinationViewController setGameWon:IWon];
            [segue.destinationViewController setCelebrityToFind:celebrityToFind];
        }
    } else if ([segue.identifier isEqualToString:@"askNextQuestion"]) {
        if ([segue.destinationViewController isKindOfClass:[chNewQuestionViewController class]] == YES) {
            [segue.destinationViewController setQuestionNumberToNext];
            [segue.destinationViewController setQuestionLabel:[NSString stringWithFormat:NSLocalizedString(@"ASK_NEXT_QUESTION", nil), [[GMHelper sharedInstance] opponentName]]];
        }
    }
}


#pragma GMHelperDelegate
-(void) onConnectionFailed {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil) message:NSLocalizedString(@"CONNECTION_FAILED", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
-(void) onQuestionAsked:(NSString*) questionID withQuestion:(NSString*)question
{
    self.questionID = questionID;
    [[self lblQuestionAsked] setText:[NSString stringWithFormat:NSLocalizedString(@"OPPONENT_ASK", nil), [[GMHelper sharedInstance] opponentName], question]];
    
    [[GMHelper sharedInstance] storeLocalData:questionID forKey:K_QUESTION_ID_TO_ANSWER_KEY];
    [[GMHelper sharedInstance] storeLocalData:question forKey:K_QUESTION_TO_ANSWER_KEY];

    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void) onCelebritySubmittedByOpponent:(NSString*)celebritySubmitted withStatus:(NSString*)status
{
    if ([status compare:@"success"] == NSOrderedSame) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GAME_OVER", nil) message:[NSString stringWithFormat:NSLocalizedString(@"CORRECT_ANSWER_BY_OPPONENT", nil), [[GMHelper sharedInstance] opponentName]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];  
        // segue to screen @want to play again?
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WRONG_ANSWER", nil) message:[NSString stringWithFormat:NSLocalizedString(@"WRONG_ANSWER_SUBMITTED_BY_OPPONENT", nil), [[GMHelper sharedInstance] opponentName], celebritySubmitted] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];     
        
        //Segue to next question from opponent
    }
}

-(void) onQuestionAnsweredAck
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = [NSString stringWithFormat:NSLocalizedString(@"WAITING_FOR_END_TURN", nil), [[GMHelper sharedInstance] opponentName]];
}
-(void) onNewTurn:(BOOL)myTurn
{
    if (myTurn) {
        [self performSegueWithIdentifier:@"askNextQuestion" sender:self];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = [NSString stringWithFormat:NSLocalizedString(@"SKIP_TURN", nil), [[GMHelper sharedInstance] opponentName]];    }
}
-(void) onGameWon
{
    IWon = true;
    [self performSegueWithIdentifier:@"gameOver" sender:self];
}

-(void) onGameLost:(NSString*)celebrityName
{
    IWon = false;
    celebrityToFind = celebrityName;
    [self performSegueWithIdentifier:@"gameOver" sender:self];
}
-(void) onOpponentDisconnected {
//    [[self navigationController] popToRootViewControllerAnimated:TRUE];
}
-(void) onOpponentStatusUpdated {
    self.lblOpponentStatus.text = [NSString stringWithFormat:NSLocalizedString(@"OPPONENT_STATUS", nil), [[GMHelper sharedInstance] opponentName], [[GMHelper sharedInstance] opponentStatus]];
}
-(void) onOpponentQuit:(UIViewController<GMRestoreViewDelegate> *)VC
{
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma nmifMenuAnswerQuestionTableView
- (void)onAnswerMaybe {
    [self answer:@"maybe"];
}
- (void)onAnswerNo {
    [self answer:@"no"];
}
- (void)onAnswerYes {
    [self answer:@"yes"];
}

#pragma GMRestoreViewDelegate
- (void) restorePrivateData
{
    if ([[GMHelper sharedInstance] hasLocalDataForKey:K_QUESTION_TO_ANSWER_KEY]) {
        questionAsked = [[NSString alloc] initWithString:[[GMHelper sharedInstance] localDataForKey:K_QUESTION_TO_ANSWER_KEY]];
    }
    if ([[GMHelper sharedInstance] hasLocalDataForKey:K_QUESTION_ID_TO_ANSWER_KEY]) {
        self.questionID = [[NSString alloc] initWithString:[[GMHelper sharedInstance] localDataForKey:K_QUESTION_ID_TO_ANSWER_KEY]];
    }
}
@end
