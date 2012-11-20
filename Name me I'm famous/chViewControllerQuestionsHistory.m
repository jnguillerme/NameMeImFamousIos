//
//  chViewControllerQuestionsHistory.m
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 06/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "chViewControllerQuestionsHistory.h"
#import "GMHelper.h"

@interface chViewControllerQuestionsHistory ()

@end

@implementation chViewControllerQuestionsHistory

@synthesize questionList;

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
    
    self.tvQuestions.delegate = self;
    self.tvQuestions.dataSource = self;
    
    self.questionList = [[[GMHelper sharedInstance] questionList] allValues];
    
    [self.tvQuestions reloadData];
}

- (void)viewDidUnload
{
    [self setTvQuestions:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark delegate UITableViewDataSource
-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[GMHelper sharedInstance] questionList] count];
}

-(UITableViewCell*)tableView:(UITableView*)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if ([[[GMHelper sharedInstance] questionList] count] == 0) {
        cell.textLabel.text = @"(no question found)";
    } else {
        nmifQuestion * questionDetails = [self.questionList objectAtIndex:indexPath.row];
        cell.textLabel.text = [questionDetails question];
        if ( [[questionDetails answer] compare:@"yes"] == NSOrderedSame) {
            cell.textLabel.textColor = [UIColor greenColor];
        } else if ( [[questionDetails answer] compare:@"no"] == NSOrderedSame) {
            cell.textLabel.textColor = [UIColor redColor];
        } else {
            cell.textLabel.textColor = [UIColor orangeColor];
        }
   }
    return cell;
}

-(void) onOpponentDisconnected {
    [[self navigationController] popToRootViewControllerAnimated:TRUE];
}


@end
