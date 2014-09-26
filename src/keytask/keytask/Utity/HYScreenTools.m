//
//  HYScreenTools.m
//  keytask
//
//  Created by 许 玮 on 14-9-24.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYScreenTools.h"
#import "HYConstants.h"

@implementation HYScreenTools


+(float)getScreenHeight
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size.height;
}

+(float)getScreenWidth
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size.width;
}

+(float)getStatusHeight
{
    return StatusHeight;
}

@end
