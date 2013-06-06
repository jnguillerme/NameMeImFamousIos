//
//  Celebrity.h
//  Name me I'm famous
//
//  Created by Jino on 04/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Role;

@interface Celebrity : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Role *role;


@property (nonatomic, assign) NSInteger sectionNumber;

@end
