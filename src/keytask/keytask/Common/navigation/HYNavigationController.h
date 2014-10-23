//
//  HYNavigationController.h
//  keytask
//
//  Created by 许 玮 on 14-9-16.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYNavigationModel.h"
#import "HYBaseViewController.h"

@class HYNavigationModel;
@class HYBaseViewController;
@interface HYNavigationController : NSObject

-(void)hideRightButton;
-(void)showRightButton;
-(void)hideLeftButton;
-(void)hideLeftTittle;
-(void)showLeftButton;
-(void)showLeftTittle;
-(HYNavigationController *)initWithModel:(HYNavigationModel *)model;
-(void)setBackgroudImageByModel;
-(void)pushController:(HYBaseViewController *)controller;
-(void)show;
-(float)getNavigationHeight;
-(void)setLeftTittleColor:(UIColor *)color;
-(void)setLeftButtonTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
-(void)popController:(HYBaseViewController *)controller;
-(void)removeRightTarget;
-(HYBaseViewController *)getLastModel;
-(UIButton *)getRightButton;
-(void)setRightButtonTittle:(NSString *)tittle;
-(HYBaseViewController *)getFirstController;
-(HYNavigationModel *)getModel;
-(void)removeAllModels;

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
-(void)setCenterTittleColor:(UIColor *)color;

-(void)setRightButtonTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
-(void)initLeftButton;
-(void)initRightButton;

@end
