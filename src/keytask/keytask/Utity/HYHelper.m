//
//  HYHelper.m
//  keytask
//
//  Created by 许 玮 on 14-9-28.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYHelper.h"
#import "HYNavigationController.h"
#import "HYAppDelegate.h"

@implementation HYHelper

+(NSString *)getRemoteTaskID
{
    HYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.remoteTaskID;
}

+(HYAppDelegate *)getApp
{
    return [[UIApplication sharedApplication] delegate];
}

+(void)setLockView:(DrawPatternLockViewController *)view
{
    HYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.lockVC = view;
}

+(HYNavigationController *)getNavigationController
{
    HYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate getNavigation];
}

+(DrawPatternLockViewController *)getLockView
{
    HYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate lockVC];
}

+(HYTabbarController *)getTabbarController
{
    HYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate getTabbar];
}

+(UIWindow *)getWindow
{
    HYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate window];
}

+(HYUserLoginModel *)getUser
{
    HYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate user];
}

+(void)setUser:(HYUserLoginModel *)user
{
    HYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.user = user;
}

+(NSString *)getDownloadURL
{
    HYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.downloadString;
}

+(void)setDownloadURL:(NSString *)downloadURL
{
    HYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.downloadString = downloadURL;
}


@end
