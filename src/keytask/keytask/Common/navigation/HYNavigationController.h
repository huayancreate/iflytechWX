//
//  HYNavigationController.h
//  keytask
//
//  Created by 许 玮 on 14-9-16.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYNavigationModel.h"

@interface HYNavigationController : NSObject

-(HYNavigationController *)initWithModel:(HYNavigationModel *)model;
-(void)setBackgroudImageByModel;


-(UIView *)getView;
-(void)popToParentView;
-(void)pushView;
-(void)setCenterTittle:(NSString *)tittle;
-(void)setBackgroudImage:(UIImage *)img;
-(void)setLeftButtonImage:(UIImage *)img;
-(void)setLeftTittle:(NSString *)tittle;
-(void)setRightButtonImage:(UIImage *)img;
-(void)setRightTittle:(NSString *)tittle;
-(void)setLeftTittleFont:(UIFont *)font;
-(void)setRightTittleFont:(UIFont *)font;
-(void)setCenterTittleFont:(UIFont *)font;
-(void)setRightButtonTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
-(void)initLeftButton;
-(void)initRightButton;

@end
