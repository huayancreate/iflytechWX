//
//  HYHelper.h
//  keytask
//
//  Created by 许 玮 on 14-9-28.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYNavigationController.h"
#import "HYUserLoginModel.h"
#import "DrawPatternLockViewController.h"
#import "HYAppDelegate.h"

@class HYNavigationController;
@class HYTabbarController;
@interface HYHelper : NSObject
+(HYNavigationController *)getNavigationController;
+(HYTabbarController *)getTabbarController;
+(UIWindow *)getWindow;
+(HYUserLoginModel *)getUser;
+(void)setUser:(HYUserLoginModel *)user;
+(DrawPatternLockViewController *)getLockView;
+(void)setLockView:(DrawPatternLockViewController *)view;
+(HYAppDelegate *)getApp;
+(NSString *)getDownloadURL;
+(void)setDownloadURL:(NSString *)downloadURL;

+(NSString *)getRemoteTaskID;


@end
