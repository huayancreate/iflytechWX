//
//  HYAutoHeightTextView.h
//  keytask
//
//  Created by 许 玮 on 15/1/28.
//  Copyright (c) 2015年 科大讯飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYAutoHeightTextView;

@protocol HYAutoHeightTextViewDelegate <NSObject>

@optional

- (void)textView:(HYAutoHeightTextView *)textView heightChanged:(NSInteger)height;

@end

@interface HYAutoHeightTextView : UITextView

@property (assign, nonatomic) id<UITextViewDelegate, HYAutoHeightTextViewDelegate> delegate;

@end
