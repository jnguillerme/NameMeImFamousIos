//
//  nmifHistoricalGamesViewController.h
//  Name me I'm famous
//
//  Created by Jino on 15/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface nmifHistoricalGamesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tvHistoricalGames;
@end
