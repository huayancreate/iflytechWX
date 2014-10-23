//
//  HYTaskListTableViewCell.h
//  keytask
//
//  Created by 许 玮 on 14-10-8.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYTaskModel.h"

@interface HYTaskListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *statusImgView;
@property (nonatomic, strong) UILabel *taskNameView;
@property (nonatomic, strong) UILabel *lastInfoView;
@property (nonatomic, strong) UILabel *lastDateView;
@property HYTaskModel *model;

-(void)initControl;

@end
