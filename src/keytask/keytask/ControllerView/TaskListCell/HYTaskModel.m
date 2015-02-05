//
//  HYTaskListCellModel.m
//  keytask
//
//  Created by 许 玮 on 14-10-16.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYTaskModel.h"
#import "HYTaskOperateModel.h"

@implementation HYTaskModel
@synthesize name;
@synthesize lastDate;
@synthesize lastInfo;
@synthesize imgName;
@synthesize type;
@synthesize initiator;
@synthesize initiatorName;
@synthesize executor;
@synthesize executorName;
@synthesize ID;
@synthesize endTime;
@synthesize status;
//@synthesize operateList;
@synthesize functions;
@synthesize recordList;
@synthesize paticrpant;
@synthesize paticrpantName;
@synthesize documentMarker;
@synthesize goal;
@synthesize days;
@synthesize product;
@synthesize description;
@synthesize messageCount;
@synthesize lastOperateInfo;


-(NSString *)getImgName
{
    if([status  isEqual: @"100"])
    {
        imgName = @"temp";
    }
    if([status  isEqual: @"101"])
    {
        imgName = @"accept";
    }
    if([status  isEqual: @"102"])
    {
        imgName = @"reject";
    }
    if([status  isEqual: @"103"])
    {
        imgName = @"progress";
    }
    if([status  isEqual: @"104"])
    {
        //TODO 缺失
        imgName = @"104status";
    }
    if([status  isEqual: @"105"])
    {
        imgName = @"end";
    }
    if([status  isEqual: @"106"])
    {
        imgName = @"stop";
    }
    if([status  isEqual: @"1001"])
    {
        imgName = @"extend";
    }
    return imgName;
}

-(NSString *)getLastInfo
{
    if(lastOperateInfo == nil)
    {
        return @"";
    }
    return lastOperateInfo;
}

-(NSString *)getLastTime
{
    return endTime;
}


@end
