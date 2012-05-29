//
//  ADLPageThumbnailManager.h
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADLPage;

@interface ADLPageThumbnailManager : NSObject

+ (ADLPageThumbnailManager*)sharedManager;

@property (assign, nonatomic) CGSize baseSize;
@property (assign, nonatomic) CGSize thumbnailSize;

- (void)fetchThumbnailForPage:(ADLPage*)page;

@end


extern NSString* ADLPageThumbnailManagerRenderedPageNotification;
extern NSString* ADLPageThumbnailManagerPageUUIDKey;
extern NSString* ADLPageThumbnailManagerPageImageKey;