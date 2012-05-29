//
//  ADLPageThumbnailManager.m
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADLPageThumbnailManager.h"

#import "ADLPageRenderingOperation.h"
#import "ADLNotebookLibrary.h"
#import "ADLPage.h"

NSString* ADLPageThumbnailManagerRenderedPageNotification = @"ADLPageThumbnailManagerRenderedPageNotification";
NSString* ADLPageThumbnailManagerPageUUIDKey = @"ADLPageThumbnailManagerPageUUIDKey";
NSString* ADLPageThumbnailManagerPageImageKey = @"ADLPageThumbnailManagerPageImageKey";

@interface ADLPageThumbnailManager ()

@property (strong, nonatomic) NSOperationQueue* queue;

@end

@implementation ADLPageThumbnailManager

@synthesize baseSize = _baseSize;
@synthesize queue = _queue;
@synthesize thumbnailSize = _thumbnailSize;

+ (ADLPageThumbnailManager*)sharedManager {
    static dispatch_once_t onceToken;
    static ADLPageThumbnailManager* sharedManager = nil;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ADLPageThumbnailManager alloc] init];
    });
    return sharedManager;
}

- (id)init {
    if((self = [super init])) {
        self.queue = [[NSOperationQueue alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageChanged:) name:ADLPageChangedNotification object:nil];
    }
    return self;
}

- (void)pageChanged:(NSNotification*)notification {
    [self renderThumbnailForPage:notification.object];
}

- (void)postNotificationForPageUUID:(NSString*)pageUUID image:(UIImage*)resultImage {
    [[NSNotificationCenter defaultCenter] postNotificationName:ADLPageThumbnailManagerRenderedPageNotification object:pageUUID userInfo:[NSDictionary dictionaryWithObjectsAndKeys: pageUUID, ADLPageThumbnailManagerPageUUIDKey, resultImage, ADLPageThumbnailManagerPageImageKey, nil]];
}

- (void)renderThumbnailForPage:(ADLPage*)page {
    NSString* pageUUID = page.uuid;
    ADLPageRenderingOperation* operation = [[ADLPageRenderingOperation alloc] initWithPage:page size:self.thumbnailSize baseSize:self.baseSize];
    operation.completionBlock = ^{
        UIImage* resultImage = operation.resultImage;
        if(resultImage != nil) {
            NSData* imagePNG = UIImagePNGRepresentation(resultImage);
            [imagePNG writeToURL:[self imagePathForPageWithUUID:pageUUID] atomically:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self postNotificationForPageUUID:pageUUID image:resultImage];
            });
        }
    };
    [self.queue addOperation:operation];

}

- (NSURL*)imagePathForPageWithUUID:(NSString*)pageUUID {
    NSURL* documentsURL = [[ADLNotebookLibrary sharedLibrary] applicationDocumentsDirectory];
    return [documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", pageUUID]];
}

- (void)fetchThumbnailForPage:(ADLPage*)page {
    NSString* pageUUID = page.uuid;
    NSURL* imagePath = [self imagePathForPageWithUUID:pageUUID];
    UIImage* result = [UIImage imageWithContentsOfFile:imagePath.path];
    if(result != nil) {
        [self postNotificationForPageUUID:pageUUID image:result];
    }
    else {
        [self renderThumbnailForPage:page];
    }
}

@end
