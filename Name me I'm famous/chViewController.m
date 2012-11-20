//
//  chViewController.m
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 26/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "chAppDelegate.h"
#import "chViewController.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "chNewGameViewController.h"


@interface chViewController ()

@end

@implementation chViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
    chAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    // The user has initiated a login, so call the openSession method
    // and show the login UX if necessary.
 //   [appDelegate openSessionWithAllowLoginUI:YES];
}

  
@end
