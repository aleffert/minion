//
//  ADLDetailViewController.m
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADLNotebookViewController.h"

#import "ADLNotebookLibrary.h"
#import "ADLSwatchButton.h"
#import "ADLTool.h"

@interface ADLNotebookViewController ()
@property (strong, nonatomic) UIPopoverController* masterPopoverController;
@property (strong, nonatomic) ADLPageViewController* currentPageController;

@property (strong, nonatomic) IBOutlet UIScrollView* scrollView;
@property (strong, nonatomic) IBOutlet UIView* contentView;
@property (strong, nonatomic) IBOutletCollection(ADLSwatchButton) NSArray* swatchButtons;

@property (strong, nonatomic) ADLTool* activeTool;

- (void)configureView;
@end

@implementation ADLNotebookViewController

@synthesize activeTool = _activeTool;
@synthesize contentView = _contentView;
@synthesize currentPageController = _currentPageController;
@synthesize detailItem = _detailItem;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize scrollView = _scrollView;
@synthesize swatchButtons = _swatchButtons;

#pragma mark - Managing the detail item

- (void)setDetailItem:(ADLPage*)newDetailItem
{
    if (_detailItem != newDetailItem) {
        [self removeCurrentPageController];
        _detailItem = newDetailItem;
        
        self.currentPageController = [[ADLPageViewController alloc] initWithPage:_detailItem];
        self.currentPageController.delegate = self;
        [self addChildViewController:self.currentPageController];
        
        self.activeTool = [ADLColorTool colorToolWithColor:[UIColor redColor]];
        
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
    [self configureView];
    self.scrollView.contentSize = self.contentView.frame.size;
}

- (void)configureView {
    if(self.isViewLoaded) {
        [self.contentView addSubview:self.currentPageController.view];
        self.currentPageController.view.frame = self.contentView.bounds;
        [self updateSwatchButtons];
        NSArray* swatchColors = [[ADLNotebookLibrary sharedLibrary] swatchColors];
        [self.swatchButtons enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL* stop) {
            ADLSwatchButton* button = object;
            button.color = [swatchColors objectAtIndex:index];
        }];
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



- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration animations:^{
        self.contentView.center = CGPointMake(self.scrollView.center.x, self.contentView.center.y);
    }];
}

#pragma mark Tools

- (void)updateSwatchButtons {
    __block UIColor* activeToolColor = nil;
    [self.activeTool caseLineTool:^(ADLLineTool* lineTool) {
    } colorTool:^(ADLColorTool* colorTool) {
        activeToolColor = colorTool.color;
    }];
    for(ADLSwatchButton* button in self.swatchButtons) {
        button.selected = [button.color isEqual:activeToolColor];
    }
}

- (IBAction)takeColorFrom:(ADLSwatchButton*)sender {
    self.activeTool = [ADLColorTool colorToolWithColor:sender.color];
    [self updateSwatchButtons];
}

- (IBAction)useLineTool:(id)sender {
    self.activeTool = [ADLLineTool lineTool];
    [self updateSwatchButtons];
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
