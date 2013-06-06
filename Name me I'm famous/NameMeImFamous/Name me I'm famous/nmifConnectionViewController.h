//
//  nmifConnectionViewController.h
//  Name me I'm famous
//
//  Created by Jino on 10/12/2012.
//  Copyright (c) 2012 nmif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAMHelper.h"
#import "GMHelper.h"
#import "nmifMenuConnectionTableView.h"

@interface nmifConnectionViewController : UIViewController<PAMHelperDelegate, GMHelperDelegate, nmifMenuConnectionTableViewDelegate> {
    nmifMenuConnectionTableView *menuTableView;
}

@property (weak, nonatomic) IBOutlet UITextField *tfLogin;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UILabel *sbRemeberMe;
@property (weak, nonatomic) IBOutlet UISwitch *sbRememberMe;
@property (weak, nonatomic) IBOutlet UITableView *tvMenu;

@end
