//
//  nmifHistoricalGamesViewController.m
//  Name me I'm famous
//
//  Created by Jino on 15/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifHistoricalGamesViewController.h"
#import "nmifBackgroundLayer.h"
#import "GMHelper.h"
#import "nmifHistoricalGame.h"
#import "nmifUITableViewCellGameInProgressCell.h"

@interface nmifHistoricalGamesViewController ()

@end

@implementation nmifHistoricalGamesViewController

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
    
    self.tvHistoricalGames.delegate = self;
    self.tvHistoricalGames.dataSource = self;
    
    [[self  navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTvHistoricalGames:nil];
    [super viewDidUnload];
}

#pragma mark delegate UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[GMHelper sharedInstance] historicalGames] count];
}
//-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    nmifHistoricalGame *currentHistoricalGame = [[[GMHelper sharedInstance] historicalGames] objectAtIndex:section];

    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,0,300,44)];
    
    titleLabel.text = currentHistoricalGame.gameDate;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    [sectionView addSubview:titleLabel];
    
    return sectionView;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {    
    return 4;
}

-(UITableViewCell*)tableView:(UITableView*)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    nmifHistoricalGame *historicalGame = [[[GMHelper sharedInstance] historicalGames] objectAtIndex:[indexPath section]];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:0.05f green:0.48f blue:0.58f alpha:1];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    if (historicalGame == 0) {
        cell.textLabel.text = NSLocalizedString(@"NO_GAME_FOUND_FOR_CELL", nil);
    } else {
        
        cell.textLabel.text = [historicalGame getTitleForIndex:[indexPath row]];
        cell.detailTextLabel.text = [historicalGame getValueForIndex:[indexPath row]];

    }
    return cell;
}

@end
