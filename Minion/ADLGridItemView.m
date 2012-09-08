//
//  ADLGridItemView.m
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADLGridItemView.h"

#import "ADLGridItem.h"

@interface ADLGridItemView ()

@property (strong, nonatomic) ADLGridItem* item;

@end

@implementation ADLGridItemView

@synthesize item = _item;

- (ADLGridItemView*)initWithItem:(ADLGridItem *)item size:(CGSize)itemSize {
    if((self = [super initWithFrame:CGRectMake(0, 0, itemSize.width, itemSize.height)])) {
        self.item = item;
        self.layer.borderColor = [[self class] borderColor].CGColor;
        self.layer.borderWidth = 1;
        
        self.backgroundColor = item.color;
        
        [self.item addObserver:self forKeyPath:@"color" options:0 context:(__bridge void*) self];
    }
    return self;
}

- (void)dealloc {
    [self.item removeObserver:self forKeyPath:@"color" context:(__bridge void*)self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"color"]) {
        if(![self.backgroundColor isEqual:self.item.color]) {
            [UIView transitionWithView:self duration:.1 options:UIViewAnimationTransitionFlipFromLeft animations:^{
                self.backgroundColor = self.item.color;
            } completion:nil];
        }
    }
}

+ (UIColor*)borderColor {
    return [UIColor colorWithWhite:.7 alpha:1.];
}

+ (CGSize)itemSizeForCanvasSize:(CGSize)canvasSize gridWidth:(CGFloat)gridWidth gridHeight:(CGFloat)gridHeight {
    CGFloat width = floorf(canvasSize.width / gridWidth);
    CGFloat height = floorf(canvasSize.height / gridHeight);
    CGFloat size = fminf(width, height);
    return CGSizeMake(size, size);
}

@end
