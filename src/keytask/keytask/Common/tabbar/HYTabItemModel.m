//
//  HYTabItem.m
//  keytask
//
//  Created by 许 玮 on 14-9-17.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYTabItemModel.h"

@interface HYTabItemModel()
@property (nonatomic, strong) UIImage *_selectImg;
@property (nonatomic, strong) UIImage *_unselectImg;
@property float _itemWidth;
@property int _index;
@property BOOL _select;


@end

@implementation HYTabItemModel
@synthesize _selectImg;
@synthesize _unselectImg;
@synthesize _itemWidth;
@synthesize _index;
@synthesize _select;

-(void)setSelect:(BOOL)select
{
    _select = select;
}

-(BOOL)isSelect
{
    return _select;
}

-(void)setIndex:(int)index
{
    _index = index;
}

-(void)setItemWidth:(float)itemWidth
{
    _itemWidth = itemWidth;
}

-(int)getIndex
{
    return _index;
}

-(float)getItemWidth
{
    return _itemWidth;
}

-(void)setUnselectBackgroudImage:(UIImage *)image
{
    _unselectImg = image;
}

-(void)setSelectBackgroundImage:(UIImage *)image
{
    _selectImg = image;
}

-(UIImage *)getUnselectBackgroudImage
{
    return _unselectImg;
}

-(UIImage *)getSelectBackgroundImage
{
    return  _selectImg;
}


@end
