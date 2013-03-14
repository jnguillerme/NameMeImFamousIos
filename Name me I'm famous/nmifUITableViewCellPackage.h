//
//  nmifUITableViewPackage.h
//  Name me I'm famous
//
//  Created by Jino on 07/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol nmifUITableViewCellPackageDelegate
-(void) onCellSwitchOn:(bool)isOn forCellAtRow:(int)cellRow;
@end

@interface nmifUITableViewCellPackage : UITableViewCell {
id<nmifUITableViewCellPackageDelegate> delegate;
}

@property bool on;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDelegate:(id<nmifUITableViewCellPackageDelegate>)theDelegate;

@end
