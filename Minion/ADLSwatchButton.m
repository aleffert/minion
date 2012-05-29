//
//  ADLSwatchButton.m
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADLSwatchButton.h"

@interface ADLSwatchButton ()

@property (strong, nonatomic) CAShapeLayer* swatchLayer;

@end

@implementation ADLSwatchButton

@synthesize swatchLayer = _swatchLayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    
    CAShapeLayer* clearLayer = [CAShapeLayer layer];
    clearLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    clearLayer.fillColor = [UIColor whiteColor].CGColor;
    clearLayer.frame = self.bounds;
    [self.layer addSublayer:clearLayer];
    
    UIBezierPath* strikePath = [UIBezierPath bezierPath];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGPoint startPoint = CGPointMake(cosf(M_PI_4) * width / 2 + width / 2, sinf(M_PI_4) * height / 2 + height / 2);
    CGPoint endPoint = CGPointMake(cosf(M_PI_4 + M_PI) * width / 2 + width / 2, sinf(M_PI_4 + M_PI) * height / 2 + height / 2);
    [strikePath moveToPoint:startPoint];
    [strikePath addLineToPoint:endPoint];
    CAShapeLayer* strikeLayer = [CAShapeLayer layer];
    strikeLayer.path = strikePath.CGPath;
    strikeLayer.frame = self.bounds;
    strikeLayer.lineWidth = 4;
    strikeLayer.strokeColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:strikeLayer];
    
    self.swatchLayer = [CAShapeLayer layer];
    self.swatchLayer.path = clearLayer.path;
    self.swatchLayer.frame = self.bounds;
    self.swatchLayer.lineWidth = 4;
    [self.layer addSublayer:self.swatchLayer];
    self.showsTouchWhenHighlighted = YES;
}

- (void)adjustBorderColor {
    if(self.selected) {
        self.swatchLayer.strokeColor = [UIColor blackColor].CGColor;
    }
    else {
        self.swatchLayer.strokeColor = [UIColor grayColor].CGColor;
    }
}

- (void)setColor:(UIColor*)color {
    self.swatchLayer.fillColor = color.CGColor;
}

- (UIColor*)color {
    return [UIColor colorWithCGColor:self.swatchLayer.fillColor];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self adjustBorderColor];
}

@end
