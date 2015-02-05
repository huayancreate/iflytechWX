//
//  HYFunctionsModel.h
//  keytask
//
//  Created by 许 玮 on 14-10-20.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYFunctionsModel : NSObject
@property (nonatomic, strong) NSString *auditF;
@property (nonatomic, strong) NSString *editF;
@property (nonatomic, strong) NSString *deleteF;
@property (nonatomic, strong) NSString *finishF;
@property (nonatomic, strong) NSString *endF;
@property (nonatomic, strong) NSString *discussF;
@property (nonatomic, strong) NSString *receiverF;
@property (nonatomic, strong) NSString *forwardingF;

-(NSArray *)getIcons;
-(NSArray *)getShowNames;
-(BOOL)getDisuss;
-(BOOL)getEdit;

@end
