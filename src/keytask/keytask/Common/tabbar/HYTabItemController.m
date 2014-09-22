//
//  HYTabItemController.m
//  keytask
//
//  Created by 许 玮 on 14-9-17.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYTabItemController.h"
#import "HYTabItemModel.h"
#import "HYTabItemView.h"

@interface HYTabItemController()
@property (nonatomic, strong) HYTabItemModel *_model;
@property (nonatomic, strong) HYTabItemView *_view;

@end

@implementation HYTabItemController
@synthesize _view;
@synthesize _model;


-(void)initModelAndFrame:(CGRect)size
{
    _view = [[HYTabItemView alloc] initWithFrame:size];
    _model = [[HYTabItemModel alloc] init];
}

-(void)setUnselectBackgroudImage:(UIImage *) image
{
    [_model setUnselectBackgroudImage:image];
}

-(void)setSelectBackgroundImage:(UIImage *) image
{
    [_model setSelectBackgroundImage:image];
}

-(void)setBackgroundImage
{
    assert([_model getSelectBackgroundImage] != nil && [_model getUnselectBackgroudImage] != nil);
    if([_model isSelect])
    {
        _view.layer.contents = (id)_model.getSelectBackgroundImage.CGImage;
    }else
    {
        _view.layer.contents = (id)_model.getUnselectBackgroudImage.CGImage;
    }
}

-(void)setSelect:(BOOL)select
{
    [_model setSelect:select];
}

-(void)setBadgeNumber:(int)number
{
    [_model setBadgeNumber:number];
}

@end
