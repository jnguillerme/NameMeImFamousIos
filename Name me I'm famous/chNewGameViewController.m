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

@interface chNewGameViewController ()

@end

@implementation chNewGameViewController

@synthesize opponentName;

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onBtnNewRandomGameClick:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES]; 
    hud.labelText = @"Recherche d'un adversaire...";

    [[GMHelper sharedInstance] newRandomGame:self];
}

#pragma GMHelperDelegate
-(void) onNewRandomGameSuccess {
    [self performSegueWithIdentifier:@"chooseCelebrityName" sender:self];
}

-(void) onNewRandomGameFailed:(NSString*)error {
    
}

-(void) onNewRandomGame:(NSString*)opponent {
    self.opponentName = opponent;
    [self performSegueWithIdentifier:@"chooseCelebrityName" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"chooseCelebrityName"]) {
        if ([segue.destinationViewController isKindOfClass:[chCelebrityChoiceViewController class]] == YES) {
            [segue.destinationViewController setOpponentName:self.opponentName];
        }
    }
}

@end
