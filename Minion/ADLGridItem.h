//
//  ADLGridItem.h
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ADLGridRow;

@interface ADLGridItem : NSManagedObject

@property (nonatomic, strong) UIColor* color;
@property (nonatomic, strong) ADLGridRow *row;

@end
