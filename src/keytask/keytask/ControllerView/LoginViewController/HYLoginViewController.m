//
//  HYLoginViewController.m
//  keytask
//
//  Created by 许 玮 on 14-9-24.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYLoginViewController.h"
#import "HYNavigationController.h"
#import "HYNavigationModel.h"
#import "HYImageFactory.h"
#import "HYConstants.h"

@interface HYLoginViewController ()
@property (nonatomic, strong) HYNavigationController *_nav;
@property (nonatomic, strong) HYNavigationModel *_navModel;

@end

@implementation HYLoginViewController
@synthesize _nav;
@synthesize _navModel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initNavigationBar];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavigationBar
{
    _navModel = [[HYNavigationModel alloc] init];
    _navModel._backgroudImg = [HYImageFactory GetImageByName:@"topbg" AndType:PNG];
    
    _nav = [[HYNavigationController alloc] initWithModel:_navModel];
    
    [_nav setBackgroudImageByModel];
    
    _nav 
    
    //    [nav setCenterTittle:@"我是测试的"];
    [_nav initLeftButton];
    [_nav initRightButton];
    
    [self.view addSubview:[_nav getView]];
    
    [[_nav getView] setHidden:YES];
    
}

@end
