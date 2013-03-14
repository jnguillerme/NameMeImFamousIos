//
//  chViewController.m
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 26/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "chViewController.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "chNewGameViewController.h"
#import "MBProgressHUD.h"
#import "nmifBackgroundLayer.h"

@interface chViewController ()

@end

@implementation chViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CAGradientLayer *bgLayer = [nmifBackgroundLayer blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    id<nmifMenuTableViewDelegate> theDelegate = (id<nmifMenuTableViewDelegate>)self;
    menuTableView = [[nmifMenuNewGameTableView alloc] initWithDelegate:theDelegate];
    self.tvMenu.delegate = menuTableView;
    self.tvMenu.dataSource = menuTableView;
    
    [menuTableView addMenuItem:NSLocalizedString(@"NEW_GAME", nil) withDescription:NSLocalizedString(@"NEW_GAME_DESCRIPTION", nil) andImage:@"newRandomGame.png" andAction:@selector(onNewGame) andDelegate:theDelegate];
    [menuTableView addMenuItem:NSLocalizedString(@"NEW_PLAYER", nil) withDescription:NSLocalizedString(@"NEW_PLAYER_DESCRIPTION", nil)andImage:@"user_add.png" andAction:@selector(onNewPlayer) andDelegate:theDelegate];
    
    [self.tvMenu reloadData];

    // Do any additional setup after loading the view, typically from a nib.
   if ([[PAMHelper sharedInstance] hasStoredCredentials]) {
        [[PAMHelper sharedInstance] authenticateLocalUser:self];
    }
}

- (void)viewDidUnload
{
    [self setTvMenu:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [[self  navigationController] setNavigationBarHidden:YES animated:YES];    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}
- (IBAction)onFBLogin:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = [NSString stringWithFormat:NSLocalizedString(@"CONNECTING_TO_FACEBOOK", nil)];
    
    nmifAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openFBSessionWithAllowLoginUI:YES withDelegate:self];
}

#pragma nmifMenuNewGameTableViewDelegate
-(void) onNewGame
{
    [self performSegueWithIdentifier:@"newGameFromViewController" sender:self];
}

-(void) onNewPlayer
{
    [self performSegueWithIdentifier:@"newPlayerFromViewController" sender:self];    
}
#pragma FBAppDelegate
-(void) facebookDidLogin:(NSString *)userName {
    [[PAMHelper sharedInstance] loginAccount:userName withPassword:@"" andAccountType:@"facebook" withDelegate:self];
}

#pragma PAMHelperDelegate
- (void)onLoginSuccess
{
    [self performSegueWithIdentifier:@"gameInProgressFromMainMenu" sender:self];    
}

- (void)onLoginFailed:(NSString*)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LOGIN_FAILED", nil) message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma GMHelperDelegate
- (void)onConnectionFailed
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil) message:NSLocalizedString(@"CONNECTION_FAILED", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void) onOpponentStatusUpdated {
}

-(void)onNewCelebrity:(NSString *)name withRole:(NSString *)role
{
    // ADD TO LOCAL DATABASE
}

-(void) onGamesInProgressLoaded
{

}
@end
