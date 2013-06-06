//
//  nmifTopCelebritiesViewController.m
//  Name me I'm famous
//
//  Created by Jino on 14/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifTopCelebritiesViewController.h"
#import "GMHelper.h"
#import "nmifBackgroundLayer.h"
#import "nmifCelebrity.h"

@interface nmifTopCelebritiesViewController ()

@end

@implementation nmifTopCelebritiesViewController

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
    
    self.tvTopCelebrities.delegate = self;
    self.tvTopCelebrities.dataSource = self;
    
    [[self  navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTvTopCelebrities:nil];
    [super viewDidUnload];
}

#pragma mark delegate UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

 -(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
 NSString *sectionTitle = NSLocalizedString(@"TOP_CELEBRITIES", nil);
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
    return [[[GMHelper sharedInstance] topCelebrities] count];
}


-(UITableViewCell*)tableView:(UITableView*)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:0.05f green:0.48f blue:0.58f alpha:1];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor blackColor];
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    
    if ([[[GMHelper sharedInstance] topCelebrities] count] == 0) {
        cell.textLabel.text = NSLocalizedString(@"NO_ROLE_FOUND_FOR_CELL", nil);
    } else {
        nmifCelebrity *item = [[[GMHelper sharedInstance] topCelebrities] objectAtIndex:[indexPath row]];
        cell.textLabel.text = [NSString stringWithFormat:@"%d - %@", [indexPath row]+1, item.celebrityName];
        cell.detailTextLabel.text = item.celebrityRole;
    }
    return cell;
}
@end
