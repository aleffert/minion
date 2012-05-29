//
//  ADLNotebook.m
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADLNotebook.h"
#import "ADLPage.h"


@implementation ADLNotebook

@dynamic title;
@dynamic pages;

- (void)addPagesObject:(ADLPage *)value {
    NSMutableOrderedSet* set = [self mutableOrderedSetValueForKey:@"pages"];
    [set addObject:value];
}

@end
