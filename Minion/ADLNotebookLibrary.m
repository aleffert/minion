//
//  ADLNotebookLibrary.m
//  Minion
//
//  Created by Akiva Leffert on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADLNotebookLibrary.h"

#import "ADLGridItem.h"
#import "ADLGridRow.h"
#import "ADLNotebook.h"
#import "ADLPage.h"

NSString* ADLPageChangedNotification = @"ADLPageChangedNotification";

static NSUInteger ADLPageRows = 23;
static NSUInteger ADLPageColumns = 15;
static NSString* ADLNotebookMainNotebookIDKey = @"ADLNotebookMainNotebookIDKey";

@interface ADLNotebookLibrary ()

@property (strong, nonatomic) NSManagedObjectContext *mainContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation ADLNotebookLibrary

@synthesize managedObjectModel = _managedObjectModel;
@synthesize mainContext = _mainContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (ADLNotebookLibrary*)sharedLibrary {
    static dispatch_once_t onceToken;
    static ADLNotebookLibrary* sharedLibrary = nil;
    dispatch_once(&onceToken, ^{
        sharedLibrary = [[ADLNotebookLibrary alloc] init];
    });
    
    return sharedLibrary;
}

- (id)init {
    if((self = [super init])) {
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Minion.sqlite"];
        
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Minion" withExtension:@"momd"];
        self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        NSError *error = nil;
        self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {

        }
        self.mainContext = [[NSManagedObjectContext alloc] init];
        [self.mainContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainContextSaved:) name:NSManagedObjectContextDidSaveNotification object:self.mainContext];
    }
    return self;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectID*)mainNotebookID {
    NSString* mainURLString = [[NSUserDefaults standardUserDefaults] objectForKey:ADLNotebookMainNotebookIDKey];
    if(mainURLString == nil) {
        ADLNotebook* notebook = [NSEntityDescription insertNewObjectForEntityForName: @"ADLNotebook" inManagedObjectContext:self.mainContext];
        [self freshPageInNotebook:notebook];
        NSError* error = nil;
        [self.mainContext save:&error];
        NSAssert(error == nil, @"Error creating main notebook.");
        mainURLString = notebook.objectID.URIRepresentation.absoluteString;
        [[NSUserDefaults standardUserDefaults] setObject:mainURLString forKey:ADLNotebookMainNotebookIDKey];
    }
    NSURL* mainURL = [NSURL URLWithString:mainURLString];
    
    return [self.persistentStoreCoordinator managedObjectIDForURIRepresentation:mainURL];
}

- (ADLNotebook*)mainNotebook {
    NSManagedObjectID* notebookID = [self mainNotebookID];
    NSError* error = nil;
    ADLNotebook* result = (ADLNotebook*)[self.mainContext existingObjectWithID:notebookID error:&error];
    NSAssert(error == nil, @"Error finding main notebook");
    return result;
}

- (void)commitChanges {
    NSError* error = nil;
    NSManagedObjectContext *managedObjectContext = self.mainContext;
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (NSFetchedResultsController*)fetchedPageResultsForNotebook:(ADLNotebook *)notebook {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    fetchRequest.entity = [NSEntityDescription entityForName:@"ADLPage" inManagedObjectContext:self.mainContext];
    fetchRequest.fetchBatchSize = 20;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"owner = %@", self.mainNotebook];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.mainContext sectionNameKeyPath:nil cacheName:@"Pages"];
        
    return aFetchedResultsController;
}

- (NSString*)freshUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
    return (__bridge_transfer NSString*)uuidString;
}

- (ADLPage*)freshPageInNotebook:(ADLNotebook *)notebook {
    ADLPage* page = [NSEntityDescription insertNewObjectForEntityForName:@"ADLPage" inManagedObjectContext:self.mainContext];
    page.creationDate = [NSDate timeIntervalSinceReferenceDate];
    for(NSUInteger row = 0; row < ADLPageRows; row++) {
        ADLGridRow* newRow = [NSEntityDescription insertNewObjectForEntityForName:@"ADLGridRow" inManagedObjectContext:self.mainContext];
        [page addRowsObject:newRow];
        for(NSUInteger column = 0; column < ADLPageColumns; column++) {
            ADLGridItem* item = [NSEntityDescription insertNewObjectForEntityForName:@"ADLGridItem" inManagedObjectContext:self.mainContext];
            item.color = [UIColor clearColor];
            [newRow addItemsObject:item];
        }
    }
    page.uuid = [self freshUUID];
    
    [notebook addPagesObject:page];
    return page;
}

- (void)mainContextSaved:(NSNotification*)notification {
    NSArray* changedObjects = [[notification userInfo] objectForKey:NSUpdatedObjectsKey];
    NSMutableSet* changedPages = [[NSMutableSet alloc] init];
    for(NSManagedObject* object in changedObjects) {
        if([object isKindOfClass:[ADLPage class]]) {
            [changedPages addObject:object];
        }
        else if([object isKindOfClass:[ADLGridItem class]]) {
            ADLGridItem* item = (ADLGridItem*)object;
            [changedPages addObject:item.row.page];
        }
    }
    
    for(ADLPage* page in changedPages) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ADLPageChangedNotification object:page];
    }
}

- (void)performWithFreshContext:(void(^)(NSManagedObjectContext* objectContext))action {
    NSManagedObjectContext* context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = self.persistentStoreCoordinator;
    action(context);
}

- (NSArray*)swatchColors {
    return [NSArray arrayWithObjects:
            [UIColor redColor],
            [UIColor greenColor],
            [UIColor blueColor],
            [UIColor orangeColor],
            [UIColor cyanColor],
            [UIColor magentaColor],
            [UIColor yellowColor],
            [UIColor clearColor],
            nil];
}

@end
