//
//  HYMainViewController.h
//  keytask
//
//  Created by 许 玮 on 14-9-22.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYBaseViewController.h"
#import "HYConstants.h"


@interface HYMainViewController : HYBaseViewController<UITableViewDelegate,UITableViewDataSource>


-(void)setItemTag:(int) itemTag;
-(void)reloadData;

@end
