//
//  nmifMemuTableView.h
//  Name me I'm famous
//
//  Created by Jino on 28/02/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol nmifMenuTableViewDelegate
-(void) newGame;
-(void) inviteFriend;
@end

@interface nmifMenuTableView : NSObject<UITableViewDelegate, UITableViewDataSource> {
    id <nmifMenuTableViewDelegate> delegate;
    NSMutableArray *menu;
}

-(id) initWithDelegate:(id<nmifMenuTableViewDelegate>)theDelegate;
-(void) addMenuItem:(NSString*)theTitle withDescription:(NSString*)theDescription andImage:(NSString*)theImage andAction:(SEL)theAction andDelegate:(id<nmifMenuTableViewDelegate>)theDelegate;

@end
