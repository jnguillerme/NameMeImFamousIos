//
//  chGameOverViewController.h
//  CelebrityHead
//
//  Created by Jean-Noel Guillerme on 05/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chGameOverViewController : UIViewController

@property BOOL gameWon;
@property (weak, nonatomic) IBOutlet UILabel *lblGameStatus;

@end
