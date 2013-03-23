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
#import "nmifBackgroundLayer.h"

@interface chCelebrityChoiceViewController ()

@end

@implementation chCelebrityChoiceViewController
@synthesize lblOpponentFound = _lblOpponentFound;
@synthesize lblCelebrityName = _lblCelebrityName;

- (void) setCelebrityName:(NSString *)celebrityName {
    [self.lblCelebrityName setText:celebrityName];
}
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
    NSLog(@"chCelbrityChoiceViewController viewDidLoad");
    [super viewDidLoad];
    
	// Do any additional setup after loading the view
    CAGradientLayer *bgLayer = [nmifBackgroundLayer blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    id<nmifMenuTableViewDelegate> theDelegate = (id<nmifMenuTableViewDelegate>)self;
    menuTableView = [[nmifMenuCelebrityChoiceTableView alloc] initWithDelegate:theDelegate];
    self.tvMenu.delegate = menuTableView;
    self.tvMenu.dataSource = menuTableView;
    [menuTableView addMenuItem:NSLocalizedString(@"PICKUP_CELEBRITY", nil) withDescription:NSLocalizedString(@"PICKUP_CELEBRITY_DESCRIPTION", nil) andImage:@"selectcelebrity.png" andAction:@selector(onCelebrityPickedUp) andDelegate:theDelegate];
    
    [self.tvMenu reloadData];

    self.lblOpponentFound.text = [NSString stringWithFormat:NSLocalizedString(@"OPPONENTFOUND", nil), [[GMHelper sharedInstance] opponentName]];
    [[GMHelper sharedInstance] setDelegate:self];
        
    self.lblOpponentStatus.text = [NSString stringWithFormat:NSLocalizedString(@"OPPONENT_STATUS", nil), [[GMHelper sharedInstance] opponentName], [[GMHelper sharedInstance] opponentStatus]];
}

-(void) viewDidAppear:(BOOL)animated
{
    NSLog(@"chCelbrityChoiceViewController viewDidAppear");
    
    [super viewDidAppear:animated];

    [[GMHelper sharedInstance] saveGameInProgress:@"celebrityChoiceViewID"];
    BOOL fPickedUpByMe = [[GMHelper sharedInstance] wasCelebrityPickedUpByMe];
    BOOL fPickedUpByOpponent = [[GMHelper sharedInstance] wasCelebrityPickedUpByOpponent];
    BOOL myTurn = [[GMHelper sharedInstance] myTurn];
    
    if (fPickedUpByMe) {
        if (!fPickedUpByOpponent) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = [NSString stringWithFormat:NSLocalizedString(@"WAITING_FOR_OPPONENT_CHOICE", nil), [[GMHelper sharedInstance] opponentName]];
        } else {
            if (myTurn) {
                [self performSegueWithIdentifier:@"askFirstQuestion" sender:self];
            } else {
                [self performSegueWithIdentifier:@"waitForFirstQuestion" sender:self];
            }
        }
    }
    
    
    [[GMHelper sharedInstance] replayPendingEvents];
}

- (void)viewDidUnload
{
    [self setLblCelebrityName:nil];
    [self setLblOpponentFound:nil];
    [self setLblOpponentStatus:nil];
    [self setTvMenu:nil];
    [self setBtnParam:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    if ([MBProgressHUD HUDForView:self.view] != nil) {
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint location = [touch locationInView:touch.view];
            
        if (CGRectContainsPoint(self.btnParam.frame, location)) {
            [self performSegueWithIdentifier:@"paramFromCelebrityChoice" sender:self];
        }
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [[self  navigationController] setNavigationBarHidden:YES animated:YES];
}	


- (IBAction)onEditCelebrityBegin:(id)sender {
    [[GMHelper sharedInstance] startTyping];
    [self.view endEditing:YES];
    
    [self performSegueWithIdentifier:@"displayCelebrityList" sender:self];
}
- (IBAction)onEditCelebrityEnd:(id)sender {
    [[GMHelper sharedInstance] stopTyping];
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"askFirstQuestion"]) {
        if ([segue.destinationViewController isKindOfClass:[chNewQuestionViewController class]] == YES) {
            [segue.destinationViewController setQuestionNumber:1];
            [segue.destinationViewController setQuestionLabel:[NSString stringWithFormat:@"%@ a choisi votre personnalite. Posez lui des questions pour deviner qui c'est. Il ne pourra repondre que par oui, non ou peut etre", [[GMHelper sharedInstance] opponentName]]];
        }
    } else if ([segue.identifier isEqualToString:@"displayCelebrityList"]) {
        if ([segue.destinationViewController isKindOfClass:[nmifCelebrityListViewController class]] == YES) {
            [segue.destinationViewController prepareCelebrityList:self];
        }
    }
}

#pragma nmifMenuCelebrityChoiceTableView
- (void)onCelebrityPickedUp
{
    [self.view endEditing:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = [NSString stringWithFormat:NSLocalizedString(@"WAITING_FOR_OPPONENT_CHOICE", nil), [[GMHelper sharedInstance] opponentName]];
    
    [[GMHelper sharedInstance] pickupCelebrity:_lblCelebrityName.text withDelegate:self];
    
}

#pragma GMHelperDelegate
-(void) onConnectionFailed
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil) message:NSLocalizedString(@"CONNECTION_FAILED", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
-(void) onPickupCelebritySuccess:(NSString *)celebrity {
    
    if ([[GMHelper sharedInstance] wasCelebrityPickedUpByOpponent] == true) {
        [self performSegueWithIdentifier:@"waitForFirstQuestion" sender:self];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES]; 
        hud.labelText = [NSString stringWithFormat:NSLocalizedString(@"WAITING_FOR_OPPONENT_CHOICE", nil), [[GMHelper sharedInstance] opponentName]];
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
    if ([[GMHelper sharedInstance] wasCelebrityPickedUpByMe] == true) {
        [self performSegueWithIdentifier:@"askFirstQuestion" sender:self];        
    }
}

-(void) onOpponentDisconnected {
    //[[self navigationController] popToRootViewControllerAnimated:TRUE];
    // update opponent status 
}

-(void) onOpponentStatusUpdated {
    self.lblOpponentStatus.text = [NSString stringWithFormat:NSLocalizedString(@"OPPONENT_STATUS", nil), [[GMHelper sharedInstance] opponentName], [[GMHelper sharedInstance] opponentStatus]];
}

-(void) onOpponentQuit:(UIViewController<GMRestoreViewDelegate> *)VC
{
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma GMRestoreViewDelegate
- (void) restorePrivateData
{
    
}
@end
