//
//  nmifConnectionViewController.m
//  Name me I'm famous
//
//  Created by Jino on 10/12/2012.
//  Copyright (c) 2012 nmif. All rights reserved.
//

#import "nmifConnectionViewController.h"
#import "MBProgressHUD.h"
#import "nmifBackgroundLayer.h"

@interface nmifConnectionViewController ()

@end

@implementation nmifConnectionViewController

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

    menuTableView = [[nmifMenuConnectionTableView alloc] initWithDelegate:theDelegate];
    self.tvMenu.delegate = menuTableView;
    self.tvMenu.dataSource = menuTableView;
    
    [menuTableView addMenuItem:NSLocalizedString(@"CONNECT", nil) withDescription:NSLocalizedString(@"CONNECT_DESCRIPTION", nil) andImage:@"connect.png" andAction:@selector(onConnect) andDelegate:theDelegate];
    [menuTableView addMenuItem:NSLocalizedString(@"FORGOT_PASSWORD", nil) withDescription:NSLocalizedString(@"FORGOT_PASSWORD_DESCRIPTION", nil) andImage:@"forgotPassword.png" andAction:@selector(onDisconnect) andDelegate:theDelegate];
    
    [self.tvMenu reloadData];
    [[self  navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onConnect
{
    [self.view endEditing:YES];
    
    if (self.tfLogin.text.length == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil) message:NSLocalizedString(@"EMPTY_LOGIN",) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else  if (self.tfPassword.text.length == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil) message:NSLocalizedString(@"EMPTY_PASSWORD",) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText =  NSLocalizedString(@"CONNECTING", nil);

        [[PAMHelper sharedInstance] loginAccount:self.tfLogin.text withPassword:self.tfPassword.text andAccountType:@"internal" withDelegate:self];
    }
}

- (void)onForgotPassword
{
    
    if (self.tfLogin.text.length == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil) message:NSLocalizedString(@"EMPTY_LOGIN",) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText =  NSLocalizedString(@"RESETING_PWD", nil);

        [[PAMHelper sharedInstance] forgotPassword:self.tfLogin.text withDelegate:self];
    }
}

- (void)viewDidUnload {
    [self setTfLogin:nil];
    [self setTfPassword:nil];
    [self setSbRemeberMe:nil];
    [self setSbRememberMe:nil];
    [[self  navigationController] setNavigationBarHidden:YES animated:YES];

    [self setTvMenu:nil];
    [super viewDidUnload];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma PAMHelperDelegate

- (void)onLoginSuccess
{
    if (self.sbRememberMe.on == YES ) {
        [[PAMHelper sharedInstance] saveCredentials:self.tfLogin.text withPassword:self.tfPassword.text];
    }
    
    // RESUME GAME IN PROGRESS
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self performSegueWithIdentifier:@"gameInProgress" sender:self];

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
- (void)onPasswordReset:(NSString*)email
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SUCCESS", nil) message:[NSString stringWithFormat:NSLocalizedString(@"RESET_PWD_SUCCESS", nil), email] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

}
- (void)onPasswordResetFailed:(NSString*)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil) message:[NSString stringWithFormat:NSLocalizedString(@"RESET_PWD_FAILED", nil), error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

}

#pragma GMHelperDelegate
-(void)onNewCelebrity:(NSString *)name withRole:(NSString *)role
{
    // ADD TO LOCAL DATABASE
}
@end
