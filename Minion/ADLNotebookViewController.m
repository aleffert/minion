//
//  ADLDetailViewController.m
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADLNotebookViewController.h"

#import "ADLPageViewController.h"

@interface ADLNotebookViewController ()
@property (strong, nonatomic) UIPopoverController* masterPopoverController;
@property (strong, nonatomic) ADLPageViewController* currentPageController;

- (void)configureView;
@end

@implementation ADLNotebookViewController

@synthesize detailItem = _detailItem;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize currentPageController = _currentPageController;

#pragma mark - Managing the detail item

- (void)setDetailItem:(ADLPage*)newDetailItem
{
    if (_detailItem != newDetailItem) {
        [self removeCurrentPageController];
        _detailItem = newDetailItem;
        
        self.currentPageController = [[ADLPageViewController alloc] initWithPage:_detailItem];
        [self addChildViewController:self.currentPageController];
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }

}

- (void)removeCurrentPageController {
    if(self.currentPageController.isViewLoaded) {
        [self.currentPageController.view removeFromSuperview];
    }
    [self.currentPageController removeFromParentViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)configureView {
    if(self.isViewLoaded) {
        [self.view addSubview:self.currentPageController.view];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
							
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
