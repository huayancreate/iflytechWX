//
//  HYUserLoingModel.h
//  keytask
//
//  Created by 许 玮 on 14-10-19.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYMyProxyModel.h"

@interface HYUserLoginModel : NSObject

@property NSString *accountName;
@property NSString *password;
@property NSString *token;
@property NSString *headImg;
@property NSString *username;
@property NSMutableArray *selectList;
@property NSMutableArray *selectPartList;
@property NSString *lastTimeHeadImg;
@property NSMutableArray *partList;
@property NSMutableArray *excList;
@property NSString *endTimeString;
@property NSString *executorString;
@property NSString *paticrpantString;
@property NSMutableArray *isAddPartViewList;
@property NSMutableArray *proxyList;
@property BOOL isNew;
@property HYMyProxyModel *helpModel;
@property BOOL isLogin;

@end
