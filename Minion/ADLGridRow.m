//
//  ADLGridRow.m
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADLGridRow.h"
#import "ADLGridItem.h"
#import "ADLPage.h"


@implementation ADLGridRow

@dynamic items;
@dynamic page;

- (void)addItemsObject:(ADLGridItem *)value {
    NSMutableOrderedSet* set = [self mutableOrderedSetValueForKey:@"items"];
    [set addObject:value];
}

@end
