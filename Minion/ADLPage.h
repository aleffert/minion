//
//  ADLPage.h
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ADLGridRow, ADLNotebook;

@interface ADLPage : NSManagedObject

@property (nonatomic) NSTimeInterval creationDate;
@property (nonatomic) NSOrderedSet* lines;
@property (nonatomic, strong) ADLNotebook *owner;
@property (nonatomic, strong) NSOrderedSet *rows;
@property (nonatomic, strong) NSString* uuid;

@end

@interface ADLPage (CoreDataGeneratedAccessors)

- (void)insertObject:(ADLGridRow *)value inRowsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRowsAtIndex:(NSUInteger)idx;
- (void)insertRows:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRowsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRowsAtIndex:(NSUInteger)idx withObject:(ADLGridRow *)value;
- (void)replaceRowsAtIndexes:(NSIndexSet *)indexes withRows:(NSArray *)values;
- (void)addRowsObject:(ADLGridRow *)value;
- (void)removeRowsObject:(ADLGridRow *)value;
- (void)addRows:(NSOrderedSet *)values;
- (void)removeRows:(NSOrderedSet *)values;
@end
