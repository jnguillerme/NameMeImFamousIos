//
//  chCelebrityChoiceViewController.m
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 26/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "chCelebrityChoiceViewController.h"
#import "chNewQuestionViewController.h"
#import "chWaitForQuestionViewController.h"
#import "nmifCelebrity.h"
#import "MBProgressHUD.h"

@interface chCelebrityChoiceViewController ()

@end

@implementation chCelebrityChoiceViewController
@synthesize lblOpponentFound = _lblOpponentFound;
@synthesize lblCelebrityName = _lblCelebrityName;
@synthesize opponentName = _opponentName;
@synthesize celebrityPickedUpByMe = _celebrityPickedUpByMe;
@synthesize celebrityPickedUpByOpponent = _celebrityPickedUpByOpponent;


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
    
	// Do any additional setup after loading the view
    self.lblOpponentFound.text = [NSString stringWithFormat:NSLocalizedString(@"OPPONENTFOUND", nil), self.opponentName];
    [[GMHelper sharedInstance] setDelegate:self];
    
    self.celebrityPickedUpByMe = false;
    self.celebrityPickedUpByOpponent = false;
}

- (void)viewDidUnload
{
    [self setLblCelebrityName:nil];
    [self setLblOpponentFound:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onBtnChoosePressed:(id)sender 
{
    [self.view endEditing:YES];
    [[GMHelper sharedInstance] pickupCelebrity:_lblCelebrityName.text withDelegate:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender  
{
    if ([segue.identifier isEqualToString:@"askFirstQuestion"]) {
        if ([segue.destinationViewController isKindOfClass:[chNewQuestionViewController class]] == YES) {
            [segue.destinationViewController setQuestionNumber:1];
            [segue.destinationViewController setQuestionLabel:[NSString stringWithFormat:@"%@ a choisi votre personnalite. Posez lui des questions pour deviner qui c'est. Il ne pourra repondre que par oui, non ou peut etre", [[GMHelper sharedInstance] opponentName]]];
        }
    } else if ([segue.identifier isEqualToString:@"waitForFirstQuestion"]) {
        
    }
}

#pragma GMHelperDelegate
-(void) onPickupCelebritySuccess:(NSString *)celebrity {
    self.celebrityPickedUpByMe = true;
    [nmifCelebrity sharedInstance].celebrityName = celebrity;
    
    if (self.celebrityPickedUpByOpponent == true) {
        [self performSegueWithIdentifier:@"waitForFirstQuestion" sender:self];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES]; 
        hud.labelText = [NSString stringWithFormat:NSLocalizedString(@"WAITING_FOR_OPPONENT_CHOICE", nil), self.opponentName];
    }
}

-(void) onPickupCelebrityError:(NSString *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"PICKUP_CELEBRITY_FAILED", nil) message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
-(void) onCelebrityPickedUpByOpponent:(NSString *)celebrity
{
    self.celebrityPickedUpByOpponent = true;
    if (self.celebrityPickedUpByMe == true) {
        [self performSegueWithIdentifier:@"askFirstQuestion" sender:self];        
    }
}

-(void) onOpponentDisconnected {
    [[self navigationController] popToRootViewControllerAnimated:TRUE];    
}

@end
