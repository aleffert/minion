//
//  ADLPage.m
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADLPage.h"
#import "ADLGridRow.h"
#import "ADLNotebook.h"


@implementation ADLPage

@dynamic creationDate;
@dynamic gridHeight;
@dynamic gridWidth;
@dynamic lines;
@dynamic rows;
@dynamic owner;
@dynamic uuid;

- (void)addRowsObject:(ADLGridRow *)value {
    NSMutableOrderedSet* set = [self mutableOrderedSetValueForKey:@"rows"];
    [set addObject:value];
}

@end
