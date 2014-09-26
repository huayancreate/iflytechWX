//
//  HYMainViewController.m
//  keytask
//
//  Created by 许 玮 on 14-9-22.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYMainViewController.h"
#import "HYImageFactory.h"
#import "HYConstants.h"
#import "HYTabbarController.h"
#import "HYTabItemController.h"

@interface HYMainViewController ()

@end

@implementation HYMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化导航条
//    [self initNavigationBar];
    
    //初始化选项卡
    [self initTabBar];
    
    //初始化主窗体
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(void)initTabBar
{
//    HYTabItemModel *model1 = [[HYTabItemModel alloc] init];
//    
//    HYTabItemController *tabItem1 = [[HYTabItemController alloc] initWithName:@"1"];
    
    
    
    
    
    
    NSArray *items = [[NSArray alloc] initWithObjects:@"11",@"22", nil];
    HYTabbarController *tabbarController = [[HYTabbarController alloc] initWithTabbarItem:items];
    [tabbarController setBackgroudImage:[HYImageFactory GetImageByName:@"tabbarbg" AndType:PNG]];
    
    [self.view addSubview:[tabbarController getView]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
