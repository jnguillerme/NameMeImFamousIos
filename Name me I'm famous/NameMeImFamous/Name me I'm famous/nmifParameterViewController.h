//
//  nmifParameterViewController.h
//  Name me I'm famous
//
//  Created by Jino on 04/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nmifMenuParametersTableView.h"
#import "PAMHelper.h"

@interface nmifParameterViewController : UIViewController<PAMHelperDelegate, nmifMenuParametersTableViewDelegate, UIAlertViewDelegate> {
    nmifMenuParametersTableView *menuTableView;
    
    bool fGiveupGame;
}

@property (weak, nonatomic) IBOutlet UITableView *tvMenu;
@end
