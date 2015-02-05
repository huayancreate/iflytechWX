//
//  ChartMessage.h
//  keytask
//
//  Created by 许 玮 on 14-10-15.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//
typedef enum {
    
    messageFrom,
    messageTo,
    messageSys
    
}ChartMessageType;
#import <Foundation/Foundation.h>
#import "HYFileModel.h"

@interface ChartMessage : NSObject
@property (nonatomic,assign) ChartMessageType messageType;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSDictionary *dict;
@property (nonatomic, copy) NSString *iconLabelText;
@property (nonatomic, strong) HYFileModel *fileModel;
@property (nonatomic, strong) NSString *iconAccountName;

@end
