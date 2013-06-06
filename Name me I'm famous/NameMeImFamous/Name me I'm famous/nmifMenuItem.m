//
//  nmifMenuItem.m
//  Name me I'm famous
//
//  Created by Jino on 27/02/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifMenuItem.h"

@implementation nmifMenuItem 

@synthesize title;
@synthesize description;
@synthesize image;

-(id)initWithTitle:(NSString*)theTitle andDescription:(NSString*)theDescription andImage:(NSString*)theImage andAction:(SEL)theAction
{
    self.title = [NSString stringWithString:theTitle];
    self.description = [NSString stringWithString:theDescription];
    self.image = [NSString stringWithString:theImage];
    self.itemAction = theAction;
    return self;
}
@end
