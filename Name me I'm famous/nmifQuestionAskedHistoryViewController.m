//
//  nmifQuestionAskedHistoryViewController.m
//  Name me I'm famous
//
//  Created by Jino on 19/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifQuestionAskedHistoryViewController.h"
#import "nmifBackgroundLayer.h"
#import "GMHelper.h"

@interface nmifQuestionAskedHistoryViewController ()

@end

@implementation nmifQuestionAskedHistoryViewController

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
    
    self.tvQuestionAsked.delegate = self;
    self.tvQuestionAsked.dataSource = self;
    NSLog(@"questions asked : %d", [[[GMHelper sharedInstance] questionHistory] count]);
    [self.tvQuestionAsked reloadData];
    [[self  navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTvQuestionAsked:nil];
    [super viewDidUnload];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[self  navigationController] setNavigationBarHidden:YES animated:YES];
}

#pragma mark delegate UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = NSLocalizedString(@"QUESTION_ASKED_HISTORY", nil);
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,0,300,44)];
    
    titleLabel.text = sectionTitle;
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
    return [[[GMHelper sharedInstance] questionHistory] count];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    questionSelected = [self.tvQuestionAsked cellForRowAtIndexPath:indexPath].textLabel.text;
    [self performSegueWithIdentifier:@"questionFromQuestionAskedHistory" sender:self];
}

-(UITableViewCell*)tableView:(UITableView*)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    nmifUITableViewCellWithSwipe *cell = [theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[nmifUITableViewCellWithSwipe alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier andDelegate:self];
        cell.backgroundColor = [UIColor colorWithRed:0.05f green:0.48f blue:0.58f alpha:1];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    if ([[[GMHelper sharedInstance] questionHistory] count] == 0) {
        cell.textLabel.text = NSLocalizedString(@"NO_ROLE_FOUND_FOR_CELL", nil);
    } else {
        cell.textLabel.text = [[[GMHelper sharedInstance] questionHistory] objectAtIndex:[indexPath row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.tag = [indexPath row];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"questionFromQuestionAskedHistory"] && [segue.destinationViewController respondsToSelector:@selector(setQuestionAsked:)] ) {
        [segue.destinationViewController setQuestionAsked:questionSelected];
    }
}

#pragma mark delegate nmifUITableViewCellWithSwipeDelegate
-(void)onCellSwipeLeft:(int)row
{
    [[[GMHelper sharedInstance] questionHistory] removeObjectAtIndex:row];
    [self.tvQuestionAsked reloadData];
}
-(void)onCellSwipeRight:(int)row
{
}
@end


