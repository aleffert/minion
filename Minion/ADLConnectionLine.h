//
//  ADLConnectionLine.h
//  Minion
//
//  Created by Akiva Leffert on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ADLGridItem;
@class ADLPage;

@interface ADLConnectionLine : NSManagedObject

@property (nonatomic, retain) ADLPage *page;
@property (nonatomic, retain) ADLGridItem* source;
@property (nonatomic, retain) ADLGridItem* destination;

@end
