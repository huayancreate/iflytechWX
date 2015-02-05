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

-(NSArray *)getStock
{
    return _stock;
}

-(void)removeAll
{
    [_stock removeAllObjects];
}

-(void)push:(HYBaseViewController *)controller
{
    if(_stock == nil)
    {
        _stock = [[NSMutableArray alloc] init];
    }
    
    [_stock addObject:controller];

}

-(void)removeLastController
{
    [_stock removeLastObject];
}

-(int)getCount
{
    return [_stock count];
}

-(HYBaseViewController *)getFirst
{
    return [_stock objectAtIndex:0];
}

-(HYBaseViewController *)getLastController
{
    return [_stock objectAtIndex:([_stock count] - 1)];
}

@end
