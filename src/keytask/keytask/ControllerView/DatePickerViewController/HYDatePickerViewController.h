//
//  HYDatePickerViewController.h
//  keytask
//
//  Created by 许 玮 on 14-10-22.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYBaseViewController.h"

@protocol HYDatePickerViewControllerDelegate;
@interface HYDatePickerViewController : UIViewController

-(void)initDatePicker;
@end

@protocol HYDatePickerViewControllerDelegate<NSObject>
- (void)datePickerController:(HYDatePickerViewController *)controller;
@end
