//
//  nmifGameInProgressTableView.m
//  Name me I'm famous
//
//  Created by Jino on 28/02/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "GMHelper.h"
#import "nmifGameInProgressTableView.h"
#import "nmifGame.h"
#import "nmifGameItem.h"
#import "nmifUITableViewCellGameInProgressCell.h"

@implementation nmifGameInProgressTableView

@synthesize games;
@synthesize gameContents;
@synthesize gameList;


-(id) initWithDelegate:(id<nmifGameInProgressTableViewDelegate>)theDelegate
{
    delegate = theDelegate;
    return self;
}


-(void) loadGames
{
    self.games = [[[GMHelper sharedInstance] games] allValues];
    
    nmifGame* game;
    NSMutableDictionary* gameContentsTemp = [[NSMutableDictionary alloc] init];
    for (game in games) {
        [[GMHelper sharedInstance] setActiveGameID:[game gameID]];
        NSString *opponentCelebrity = [game opponentCelebrity];
        if (opponentCelebrity == nil || [opponentCelebrity length] == 0) {
            opponentCelebrity = NSLocalizedString(@"NOT_CHOSEN_YET", nil);
        }
        nmifGameItem *itemOpponentCelebrity = [[nmifGameItem alloc] initWithTitle:NSLocalizedString(@"GAMEOPPONENT_CELEBRITY", nil) andContent:opponentCelebrity];
        
        nmifGameItem *itemGameStatus = [[nmifGameItem alloc] initWithTitle:NSLocalizedString(@"GAMESTATUS", nil) andContent:[[GMHelper sharedInstance] gameStatus]];
        nmifGameItem *itemQuestionHistory = [[nmifGameItem alloc] initWithAccessoryAndTitle:nil andContent:NSLocalizedString(@"GAME_QUESTION_HISTORY", nil) andAction:@selector(showQuestionHistory:) andImage:@"gameHistory.png"];
        nmifGameItem *itemResumeGame = [[nmifGameItem alloc] initWithAccessoryAndTitle:nil andContent:NSLocalizedString(@"RESUMEGAME", nil) andAction:@selector(resumeGame:) andImage:@"askquestion.png"];
        
        NSArray* tempArrayGame = [[NSArray alloc] initWithObjects:itemOpponentCelebrity, itemGameStatus, itemQuestionHistory, itemResumeGame, nil];
        [gameContentsTemp setObject:tempArrayGame forKey:[game gameID]];
    }
    
    [[GMHelper sharedInstance] setActiveGameID:nil];
    
    gameContents = gameContentsTemp;
    gameList = [[gameContents allKeys] sortedArrayUsingSelector:@selector(compare:)];
}


-(void) showQuestionHistory:(NSString*)gameID
{
    [delegate showQuestionHistory:gameID];
}

-(void) resumeGame:(NSString*)gameID
{
    [delegate resumeGame:gameID];
}

#pragma mark delegate UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [gameList count];
}
//-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    nmifGame *currentGame = [[[GMHelper sharedInstance] games] objectForKey:[gameList objectAtIndex:section]];
    NSString *sectionTitle = [NSString stringWithFormat:NSLocalizedString(@"GAME_AGAINST", nil),  [currentGame opponentName]];
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
    NSArray* gameData = [gameContents objectForKey:[gameList objectAtIndex:section]];
    
    return [gameData count];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *gameID = [gameList objectAtIndex:[indexPath section]];
    NSArray* gameData = [gameContents objectForKey:gameID];
    nmifGameItem *item = [gameData objectAtIndex:[indexPath row]];
    
    if ([item itemAction] != nil && [self respondsToSelector:[item itemAction]]) {
        [self performSelector:[item itemAction] withObject:gameID];
    }
}


-(UITableViewCell*)tableView:(UITableView*)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray* gameData = [gameContents objectForKey:[gameList objectAtIndex:[indexPath section]]];
    
    if (cell == nil) {
        cell = [[nmifUITableViewCellGameInProgressCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:0.05f green:0.48f blue:0.58f alpha:1];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
    }
    
    if ([[[GMHelper sharedInstance] games] count] == 0) {
        cell.textLabel.text = NSLocalizedString(@"NO_GAME_FOUND_FOR_CELL", nil);
    } else {
        nmifGameItem *item = [gameData objectAtIndex:[indexPath row]];
        if (item.itemTitle != nil) {
            cell.textLabel.text = item.itemTitle;
        }
        if (item.itemContent != nil) {
            cell.detailTextLabel.text = item.itemContent;
        }
        if (item.itemHasAccessory) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if (item.itemImage != nil) {
            cell.imageView.image = [UIImage imageNamed:item.itemImage];
        }
    }
    return cell;
}

@end
