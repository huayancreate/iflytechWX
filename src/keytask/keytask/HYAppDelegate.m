//
//  HYAppDelegate.m
//  keytask
//
//  Created by 许 玮 on 14-9-16.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYAppDelegate.h"
#import "HYLoginViewController.h"
#import "HYImageFactory.h"
#import "HYConstants.h"
#import "IQKeyboardManager.h"
#import "HYTabItemController.h"
#import "DrawPatternLockViewController.h"
#import "HYMainViewController.h"

@interface HYAppDelegate()
@property (nonatomic, strong) HYNavigationController *_nav;
@property (nonatomic, strong) HYNavigationModel *_navModel;
@property (nonatomic, strong) HYTabbarController *_tabbar;
@property (nonatomic, strong) DrawPatternLockViewController *lockVC;

@end


@implementation HYAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize _nav;
@synthesize _navModel;
@synthesize _tabbar;
@synthesize lockVC;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    [self initNavigationBar];
    
    [self initTabBar];
    
    //读取plist
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"lockPlist" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if([[data objectForKey:@"isLogin"] boolValue])
    {
        lockVC = [[DrawPatternLockViewController alloc] init];
        [lockVC setTarget:self withAction:@selector(lockEntered:)];
        self.window.rootViewController = lockVC;
    }else
    {
        HYLoginViewController * rootVC = [[HYLoginViewController alloc]init];
        [[rootVC getNavigationController] pushController:rootVC];
//        self.window.rootViewController = rootVC;
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)lockEntered:(NSString*)key {
    NSLog(@"key: %@", key);
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"lockPlist" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if (![key isEqualToString:[data objectForKey:@"key"]]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误"
                                                            message:@"密码不正确!"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
    }else
    {
        HYLoginViewController *loginView = [[HYLoginViewController alloc] init];
        loginView.user.accountName = [data objectForKey:@"accountName"];
        loginView.user.token = [data objectForKey:@"token"];
        loginView.user.username = [data objectForKey:@"username"];;
        [[_nav getModel] push:loginView];
        
        HYMainViewController *mainView = [[HYMainViewController alloc] init];
        mainView.user = loginView.user;
        [mainView setItemTag:TASK_START];
        [_nav pushController:mainView];
    }
}

-(void)initTabBar
{
    HYTabItemModel *itemstartModel = [[HYTabItemModel alloc] init];
    HYTabItemController *itemstart = [[HYTabItemController alloc] initWithModel:itemstartModel];
    [itemstart setUnselectBackgroudImage:[HYImageFactory GetImageByName:@"start" AndType:PNG]];
    [itemstart setSelectBackgroundImage:[HYImageFactory GetImageByName:@"start_hover" AndType:PNG]];
    [itemstart setName:MY_TASK_START];
    
    HYTabItemModel *itemexcModel = [[HYTabItemModel alloc] init];
    HYTabItemController *itemexc = [[HYTabItemController alloc] initWithModel:itemexcModel];
    [itemexc setUnselectBackgroudImage:[HYImageFactory GetImageByName:@"exc" AndType:PNG]];
    [itemexc setSelectBackgroundImage:[HYImageFactory GetImageByName:@"exc_hover" AndType:PNG]];
    [itemexc setName:MY_TASK_EXC];
    
    HYTabItemModel *itemjionModel = [[HYTabItemModel alloc] init];
    HYTabItemController *itemjion = [[HYTabItemController alloc] initWithModel:itemjionModel];
    [itemjion setUnselectBackgroudImage:[HYImageFactory GetImageByName:@"jion" AndType:PNG]];
    [itemjion setSelectBackgroundImage:[HYImageFactory GetImageByName:@"jion_hover" AndType:PNG]];
    [itemjion setName:MY_TASK_JOIN];
    
    HYTabItemModel *itemmoreModel = [[HYTabItemModel alloc] init];
    HYTabItemController *itemmore = [[HYTabItemController alloc] initWithModel:itemmoreModel];
    [itemmore setUnselectBackgroudImage:[HYImageFactory GetImageByName:@"more" AndType:PNG]];
    [itemmore setSelectBackgroundImage:[HYImageFactory GetImageByName:@"more_hover" AndType:PNG]];
    
    
    NSArray *items = [[NSArray alloc] initWithObjects:itemstart,itemexc, itemjion,itemmore,nil];
    _tabbar = [[HYTabbarController alloc] initWithTabbarItem:items];
    [_tabbar setBackgroudImage:[HYImageFactory GetImageByName:@"tabbarbg" AndType:PNG]];
    
    [_tabbar initItems];
}

-(void)initNavigationBar
{
    _navModel = [[HYNavigationModel alloc] init];
    _navModel._backgroudImg = [HYImageFactory GetImageByName:@"topbg" AndType:PNG];
    
    _nav = [[HYNavigationController alloc] initWithModel:_navModel];
    
    [_nav setBackgroudImageByModel];
    [_nav initLeftButton];
    [_nav initRightButton];
    
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
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"keytask" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"keytask.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(HYNavigationController *)getNavigation
{
    return _nav;
}

-(HYTabbarController *)getTabbar
{
    return _tabbar;
}

static void uncaughtExceptionHandler(NSException *exception) {
    
    NSLog(@"CRASH: %@", exception);
    
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    
    // Internal error reporting
    
}



@end
