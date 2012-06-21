//
//  ADLConnectionLineView.h
//  Minion
//
//  Created by Akiva Leffert on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADLConnectionLine;
@class ADLGridItem;
@protocol ADLConnectionLineViewDelegate;

@interface ADLConnectionLineView : UIView

- (id)initWithFrame:(CGRect)frame line:(ADLConnectionLine*)line delegate:(id <ADLConnectionLineViewDelegate>)delegate;

@property (readonly, assign, nonatomic) id <ADLConnectionLineViewDelegate> delegate;

@end


@protocol ADLConnectionLineViewDelegate <NSObject>

- (CGPoint)locationForItem:(ADLGridItem *)item relativeToLineView:(ADLConnectionLineView*)lineView;

@end