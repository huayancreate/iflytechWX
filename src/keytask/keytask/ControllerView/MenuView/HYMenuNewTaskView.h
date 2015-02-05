//
//  HYMenuView.h
//  keytask
//
//  Created by 许 玮 on 14-10-14.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYTaskModel.h"
#import "HYUserLoginModel.h"
#import "HYMessageViewController.h"

@interface HYMenuNewTaskView : UIView<UIAlertViewDelegate>

-(void)initWithIcons:(NSArray *)icons showNames:(NSArray *)showNames bgImgName:(NSString *)bgImgName AndProxyArray:(NSArray *)proxys;

-(BOOL)isShow;
-(void)setShow:(BOOL)isS;

@end
