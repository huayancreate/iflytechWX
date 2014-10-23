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

@interface HYMenuView : UIView<UIAlertViewDelegate>

-(void)initWithIcons:(NSArray *)icons showNames:(NSArray *)showNames bgImgName:(NSString *)bgImgName model:(HYTaskModel *)model user:(HYUserLoginModel *)user;

@end
