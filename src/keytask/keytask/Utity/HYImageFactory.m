//
//  HYGetImageFactory.m
//  keytask
//
//  Created by 许 玮 on 14-9-24.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYImageFactory.h"

@implementation HYImageFactory

+(UIImage *)GetImageByName:(NSString *)name AndType:(NSString *)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    return  [UIImage imageWithContentsOfFile:path];
}


@end
