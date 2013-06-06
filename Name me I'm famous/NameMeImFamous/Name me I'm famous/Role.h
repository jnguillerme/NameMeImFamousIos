//
//  Role.h
//  Name me I'm famous
//
//  Created by Jino on 04/03/2013.
//  Copyright (c) 2013 nmif. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Celebrity;

@interface Role : NSManagedObject

@property (nonatomic, retain) NSString * role;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSSet *celebrities;
@end

@interface Role (CoreDataGeneratedAccessors)

- (void)addCelebritiesObject:(Celebrity *)value;
- (void)removeCelebritiesObject:(Celebrity *)value;
- (void)addCelebrities:(NSSet *)values;
- (void)removeCelebrities:(NSSet *)values;

@end
