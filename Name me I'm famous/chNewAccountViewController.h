//
//  chNewAccountViewController.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 24/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAMHelper.h"
#import "GMHelper.h"
#import "nmifMenuNewPlayerTableView.h"

@interface chNewAccountViewController : UIViewController<PAMHelperDelegate, GMHelperDelegate, nmifMenuNewPlayerTableViewDelegate> {
    nmifMenuNewPlayerTableView *menuTableView;
}

@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfLogin;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;

@property (weak, nonatomic) IBOutlet UITableView *tvMenu;

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
