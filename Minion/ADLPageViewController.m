//
//  ADLPageViewController.m
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADLPageViewController.h"

#import "ADLConnectionLine.h"
#import "ADLConnectionLineView.h"
#import "ADLGridRow.h"
#import "ADLGridItem.h"
#import "ADLGridItemView.h"
#import "ADLNotebookLibrary.h"
#import "ADLPage.h"
#import "ADLPageThumbnailManager.h"
#import "ADLTool.h"

@interface ADLPageViewController ()

@property (strong, nonatomic) ADLPage* page;
@property (strong, nonatomic) NSMutableDictionary* itemViews;
@property (strong, nonatomic) NSMutableDictionary* lineViews;
@property (strong, nonatomic) ADLGridItemView* dragStartItemView;
@property (strong, nonatomic) CAShapeLayer* dragLineLayer;

@end

@implementation ADLPageViewController

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
    [self makeLines];
    
//    UIPanGestureRecognizer* dragApplyGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//    [self.view addGestureRecognizer:dragApplyGesture];
    
    UITapGestureRecognizer* tapApplyGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tapApplyGesture];
}

- (void)viewDidUnload {
    self.itemViews = nil;
}

- (CGRect)contentRect {
    return UIEdgeInsetsInsetRect(self.view.bounds, UIEdgeInsetsMake(10, 10, 60, 10));
}

- (CGSize)currentGridItemSize {
    return [ADLGridItemView itemSizeForCanvasSize:self.contentRect.size gridWidth:self.page.gridWidth gridHeight:self.page.gridHeight];
}

- (void)makeViews {
    self.itemViews = [[NSMutableDictionary alloc] init];
    CGSize itemSize = [self currentGridItemSize];
    for(ADLGridRow* row in self.page.rows) {
        for(ADLGridItem* item in row.items) {
            ADLGridItemView* itemView = [[ADLGridItemView alloc] initWithItem:item size:itemSize];
            [self.view addSubview:itemView];
            [self.itemViews setObject:itemView forKey:item.objectID];
        }
    }
    
    [self layoutItems];
}

- (void)makeLines {
    self.lineViews = [[NSMutableDictionary alloc] init];
    for(ADLConnectionLine* line in self.page.lines) {
        [self addLine:line];
    }
}

- (void)viewWillLayoutSubviews {
    [self layoutItems];
}

- (void)addLine:(ADLConnectionLine*)line {
    ADLConnectionLineView* view = [[ADLConnectionLineView alloc] initWithFrame:self.view.bounds line:line delegate:self];
    [self.view addSubview:view];
    [self.lineViews setObject:view forKey:line.objectID];
}

- (CGPoint)contentStartPoint {
    CGSize itemSize = [self currentGridItemSize];
    CGFloat totalWidth = itemSize.width * self.page.gridWidth - self.page.gridWidth - 1;
    CGFloat totalHeight = itemSize.height * self.page.gridHeight - self.page.gridHeight - 1;
    
    CGRect contentRect = self.contentRect;
    CGFloat x = contentRect.origin.x + (contentRect.size.width - totalWidth) / 2;
    CGFloat y = contentRect.origin.y + (contentRect.size.height - totalHeight) / 2;
    return CGPointMake(x, y);
}

- (void)layoutItems {
    CGPoint startPoint = [self contentStartPoint];
    CGSize itemSize = [self currentGridItemSize];
    CGFloat accumulatedHeight = startPoint.y;
    
    for(ADLGridRow* row in self.page.rows) {
        CGFloat accumulatedWidth = startPoint.x;
        for(ADLGridItem* item in row.items) {
            ADLGridItemView* itemView = [self.itemViews objectForKey:item.objectID];
            itemView.center = CGPointMake(accumulatedWidth + itemSize.width / 2, accumulatedHeight + itemSize.height / 2);
            itemView.bounds = CGRectMake(0, 0, itemSize.width, itemSize.height);
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

- (CGPoint)locationForItem:(ADLGridItem *)item relativeToLineView:(ADLConnectionLineView*)lineView {
    ADLGridItemView* view = [self.itemViews objectForKey:item.objectID];
    return [lineView convertPoint:view.center fromView:view.superview];
}

- (void)colorChangingGesture:(UIGestureRecognizer*)gesture tool:(ADLColorTool*)tool{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStateEnded:
        {
            ADLGridItemView* gridItem = [self gridItemViewAtPoint:[gesture locationInView:self.view]];
            gridItem.item.color = tool.color;
            break;
        }
        default:
            break;
    }
    if(gesture.state == UIGestureRecognizerStateEnded) {
        [[ADLNotebookLibrary sharedLibrary] commitChanges];
    }
}

- (void)dragLineWithGesture:(UIGestureRecognizer*)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            self.dragStartItemView = [self gridItemViewAtPoint:[gesture locationInView:self.view]];
            self.dragLineLayer = [CAShapeLayer layer];
            self.dragLineLayer.frame = self.view.bounds;
            self.dragLineLayer.lineWidth = 2;
            self.dragLineLayer.lineDashPattern = [NSArray arrayWithObjects:
                                                  [NSNumber numberWithFloat:4],
                                                  [NSNumber numberWithFloat:4],
                                                  nil];
            self.dragLineLayer.strokeColor = [UIColor blackColor].CGColor;
            [self.view.layer addSublayer:self.dragLineLayer];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint = [gesture locationInView:self.view];
            
            ADLGridItemView* destView = [self gridItemViewAtPoint:[gesture locationInView:self.view]];
            if(destView != nil) {
                currentPoint = [self.view convertPoint:destView.center fromView:destView.superview];
            }
            
            UIBezierPath* path = [UIBezierPath bezierPath];
            CGPoint startPoint = [self.view convertPoint:self.dragStartItemView.center fromView:self.dragStartItemView.superview];
            [path moveToPoint:startPoint];
            [path addLineToPoint:currentPoint];
            self.dragLineLayer.path = path.CGPath;
            break;
        }
        case UIGestureRecognizerStateEnded: {
            ADLGridItemView* destView = [self gridItemViewAtPoint:[gesture locationInView:self.view]];
            if(destView != nil) {
                ADLGridItem* srcItem = self.dragStartItemView.item;
                ADLGridItem* dstItem = destView.item;
                ADLConnectionLine* line = [[ADLNotebookLibrary sharedLibrary] addLineBetweenSource:srcItem destination:dstItem];
                [self addLine:line];
            }
            [self.dragLineLayer removeFromSuperlayer];
            self.dragLineLayer = nil;
            [[ADLNotebookLibrary sharedLibrary] commitChanges];
            break;
        }
        default:
            break;
    }
}

- (void)tap:(UITapGestureRecognizer*)gesture {
    [self.delegate.activeTool caseLineTool:^(ADLLineTool* tool) {
        // Do nothing
    } colorTool:^(ADLColorTool* tool) {
        [self colorChangingGesture:gesture tool:tool];
    }];
}

- (void)pan:(UIPanGestureRecognizer*)gesture {
    [self.delegate.activeTool caseLineTool:^(ADLLineTool* tool) {
        [self dragLineWithGesture:gesture];
    } colorTool:^(ADLColorTool* tool) {
        [self colorChangingGesture:gesture tool:tool];
    }];
}

@end
