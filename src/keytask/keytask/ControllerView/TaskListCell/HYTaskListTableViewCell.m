//
//  HYTaskListTableViewCell.m
//  keytask
//
//  Created by 许 玮 on 14-10-8.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYTaskListTableViewCell.h"
#import "HYConstants.h"
#import "HYScreenTools.h"
#import "HYImageFactory.h"

@implementation HYTaskListTableViewCell
@synthesize statusImgView;
@synthesize taskNameView;
@synthesize lastDateView;
@synthesize lastInfoView;
@synthesize model;

- (void)awakeFromNib {
    // Initialization code
//    [self initControl];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initControl
{
    statusImgView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 42, 42)];
    [self addSubview:statusImgView];
    [statusImgView setImage:[HYImageFactory GetImageByName:[model getImgName] AndType:PNG]];
    taskNameView = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 190, 22)];
    
    //test xuwei
    [taskNameView setText:model.name];
    
    
    [taskNameView setFont:[UIFont fontWithName:FONT_BOLD size:14]];
    [taskNameView setTextColor:[UIColor blackColor]];
    [self addSubview:taskNameView];
    lastInfoView = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 250, 22)];
    
    //test xuwei
    [lastInfoView setText:[model getLastInfo]];
    
    [lastInfoView setFont:[UIFont fontWithName:FONT size:12]];
    [lastInfoView setTextColor:[UIColor grayColor]];
    [self addSubview:lastInfoView];
    lastDateView = [[UILabel alloc] initWithFrame:CGRectMake([HYScreenTools getScreenWidth] - 70, 6, 65, 22)];
    
    //test xuwei
    [lastDateView setText:[model getLastTime]];
    
    [lastDateView setFont:[UIFont fontWithName:FONT size:8]];
    [lastDateView setTextColor:[UIColor grayColor]];
    [self addSubview:lastDateView];
    
}

@end
