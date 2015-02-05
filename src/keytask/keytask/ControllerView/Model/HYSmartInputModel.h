//
//  HYSmartInputModel.h
//  keytask
//
//  Created by 许 玮 on 14-10-22.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYSmartInputModel : NSObject

@property NSString *accountName;
@property NSString *name;
@property NSString *deptName;
@property (nonatomic ,strong) UIImageView *imgView;;

-(NSString *)getString;

-(UIImageView *)getSelectImg:(int)tag AndTarget:(id)target;

@property NSMutableArray *selectList;

@end
