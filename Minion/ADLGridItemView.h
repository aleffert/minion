//
//  ADLGridItemView.h
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADLGridItem;

@interface ADLGridItemView : UIView

+ (UIColor*)borderColor;
+ (CGSize)gridItemSize;

- (ADLGridItemView*)initWithItem:(ADLGridItem*)item;

@property (readonly, strong, nonatomic) ADLGridItem* item;

@end
