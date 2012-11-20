//
//  chNewGameViewController.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 26/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMHelper.h"

@interface chNewGameViewController : UIViewController<GMHelperDelegate>

@property (weak,nonatomic) NSString* opponentName;
@end
