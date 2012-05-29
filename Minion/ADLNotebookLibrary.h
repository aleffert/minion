//
//  ADLNotebookLibrary.h
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADLNotebook;
@class ADLPage;

@interface ADLNotebookLibrary : NSObject

+ (ADLNotebookLibrary*)sharedLibrary;
@property (readonly, strong, nonatomic) NSManagedObjectContext* mainContext;
@property (readonly, strong, nonatomic) NSManagedObjectID* mainNotebookID;
@property (readonly, strong, nonatomic) ADLNotebook* mainNotebook;

- (void)commitChanges;

- (ADLPage*)freshPageInNotebook:(ADLNotebook*)notebook;
- (NSFetchedResultsController*)fetchedPageResultsForNotebook:(ADLNotebook*)notebook;

@end
