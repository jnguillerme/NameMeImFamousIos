//
//  nmifUITableViewCellGameInProgressCell.m
//  Name me I'm famous
//
//  Created by Jino on 25/02/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifUITableViewCellGameInProgressCell.h"

@implementation nmifUITableViewCellGameInProgressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
    
    self.textLabel.frame = CGRectMake(10,10,120, 20);
    self.detailTextLabel.frame = CGRectMake(130,10,170, 20);
    
}
@end

