//
//  nmifUITableViewPackage.m
//  Name me I'm famous
//
//  Created by Jino on 07/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifUITableViewCellPackage.h"

@implementation nmifUITableViewCellPackage

@synthesize on;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDelegate:(id<nmifUITableViewCellPackageDelegate>)theDelegate
{
    delegate = theDelegate;
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipe:)];
        leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:leftSwipe];
        
        UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipe:)];
        rightSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:rightSwipe];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}  


-(void) layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(10,10,60, 20);
    self.detailTextLabel.frame = CGRectMake(70,10,170, 20);
    
}


-(void)cellSwipe:(UISwipeGestureRecognizer*)gesture
{
    on = !on;
    
    if (on) {
        self.textLabel.text = @"\u2714";
    } else {
        self.textLabel.text = @"\u2718";
    }
    
    [delegate onCellSwitchOn:on forCellAtRow:[self tag]];
}
@end
