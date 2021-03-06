//
//  HYTabbarController.h
//  keytask
//
//  Created by 许 玮 on 14-9-24.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYTabbarView.h"
#import "HYTabItemController.h"

@interface HYTabbarController : NSObject

-(HYTabbarController *)initWithTabbarItem:(NSArray *) items;

-(void)setBackgroudImage:(UIImage *)img;

-(HYTabItemController *)getLastSelectItem;

-(HYTabItemController *)getSelectItem;

-(HYTabbarView *)getView;

-(NSArray *)getItems;

-(float)getTabbarHeight;

-(void)initItems;

-(void)initItemsBar;

@end
