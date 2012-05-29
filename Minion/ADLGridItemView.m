//
//  ADLGridItemView.m
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADLGridItemView.h"

#import "ADLGridItem.h"

static CGFloat ADLGridItemSize = 40.;

@interface ADLGridItemView ()

@property (strong, nonatomic) ADLGridItem* item;

@end

@implementation ADLGridItemView

@synthesize item = _item;

- (ADLGridItemView*)initWithItem:(ADLGridItem *)item {
    CGSize itemSize = [[self class] gridItemSize];
    if((self = [super initWithFrame:CGRectMake(0, 0, itemSize.width, itemSize.height)])) {
        self.item = item;
        self.layer.borderColor = [UIColor colorWithWhite:.3 alpha:1.].CGColor;
        self.layer.borderWidth = 1;
        
        self.backgroundColor = item.color;
        
        [self.item addObserver:self forKeyPath:@"color" options:0 context:NULL];
    }
    return self;
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

+ (CGSize)gridItemSize {
    return CGSizeMake(ADLGridItemSize, ADLGridItemSize);
}

@end
