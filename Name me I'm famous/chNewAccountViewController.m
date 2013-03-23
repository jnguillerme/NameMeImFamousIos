//
//  chNewAccountViewController.m
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 24/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "chNewAccountViewController.h"
#import "PAMHelper.h"
#import "chNewGameViewController.h"
#import "MBProgressHUD.h"
#import "nmifBackgroundLayer.h"

@interface chNewAccountViewController ()

@end

@implementation chNewAccountViewController
@synthesize tfName;
@synthesize tfEmail;
@synthesize tfLogin;
@synthesize tfPassword;

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
    menuTableView = [[nmifMenuNewPlayerTableView alloc] initWithDelegate:theDelegate];
    self.tvMenu.delegate = menuTableView;
    self.tvMenu.dataSource = menuTableView;
    
    [menuTableView addMenuItem:NSLocalizedString(@"CREATE_PLAYER", nil) withDescription:NSLocalizedString(@"CREATE_PLAYER_DESCRIPTION", nil) andImage:@"user_add.png" andAction:@selector(onNewPlayer) andDelegate:theDelegate];
    
    [self.tvMenu reloadData];
    
    [[self  navigationController] setNavigationBarHidden:NO animated:YES];

}

- (void)viewDidUnload
{
    [self setTfName:nil];
    [self setTfEmail:nil];
    [self setTfLogin:nil];
    [self setTfPassword:nil];
    [self setTvMenu:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[self  navigationController] setNavigationBarHidden:YES animated:YES];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma nmifMenuNewPlayerTableView 
- (void)onNewPlayer
{
    
    // Start Request
    [[PAMHelper sharedInstance] createAccount:self.tfLogin.text withPassword:self.tfPassword.text withFullName:self.tfName.text withEMail:self.tfEmail.text withDelegate:self];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES]; 
    hud.labelText = NSLocalizedString(@"ACCOUNT_CREATION", nil);
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   /* if ([segue.identifier isEqualToString:@"newGame"]) {
        if ([segue.destinationViewController isKindOfClass:[chNewGameViewController class]] == YES) {
        }
    }*/
}

#pragma PAMHelperDelegate
- (void)onAccountCreationSuccess
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText =  NSLocalizedString(@"CONNECTING", nil);
    [[PAMHelper sharedInstance] loginAccount:self.tfLogin.text withPassword:self.tfPassword.text andAccountType:@"internal" withDelegate:self];
}

#pragma PAMHelperDelegate
- (void)onConnectionFailed
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil) message:NSLocalizedString(@"CONNECTION_FAILED", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
- (void)onLoginSuccess
{
    // store login / pwd 
    [[PAMHelper sharedInstance] saveCredentials:self.tfLogin.text withPassword:self.tfPassword.text];
 
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    // go to new game screen
    [self performSegueWithIdentifier:@"gameInProgressFromNewPlayer" sender:self];
}

- (void)onLogoutSuccess
{
    
}

- (void)onAccountCreationFailed:(NSString*)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ACCOUNT_CREATION_FAILED", nil) message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
- (void)onLoginFailed:(NSString*)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LOGIN_FAILED", nil) message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show]; 
}
- (void)onLogoutFailed:(NSString*)error
{
}

#pragma GMHelperDelegate
-(void)onNewCelebrity:(NSString *)name withRole:(NSString *)role
{
    // ADD TO LOCAL DATABASE
}

@end
