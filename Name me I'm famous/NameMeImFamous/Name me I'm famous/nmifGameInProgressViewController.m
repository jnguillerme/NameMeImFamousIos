//
//  nmifGameInProgressViewController.m
//  Name me I'm famous
//
//  Created by Jino on 19/02/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifGameInProgressViewController.h"
#import "MBProgressHUD.h"
#import "nmifBackgroundLayer.h"

@interface nmifGameInProgressViewController ()

@end

@implementation nmifGameInProgressViewController

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
    CAGradientLayer *bgLayer = [nmifBackgroundLayer blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
   // self.lblNmifTitle.textColor = [UIColor colorWithRed:0.05f green:0.48f blue:0.58f alpha:1];
    
    // Menu table view
    menuTableView = [[nmifMenuTableView alloc] initWithDelegate:self];
    self.tvMenu.delegate = menuTableView;
    self.tvMenu.dataSource = menuTableView;
    
    [menuTableView addMenuItem:@"Partie aleatoire" withDescription:@"lancer une partie avec un joueur au hasard" andImage:@"newRandomGame.png" andAction:@selector(newGame) andDelegate:self];

    [self.tvMenu reloadData];
        
    // Game in Progress tableView
    gipTableView = [[nmifGameInProgressTableView alloc] initWithDelegate:self];
    self.tvGameInProgress.delegate = gipTableView;
    self.tvGameInProgress.dataSource = gipTableView;
    
    [[GMHelper sharedInstance] setDelegate:self];

    if ([[GMHelper sharedInstance] fGamesInProgressLoaded] == true) {
        [gipTableView loadGames];
        [self.tvGameInProgress reloadData];
    }

    if ([[GMHelper sharedInstance] fCelebrityLoaded] == false || [[GMHelper sharedInstance] fGamesInProgressLoaded] == false) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = NSLocalizedString(@"LOADING_GAMES", nil);
    }
    
   [[self  navigationController] setNavigationBarHidden:YES animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTvGameInProgress:nil];
    [self setTvMenu:nil];
    [self setLblNmifTitle:nil];
    [self setBtnParam:nil];
    [super viewDidUnload];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([MBProgressHUD HUDForView:self.view] != nil) {
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint location = [touch locationInView:touch.view];
        
        if (CGRectContainsPoint(self.btnParam.frame, location)) {
            [self performSegueWithIdentifier:@"paramFromGameInProgress" sender:self];
        }
    }
}
#pragma mark delegate nmifMenuTableViewDelegate
- (void)newGame {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"LOOKING_FOR_OPPONENT", nil);
    
    [[GMHelper sharedInstance] newRandomGame:self];
}

#pragma mark delegate nmifGameInPogressTableViewDelegate
-(void) showQuestionHistory:(NSString*)gameID
{
    [[GMHelper sharedInstance] setActiveGameID:gameID];
    if ([[[GMHelper sharedInstance] questions] count] == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"NMIF" message:NSLocalizedString(@"NO_QUESTION_ASKED", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        [self performSegueWithIdentifier:@"showQuestionHistoryFromGameInProgress" sender:self];
    }
}

-(void) resumeGame:(NSString*)gameID
{
    [[GMHelper sharedInstance] setActiveGameID:gameID];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    UIViewController<GMRestoreViewDelegate> *VC = (UIViewController<GMRestoreViewDelegate>*)[storyBoard instantiateViewControllerWithIdentifier:[[GMHelper sharedInstance] gameInProgress]];
    [VC restorePrivateData];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark delegate GMHelper
-(void) onGamesInProgressLoaded
{
    [gipTableView loadGames];
    [self.tvGameInProgress reloadData];

    if ([[GMHelper sharedInstance] fCelebrityLoaded] == true) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}
-(void) onNewRandomGameSuccess {
    [self performSegueWithIdentifier:@"chooseCelebrityName" sender:self];
}

-(void) onNewRandomGameFailed:(NSString*)error {
    
}

-(void) onNewRandomGame {
    [self performSegueWithIdentifier:@"chooseCelebrityName" sender:self];
}

-(void) onCelebrityListEnd
{
    if ([[GMHelper sharedInstance] fGamesInProgressLoaded] == true) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}
@end
