//
//  chNewAccountViewController.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 24/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAMHelper.h"

@interface chNewAccountViewController : UIViewController<PAMHelperDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfLogin;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnCreate;

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
