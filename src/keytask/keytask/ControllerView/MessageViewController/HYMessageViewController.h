//
//  HYMessageViewController.h
//  keytask
//
//  Created by 许 玮 on 14-10-14.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYBaseViewController.h"
#import "ChartCell.h"
#import "HYTaskModel.h"

@interface HYMessageViewController : HYBaseViewController<UITableViewDelegate,UITableViewDataSource,ChartCellDelegate,UITextFieldDelegate>

@property HYTaskModel *taskModel;
-(void)getLastRecord;
-(void)getSendLastRecord;
-(void)getFunctions;
@property (nonatomic, strong) NSTimer *connectionTimer;
@property BOOL isMySend;
@property BOOL isMySendSuccess;
@property BOOL isImgFlag;;

@end
