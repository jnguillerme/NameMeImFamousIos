//
//  nmifGameItem.h
//  Name me I'm famous
//
//  Created by Jino on 25/02/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface nmifGameItem : NSObject {
    NSString *itemTitle;
    NSString *itemContent;
    bool itemHasAccessory;
    SEL itemAction;
    NSString *itemImage;
}

@property (nonatomic, strong) NSString *itemTitle;
@property (nonatomic, strong) NSString *itemContent;
@property bool itemHasAccessory;
@property SEL itemAction;
@property (nonatomic, strong) NSString *itemImage;

-(id)initWithTitle:(NSString*)title andContent:(NSString*)content;
-(id)initWithAccessoryAndTitle:(NSString*)title andContent:(NSString*)content andAction:(SEL)action andImage:(NSString*)theImage;

@end
