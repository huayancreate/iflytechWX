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

+(HYNavigationController *)getNavigationController
{
    HYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate getNavigation];
}

@end
