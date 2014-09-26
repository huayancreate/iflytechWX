//
//  HYTabItemController.h
//  keytask
//
//  Created by 许 玮 on 14-9-17.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYTabItemModel.h"

@interface HYTabItemController : NSObject

-(HYTabItemController *)initWithModel:(HYTabItemModel *) model;

-(void)setUnselectBackgroudImage:(UIImage *) image;

-(void)setSelectBackgroundImage:(UIImage *) image;

-(void)setName:(NSString *) name;

-(NSString *)getName;

-(void)setBadgeNumber:(int) number;

-(int)getBadgeNumber;

-(void)setBackgroundImage;

-(void)setSelect:(BOOL) select;

@end
