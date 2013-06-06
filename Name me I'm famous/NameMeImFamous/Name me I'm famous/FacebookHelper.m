//
//  FacebookHelper.m
//  Name me I'm famous
//
//  Created by Jino on 12/12/2012.
//  Copyright (c) 2012 nmif. All rights reserved.
//

#import "FacebookHelper.h"
#import "PAMHelper.h"

@implementation FacebookHelper


static FacebookHelper * sharedHelper = 0;

+ (FacebookHelper*) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[FacebookHelper alloc] init];
    }
    return sharedHelper;
}



@end
