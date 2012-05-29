//
//  ADLPageThumbnailCell.m
//  Minion
//
//  Created by Akiva Leffert on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADLPageThumbnailCell.h"

#import "ADLPage.h"
#import "ADLPageThumbnailManager.h"

@interface ADLPageThumbnailCell ()

@property (strong, nonatomic) UIImageView* thumbnail;
@property (strong, nonatomic) NSString* pageUUID;

@end

@implementation ADLPageThumbnailCell

@synthesize thumbnail = _thumbnail;
@synthesize pageUUID = _pageUUID;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 10, 10)];
        self.thumbnail.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.thumbnail];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageThumbnailRendered:) name:ADLPageThumbnailManagerRenderedPageNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)prepareForReuse {
    self.pageUUID = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ADLPageThumbnailManagerRenderedPageNotification object:nil];
}

- (void)usePage:(ADLPage *)page {
    self.pageUUID = page.uuid;
    [[ADLPageThumbnailManager sharedManager] fetchThumbnailForPage:page];
}

- (void)pageThumbnailRendered:(NSNotification*)notification {
    NSString* pageUUID = [[notification userInfo] objectForKey:ADLPageThumbnailManagerPageUUIDKey];
    UIImage* image = [[notification userInfo] objectForKey:ADLPageThumbnailManagerPageImageKey];
    if([self.pageUUID isEqualToString:pageUUID]) {
        self.thumbnail.image = image;
    }
}

@end
