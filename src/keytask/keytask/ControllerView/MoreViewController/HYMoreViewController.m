//
//  HYMoreViewController.m
//  keytask
//
//  Created by 许 玮 on 14-10-10.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYMoreViewController.h"
#import "HYConstants.h"
#import "HYImageFactory.h"
#import "HYControlFactory.h"
#import "HYScreenTools.h"

@interface HYMoreViewController ()

@end

@implementation HYMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self bindAction];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initControl];
}

-(void)initControl
{
    UIImageView *bgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(0, [[self getNavigationController] getNavigationHeight] + [HYScreenTools getStatusHeight], [HYScreenTools getScreenWidth], [HYScreenTools getScreenHeight] - [[self getNavigationController] getNavigationHeight] - [HYScreenTools getStatusHeight]) backgroundImgName:nil backgroundColor:[UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f] isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [self.view addSubview:bgView];
    
    UIImageView *myProxyView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(0, 10, bgView.frame.size.width, 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:NO closeKeyboard:NO isFrame:YES];
    [bgView addSubview:myProxyView];
    
    UILabel *myProxyLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(10, 7, 100, 30) textfont:[UIFont fontWithName:FONT_BOLD size:15]  text:@"我的助理" textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentCenter];
    [myProxyView addSubview:myProxyLabel];
    
    UIImageView *myProxyRightView = [HYControlFactory GetImgViewWithCGRect:CGRectMake((myProxyView.frame.size.width) - 50 , 7, 36, 30) backgroundImgName:@"newtask_right" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [myProxyView addSubview:myProxyRightView];
    
    
    
    
    UIImageView *upHeadImgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(0, myProxyView.frame.origin.y + myProxyView.frame.size.height + 20, bgView.frame.size.width, 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:NO closeKeyboard:NO isFrame:YES];
    [bgView addSubview:upHeadImgView];
    
    UILabel *upHeadImgLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(10, 7, 100, 30) textfont:[UIFont fontWithName:FONT_BOLD size:15]  text:@"设置头像" textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentCenter];
    [upHeadImgView addSubview:upHeadImgLabel];
    
    
    UIImageView *upHeadImgRightView = [HYControlFactory GetImgViewWithCGRect:CGRectMake((upHeadImgView.frame.size.width) - 50 , 7, 36, 30) backgroundImgName:@"newtask_right" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [upHeadImgView addSubview:upHeadImgRightView];
    
    
    
    UIImageView *checkVersionView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(0, upHeadImgView.frame.origin.y + upHeadImgView.frame.size.height, bgView.frame.size.width, 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:NO closeKeyboard:NO isFrame:YES];
    [bgView addSubview:checkVersionView];
    
    UILabel *checkVersionLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(10, 7, 100, 30) textfont:[UIFont fontWithName:FONT_BOLD size:15]  text:@"版本更新" textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentCenter];
    [checkVersionView addSubview:checkVersionLabel];
    
    UIImageView *checkVersionRightView = [HYControlFactory GetImgViewWithCGRect:CGRectMake((checkVersionView.frame.size.width) - 50 , 7, 36, 30) backgroundImgName:@"newtask_right" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [checkVersionView addSubview:checkVersionRightView];
    
    
    UIButton *logoutButton = [HYControlFactory GetButtonWithCGRect:CGRectMake(10, checkVersionView.frame.origin.y + checkVersionView.frame.size.height + 30 , bgView.frame.size.width - 20, 44) backgroundImg:@"more_btn" selectBackgroundImgName:@"more_btn_hover" addTarget:nil action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    
    [logoutButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [bgView addSubview:logoutButton];
    
}

-(void)logoutAction
{
    [super logoutAction];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[[self getNavigationController] getView] setHidden:NO];
    [[[self getTabbarController] getView] setHidden:YES];
    [[self getNavigationController] setCenterTittle:[self title]];
    [[self getNavigationController] setLeftButtonImage:[HYImageFactory GetImageByName:@"leftButton" AndType:PNG]];
    [[self getNavigationController] setLeftTittle:MORE];
    [[self getNavigationController] setLeftTittleFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [[self getNavigationController] setLeftTittleColor:[UIColor whiteColor]];
    
    [[self getNavigationController] hideRightButton];
    [[self getNavigationController] showLeftButton];
    [[self getNavigationController] showLeftTittle];
}

-(void)bindAction
{
    [[self getNavigationController] setLeftButtonTarget:nil action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)backAction:(id)sender
{
    [[self getNavigationController] popController:self];
    [[[self getTabbarController] getSelectItem] setSelect:NO];
    [[[self getTabbarController] getLastSelectItem] setSelect:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
