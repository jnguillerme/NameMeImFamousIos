//
//  chCelebrityChoiceViewController.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 26/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMHelper.h"

@interface chCelebrityChoiceViewController : UIViewController<GMHelperDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblOpponentFound;

@property (weak, nonatomic) IBOutlet UITextField *lblCelebrityName;
@property (strong, nonatomic) NSString *opponentName;
@property BOOL celebrityPickedUpByMe;
@property BOOL celebrityPickedUpByOpponent;
@end
