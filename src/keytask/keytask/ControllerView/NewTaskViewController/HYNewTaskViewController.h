//
//  HYNewTaskViewController.h
//  keytask
//
//  Created by 许 玮 on 14-10-9.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYBaseViewController.h"
#import "HYTaskModel.h"
#import "HYDatePickerViewController.h"
#import "HYSmartInputViewController.h"
#import "HYMyProxyModel.h"

@interface HYNewTaskViewController : HYBaseViewController<UIScrollViewDelegate,HYDatePickerViewControllerDelegate,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,HYSmartInputViewControllerDelegate>

@property HYTaskModel *model;
@property BOOL isForwarding;
@property BOOL isEdit;
@property HYMyProxyModel *helpModel;
@property BOOL isInformation;

@end
