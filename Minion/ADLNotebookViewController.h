//
//  ADLDetailViewController.h
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADLPage;

@interface ADLNotebookViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) ADLPage* detailItem;

@end
