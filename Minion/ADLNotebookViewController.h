//
//  ADLDetailViewController.h
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADLNotebook;

@interface ADLNotebookViewController : UIViewController < UIPageViewControllerDataSource, UIPageViewControllerDelegate>

- (id)initWithNotebook:(ADLNotebook*)notebook;

@end
