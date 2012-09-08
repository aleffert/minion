//
//  ADLAppDelegate.m
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADLAppDelegate.h"

#import "ADLAddPageViewController.h"
#import "ADLNotebook.h"
#import "ADLNotebookLibrary.h"
#import "ADLNotebookViewController.h"
#import "ADLPage.h"
#import "ADLPageThumbnailManager.h"
#import "ADLPageThumbnailViewController.h"

@interface ADLAppDelegate ()

@property (strong, nonatomic) UISplitViewController *splitViewController;

- (void)saveContext;

@end

@implementation ADLAppDelegate

@synthesize window = _window;
@synthesize splitViewController = _splitViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // This is sort of unfortunate. We should really be getting these metrics from somewhere
    // TODO: Get them from somewhere
    [[ADLPageThumbnailManager sharedManager] setBaseSize:CGSizeMake(586, 899)];
    [[ADLPageThumbnailManager sharedManager] setThumbnailSize:CGSizeMake(300, 460)];
    
    UIPageViewController* pageViewController =
    [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationDirectionForward options:@{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)}];
    
    pageViewController.delegate = self;
    pageViewController.dataSource = self;

    ADLPageViewController* initialViewController = [[ADLPageViewController alloc] initWithPage:[[[[ADLNotebookLibrary sharedLibrary] mainNotebook] pages] objectAtIndex:0]];
    
    [pageViewController setViewControllers:@[initialViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.window.rootViewController = pageViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    [[ADLNotebookLibrary sharedLibrary] commitChanges];
}


#pragma mark Page Controller Delegate

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
            currentIndex = [[[[ADLNotebookLibrary sharedLibrary] mainNotebook] pages] count];
        }
    }
    if(currentIndex > 0) {
        ADLPage* page = [[[[ADLNotebookLibrary sharedLibrary] mainNotebook] pages] objectAtIndex:currentIndex - 1];
        ADLPageViewController* controller = [[ADLPageViewController alloc] initWithPage:page];
        return controller;
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
    if(index < [[[[ADLNotebookLibrary sharedLibrary] mainNotebook] pages] count]) {
        ADLPage* page = [[[[ADLNotebookLibrary sharedLibrary] mainNotebook] pages] objectAtIndex:index];
        ADLPageViewController* controller = [[ADLPageViewController alloc] initWithPage:page];
        return controller;
    }
    else {
        return nil;
    }
}

@end
