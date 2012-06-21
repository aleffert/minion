//
//  ADLPageRenderingOperation.m
//  Minion
//
//  Created by Akiva Leffert on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADLPageRenderingOperation.h"

#import "ADLConnectionLine.h"
#import "ADLGridItem.h"
#import "ADLGridRow.h"
#import "ADLGridItemView.h"
#import "ADLNotebookLibrary.h"
#import "ADLPage.h"


@interface ADLPageRenderingOperation ()

@property (retain, nonatomic) NSManagedObjectID* pageID;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGSize baseSize;
@property (strong, nonatomic) UIImage* resultImage;

@end

@implementation ADLPageRenderingOperation

@synthesize baseSize = _baseSize;
@synthesize pageID = _pageID;
@synthesize resultImage = _resultImage;
@synthesize size = _size;

- (ADLPageRenderingOperation*)initWithPage:(ADLPage*)page size:(CGSize)size baseSize:(CGSize)baseSize {
    if((self = [super init])) {
        self.pageID = page.objectID;
        self.size = size;
        self.baseSize = baseSize;
    }
    return self;
}

- (CGRect)rectForCellAtX:(NSUInteger)x y:(NSUInteger)y {
    CGSize itemSize = [ADLGridItemView gridItemSize];
    CGFloat xCoord = itemSize.width * (x + 1) - x;
    CGFloat yCoord = itemSize.height * (y + 1) - y;
    return CGRectMake(xCoord, yCoord, itemSize.width, itemSize.height);
}

- (CGPoint)rectCenter:(CGRect)rect {
    return CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
}

- (void)main {
    [[ADLNotebookLibrary sharedLibrary] performWithFreshContext:^(NSManagedObjectContext* objectContext) {
        NSError* error = nil;
        ADLPage* page = (ADLPage*)[objectContext existingObjectWithID:self.pageID error:&error];
        if(error != nil) {
            return;
        }
        UIGraphicsBeginImageContextWithOptions(self.size, YES, 0.);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(ctx, self.size.width / self.baseSize.width, self.size.height / self.baseSize.height);
        [[UIColor whiteColor] set];
        CGContextFillRect(ctx, CGRectMake(0, 0, self.baseSize.width, self.baseSize.height));
        UIColor* gridBorderColor = [ADLGridItemView borderColor];
        [page.rows enumerateObjectsUsingBlock:^(id obj, NSUInteger y, BOOL* stop) {
            ADLGridRow* row = obj;
            [row.items enumerateObjectsUsingBlock:^(id obj2, NSUInteger x, BOOL* stop) {
                ADLGridItem* item = obj2;
                CGRect itemRect = [self rectForCellAtX:x y:y];
                UIBezierPath* itemPath =  [UIBezierPath bezierPathWithRect:itemRect];
                [item.color setFill];
                [itemPath fill];
                [gridBorderColor setStroke];
                [itemPath stroke];
            }];
        }];
        for(ADLConnectionLine* line in page.lines) {
            NSUInteger srcX = [line.source.row.items indexOfObject: line.source];
            NSUInteger srcY = [line.source.row.page.rows indexOfObject: line.source.row];
            NSUInteger dstX = [line.destination.row.items indexOfObject: line.destination];
            NSUInteger dstY = [line.destination.row.page.rows indexOfObject: line.destination.row];
            CGRect srcRect = [self rectForCellAtX:srcX y:srcY];
            CGRect dstRect = [self rectForCellAtX:dstX y:dstY];
            CGPoint srcCenter = [self rectCenter:srcRect];
            CGPoint dstCenter = [self rectCenter:dstRect];
            UIBezierPath* linePath = [UIBezierPath bezierPath];
            [linePath moveToPoint:srcCenter];
            [linePath addLineToPoint:dstCenter];
            [[UIColor blackColor] setStroke];
            [linePath stroke];
        }
        
        self.resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }];
}

@end
