//
//  chSubmitAnswerViewController.m
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 23/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "chSubmitAnswerViewController.h"
#import "chGameOverViewController.h"
#import "nmifBackgroundLayer.h"

@interface chSubmitAnswerViewController ()

@end

@implementation chSubmitAnswerViewController
@synthesize tfCelebrity;

NSString * const K_CELEBRITY_KEY = @"NMIF.SUBMITANSWERVIEWID.CELEBRITY";

- (void) setCelebrityName:(NSString *)celebrityName {
    [self.tfCelebrity setText:celebrityName];
    [[GMHelper sharedInstance] storeLocalData:celebrityName forKey:K_CELEBRITY_KEY];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        IWon = false;
        celebrityToFind = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[self  navigationController] setNavigationBarHidden:NO animated:YES];
    self.lblOpponentStatus.text = [NSString stringWithFormat:NSLocalizedString(@"OPPONENT_STATUS", nil), [[GMHelper sharedInstance] opponentName], [[GMHelper sharedInstance] opponentStatus]];
   
    CAGradientLayer *bgLayer = [nmifBackgroundLayer blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    id<nmifMenuTableViewDelegate> theDelegate = (id<nmifMenuTableViewDelegate>)self;
    menuTableView = [[nmifMenuSubmitCelebrityTableView alloc] initWithDelegate:theDelegate];
    self.tvMenu.delegate = menuTableView;
    self.tvMenu.dataSource = menuTableView;
    
    [menuTableView addMenuItem:NSLocalizedString(@"SUBMIT_CELEBRITY", nil) withDescription:NSLocalizedString(@"SUBMIT_CELEBRITY_DESCRIPTION", nil) andImage:@"newRandomGame.png" andAction:@selector(onCelebritySubmit) andDelegate:theDelegate];

       [menuTableView addMenuItem:NSLocalizedString(@"SHOW_HISTORY", nil) withDescription:NSLocalizedString(@"SHOW_HISTORY_DESCRIPTION", nil) andImage:@"gameHistory.png" andAction:@selector(onShowQuestionHistory) andDelegate:theDelegate];  ;
    
    
    [self.tvMenu reloadData];
    
    [[GMHelper sharedInstance] saveGameInProgress:@"submitCelebrityViewID"];
    [[GMHelper sharedInstance] replayPendingEvents];
}

- (void)viewDidUnload
{
    [self setTfCelebrity:nil];
    [[self  navigationController] setNavigationBarHidden:YES animated:YES];

    [self setLblOpponentStatus:nil];
    [self setTvMenu:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // clean local data
    [[GMHelper sharedInstance] clearLocalDataForKey:K_CELEBRITY_KEY];
    
    if ([segue.identifier isEqualToString:@"gameOver"]) {
        if ([segue.destinationViewController isKindOfClass:[chGameOverViewController class]] == YES) {
            [segue.destinationViewController setGameWon:IWon];
            [segue.destinationViewController setCelebrityToFind:celebrityToFind];
        }
    } else if ([segue.identifier isEqualToString:@"displayCelebrityListFromSubmit"]) {
        if ([segue.destinationViewController isKindOfClass:[nmifCelebrityListViewController class]] == YES) {
            [segue.destinationViewController prepareCelebrityList:self];
        }
    }
}
- (IBAction)onEditCelebrityBegin:(id)sender {
    [[GMHelper sharedInstance] startTyping];
    [self.view endEditing:YES];

//    [self performSegueWithIdentifier:@"displayCelebrityList" sender:self];
}
- (IBAction)onEditCelebrityEnd:(id)sender {
    [[GMHelper sharedInstance] stopTyping];
}

#pragma nmifMenuSubmitCelebrityTableViewDelegate
- (void)onCelebritySubmit {
    if (self.tfCelebrity.text.length > 0 ) {
        [[GMHelper sharedInstance] submitCelebrity:self.tfCelebrity.text withDelegate:self];
    }
}
-(void)onShowQuestionHistory {
    [self performSegueWithIdentifier:@"questionHistoryFromSubmit" sender:self];
}
#pragma GMHelperDelegate
-(void) onCelebritySubmitted:(NSString*)celebritySubmitted withStatus:(NSString*)status
{
    if ([status compare:@"success"] == NSOrderedSame) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GAME_OVER", nil) message:NSLocalizedString(@"CORRECT_ANSWER", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];  
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WRONG_ANSWER", nil) message:[NSString stringWithFormat:NSLocalizedString(@"WRONG_ANSWER_SUBMITTED", nil), celebritySubmitted] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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

-(void) onGameWon
{
    IWon = true;
    [self performSegueWithIdentifier:@"gameOver" sender:self];
}
-(void)onGameLost:(NSString *)celebrityName
{
    IWon = true;
    celebrityToFind = celebrityName;
    [self performSegueWithIdentifier:@"gameOver" sender:self];
}

-(void) onOpponentDisconnected {
}
-(void) onOpponentStatusUpdated {
    self.lblOpponentStatus.text = [NSString stringWithFormat:NSLocalizedString(@"OPPONENT_STATUS", nil), [[GMHelper sharedInstance] opponentName], [[GMHelper sharedInstance] opponentStatus]];
}
-(void) onOpponentQuit:(UIViewController<GMRestoreViewDelegate> *)VC
{
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma GMRestoreView Delegate
- (void) restorePrivateData
{
    if ([[GMHelper sharedInstance] hasLocalDataForKey:K_CELEBRITY_KEY]) {
        [self.tfCelebrity setText:[[GMHelper sharedInstance] localDataForKey:K_CELEBRITY_KEY]];
    }
}
@end
