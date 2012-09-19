//
//  ADLDetailViewController.m
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADLNotebookViewController.h"

#import "ADLAddPageViewController.h"
#import "ADLEditorToolsViewController.h"
#import "ADLNotebook.h"
#import "ADLPage.h"
#import "ADLPageViewController.h"

@interface ADLNotebookViewController ()

@property (strong, nonatomic) IBOutlet ADLEditorToolsViewController* toolsController;
@property (strong, nonatomic) ADLNotebook* notebook;
@property (strong, nonatomic) UIPageViewController* pageController;

@end

@implementation ADLNotebookViewController

- (id)initWithNotebook:(ADLNotebook*)notebook {
    if((self = [super initWithNibName:nil bundle:nil])) {
        self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationDirectionForward options:@{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)}];
        
        self.notebook = notebook;
        self.pageController.delegate = self;
        self.pageController.dataSource = self;
        
        
        self.toolsController = [[ADLEditorToolsViewController alloc] initWithNibName:nil bundle:nil];
        
        ADLPageViewController* initialViewController = [self pageControllerForPage:self.notebook.pages[0]];
        
        [self.pageController setViewControllers:@[initialViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        [self addChildViewController:self.pageController];
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewDidLoad {
    [self.view addSubview:self.pageController.view];
    self.pageController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.pageController.view.frame = self.view.bounds;
    [self.view addSubview:self.toolsController.view];
    
    CGFloat toolsX = self.view.frame.size.width / 2;
    CGFloat toolsY = self.view.frame.size.height - self.toolsController.view.frame.size.height / 2;
    self.toolsController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    self.toolsController.view.center = CGPointMake(toolsX, toolsY);
}

#pragma mark Page Controller Delegate

- (ADLPageViewController*)pageControllerForPage:(ADLPage*)page {
    
    ADLPageViewController* controller = [[ADLPageViewController alloc] initWithPage:page];
    controller.delegate = self.toolsController;
    return controller;
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if(UIInterfaceOrientationIsPortrait(orientation)) {
        UIViewController *currentViewController = [pageViewController.viewControllers objectAtIndex:0];
        NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
        [pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
        pageViewController.doubleSided = NO;
        
        return UIPageViewControllerSpineLocationMin;
    }
    else {
        NSArray *viewControllers = nil;
        ADLPageViewController *viewController = [pageViewController.viewControllers objectAtIndex:0];
        ADLPage* page = viewController.page;
        NSUInteger currentIndex = [page.owner.pages indexOfObject:page];
        
        if(currentIndex %2 == 0)
        {
            UIViewController *nextViewController = [self pageViewController:pageViewController viewControllerAfterViewController:viewController];
            if(nextViewController != nil) {
                viewControllers = [NSArray arrayWithObjects:viewController, nextViewController, nil];
            }
            else {
                ADLAddPageViewController* controller = [[ADLAddPageViewController alloc] init];
                viewControllers = [NSArray arrayWithObjects:viewController, controller, nil];
            }
        }
        else
        {
            UIViewController *previousViewController = [self pageViewController:pageViewController viewControllerBeforeViewController:viewController];
            viewControllers = [NSArray arrayWithObjects:previousViewController, viewController, nil];
        }
        //Now, set the viewControllers property of UIPageViewController
        [pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
        return UIPageViewControllerSpineLocationMid;
    }
}


- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(ADLPageViewController *)viewController {
    NSUInteger currentIndex = 1;
    if(viewController != nil) {
        if([viewController isKindOfClass:[ADLPageViewController class]]) {
            ADLPage* page = viewController.page;
            currentIndex = [page.owner.pages indexOfObject:page];
        }
        else {
            currentIndex = self.notebook.pages.count;
        }
    }
    if(currentIndex > 0) {
        ADLPage* page = [self.notebook.pages objectAtIndex:currentIndex - 1];
        return [self pageControllerForPage:page];
    }
    else {
        return nil;
    }
    
}

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(ADLPageViewController *)viewController {
    
    if(![viewController isKindOfClass:[ADLPageViewController class]]) {
        return nil;
    }
    
    NSUInteger index = 0;
    if(viewController != nil) {
        ADLPage* page = viewController.page;
        index = [page.owner.pages indexOfObject:page] + 1;
    }
    if(index < self.notebook.pages.count) {
        ADLPage* page = [self.notebook.pages objectAtIndex:index];
        return [self pageControllerForPage:page];
    }
    else {
        return nil;
    }
}

@end
