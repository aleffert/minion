//
//  ADLNotebookLibrary.h
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADLConnectionLine;
@class ADLGridItem;
@class ADLNotebook;
@class ADLPage;

@interface ADLNotebookLibrary : NSObject

+ (ADLNotebookLibrary*)sharedLibrary;
@property (readonly, strong, nonatomic) NSManagedObjectContext* mainContext;
@property (readonly, strong, nonatomic) NSManagedObjectID* mainNotebookID;
@property (readonly, strong, nonatomic) ADLNotebook* mainNotebook;
@property (readonly, copy, nonatomic) NSArray* swatchColors;

@property (readonly, nonatomic) NSURL* applicationDocumentsDirectory;

- (void)commitChanges;

- (void)performWithFreshContext:(void(^)(NSManagedObjectContext* objectContext))action;

- (ADLPage*)freshPageInNotebook:(ADLNotebook*)notebook;
- (NSFetchedResultsController*)fetchedPageResultsForNotebook:(ADLNotebook*)notebook;

- (ADLConnectionLine*)addLineBetweenSource:(ADLGridItem*)source destination:(ADLGridItem*)destination;

@end

extern NSString* ADLPageChangedNotification;