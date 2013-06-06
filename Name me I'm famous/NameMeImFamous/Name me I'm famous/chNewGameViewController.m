//
//  chNewGameViewController.m
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 26/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "chNewGameViewController.h"
#import "chCelebrityChoiceViewController.h"
#import "MBProgressHUD.h"
#import "PAMHelper.h"
#import "nmifAppDelegate.h"
#import "nmifMenuItem.h"

@interface chNewGameViewController ()

@end

@implementation chNewGameViewController

@synthesize menu;

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
    self.tvMenu.delegate = self;
    self.tvMenu.dataSource = self;
    
    nmifMenuItem *menuItemNewGame = [[nmifMenuItem alloc] initWithTitle:@"Partie aleatoire" andDescription:@"lancer une partie avec un joueur au hasard" andImage:@"newRandomGame.png" andAction:(SEL)nil];
    nmifMenuItem *menuItemDisconnect = [[nmifMenuItem alloc] initWithTitle:@"Se deconnecter" andDescription:@"retour a l'ecrand de connection" andImage:@"disconnect.png" andAction:(SEL)nil];
    
    menu = [[NSArray alloc] initWithObjects:menuItemNewGame, menuItemDisconnect, nil];
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)onBtnDisconnectClick:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"LOGIN_OUT", nil);

    
    [[PAMHelper sharedInstance] clearCredentials];
    [[PAMHelper sharedInstance] logoutAccount:self];
    
    // disconnect from Facebook if we are connected
    nmifAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate closeFBSession];
}

- (IBAction)onBtnNewRandomGameClick:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES]; 
    hud.labelText = NSLocalizedString(@"LOOKING_FOR_OPPONENT", nil);

    [[GMHelper sharedInstance] newRandomGame:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}
#pragma mark delegate UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menu count];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  /*  NSString *gameID = [gameList objectAtIndex:[indexPath section]];
    NSArray* gameData = [gameContents objectForKey:gameID];
    nmifGameItem *item = [gameData objectAtIndex:[indexPath row]];
    
    if ([item itemAction] != nil) {
        [self performSelector:[item itemAction] withObject:gameID];
    }*/
}


-(UITableViewCell*)tableView:(UITableView*)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:cellIdentifier];

    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:0.05f green:0.53f blue:0.58f alpha:1];

        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    if ([self.menu count] == 0) {
        cell.textLabel.text = NSLocalizedString(@"NO_GAME_FOUND_FOR_CELL", nil);
    } else {
        nmifMenuItem *item = [self.menu objectAtIndex:[indexPath row]];
        cell.textLabel.text = item.title;
        cell.detailTextLabel.text = item.description;
        cell.imageView.image = [UIImage imageNamed:item.image];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    return cell;
}

#pragma GMHelperDelegate
-(void) onNewRandomGameSuccess {
    [self performSegueWithIdentifier:@"chooseCelebrityName" sender:self];
}

-(void) onNewRandomGameFailed:(NSString*)error {
    
}

-(void) onNewRandomGame {
    [self performSegueWithIdentifier:@"chooseCelebrityName" sender:self];
}

#pragma PAMHelperDelegate
- (void)onLogoutSuccess
{
    [self performSegueWithIdentifier:@"loginMenu" sender:self];
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
    [self.navigationController pushViewController:VC animated:YES];
}
@end
