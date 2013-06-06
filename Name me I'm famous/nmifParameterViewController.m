//
//  nmifParameterViewController.m
//  Name me I'm famous
//
//  Created by Jino on 04/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifParameterViewController.h"
#import "nmifBackgroundLayer.h"
#import "MBProgressHUD.h"
#import "nmifAppDelegate.h"

@interface nmifParameterViewController ()

@end

@implementation nmifParameterViewController

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
    CAGradientLayer *bgLayer = [nmifBackgroundLayer blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    id<nmifMenuTableViewDelegate> theDelegate = (id<nmifMenuTableViewDelegate>)self;
    menuTableView = [[nmifMenuParametersTableView alloc] initWithDelegate:theDelegate];
    self.tvMenu.delegate = menuTableView;
    self.tvMenu.dataSource = menuTableView;
    
    [menuTableView addMenuItem:NSLocalizedString(@"RULES", nil) withDescription:NSLocalizedString(@"RULES_DESCRIPTION", nil) andImage:@"rules.png" andAction:@selector(displayRules) andDelegate:theDelegate];
    [menuTableView addMenuItem:NSLocalizedString(@"PACKAGES", nil) withDescription:NSLocalizedString(@"PACKAGES_DESCRIPTION", nil) andImage:@"packages.png" andAction:@selector(onPackageManagement) andDelegate:theDelegate];
    [menuTableView addMenuItem:NSLocalizedString(@"GAMEINPROGRESS", nil) withDescription:NSLocalizedString(@"GAMEINPROGRESS_DESCRIPTION", nil) andImage:@"gameinprogress.png" andAction:@selector(onGameInProgress) andDelegate:theDelegate];    
    [menuTableView addMenuItem:NSLocalizedString(@"MY_GAMES", nil) withDescription:NSLocalizedString(@"MY_GAMES_DESCRIPTION", nil) andImage:@"mygameshistory.png" andAction:@selector(onGameHistory) andDelegate:theDelegate];
    [menuTableView addMenuItem:NSLocalizedString(@"TOP_CELEBRITIES", nil) withDescription:NSLocalizedString(@"TOP_CELEBRITIES_DESCRIPTION", nil) andImage:@"topcelebrities.png" andAction:@selector(onTopCelebrities) andDelegate:theDelegate];
    
    if ([[GMHelper sharedInstance] activeGameID] != nil) {
        [menuTableView addMenuItem:NSLocalizedString(@"GIVEUPGAME", nil) withDescription:NSLocalizedString(@"GIVEUPGAME_DESCRIPTION", nil) andImage:@"quitGame2.png" andAction:@selector(onGiveUpGame) andDelegate:theDelegate];
    }
    [menuTableView addMenuItem:NSLocalizedString(@"DISCONNECTION", nil) withDescription:NSLocalizedString(@"DISCONNECTION_DESCRIPTION", nil) andImage:@"disconnect.png" andAction:@selector(onDisconnect) andDelegate:theDelegate];

    
    [self.tvMenu reloadData];

    [[self  navigationController] setNavigationBarHidden:NO animated:YES];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTvMenu:nil];
    [super viewDidUnload];    
}


#pragma nmifMenuParametersTableViewDelegate
-(void) onPackageManagement
{
    [self performSegueWithIdentifier:@"packageManagementFromParameters" sender:self];
}
-(void) onGameInProgress
{
    [self performSegueWithIdentifier:@"gameInProgressFromParameters" sender:self];
}
-(void) onGameHistory
{
    [self performSegueWithIdentifier:@"historicalGamesFromParams" sender:self];    
}
-(void) onTopCelebrities
{
    [self performSegueWithIdentifier:@"topCelebritiesFromParams" sender:self];
}

-(void)displayRules
{
    [self performSegueWithIdentifier:@"displayRulesFromParams" sender:self];
}
-(void) onGiveUpGame
{
    fGiveupGame = true;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"NMIF" message:NSLocalizedString(@"CONFIRM_GIVEUP", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [alert show];

}
-(void) onDisconnect
{
    fGiveupGame = false;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"NMIF" message:NSLocalizedString(@"CONFIRM_DISCONNECT", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [alert show];
}

#pragma UIAlertViewDelegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)   { // OK
        if (fGiveupGame) {
            [self giveUpGame];
        } else {
            [self disconnect];
        }
    }
}

-(void) giveUpGame
{
    [[GMHelper sharedInstance] quitGame];
    [self onGameInProgress];
}

-(void) disconnect
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"LOGIN_OUT", nil);
    
    [[PAMHelper sharedInstance] clearCredentials];
    [[PAMHelper sharedInstance] logoutAccount:self];
    
    // delete all local data
    [[GMHelper sharedInstance] clearGameInProgress];
    [[GMHelper sharedInstance] setFGamesInProgressLoaded:false];
    [[GMHelper sharedInstance] clearDataStore];
        
    // disconnect from Facebook if we are connected
    nmifAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate closeFBSession];
}

#pragma PAMHelperDelegate
- (void)onLogoutSuccess
{
    [self performSegueWithIdentifier:@"loginMenuFromParameters" sender:self];
}
- (void)onLogoutFailed:(NSString*)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LOGOUT_FAILED", nil) message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void) onOpponentStatusUpdated {
    
}
-(void) onOpponentQuit:(UIViewController<GMRestoreViewDelegate> *)VC
{
}
@end
