//
//  nmifMemuTableView.m
//  Name me I'm famous
//
//  Created by Jino on 28/02/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifMenuTableView.h"
#import "nmifMenuItem.h"

@implementation nmifMenuTableView

-(id) initWithDelegate:(id<nmifMenuTableViewDelegate>)theDelegate
{
    delegate = theDelegate;
    menu = [[NSMutableArray alloc] initWithCapacity:1];
    return self;
}

-(void) addMenuItem:(NSString*)theTitle withDescription:(NSString*)theDescription andImage:(NSString*)theImage andAction:(SEL)theAction andDelegate:(id<nmifMenuTableViewDelegate>)theDelegate
{
    nmifMenuItem *menuItem = [[nmifMenuItem alloc] initWithTitle:theTitle andDescription:theDescription andImage:theImage andAction:theAction];
    delegate = theDelegate;
    [menu addObject:menuItem];
}

#pragma mark delegate UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(void)newGame
{
    [delegate newGame];
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [menu count];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    nmifMenuItem *item = [menu objectAtIndex:[indexPath row]];
     
     if ([item itemAction] != nil && [self respondsToSelector:[item itemAction]]) {
         [self performSelector:[item itemAction]];
     }
}


-(UITableViewCell*)tableView:(UITableView*)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:0.05f green:0.48f blue:0.58f alpha:1];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    if ([menu count] == 0) {
        cell.textLabel.text = NSLocalizedString(@"NO_GAME_FOUND_FOR_CELL", nil);
    } else {
        nmifMenuItem *item = [menu objectAtIndex:[indexPath row]];
        cell.textLabel.text = item.title;
        cell.detailTextLabel.text = item.description;
        cell.imageView.image = [UIImage imageNamed:item.image];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    return cell;
}

@end
