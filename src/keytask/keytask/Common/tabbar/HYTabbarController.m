//
//  HYTabbarController.m
//  keytask
//
//  Created by 许 玮 on 14-9-24.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYTabbarController.h"
#import "HYTabItemController.h"
#import "HYScreenTools.h"

@interface HYTabbarController ()
@property (nonatomic, strong) NSMutableArray *_items;
@property (nonatomic, strong) HYTabbarView *_view;
@property float _originY;
@property float _originX;

@end

@implementation HYTabbarController
@synthesize _items;
@synthesize _view;
@synthesize _originY;
@synthesize _originX;

-(HYTabbarView *)getView
{
    return _view;
}

-(HYTabbarController *)initWithTabbarItem:(NSMutableArray *)items
{
    _originY = [HYScreenTools getScreenHeight];
    _originX = [HYScreenTools getScreenWidth];
    _view = [[HYTabbarView alloc] initWithFrame:CGRectMake(0, _originY - 44, _originX , 44)];
    _items = items;
    return self;
}

-(void)setBackgroudImage:(UIImage *)img
{
    assert(_view != nil);
    [_view setBackgroundColor:[UIColor colorWithPatternImage:img]];
}



@end
