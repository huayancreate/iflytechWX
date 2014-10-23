//
//  HYHelper.h
//  keytask
//
//  Created by 许 玮 on 14-9-28.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYNavigationController.h"

@class HYNavigationController;
@class HYTabbarController;
@interface HYHelper : NSObject
+(HYNavigationController *)getNavigationController;
+(HYTabbarController *)getTabbarController;
+(UIWindow *)getWindow;


@end
