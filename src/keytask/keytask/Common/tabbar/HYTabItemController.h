//
//  HYTabItemController.h
//  keytask
//
//  Created by 许 玮 on 14-9-17.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYTabItemModel.h"
#import "HYTabItemView.h"

@interface HYTabItemController : NSObject

-(void)bindAction:(SEL)action Target:(id)target;

-(UIImageView *)getShowView;

-(HYTabItemView *)getView;

-(void)setIndex:(int)index;

-(void)setItemWidth:(float)itemWidth;

-(void)setView:(HYTabItemView *)view;

-(HYTabItemController *)initWithModel:(HYTabItemModel *) model;

-(void)setUnselectBackgroudImage:(UIImage *) image;

-(void)setSelectBackgroundImage:(UIImage *) image;

-(void)setName:(NSString *) name;

-(void)setType:(NSString *)type;

-(NSString *)getType;

-(NSString *)getName;

-(void)setBadgeNumber:(int) number;

-(int)getBadgeNumber;

-(void)setBackgroundImage;

-(void)setSelect:(BOOL) select;

-(UIImage *)getSelectBackgroundImage;

-(UIImage *)getUnselectBackgroundImage;

@end
