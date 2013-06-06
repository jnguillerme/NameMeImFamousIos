//
//  nmifMenuItem.h
//  Name me I'm famous
//
//  Created by Jino on 27/02/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface nmifMenuItem : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *image;
@property SEL itemAction;

-(id)initWithTitle:(NSString*)theTitle andDescription:(NSString*)theDescription andImage:(NSString*)theImage andAction:(SEL)theAction;
@end
