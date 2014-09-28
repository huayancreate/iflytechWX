//
//  HYBaseViewController.h
//  keytask
//
//  Created by 许 玮 on 14-9-22.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYNavigationController.h"

@class HYNavigationController;
@interface HYBaseViewController : UIViewController

-(HYNavigationController *) getNavigationController;
-(void) setNavigationController;

@end
