//
//  nmifCelebrityListViewController.m
//  Name me I'm famous
//
//  Created by Jino on 05/02/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifCelebrityListViewController.h"
#import "Celebrity.h"
#import "chCelebrityChoiceViewController.h"

@interface nmifCelebrityListViewController ()

@end

@implementation nmifCelebrityListViewController

@synthesize celebrityList;
@synthesize allCelebrityList;
@synthesize filteredCelebrityList;

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
    disableCelebritiesNotInPackages = YES;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Celebrity" inManagedObjectContext:[[GMHelper sharedInstance] managedObjectContext]];
    
    if ([self filterToRole] != nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(role.role = %@)", [self filterToRole]];
        [fetchRequest setPredicate:predicate];
        disableCelebritiesNotInPackages = NO;
        
        self.navigationController.navigationController.title = [self filterToRole];
    }
    
    [fetchRequest setEntity:entity];
    NSError *error;

    allCelebrityList = [NSMutableArray arrayWithArray:[[[GMHelper sharedInstance] managedObjectContext] executeFetchRequest:fetchRequest error:&error]];
    
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    
    for (Celebrity* celebrity in allCelebrityList) {
        NSInteger sect = [theCollation sectionForObject:celebrity collationStringSelector:@selector(name)];
        celebrity.sectionNumber = sect;
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (Celebrity *celebrity in allCelebrityList) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:celebrity.sectionNumber] addObject:celebrity];
    }
    
    self.celebrityList = [NSMutableArray arrayWithCapacity:1];
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
        [self.celebrityList addObject:sortedSection];
    }
    
    self.filteredCelebrityList = [NSMutableArray arrayWithCapacity:[allCelebrityList count]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark delegate UITableViewDataSource
-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.searchDisplayController.isActive) {
        return nil;
    } else {
        return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
    }
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!self.searchDisplayController.isActive && [[self.celebrityList objectAtIndex:section] count] > 0) {
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    }
    return nil;
}

-(NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    } else {
        return [self.celebrityList count];
    }
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filteredCelebrityList count];
    } else {
        return [[self.celebrityList objectAtIndex:section] count];
    }
}

-(UITableViewCell*)tableView:(UITableView*)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:0.05f green:0.48f blue:0.58f alpha:1];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    
    for (UIView *view in [theTableView subviews]) {
        if ([view respondsToSelector:@selector(setIndexColor:)]) {
            [view performSelector:@selector(setIndexColor:) withObject:[UIColor whiteColor]];
        }
    }
    if ([self.celebrityList count] == 0) {
        cell.textLabel.text = NSLocalizedString(@"NO_QUESTION_FOUND_FOR_CELL", nil);
    } else {
        Celebrity *celebrity;
        if (theTableView == self.searchDisplayController.searchResultsTableView) {
            celebrity = [filteredCelebrityList objectAtIndex:indexPath.row];
        } else {
            celebrity = [[self.celebrityList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        }
        cell.textLabel.text = celebrity.name;
        cell.detailTextLabel.text = celebrity.role.role;
        
        if (disableCelebritiesNotInPackages && (![[[GMHelper sharedInstance] packages] containsObject:celebrity.role.role])) {
            cell.userInteractionEnabled = NO;
            cell.textLabel.enabled = NO;
            cell.detailTextLabel.enabled = NO;
        } else {
            cell.userInteractionEnabled = YES;
            cell.textLabel.enabled = YES;
            cell.detailTextLabel.enabled = YES;
        }
    }
    

    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchDisplayController.isActive) {
        selectedCelebrity = [self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:indexPath].textLabel.text;
    } else {
        selectedCelebrity = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    }
  //  [self performSegueWithIdentifier:@"celebrityPickedUp" sender:self];
    [delegate setCelebrityName:selectedCelebrity];
    [self dismissModalViewControllerAnimated:YES];    
}


- (void)viewDidUnload {
 //   [self setTvCelebrity:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}

-(void)prepareCelebrityList:(id<nmifCelebrityChoiceDelegate>)withDelegate {
    delegate = withDelegate;
}


-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    [self.filteredCelebrityList removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
    filteredCelebrityList = [NSMutableArray arrayWithArray:[allCelebrityList filteredArrayUsingPredicate:predicate]];
}
#pragma mark delegate UISearchBarDelegate

#pragma mark delegate UISearchDisplayDelegate
-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    [self.tableView reloadSectionIndexTitles];
}
-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    [self.tableView reloadSectionIndexTitles];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    [controller.searchResultsTableView setBackgroundColor: [UIColor colorWithRed:0.05f green:0.48f blue:0.58f alpha:1]];
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}

@end