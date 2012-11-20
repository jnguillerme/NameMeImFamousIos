//
//  chRootViewController.m
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 27/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "chRootViewController.h"
#import "chNewGameViewController.h"

@interface chRootViewController ()

@end

@implementation chRootViewController

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
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Untitled.png@"]]]; 
    	
	// Do any additional setup after loading the view.
   if ([[PAMHelper sharedInstance] hasStoredCredentials]) {        
        [[PAMHelper sharedInstance] authenticateLocalUser:self];
    } else {
        [self performSegueWithIdentifier:@"newAccountFromRoot" sender:self];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"newGameFromRoot"]) {
        if ([segue.destinationViewController isKindOfClass:[chNewGameViewController class]] == YES) {
        }
   }
}
#pragma PAMHelperDelegate

- (void)onLoginSuccess
{
    // RESUME GAME IN PROGRESS
   [self performSegueWithIdentifier:@"newGameFromRoot" sender:self];
}

- (void)onLoginFailed:(NSString*)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Login failed" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
@end
