//
//  HYSmartInputViewController.h
//  keytask
//
//  Created by 许 玮 on 14-10-22.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYBaseViewController.h"

@class HYSmartInputViewController;
@protocol HYSmartInputViewControllerDelegate;
@interface HYSmartInputViewController : HYBaseViewController<UITableViewDataSource,UITableViewDelegate>

@end

@protocol HYSmartInputViewControllerDelegate<NSObject>

-(void)returnSmartInputViewController:(HYSmartInputViewController *)controller;

@end