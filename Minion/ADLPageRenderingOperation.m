//
//  ADLPageRenderingOperation.m
//  Minion
//
//  Created by Akiva Leffert on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADLPageRenderingOperation.h"

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
        CGFloat accumulatedHeight = 0;
        CGSize itemSize = [ADLGridItemView gridItemSize];
        UIColor* gridBorderColor = [ADLGridItemView borderColor];
        for(ADLGridRow* row in page.rows) {
            CGFloat accumulatedWidth = 0;
            for(ADLGridItem* item in row.items) {
                UIBezierPath* itemPath =  [UIBezierPath bezierPathWithRect:CGRectMake(accumulatedWidth, accumulatedHeight, itemSize.width, itemSize.height)];
                [item.color setFill];
                [itemPath fill];
                [gridBorderColor setStroke];
                [itemPath stroke];
                accumulatedWidth += itemSize.width - 1;
            }
            accumulatedHeight += itemSize.height - 1;
        }
        
        self.resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }];
}

@end
