//
//  nmifTopCelebritiesViewController.h
//  Name me I'm famous
//
//  Created by Jino on 14/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface nmifTopCelebritiesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tvTopCelebrities;
@end
