//
//  chViewControllerQuestionsHistory.m
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 06/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "chViewControllerQuestionsHistory.h"
#import "GMHelper.h"
#import "nmifBackgroundLayer.h"
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
    [[self  navigationController] setNavigationBarHidden:NO animated:YES];

    CAGradientLayer *bgLayer = [nmifBackgroundLayer blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];

    self.tvQuestions.delegate = self;
    self.tvQuestions.dataSource = self;
    
    self.questionList = [[[GMHelper sharedInstance] questions] allValues];
    
    [self.tvQuestions reloadData];
}

- (void)viewDidUnload
{
    [self setTvQuestions:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[self  navigationController] setNavigationBarHidden:YES animated:YES];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark delegate UITableViewDataSource
-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[GMHelper sharedInstance] questions] count];
}

-(UITableViewCell*)tableView:(UITableView*)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if ([[[GMHelper sharedInstance] questions] count] == 0) {
        cell.textLabel.text = NSLocalizedString(@"NO_QUESTION_FOUND_FOR_CELL", nil);
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
//    [[self navigationController] popToRootViewControllerAnimated:TRUE];
}

-(void) onOpponentStatusUpdated {
}
-(void) onOpponentQuit:(UIViewController<GMRestoreViewDelegate> *)VC
{
    [self.navigationController pushViewController:VC animated:YES];
}
@end
