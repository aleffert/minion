//
//  ADLPageViewController.h
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ADLConnectionLineView.h"

@class ADLTool;
@class ADLPage;
@protocol ADLPageViewControllerDelegate;

@interface ADLPageViewController : UIViewController <ADLConnectionLineViewDelegate>

- (id)initWithPage:(ADLPage*)page;

@property (weak, nonatomic) id <ADLPageViewControllerDelegate> delegate;
@property (readonly, strong, nonatomic) ADLPage* page;

@end


@protocol ADLPageViewControllerDelegate <NSObject>

@property (strong, readonly, nonatomic) ADLTool* activeTool;

@end
