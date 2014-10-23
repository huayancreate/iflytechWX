//
//  HYControlFactory.h
//  keytask
//
//  Created by 许 玮 on 14-9-29.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYControlFactory : NSObject

+(UIImageView *)GetImgViewWithCGRect:(CGRect )size backgroundImgName:(NSString *)imgName backgroundColor:(UIColor *)color isCornerRadius:(BOOL)isRadius closeKeyboard:(BOOL)isClose isFrame:(BOOL)isFrame;

+(UIScrollView *)GetScrollViewWithCGRect:(CGRect)size backgroundColor:(UIColor *)color backImgName:(NSString *)name delegate:(id)delegate;

+(UITextView *)GetTextViewWithCGRect:(CGRect)size isCornerRaidus:(BOOL)isRadius font:(UIFont *)font textColor:(UIColor *)color;

+(UILabel *)GetLableWithCGRect:(CGRect)size textfont:(UIFont *)font text:(NSString *)text textColor:(UIColor *)color TextAlignment:(NSTextAlignment)textAlignment;

+(UIButton *)GetButtonWithCGRect:(CGRect )size backgroundImg:(NSString *)imgName selectBackgroundImgName:(NSString *)selectImgName addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

+(UITextField *)GetTextFieldWithCGRect:(CGRect )size Placeholder:(NSString *)placeholder SecureTextEntry:(BOOL)secureTextEntry;

@end
