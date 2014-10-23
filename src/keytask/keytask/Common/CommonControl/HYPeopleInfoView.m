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

@interface HYPeopleInfoView()
{
    UILabel *nameLabel;
}
@end

@implementation HYPeopleInfoView
@synthesize name;
@synthesize icon;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(HYPeopleInfoView *)getView
{
    UIImageView *iconView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(0, 0, 35, 35) backgroundImgName:nil backgroundColor:[UIColor clearColor] isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [iconView setImage:icon];
    nameLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(0, 35, 35, 15) textfont:[UIFont fontWithName:FONT size:10] text:name textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentCenter];
    [self addSubview:iconView];
    [self addSubview:nameLabel];
    return self;
}

-(void)setViewName:(NSString *)viewName
{
    [nameLabel setText:viewName];
}


@end
