//
//  nmifUITableViewCellWithSwipe.h
//  Name me I'm famous
//
//  Created by Jino on 28/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol nmifUITableViewCellWithSwipeDelegate
-(void) onCellSwipeLeft:(int)cellRow;
-(void) onCellSwipeRight:(int)cellRow;
@end

@interface nmifUITableViewCellWithSwipe : UITableViewCell {
    id<nmifUITableViewCellWithSwipeDelegate> delegate;
}

@property bool on;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDelegate:(id<nmifUITableViewCellWithSwipeDelegate>)theDelegate;



@end
