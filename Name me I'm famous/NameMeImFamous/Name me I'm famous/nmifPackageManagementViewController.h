//
//  nmifPackageManagementViewController.h
//  Name me I'm famous
//
//  Created by Jino on 04/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nmifUITableViewCellPackage.h"

@interface nmifPackageManagementViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, nmifUITableViewCellPackageDelegate> {
    NSMutableArray *packages;
    bool fPackageUpdated;
    
    NSUInteger activeRow;
}

@property (weak, nonatomic) IBOutlet UITableView *tvPackages;
@end
