//
//  HYFunctionsModel.m
//  keytask
//
//  Created by 许 玮 on 14-10-20.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYFunctionsModel.h"

@implementation HYFunctionsModel
@synthesize auditF;
@synthesize editF;
@synthesize deleteF;
@synthesize finishF;
@synthesize endF;
@synthesize discussF;
@synthesize receiverF;
@synthesize forwardingF;

-(NSMutableArray *)getIcons
{
    NSMutableArray *icons = [[NSMutableArray alloc] init];
    if([receiverF isEqual: @"True"])
    {
        [icons addObject:@"take_task"];
        [icons addObject:@"refuse"];
    }
    [icons addObject:@"task_information"];
    if([discussF isEqual:@"True"])
    {
        [icons addObject:@"jionpeople"];
    }
    if([finishF isEqual: @"True"])
    {
        [icons addObject:@"end_apply"];
    }
    if([endF isEqual: @"True"])
    {
        [icons addObject:@"end_task"];
        [icons addObject:@"stop_task"];
    }
    if([auditF isEqual: @"True"])
    {
        [icons addObject:@"audit_button"];
        [icons addObject:@"audit_no_button"];
    }
    if([forwardingF isEqual:@"True"])
    {
        [icons addObject:@"forwarding"];
    }
    return icons;
}

-(NSMutableArray *)getShowNames
{
    NSMutableArray *showNames = [[NSMutableArray alloc] init];
    if([receiverF isEqual: @"True"])
    {
        [showNames addObject:@"接受任务"];
        [showNames addObject:@"拒绝任务"];
    }
    [showNames addObject:@"任务详情"];
    if([discussF isEqual:@"True"])
    {
        [showNames addObject:@"添加参与人"];
    }
    if([finishF isEqual: @"True"])
    {
        [showNames addObject:@"结束申请"];
    }
    if([endF isEqual: @"True"])
    {
        [showNames addObject:@"结束任务"];
        [showNames addObject:@"终止任务"];
    }
    if([auditF isEqual: @"True"])
    {
        [showNames addObject:@"审核通过"];
        [showNames addObject:@"审核不通过"];
    }
    if([forwardingF isEqual:@"True"])
    {
        [showNames addObject:@"复制"];
    }
    return showNames;
}

-(BOOL)getEdit
{
    if([editF isEqual:@"True"])
    {
        return true;
    }else
    {
        return false;
    }
}

-(BOOL)getDisuss
{
    if([discussF isEqual:@"True"])
    {
        return true;
    }else
    {
        return false;
    }
}


@end
