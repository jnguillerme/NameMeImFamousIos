//
//  nmifUITableViewCellWithSwipe.m
//  Name me I'm famous
//
//  Created by Jino on 28/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifUITableViewCellWithSwipe.h"

@implementation nmifUITableViewCellWithSwipe

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDelegate:(id<nmifUITableViewCellWithSwipeDelegate>)theDelegate
{
    delegate = theDelegate;
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onCellSwipeLeft:)];
        leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:leftSwipe];
        
        UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onCellSwipeRight:)];
        rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:rightSwipe];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)onCellSwipeLeft:(UISwipeGestureRecognizer*)gesture
{
    [delegate onCellSwipeLeft:[self tag]];
}
-(void)onCellSwipeRight:(UISwipeGestureRecognizer*)gesture
{
    [delegate onCellSwipeRight:[self tag]];
}


@end
