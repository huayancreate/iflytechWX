//
//  HYTabItem.h
//  keytask
//
//  Created by 许 玮 on 14-9-17.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYTabItemModel : NSObject

-(void)setIndex:(int)index;

-(void)setItemWidth:(float)itemWidth;

-(int)getIndex;

-(float)getItemWidth;

-(int)getBadgeNumber;

-(void)setUnselectBackgroudImage:(UIImage *) image;

-(void)setSelectBackgroundImage:(UIImage *) image;

-(UIImage *)getUnselectBackgroudImage;

-(UIImage *)getSelectBackgroundImage;

-(void)setName:(NSString *) name;

-(NSString *)getName;

-(void)setBadgeNumber:(int) number;

-(BOOL)isSelect;

-(void)setSelect:(BOOL) select;
@end
