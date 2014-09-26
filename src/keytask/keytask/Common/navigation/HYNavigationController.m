//
//  HYNavigationController.m
//  keytask
//
//  Created by 许 玮 on 14-9-16.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYNavigationController.h"
#import "HYNavigationModel.h"
#import "HYNavigationView.h"
#import "HYScreenTools.h"

@interface HYNavigationController ()
@property (nonatomic, strong) NSMutableArray *viewstack;
@property (nonatomic, strong) HYNavigationModel *_model;
@property (nonatomic, strong) HYNavigationView *_view;
@property (nonatomic, strong) UIButton *_leftButton;
@property (nonatomic, strong) UIButton *_rightButton;
@property (nonatomic, strong) UILabel *_leftTittleLabel;
@property (nonatomic, strong) UILabel *_centerTittleLabel;
@property float _originX;
@property float _statusHeight;

@end

@implementation HYNavigationController
@synthesize _model;
@synthesize _view;
@synthesize _leftButton;
@synthesize _leftTittleLabel;
@synthesize _centerTittleLabel;
@synthesize _rightButton;
@synthesize _originX;
@synthesize _statusHeight;

-(HYNavigationController *)initWithModel:(HYNavigationModel *)model
{
    if(_model == nil)
    {
        _model = [[HYNavigationModel alloc] init];
    }
    _model = model;
    _originX = [HYScreenTools getScreenWidth];
    _statusHeight = [HYScreenTools getStatusHeight];
    _view = [[HYNavigationView alloc] initWithFrame:CGRectMake(0, 0 + _statusHeight, _originX, 44)];
    if(_centerTittleLabel == nil)
    {
        _centerTittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 5 ,(_originX - 220) , 34)];
    }
    [_view addSubview:_centerTittleLabel];
    return self;
}

-(void)setBackgroudImageByModel
{
    assert(_view != nil);
    [_view setBackgroundColor:[UIColor colorWithPatternImage:_model._backgroudImg]];
}

-(HYNavigationView *)getView
{
    return _view;
}

-(void)initLeftButton
{
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton setFrame:CGRectMake(0, 0, 44, 44)];
    [_view addSubview:_leftButton];
}

-(void)initRightButton
{
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setFrame:CGRectMake((_originX - 44), 0, 44, 44)];
    [_view addSubview:_rightButton];
}

-(void)setLeftButtonImage:(UIImage *)img
{
    assert(_leftButton != nil);
    [_leftButton setAdjustsImageWhenHighlighted:NO];
    [_leftButton setBackgroundColor:[UIColor clearColor]];
    [_leftButton setImage:img forState:UIControlStateNormal];
}

-(void)setRightButtonImage:(UIImage *)img
{
    assert(_rightButton != nil);
    [_rightButton setAdjustsImageWhenHighlighted:NO];
    [_rightButton setBackgroundColor:[UIColor clearColor]];
    [_rightButton setImage:img forState:UIControlStateNormal];
}

-(void)setLeftTittle:(NSString *)tittle
{
    if(_leftTittleLabel == nil)
    {
        _leftTittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 5 + _statusHeight, 66, 34)];
    }
    _leftTittleLabel.textAlignment = NSTextAlignmentLeft;
}

-(void)setLeftTittleFont:(UIFont *)font
{
    assert(_leftTittleLabel != nil);
    _leftTittleLabel.font = font;
}

-(void)setCenterTittle:(NSString *)tittle
{
    [_centerTittleLabel setText:tittle];
    _centerTittleLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)setCenterTittleFont:(UIFont *)font
{
    assert(_centerTittleLabel != nil);
    _centerTittleLabel.font = font;
}

-(void)setRightButtonTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_rightButton addTarget:target action:action forControlEvents:controlEvents];
}

-(void)popToParentView
{

}

-(void)pushView
{

}


@end
