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

@interface chWaitForQuestionViewController ()

@end

@implementation chWaitForQuestionViewController
@synthesize lblQuestionAsked = _lblQuestionAsked;
@synthesize questionID = _questionID;
@synthesize IWon = _IWon;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES]; 
    hud.labelText = [NSString stringWithFormat:@"attente de question de %@ ...", [[GMHelper sharedInstance] opponentName]];
    
    [[GMHelper sharedInstance] setDelegate:self];
}

- (void) answer:(NSString*)withAnswer
{    
    [[GMHelper sharedInstance] answerQuestion:self.questionID withAnswer:withAnswer withDelegate:self];
}
- (IBAction)onBtnMayBePressed:(id)sender {
    [self answer:@"maybe"];
}
- (IBAction)onBtnNoPressed:(id)sender {
    [self answer:@"no"];
}
- (IBAction)onBtnYesPressed:(id)sender {
    [self answer:@"yes"];
}

- (void)viewDidUnload
{
    [self setLblQuestionAsked:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"gameOver"]) {
        if ([segue.destinationViewController isKindOfClass:[chGameOverViewController class]] == YES) {
            [segue.destinationViewController setGameWon:self.IWon];
        }
    } else if ([segue.identifier isEqualToString:@"askNextQuestion"]) {
        if ([segue.destinationViewController isKindOfClass:[chNewQuestionViewController class]] == YES) {
            [segue.destinationViewController setQuestionNumberToNext];
            [segue.destinationViewController setQuestionLabel:[NSString stringWithFormat:@"Posez la questions suivante a %@. Il ne pourra repondre que par oui, non ou peut etre", [[GMHelper sharedInstance] opponentName]]];
        }
    }
}

#pragma GMHelperDelegate
-(void) onQuestionAsked:(NSString*) questionID withQuestion:(NSString*)question
{
    self.questionID = questionID;
    [[self lblQuestionAsked] setText:[NSString stringWithFormat:@"%@ demande: %@", [[GMHelper sharedInstance] opponentName], question]];    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void) onCelebritySubmittedByOpponent:(NSString*)celebritySubmitted withStatus:(NSString*)status
{
    if ([status compare:@"success"] == NSOrderedSame) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Game over" message:[NSString stringWithFormat:@"%@ a trouve la bonne reponse !", [[GMHelper sharedInstance] opponentName]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];  
        // segue to screen @want to play again?
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Mauvaise reponse" message:[NSString stringWithFormat:@"%@ a propose %@", [[GMHelper sharedInstance] opponentName], celebritySubmitted] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];     
        
        //Segue to next question from opponent
    }
}

-(void) onQuestionAnsweredAck
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = [NSString stringWithFormat:@"en attente de la fin du tour de %@ ...", [[GMHelper sharedInstance] opponentName]]; 
}
-(void) onNewTurn:(BOOL)myTurn
{
    if (myTurn) {
        [self performSegueWithIdentifier:@"askNextQuestion" sender:self];
    }
}
-(void) onGameOver:(BOOL)Iwon
{
    self.IWon = Iwon;
    [self performSegueWithIdentifier:@"gameOver" sender:self];
}

-(void) onOpponentDisconnected {
    [[self navigationController] popToRootViewControllerAnimated:TRUE];
}

@end
