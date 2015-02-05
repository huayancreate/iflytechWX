//
//  HYAutoHeightTextView.m
//  keytask
//
//  Created by 许 玮 on 15/1/28.
//  Copyright (c) 2015年 科大讯飞. All rights reserved.
//

#import "HYAutoHeightTextView.h"

@implementation HYAutoHeightTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setContentSize:(CGSize)contentSize
{
    CGSize oriSize = self.contentSize;
    [super setContentSize:contentSize];
    if(oriSize.height != self.contentSize.height)
    {
        CGRect newFrame = self.frame;
        newFrame.size.height = self.contentSize.height;
        self.frame = newFrame;
            if([self.delegate respondsToSelector:@selector(textView:heightChanged:)])
            {
                [self.delegate textView:self heightChanged:self.contentSize.height - oriSize.height];
            }
    }
}

@end
