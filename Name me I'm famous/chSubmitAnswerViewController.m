//
//  chSubmitAnswerViewController.m
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 23/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "chSubmitAnswerViewController.h"
#import "chGameOverViewController.h"

@interface chSubmitAnswerViewController ()

@end

@implementation chSubmitAnswerViewController
@synthesize tfCelebrity;
@synthesize btnSubmit;
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
}

- (void)viewDidUnload
{
    [self setTfCelebrity:nil];
    [self setBtnSubmit:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)onBtnSubmit:(id)sender {
    
    [[GMHelper sharedInstance] submitCelebrity:self.tfCelebrity.text withDelegate:self];
    //UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Game over" message:winLost delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[alert show];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"gameOver"]) {
        if ([segue.destinationViewController isKindOfClass:[chGameOverViewController class]] == YES) {
            [segue.destinationViewController setGameWon:self.IWon];
        }
    }   
}
#pragma GMHelperDelegate
-(void) onCelebritySubmitted:(NSString*)celebritySubmitted withStatus:(NSString*)status
{
    if ([status compare:@"success"] == NSOrderedSame) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Game over" message:@"vous avez trouve la bonne reponse !" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];  
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Mauvaise reponse" message:[NSString stringWithFormat:@"Ce n'est pas %@", celebritySubmitted] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];     
        [[GMHelper sharedInstance] endTurn:self];    
    }
}

-(void)onNewTurn:(BOOL)myTurn
{
    if (!myTurn) {
        [self performSegueWithIdentifier:@"waitForNextQuestion" sender:self];
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
