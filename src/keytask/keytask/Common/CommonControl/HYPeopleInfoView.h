//
//  HYPeopleInfoView.h
//  keytask
//
//  Created by 许 玮 on 14-10-15.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYPeopleInfoView : UIView

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSString *name;

-(HYPeopleInfoView *)getView;
-(void)setViewName:(NSString *)viewName;

@end
