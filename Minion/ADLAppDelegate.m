//
//  ADLAppDelegate.m
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADLAppDelegate.h"

#import "ADLNotebookLibrary.h"
#import "ADLNotebookViewController.h"
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
    
    ADLNotebookViewController* notebookController = [[ADLNotebookViewController alloc] initWithNotebook:[[ADLNotebookLibrary sharedLibrary] mainNotebook]];

    self.window.rootViewController = notebookController;
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveContext];
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


@end
