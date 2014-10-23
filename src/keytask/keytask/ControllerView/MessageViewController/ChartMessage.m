//
//  ChartMessage.m
//  keytask
//
//  Created by 许 玮 on 14-10-15.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "ChartMessage.h"

@implementation ChartMessage
-(void)setDict:(NSDictionary *)dict
{
    _dict=dict;
    
    self.icon=dict[@"icon"];
    self.time=dict[@"time"];
    self.content=dict[@"content"];
    self.messageType=[dict[@"type"] intValue];
}
@end
