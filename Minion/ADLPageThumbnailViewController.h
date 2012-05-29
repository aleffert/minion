//
//  ADLPageThumbnailViewController.h
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADLNotebookViewController;
@class ADLNotebook;

#import <CoreData/CoreData.h>

@interface ADLPageThumbnailViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) ADLNotebookViewController *detailViewController;
@property (strong, nonatomic) ADLNotebook* notebook;

@end
