//
//  HYScrollView.m
//  keytask
//
//  Created by 许 玮 on 14-10-29.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYScrollView.h"

@implementation HYScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    if ([view isKindOfClass:[UIView class]])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    //NSLog(@"用户点击的视图 %@",view);
    return NO;
}

@end
