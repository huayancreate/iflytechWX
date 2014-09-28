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
#import "HYScreenTools.h"

@interface HYLoginViewController ()
@property float _statusHeight;
@property float _originX;
@property float _originY;

@end

@implementation HYLoginViewController
@synthesize _statusHeight;
@synthesize _originX;
@synthesize _originY;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[[self getNavigationController] getView] setHidden:YES];
        
        [self initControl];
    }
    return self;
}

-(void)initControl
{
    _statusHeight = [HYScreenTools getStatusHeight];
    _originX = [HYScreenTools getScreenWidth];
    _originY = [HYScreenTools getScreenHeight];
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 + _statusHeight, _originX, _originY)];
    
    [bgImgView setImage:[HYImageFactory GetImageByName:@"login_bg" AndType:PNG]];
    
    [self.view addSubview:bgImgView];
    
    UIImageView *loginBoxImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 190 + _statusHeight, (_originX - 20), 93)];
    
    [loginBoxImgView setImage:[HYImageFactory GetImageByName:@"loginbox" AndType:PNG]];
    
    [bgImgView addSubview:loginBoxImgView];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(((_originX - 294)/2), 315 + _statusHeight, 294, 40)];
    
    
    [loginBtn setBackgroundImage:[HYImageFactory GetImageByName:@"loginbtn_hover" AndType:PNG] forState:UIControlStateNormal];
    
    [loginBtn setBackgroundImage:[HYImageFactory GetImageByName:@"loginbtn" AndType:PNG] forState:UIControlStateSelected | UIControlStateHighlighted];
    
    [self.view addSubview:loginBtn];
    
    
    //添加textView
//    UITextView *usernameTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)]
    
    
    
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



@end
