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
#import "HYHelper.h"
#import "HYImageFactory.h"
#import "HYConstants.h"
#import "HYScreenTools.h"

@interface HYTabItemController()
@property (nonatomic, strong) HYTabItemModel *_model;
@property (nonatomic, strong) HYTabItemView *_view;
@property (nonatomic, strong) NSString *_name;
@property (nonatomic, strong) UIImageView *_showView;
@property (nonatomic, strong) UIImageView *badgeView;
@property (nonatomic, strong) NSString *_type;

@end

@implementation HYTabItemController
@synthesize _view;
@synthesize _model;
@synthesize _name;
@synthesize _showView;
@synthesize badgeView;
@synthesize _type;


-(void)setType:(NSString *)type
{
    _type = type;
}

-(NSString *)getType
{
    return _type;
}

-(void)setName:(NSString *)name
{
    _name = name;
}

-(NSString *)getName
{
    return _name;
}

-(void)bindAction:(SEL)action Target:(id)target
{
    [_showView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    _showView.tag = [_model getIndex];
    [_showView addGestureRecognizer:gesture];
}

-(HYTabItemView *)getView
{
    return _view;
}

-(void)setView:(HYTabItemView *)view
{
    _view = view;
}

-(void)setIndex:(int)index
{
    [_model setIndex:index];
}

-(void)setItemWidth:(float)itemWidth
{
    [_model setItemWidth:itemWidth];
}

-(HYTabItemController *)initWithModel:(HYTabItemModel *) model
{
    if(_model == nil)
    {
        _model = [[HYTabItemModel alloc] init];
    }
    _model = model;
    return self;
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
    if(_showView == nil)
    {
        _showView = [[UIImageView alloc] initWithFrame:CGRectMake(([_model getItemWidth] - 40)/2, 2, 40, 40)];
    }
    [_view addSubview:_showView];
}

-(UIImageView *)getShowView
{
    assert(_showView != nil);
    return _showView;
}



-(void)setSelect:(BOOL)select
{
    [_model setSelect:select];
    if([_model isSelect])
    {
        [_showView setImage:[self getSelectBackgroundImage]];
    }else
    {
        [_showView setImage:[self getUnselectBackgroundImage]];
    }
}

-(void)setBadgeNumber:(int)number
{
    if(number == 0)
    {
        if(badgeView != nil)
        {
//            [_model setBadgeNumber:number];
            [badgeView removeFromSuperview];
            badgeView = nil;
            return;
        }else
        {
            return;
        }
    }
    if(badgeView != nil)
    {
        [badgeView removeFromSuperview];
    }
    badgeView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 5, 12, 12)];
    //        [messageCount setBackgroundColor:[UIColor redColor]];
    //         messageCount.layer.cornerRadius = 10;
    [badgeView setImage:[HYImageFactory GetImageByName:@"tabbarred" AndType:PNG]];
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 8, 8)];
    msgLabel.text = [NSString stringWithFormat:@"%d",number];
    msgLabel.textColor = [UIColor whiteColor];
    msgLabel.textAlignment = NSTextAlignmentCenter;
    [msgLabel setFont:[UIFont fontWithName:FONT size:7]];
    [badgeView addSubview:msgLabel];
//    [self addSubview:badgeView];
    [_showView addSubview:badgeView];
    [_model setBadgeNumber:number];
}

-(UIImage *)getUnselectBackgroundImage
{
    return [_model getUnselectBackgroudImage];
}

-(UIImage *)getSelectBackgroundImage
{
    return  [_model getSelectBackgroundImage];
}

@end
