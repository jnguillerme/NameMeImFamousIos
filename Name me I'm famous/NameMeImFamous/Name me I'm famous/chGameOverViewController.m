//
//  chGameOverViewController.m
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 05/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "chGameOverViewController.h"
#import "GMHelper.h"
#import "nmifBackgroundLayer.h"

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
    CAGradientLayer *bgLayer = [nmifBackgroundLayer blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    id<nmifMenuTableViewDelegate> theDelegate = (id<nmifMenuTableViewDelegate>)self;
    menuTableView = [[nmifMenuGameOverTableView alloc] initWithDelegate:theDelegate];
    self.tvMenu.delegate = menuTableView;
    self.tvMenu.dataSource = menuTableView;
    
    [menuTableView addMenuItem:NSLocalizedString(@"PLAY_AGAIN", nil) withDescription:NSLocalizedString(@"PLAY_AGAIN_DESCRIPTION", nil) andImage:@"playAgain.png" andAction:@selector(onPlayAgain) andDelegate:theDelegate];
    
    [self.tvMenu reloadData];
    
    
    if (self.gameWon == YES) {
        self.lblGameStatus.text = NSLocalizedString(@"YOUWON", nil);
    } else {
        self.lblGameStatus.text = [NSString stringWithFormat:NSLocalizedString(@"YOULOST", nil), self.celebrityToFind];
    }
    
    [[GMHelper sharedInstance] gameOver ];
   [[GMHelper sharedInstance] clearGameInProgress];
}

- (void)viewDidUnload
{
    [self setLblGameStatus:nil];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma nmifMenuGameOverTableViewDelegate
-(void) onPlayAgain
{
    [self performSegueWithIdentifier:@"playAgain" sender:self];
}


@end