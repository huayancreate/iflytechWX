//
//  HYControlFactory.m
//  keytask
//
//  Created by 许 玮 on 14-9-29.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYControlFactory.h"
#import "HYImageFactory.h"
#import "HYConstants.h"

@implementation HYControlFactory


+(UIScrollView *)GetScrollViewWithCGRect:(CGRect)size backgroundColor:(UIColor *)color backImgName:(NSString *)name delegate:(id)delegate
{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:size];
    scrollView.delegate = delegate;
    if(name != nil)
    {
        [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[HYImageFactory GetImageByName:name AndType:PNG]]];
    }
    if(color != nil)
    {
        [scrollView setBackgroundColor:color];
    }
    return scrollView;
}

+(UITextView *)GetTextViewWithCGRect:(CGRect)size isCornerRaidus:(BOOL)isRadius font:(UIFont *)font textColor:(UIColor *)color
{
    UITextView *textView = [[UITextView alloc] initWithFrame:size];
    if(isRadius)
    {
        [[textView layer] setMasksToBounds:YES];
        [[textView layer] setCornerRadius:5.0];
        [[textView layer] setBorderWidth:1];
        [[textView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    }
    if(font != nil)
    {
        [textView setFont:font];
    }
    if(color != nil)
    {
        [textView setTextColor:color];
    }
        
    
    return textView;
}

+(UIImageView *)GetImgViewWithCGRect:(CGRect)size backgroundImgName:(NSString *)imgName backgroundColor:(UIColor *)color isCornerRadius:(BOOL)isRadius closeKeyboard:(BOOL)isClose isFrame:(BOOL)isFrame
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:size];
    if(imgName != nil)
    {
        [imgView setImage:[HYImageFactory GetImageByName:imgName AndType:PNG]];
    }
    if(color != nil)
    {
        [imgView setBackgroundColor:color];
    }
    imgView.userInteractionEnabled = YES;
    if(isClose)
    {
        
    }
    if(isFrame)
    {
        [[imgView layer] setMasksToBounds:YES];
        [[imgView layer] setCornerRadius:0.0];
        [[imgView layer] setBorderWidth:1];
        [[imgView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    }
    if(isRadius)
    {
        [[imgView layer] setMasksToBounds:YES];
        [[imgView layer] setCornerRadius:5.0];
        [[imgView layer] setBorderWidth:1];
        [[imgView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    }
    return imgView;
}

+(UILabel *)GetLableWithCGRect:(CGRect)size textfont:(UIFont *)font text:(NSString *)text textColor:(UIColor *)color TextAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[UILabel alloc] initWithFrame:size];
    if(text != nil)
    {
        [label setText:text];
    }
    if(font != nil)
    {
        [label setFont:font];
    }
    if(color != nil)
    {
        [label setTextColor:color];
    }
    [label setTextAlignment:textAlignment];
    return label;
}

+(UIButton *)GetButtonWithCGRect:(CGRect)size backgroundImg:(NSString *)imgName selectBackgroundImgName:(NSString *)selectImgName addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    UIButton *button = [[UIButton alloc] initWithFrame:size];
    
    [button setBackgroundImage:[HYImageFactory GetImageByName:imgName AndType:PNG] forState:UIControlStateNormal];
    
    [button setBackgroundImage:[HYImageFactory GetImageByName:selectImgName AndType:PNG] forState:UIControlStateSelected | UIControlStateHighlighted];
    
    [button addTarget:target action:action forControlEvents:controlEvents];
    
    return button;
}

+(UITextField *)GetTextFieldWithCGRect:(CGRect)size Placeholder:(NSString *)placeholder SecureTextEntry:(BOOL)secureTextEntry
{
    UITextField *textField = [[UITextField alloc] initWithFrame:size];
    [textField setPlaceholder:placeholder];
    [textField setSecureTextEntry:secureTextEntry];
    [textField setTextColor:[UIColor blackColor]];
    return textField;

}

@end
