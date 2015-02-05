//
//  HYAppDelegate.h
//  keytask
//
//  Created by 许 玮 on 14-9-16.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYNavigationController.h"
#import "HYTabbarController.h"
#import "HYUserLoginModel.h"
#import "DrawPatternLockViewController.h"

@interface HYAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HYUserLoginModel *user;
@property (nonatomic, strong) DrawPatternLockViewController *lockVC;
@property (nonatomic, strong) NSString *app_id;
@property (nonatomic, strong) NSString *channel_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *downloadString;
@property (nonatomic, strong) NSString *remoteTaskID;

-(HYNavigationController *)getNavigation;
-(HYTabbarController *)getTabbar;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
