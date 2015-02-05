//
//  HYNavigationModel.h
//  keytask
//
//  Created by 许 玮 on 14-9-22.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYBaseViewController.h"

@class HYBaseViewController;
@interface HYNavigationModel : NSObject

@property NSString *_centerTittle;
@property (nonatomic, strong) UIImage *_backgroudImg;
@property (nonatomic, strong) UIImage *_rightButtonImg;
@property (nonatomic, strong) UIImage *_leftButtonImg;
-(NSArray *)getStock;
-(void)push:(HYBaseViewController *) controller;
-(void)pop:(HYBaseViewController *) controller;
-(int)getCount;
-(HYBaseViewController *)getLastController;
-(void)removeLastController;
-(HYBaseViewController *)getFirst;
-(void)removeAll;

@end
