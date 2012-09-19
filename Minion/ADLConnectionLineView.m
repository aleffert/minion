//
//  ADLConnectionLineView.m
//  Minion
//
//  Created by Akiva Leffert on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADLConnectionLineView.h"

#import "ADLConnectionLine.h"

@interface ADLConnectionLineView ()

@property (retain, nonatomic) ADLConnectionLine* line;
@property (retain, nonatomic) CAShapeLayer* pathLayer;
@property (assign, nonatomic) id <ADLConnectionLineViewDelegate> delegate;

@end

@implementation ADLConnectionLineView

@synthesize line = _line;
@synthesize pathLayer = _pathLayer;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame line:(ADLConnectionLine*)line delegate:(id <ADLConnectionLineViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        self.pathLayer = [CAShapeLayer layer];
        self.pathLayer.lineWidth = 2;
        self.pathLayer.strokeColor = [UIColor blackColor].CGColor;
        self.pathLayer.frame = self.bounds;
        self.line = line;
        [self.layer addSublayer:self.pathLayer];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [self updateLocation];
}

- (void)didMoveToSuperview {
    [self updateLocation];
}

- (void)updateLocation {
    self.pathLayer.frame = self.bounds;
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:[self.delegate locationForItem:self.line.source relativeToLineView:self]];
    [path addLineToPoint:[self.delegate locationForItem:self.line.destination relativeToLineView:self]];
    self.pathLayer.path = path.CGPath;
}

@end
