//
//  chGameOverViewController.m
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 05/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "chGameOverViewController.h"

@interface chGameOverViewController ()

@end

@implementation chGameOverViewController
@synthesize gameWon = _gameWon;
@synthesize lblGameStatus = _lblGameStatus;

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
    
    if (self.gameWon == YES) {
        self.lblGameStatus.text = NSLocalizedString(@"YOUWON", nil);
    } else {
        self.lblGameStatus.text = NSLocalizedString(@"YOULOST", nil);
    }
}

- (void)viewDidUnload
{
    [self setLblGameStatus:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end