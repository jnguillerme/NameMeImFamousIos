//
//  nmifInviteFriendViewController.m
//  Name me I'm famous
//
//  Created by Jino on 24/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifInviteFriendViewController.h"
#import "nmifBackgroundLayer.h"
#import "MBProgressHUD.h"
#import "nmifAppDelegate.h"

@interface nmifInviteFriendViewController ()

@end

@implementation nmifInviteFriendViewController

@synthesize friendPickerController = _friendPickerController;
@synthesize friendId = _friendId;

- (FBFriendPickerViewController*)friendPickerController
{
    if (!_friendPickerController) {
        _friendPickerController = [[FBFriendPickerViewController alloc] initWithNibName:nil bundle:nil];
        NSSet *fields = [NSSet setWithObjects:@"installed", nil];
        _friendPickerController.fieldsForRequest = fields;
        
        _friendPickerController.allowsMultipleSelection = false;
        _friendPickerController.delegate = self;
    }
    return _friendPickerController;
}

- (void) setFriendPickerController:(FBFriendPickerViewController *)friendPickerController
{
    _friendPickerController = friendPickerController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[self  navigationController] setNavigationBarHidden:NO animated:YES];
    
    CAGradientLayer *bgLayer = [nmifBackgroundLayer blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];

    nmifAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate fbConnection]) {
        // show friend selector button
        self.btnFBFriendList.hidden = NO;
    } else {
        self.btnFBFriendList.hidden = YES;
    }
    id<nmifMenuTableViewDelegate> theDelegate = (id<nmifMenuTableViewDelegate>)self;
    menuTableView = [[nmifMenuInviteTableView alloc] initWithDelegate:theDelegate];
    self.tvMenu.delegate = menuTableView;
    self.tvMenu.dataSource = menuTableView;
    
    [menuTableView addMenuItem:NSLocalizedString(@"INVITE", nil) withDescription:NSLocalizedString(@"INVITE_DESCRIPTION", nil) andImage:@"invite.png" andAction:@selector(onInvite) andDelegate:theDelegate];
    
    [self.tvMenu reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTvMenu:nil];
    [self setTextFieldFriendName:nil];
    [self setBtnParam:nil];
    self.friendPickerController.delegate = nil;
    [self setFriendPickerController:nil];
    [self setBtnFBFriendList:nil];
    [super viewDidUnload];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];

    if ([MBProgressHUD HUDForView:self.view] != nil) {	
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint location = [touch locationInView:touch.view];
        
        if (CGRectContainsPoint(self.btnParam.frame, location)) {
            [self performSegueWithIdentifier:@"paramFromInvite" sender:self];
        }
    }
}

#pragma nmifMenuInviteTableViewDelegate
-(void) onInvite
{
    if ([self.textFieldFriendName.text length] > 0) {
        [self.view endEditing:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = NSLocalizedString(@"SENDING_INVITE", nil);
        
        if ( self.friendId != nil ) {
            NSMutableDictionary*params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.friendId, @"suggestions", nil];
            [FBWebDialogs presentRequestsDialogModallyWithSession:nil message:@"Tu devrais essayer name me I'm famous" title:nil parameters:params
                                                          handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                              if (error) {
                                                                  NSLog(@"Error sending request");
                                                                  [self onInviteFailed:error.localizedDescription];
                                                              } else {
                                                                  [self onInviteSuccess];
                                                              }
                                                          }];
        } else {
            [[GMHelper sharedInstance] invite:self.textFieldFriendName.text withDelegate:self];
        }
        
   }
}

#pragma GMelper
-(void) onInviteSuccess
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"APPLICATION_NAME", nil) message:[NSString stringWithFormat:NSLocalizedString(@"INVITE_SUCCEED", nil), self.textFieldFriendName.text] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    [self performSegueWithIdentifier:@"gameInProgressFromInvite" sender:self];
}

-(void) onInviteFailed:(NSString*)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"INVITE_FAILED", nil) message:[NSString stringWithFormat:NSLocalizedString(error, nil), self.textFieldFriendName.text] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)onFBSelectFriend:(id)sender
{
    [self.friendPickerController loadData];
    [self.navigationController pushViewController:self.friendPickerController animated:YES];
}

#pragma FBFriendPickerDelegate
- (void) friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker
{
    id<FBGraphUser> friend= [friendPicker.selection objectAtIndex:0];
    [self.textFieldFriendName setText:friend.name];
    if ([friend objectForKey:@"installed"] == nil) {        // nmif is not installed - send an invite
        self.friendId = friend.id;
    } else {
        self.friendId = nil;
    }
}
/*-(BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker shouldIncludeUser:(id<FBGraphUser>)user
{
    BOOL installed = [user objectForKey:@"installed"] != nil;
    return installed;
}*/
-(void) facebookViewControllerDoneWasPressed:(id)sender
{
    FBFriendPickerViewController *friendPickerController = (FBFriendPickerViewController*)sender;
    NSLog(@"Selected friend: %@", friendPickerController.selection);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) facebookViewControllerCancelWasPressed:(id)sender
{
    NSLog(@"canceled");
    [[sender presentingViewController] dismissModalViewControllerAnimated:YES];
    [self.textFieldFriendName setText:@""];
    self.friendId = nil;    
}
@end
