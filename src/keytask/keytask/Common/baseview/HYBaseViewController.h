//
//  HYBaseViewController.h
//  keytask
//
//  Created by 许 玮 on 14-9-22.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYNavigationController.h"
#import "SVProgressHUD.h"
#import "DataProcessing.h"
#import "HYTabbarController.h"
#import "HYUserLoginModel.h"

@class HYNavigationController;
@class HYTabbarController;
@interface HYBaseViewController : UIViewController
-(HYNavigationController *) getNavigationController;
-(HYTabbarController *) getTabbarController;
-(void) setNavigationController;
@property HYUserLoginModel *user;
-(void)logoutAction;
-(void)logoutRealAction;

@end
