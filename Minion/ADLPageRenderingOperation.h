//
//  ADLPageRenderingOperation.h
//  Minion
//
//  Created by Akiva Leffert on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADLPage;

@interface ADLPageRenderingOperation : NSOperation

- (ADLPageRenderingOperation*)initWithPage:(ADLPage*)page size:(CGSize)size baseSize:(CGSize)baseSize;

@property (readonly, strong, nonatomic) UIImage* resultImage;

@end
