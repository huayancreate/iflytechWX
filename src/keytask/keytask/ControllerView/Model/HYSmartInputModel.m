//
//  HYSmartInputModel.m
//  keytask
//
//  Created by 许 玮 on 14-10-22.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYSmartInputModel.h"
#import "HYControlFactory.h"
#import "HYConstants.h"

@interface HYSmartInputModel()
{
//    UIImageView *imgView;
}

@end

@implementation HYSmartInputModel
@synthesize name;
@synthesize deptName;
@synthesize accountName;
@synthesize selectList;
@synthesize imgView;

-(NSString *)getString
{
    NSString *returnString = @"";
    returnString = [returnString stringByAppendingString:name];
    returnString = [returnString stringByAppendingString:@"<"];
    returnString = [returnString stringByAppendingString:accountName];
    returnString = [returnString stringByAppendingString:@">"];
    returnString = [returnString stringByAppendingString:deptName];
    return returnString;
}

-(UIImageView *)getSelectImg:(int)tag AndTarget:(id)target
{
    imgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(0, 0, 0, 0) backgroundImgName:@"smartbg" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    imgView.tag = tag;
    NSString *showString = @"";
    showString = [showString stringByAppendingString:name];
    showString = [showString stringByAppendingString:@"<"];
    showString = [showString stringByAppendingString:accountName];
    showString = [showString stringByAppendingString:@">"];
    UILabel *label = [HYControlFactory GetLableWithCGRect:CGRectMake(3, 0, 0, 0) textfont:[UIFont fontWithName:FONT size:12] text:showString textColor:[UIColor whiteColor] TextAlignment:NSTextAlignmentCenter];
    label.userInteractionEnabled = YES;
    CGSize size = [showString sizeWithFont:[UIFont fontWithName:FONT size:12] constrainedToSize:CGSizeMake(label.frame.size.height, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    [label setFrame:CGRectMake(0, 0, size.width, 26)];
    [imgView setFrame:CGRectMake(0, 0, size.width + 28, 26)];
    UIImageView *delView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(size.width + 3, 0, 26, 26) backgroundImgName:@"smartdel" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    delView.tag = tag;
//    NSArray *delViewArr = [delView gestureRecognizers];
    [imgView addSubview:label];
    [imgView addSubview:delView];
    return imgView;
}

@end
