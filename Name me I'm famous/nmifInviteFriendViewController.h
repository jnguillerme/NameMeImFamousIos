//
//  nmifInviteFriendViewController.h
//  Name me I'm famous
//
//  Created by Jino on 24/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nmifMenuInviteTableView.h"
#import "GMHelper.h"
#import <FacebookSDK/FacebookSDK.h>

@interface nmifInviteFriendViewController : UIViewController<nmifMenuInviteTableViewDelegate, GMHelperDelegate, FBFriendPickerDelegate> {
    nmifMenuInviteTableView *menuTableView;
}

@property (weak, nonatomic) IBOutlet UIButton *btnFBFriendList;
@property (weak, nonatomic) IBOutlet UITableView *tvMenu;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFriendName;

@property (weak, nonatomic) IBOutlet UIButton *btnParam;

@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (strong, nonatomic) NSString *friendId;
@end
