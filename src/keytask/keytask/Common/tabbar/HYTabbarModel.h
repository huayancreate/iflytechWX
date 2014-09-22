//
//  HYTabbarModel.h
//  keytask
//
//  Created by 许 玮 on 14-9-17.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYTabItemModel.h"

@interface HYTabbarModel : NSObject

-(int)getCount;

-(HYTabItemModel *)getItemByName:(NSString *) name;

-(void)addTabItem:(HYTabItemModel *) item;

-(void)removeItemByName:(NSString *) name;

@end
