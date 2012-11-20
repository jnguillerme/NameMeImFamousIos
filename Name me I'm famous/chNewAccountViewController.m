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

@interface chNewAccountViewController ()

@end

@implementation chNewAccountViewController
@synthesize tfName;
@synthesize tfEmail;
@synthesize tfLogin;
@synthesize tfPassword;
@synthesize btnCreate;

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
    [self setTfName:nil];
    [self setTfEmail:nil];
    [self setTfLogin:nil];
    [self setTfPassword:nil];
    [self setBtnCreate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)onBtnCreateClick:(id)sender {
    
    // Start Request
    [[PAMHelper sharedInstance] createAccount:self.tfLogin.text withPassword:self.tfPassword.text withFullName:self.tfName.text withEMail:self.tfEmail.text withDelegate:self];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES]; 
    hud.labelText = NSLocalizedString(@"ACCOUNT_CREATION", nil);
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   /* if ([segue.identifier isEqualToString:@"newGame"]) {
        if ([segue.destinationViewController isKindOfClass:[chNewGameViewController class]] == YES) {
        }
    }*/
}

#pragma PAMHelperDelegate
- (void)onAccountCreationSuccess
{
    
    [[PAMHelper sharedInstance] loginAccount:self.tfLogin.text withPassword:self.tfPassword.text withDelegate:self];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES]; 
    hud.labelText = @"login ...";
}

- (void)onLoginSuccess
{
    // store login / pwd 
    [[PAMHelper sharedInstance] saveCredentials:self.tfLogin.text withPassword:self.tfPassword.text];
    // go to new game screen
    [self performSegueWithIdentifier:@"newGame" sender:self];
}

- (void)onLogoutSuccess
{
    
}

- (void)onAccountCreationFailed:(NSString*)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Account creation failed" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
- (void)onLoginFailed:(NSString*)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Login failed" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show]; 
}
- (void)onLogoutFailed:(NSString*)error
{
}
  


@end
