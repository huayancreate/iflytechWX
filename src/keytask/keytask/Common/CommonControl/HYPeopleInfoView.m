//
//  HYPeopleInfoView.m
//  keytask
//
//  Created by 许 玮 on 14-10-15.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYPeopleInfoView.h"
#import "HYControlFactory.h"
#import "HYConstants.h"
#import "HYImageFactory.h"
#import "SDImageView+SDWebCache.h"

@interface HYPeopleInfoView()
{
    UILabel *nameLabel;
    UIImageView *delView;
    UIImageView *iconView;
    NSString *headImgUrlStr;
}
@end

@implementation HYPeopleInfoView
@synthesize name;
@synthesize icon;
@synthesize accountName;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(HYPeopleInfoView *)getViewWithWidth:(float)iconWidth iconHeight:(float)iconHeight nameWidth:(float)nameWidth nameHeight:(float)nameHeight
{
    iconView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(0, 0, iconWidth, iconHeight) backgroundImgName:nil backgroundColor:[UIColor clearColor] isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    if(headImgUrlStr != nil)
    {
        NSURL *headUrl = [[NSURL alloc] initWithString:headImgUrlStr];
        [iconView setImageWithURL:headUrl refreshCache:YES placeholderImage:icon];
    }else
    {
        [iconView setImage:icon];
    }
    nameLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(0, iconHeight, nameWidth, nameHeight) textfont:[UIFont fontWithName:FONT size:10] text:name textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentCenter];
    [self addSubview:iconView];
    [self addSubview:nameLabel];
    return self;
}

-(void)setHeadImgUrlStr:(NSString *)imgUrl
{
    if(imgUrl == nil)
    {
        return;
    }
    headImgUrlStr = imgUrl;
    NSURL *headUrl = [[NSURL alloc] initWithString:headImgUrlStr];
    [iconView setImageWithURL:headUrl refreshCache:YES placeholderImage:icon];
}

-(void)removeDelView
{
    if(delView != nil)
    {
        [delView removeFromSuperview];
    }
}

-(void)addDelView
{
    if(delView == nil)
    {
        delView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(30, -3, 12, 12) backgroundImgName:nil backgroundColor:[UIColor clearColor] isCornerRadius:NO closeKeyboard:NO isFrame:NO];
        [delView setImage:[HYImageFactory GetImageByName:@"tabbarred_02" AndType:PNG]];
    }
    [delView removeFromSuperview];
    [self addSubview:delView];
}

-(void)setViewName:(NSString *)viewName
{
    [nameLabel setText:viewName];
}

-(HYPeopleInfoView *)getView
{
    return self;
}


@end
