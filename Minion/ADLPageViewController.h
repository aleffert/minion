//
//  ADLPageViewController.h
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADLPage;
@protocol ADLPageViewControllerDelegate;

@interface ADLPageViewController : UIViewController

- (id)initWithPage:(ADLPage*)page;

@property (weak, nonatomic) id <ADLPageViewControllerDelegate> delegate;
@property (readonly, strong, nonatomic) ADLPage* page;

@end


@protocol ADLPageViewControllerDelegate <NSObject>

@property (strong, readonly, nonatomic) UIColor* activeToolColor;

@end
