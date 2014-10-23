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
#import "HYImageFactory.h"
#import "HYConstants.h"
#import "HYTabItemView.h"
#import "HYHelper.h"
#import "HYMoreViewController.h"
#import "HYHelper.h"
#import "HYMainViewController.h"


@interface HYTabbarController ()
@property (nonatomic, strong) NSMutableArray *_items;
@property (nonatomic, strong) HYTabbarView *_view;
@property float _originY;
@property float _originX;
@property (nonatomic, strong) HYTabItemController *_selectItem;
@property (nonatomic, strong) HYTabItemController *_lastSelectItem;

@end

@implementation HYTabbarController
@synthesize _items;
@synthesize _view;
@synthesize _originY;
@synthesize _originX;
@synthesize _selectItem;
@synthesize _lastSelectItem;

-(HYTabbarView *)getView
{
    return _view;
}

-(HYTabItemController *)getLastSelectItem
{
    return _lastSelectItem;
}

-(HYTabItemController *)getSelectItem
{
    return _selectItem;
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

-(float)getTabbarHeight
{
    return _view.frame.size.height;
}

-(void)initItems
{
    assert(_items != nil);
    float itemsWidth = ([HYScreenTools getScreenWidth] / [_items count]);
    for (int i = 0; i < [_items count]; i++) {
        
        HYTabItemController *item = [_items objectAtIndex:i];
        HYTabItemView *imgBgView = [[HYTabItemView alloc] initWithFrame:CGRectMake(i * itemsWidth , 0, itemsWidth, [self getTabbarHeight])];
        [item setView:imgBgView];
        [item setItemWidth:itemsWidth];
        [item setIndex:i];
        [item setBackgroundImage];
        if(i == 0)
        {
            [item setSelect:true];
            _selectItem = item;
        }else
        {
            [item setSelect:false];
        }
        //绑定事件
        [item bindAction:@selector(onClickImg:) Target:self];
        [_view addSubview:[item getView]];
    }
}

-(void)onClickImg:(UIGestureRecognizer *)gestureRecognizer
{
    UIView *viewClicked = [gestureRecognizer view];
    if([_selectItem getShowView].tag != viewClicked.tag)
    {
        [_lastSelectItem setSelect:NO];
        _lastSelectItem = _selectItem;
        [_selectItem setSelect:NO];
        HYTabItemController *clickItem = [_items objectAtIndex:viewClicked.tag];
        _selectItem = clickItem;
        [clickItem setSelect:YES];
        [[HYHelper getNavigationController] setCenterTittle:[clickItem getName]];
        HYNavigationController *nav = [HYHelper getNavigationController];
        HYMainViewController *viewController = [nav getLastModel];
        if(viewClicked.tag == 0)
        {
            [viewController setItemTag:TASK_START];
            [viewController reloadData];
            return;
        }
        if(viewClicked.tag == 1)
        {
            [viewController setItemTag:TASK_EXC];
            [viewController reloadData];
            return;
        }
        if(viewClicked.tag == 2)
        {
            [viewController setItemTag:TASK_JOIN];
            [viewController reloadData];
            return;
        }
        if(viewClicked.tag == 3)
        {
            HYMoreViewController *moreView = [[HYMoreViewController alloc] init];
            [moreView setTitle:@""];
            [[HYHelper getNavigationController] pushController:moreView];
        }else
        {
            [viewController reloadData];
        }
    }
}


@end
