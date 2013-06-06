//
//  nmifCelebrityListViewController.h
//  Name me I'm famous
//
//  Created by Jino on 05/02/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMHelper.h"

@protocol nmifCelebrityChoiceDelegate
- (void)setCelebrityName:(NSString*)celebrity;
@end

@interface nmifCelebrityListViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate> {
    NSString *selectedCelebrity;
    id<nmifCelebrityChoiceDelegate> delegate;
    bool disableCelebritiesNotInPackages;
}

//@property (weak, nonatomic) IBOutlet UITableView *tvCelebrity;
@property (strong, nonatomic) NSMutableArray* celebrityList;
@property (strong, nonatomic) NSMutableArray* allCelebrityList;
@property (strong, nonatomic) NSString* filterToRole;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *filteredCelebrityList;

-(void)prepareCelebrityList:(id<nmifCelebrityChoiceDelegate>)withDelegate;
@end
	