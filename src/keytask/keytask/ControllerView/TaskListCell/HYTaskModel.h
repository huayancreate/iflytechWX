//
//  HYTaskListCellModel.h
//  keytask
//
//  Created by 许 玮 on 14-10-16.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYFunctionsModel.h"

@interface HYTaskModel : NSObject

@property (nonatomic, strong) NSString *imgName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lastInfo;
@property (nonatomic, strong) NSString *lastDate;
@property int type;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *initiator;
@property (nonatomic, strong) NSString *initiatorName;
@property (nonatomic, strong) NSString *executor;
@property (nonatomic, strong) NSString *executorName;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSMutableArray *operateList;
@property (nonatomic, strong) HYFunctionsModel *functions;
@property (nonatomic, strong) NSMutableArray *recordList;

@property (nonatomic, strong) NSString *paticrpant;
@property (nonatomic, strong) NSString *paticrpantName;
@property (nonatomic, strong) NSString *documentMarker;
@property (nonatomic, strong) NSString *goal;
@property (nonatomic, strong) NSString *days;
@property (nonatomic, strong) NSString *product;
@property (nonatomic, strong) NSString *description;



-(NSString *)getImgName;
-(NSString *)getLastInfo;
-(NSString *)getLastTime;

@end
