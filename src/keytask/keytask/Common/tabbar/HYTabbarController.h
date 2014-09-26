//
//  HYTabbarController.h
//  keytask
//
//  Created by 许 玮 on 14-9-24.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYTabbarView.h"

@interface HYTabbarController : NSObject

-(HYTabbarController *)initWithTabbarItem:(NSArray *) items;

-(void)setBackgroudImage:(UIImage *)img;

-(HYTabbarView *)getView;

@end
