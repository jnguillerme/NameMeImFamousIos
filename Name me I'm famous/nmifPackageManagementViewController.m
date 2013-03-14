//
//  nmifPackageManagementViewController.m
//  Name me I'm famous
//
//  Created by Jino on 04/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifPackageManagementViewController.h"
#import "nmifBackgroundLayer.h"
#import "Role.h"
#import "GMHelper.h"
#import "nmifCelebrityListViewController.h"
#import "nmifUITableViewCellPackage.h"

@interface nmifPackageManagementViewController ()

@end

@implementation nmifPackageManagementViewController

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

    self.tvPackages.delegate = self;
    self.tvPackages.dataSource = self;
    
    
    [self loadPackages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (fPackageUpdated) {
        // update core database
        Role *role;
        for (role in packages) {
            if ( [[GMHelper sharedInstance] enablePackage:role.role isAvailable:role.active] ) {
                // packeage was updated - send update to server
                [[GMHelper sharedInstance] sendPackageUpdate:role];
            }
        }
        
    }	
}
- (void)viewDidUnload {
    [self setTvPackages:nil];
    [super viewDidUnload];
}

-(void) loadPackages
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Role" inManagedObjectContext:[[GMHelper sharedInstance] managedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];

    NSSortDescriptor *	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"role" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    packages = [NSMutableArray arrayWithArray:[[[GMHelper sharedInstance] managedObjectContext] executeFetchRequest:fetchRequest error:&error]];
    fPackageUpdated = false;
    
    [self.tvPackages reloadData];
}

-(void) onCellSwitchOn:(bool)isOn forCellAtRow:(int)cellRow
{
    Role *role = [packages objectAtIndex:cellRow];
    role.active = [NSNumber numberWithBool:isOn];
    
    [packages replaceObjectAtIndex:cellRow withObject:role];
    fPackageUpdated = true;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"celebrityListFromPackages"]) {
        if ([segue.destinationViewController isKindOfClass:[nmifCelebrityListViewController class]] == YES) {
            nmifCelebrityListViewController* clvc = segue.destinationViewController;
            Role *item = [packages objectAtIndex:activeRow];
            [clvc setFilterToRole:item.role];
        }
    }
}

#pragma mark delegate UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
/*
-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = NSLocalizedString(@"AVAILABLE_PACKAGES", nil);
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,0,300,44)];
    
    titleLabel.text = sectionTitle;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    [sectionView addSubview:titleLabel];
    
    return sectionView;
}*/

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [packages count];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    activeRow = [indexPath row];
    [self performSegueWithIdentifier:@"celebrityListFromPackages" sender:self];
}

-(UITableViewCell*)tableView:(UITableView*)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    nmifUITableViewCellPackage *cell = [theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[nmifUITableViewCellPackage alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier andDelegate:self];
        cell.backgroundColor = [UIColor colorWithRed:0.05f green:0.48f blue:0.58f alpha:1];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor blackColor];
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    
    if ([packages count] == 0) {
        cell.textLabel.text = NSLocalizedString(@"NO_ROLE_FOUND_FOR_CELL", nil);
    } else {
        Role *item = [packages objectAtIndex:[indexPath row]];
        cell.detailTextLabel.text = [item role];
        cell.on = ([[item active] intValue] == 1);
        cell.tag = [indexPath row];
        if (cell.on) {
            cell.textLabel.text = @"\u2714";
        } else {
            cell.textLabel.text = @"\u2718";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}


@end
