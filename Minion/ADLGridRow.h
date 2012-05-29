//
//  ADLGridRow.h
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ADLGridItem, ADLPage;

@interface ADLGridRow : NSManagedObject

@property (nonatomic, strong) NSOrderedSet *items;
@property (nonatomic, strong) ADLPage *page;
@end

@interface ADLGridRow (CoreDataGeneratedAccessors)

- (void)insertObject:(ADLGridItem *)value inItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromItemsAtIndex:(NSUInteger)idx;
- (void)insertItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInItemsAtIndex:(NSUInteger)idx withObject:(ADLGridItem *)value;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)values;
- (void)addItemsObject:(ADLGridItem *)value;
- (void)removeItemsObject:(ADLGridItem *)value;
- (void)addItems:(NSOrderedSet *)values;
- (void)removeItems:(NSOrderedSet *)values;
@end
