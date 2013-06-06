//
//  nmifGameInProgressTableView.h
//  Name me I'm famous
//
//  Created by Jino on 28/02/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol nmifGameInProgressTableViewDelegate

-(void) showQuestionHistory:(NSString*)gameID;
-(void) resumeGame:(NSString*)gameID;

@end

@interface nmifGameInProgressTableView : NSObject<UITableViewDelegate, UITableViewDataSource> {
    id <nmifGameInProgressTableViewDelegate> delegate;

    NSDictionary* gameContents;
    NSArray* gameList;
}


@property (strong, nonatomic) NSArray* games;
@property (nonatomic, retain) NSDictionary* gameContents;
@property (nonatomic, retain) NSArray* gameList;

-(id) initWithDelegate:(id<nmifGameInProgressTableViewDelegate>)theDelegate;

-(void) loadGames;
@end
