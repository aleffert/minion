//
//  ADLPageViewController.m
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADLPageViewController.h"

#import "ADLPage.h"
#import "ADLGridRow.h"
#import "ADLGridItem.h"
#import "ADLGridItemView.h"
#import "ADLNotebookLibrary.h"
#import "ADLPageThumbnailManager.h"

@interface ADLPageViewController ()

@property (strong, nonatomic) ADLPage* page;
@property (strong, nonatomic) NSMutableDictionary* itemViews;

@end

@implementation ADLPageViewController

@synthesize delegate = _delegate;
@synthesize itemViews = _itemViews;
@synthesize page = _page;

- (id)initWithPage:(ADLPage*)page {
    if((self = [super initWithNibName:nil bundle:nil])) {
        self.page = page;
    }
   return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewDidLoad {
    [self makeViews];
    
    UIPanGestureRecognizer* dragApplyGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:dragApplyGesture];
    
    UITapGestureRecognizer* tapApplyGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tapApplyGesture];
}

- (void)viewDidUnload {
    self.itemViews = nil;
}

- (void)makeViews {
    self.itemViews = [[NSMutableDictionary alloc] init];
    for(ADLGridRow* row in self.page.rows) {
        for(ADLGridItem* item in row.items) {
            ADLGridItemView* itemView = [[ADLGridItemView alloc] initWithItem:item];
            [self.view addSubview:itemView];
            [self.itemViews setObject:itemView forKey:item.objectID];
        }
    }
    
    [self layoutItems];
}

- (void)layoutItems {
    CGFloat accumulatedHeight = 0;
    CGSize itemSize = [ADLGridItemView gridItemSize];
    
    for(ADLGridRow* row in self.page.rows) {
        CGFloat accumulatedWidth = 0;
        for(ADLGridItem* item in row.items) {
            ADLGridItemView* itemView = [self.itemViews objectForKey:item.objectID];
            itemView.center = CGPointMake(accumulatedWidth + itemSize.width / 2, accumulatedHeight + itemSize.height / 2);
            accumulatedWidth += itemSize.width - 1;
        }
        accumulatedHeight += itemSize.height - 1;
    }
}

- (ADLGridItemView*)gridItemViewAtPoint:(CGPoint)location {
    for(ADLGridItemView* view in self.itemViews.allValues) {
        if(CGRectContainsPoint(view.bounds, [view convertPoint:location fromView:self.view])) {
            return view;
        }
    }
    return nil;
}

- (void)colorChangingGesture:(UIGestureRecognizer*)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStateEnded:
        {
            ADLGridItemView* gridItem = [self gridItemViewAtPoint:[gesture locationInView:self.view]];
            gridItem.item.color = [self.delegate activeToolColor];
            break;
        }
        default:
            break;
    }
    if(gesture.state == UIGestureRecognizerStateEnded) {
        [[ADLNotebookLibrary sharedLibrary] commitChanges];
    }
}

- (void)tap:(UITapGestureRecognizer*)gesture {
    [self colorChangingGesture:gesture];
}

- (void)pan:(UIPanGestureRecognizer*)gesture {
    [self colorChangingGesture:gesture];
}

@end
