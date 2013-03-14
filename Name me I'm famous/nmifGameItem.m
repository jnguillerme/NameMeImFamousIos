//
//  nmifGameItem.m
//  Name me I'm famous
//
//  Created by Jino on 25/02/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import "nmifGameItem.h"

@implementation nmifGameItem

@synthesize itemTitle;
@synthesize itemContent;
@synthesize itemHasAccessory;
@synthesize itemAction;
@synthesize itemImage;

-(id)initWithTitle:(NSString*)title andContent:(NSString*)content
{
    itemTitle = title;
    itemContent = content;
    itemHasAccessory = false;
    itemAction = nil;
    itemImage = nil;

    return self;
}

-(id)initWithAccessoryAndTitle:(NSString*)title andContent:(NSString*)content andAction:(SEL)action andImage:(NSString*)theImage
{
    itemTitle = title;
    itemContent = content;
    itemHasAccessory = true;
    itemAction = action;
    
    return self;
}

@end
