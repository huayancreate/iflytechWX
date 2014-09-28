//
//  HYNavigationModel.m
//  keytask
//
//  Created by 许 玮 on 14-9-22.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYNavigationModel.h"

@interface HYNavigationModel()
@property (nonatomic, strong) NSMutableArray *_stock;

@end

@implementation HYNavigationModel
@synthesize _centerTittle;
@synthesize _backgroudImg;
@synthesize _rightButtonImg;
@synthesize _leftButtonImg;
@synthesize _stock;

-(void)push:(HYBaseViewController *)controller
{
    if(_stock == nil)
    {
        _stock = [[NSMutableArray alloc] init];
    }
    
    [_stock addObject:controller];

}

@end
