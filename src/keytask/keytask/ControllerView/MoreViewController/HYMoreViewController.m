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
#import "HYMyProxyViewController.h"
#import "HYHeadImgViewController.h"
#import "Harpy.h"
#import "HYNetworkInterface.h"
#import "HYHelper.h"
#import "HYHelpViewController.h"

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
    [myProxyView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myProxyActions:)]];
    
    UILabel *myProxyLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(10, 7, 100, 30) textfont:[UIFont fontWithName:FONT_BOLD size:15]  text:@"我的助理" textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentCenter];
    [myProxyView addSubview:myProxyLabel];
       [myProxyLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myProxyActions:)]];
    
    UIImageView *myProxyRightView = [HYControlFactory GetImgViewWithCGRect:CGRectMake((myProxyView.frame.size.width) - 50 , 7, 36, 30) backgroundImgName:@"newtask_right" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [myProxyView addSubview:myProxyRightView];
     [myProxyRightView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myProxyActions:)]];
    
    
    
    
    UIImageView *upHeadImgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(0, myProxyView.frame.origin.y + myProxyView.frame.size.height + 20, bgView.frame.size.width, 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:NO closeKeyboard:NO isFrame:YES];
    [bgView addSubview:upHeadImgView];
    
        [upHeadImgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upHeadImgActions:)]];
    
    UILabel *upHeadImgLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(10, 7, 100, 30) textfont:[UIFont fontWithName:FONT_BOLD size:15]  text:@"设置头像" textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentCenter];
    [upHeadImgView addSubview:upHeadImgLabel];
        [upHeadImgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upHeadImgActions:)]];
    
    
    UIImageView *upHeadImgRightView = [HYControlFactory GetImgViewWithCGRect:CGRectMake((upHeadImgView.frame.size.width) - 50 , 7, 36, 30) backgroundImgName:@"newtask_right" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [upHeadImgView addSubview:upHeadImgRightView];
    [upHeadImgRightView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upHeadImgActions:)]];
    
    
    
    UIImageView *checkVersionView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(0, upHeadImgView.frame.origin.y + upHeadImgView.frame.size.height, bgView.frame.size.width, 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:NO closeKeyboard:NO isFrame:YES];
    [bgView addSubview:checkVersionView];
    [checkVersionView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkVersionActions:)]];
    
    UILabel *checkVersionLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(10, 7, 100, 30) textfont:[UIFont fontWithName:FONT_BOLD size:15]  text:@"版本更新" textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentCenter];
    [checkVersionView addSubview:checkVersionLabel];
    [checkVersionLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkVersionActions:)]];
    
    UIImageView *checkVersionRightView = [HYControlFactory GetImgViewWithCGRect:CGRectMake((checkVersionView.frame.size.width) - 50 , 7, 36, 30) backgroundImgName:@"newtask_right" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [checkVersionView addSubview:checkVersionRightView];
    [checkVersionRightView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkVersionActions:)]];
    
    UIImageView *helpView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(0, checkVersionView.frame.origin.y + checkVersionView.frame.size.height, bgView.frame.size.width, 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:NO closeKeyboard:NO isFrame:YES];
    [bgView addSubview:helpView];
    [helpView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(helpActions:)]];
    
    UILabel *helpLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(10, 7, 100, 30) textfont:[UIFont fontWithName:FONT_BOLD size:15]  text:@"问题反馈" textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentCenter];
    
    [helpView addSubview:helpLabel];
    [helpLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(helpActions:)]];
    
    UIImageView *helpRightView = [HYControlFactory GetImgViewWithCGRect:CGRectMake((helpView.frame.size.width) - 50 , 7, 36, 30) backgroundImgName:@"newtask_right" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [helpView addSubview:helpRightView];
    [helpRightView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(helpActions:)]];
    
    
    
    UIButton *logoutButton = [HYControlFactory GetButtonWithCGRect:CGRectMake(10, helpView.frame.origin.y + helpView.frame.size.height + 30 , bgView.frame.size.width - 20, 44) backgroundImg:@"more_btn" selectBackgroundImgName:@"more_btn_hover" addTarget:nil action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    
    [logoutButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [bgView addSubview:logoutButton];
    
}

-(void)checkVersion
{
    [SVProgressHUD showWithStatus:@"正在检查最新版本..." maskType:SVProgressHUDMaskTypeGradient];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.token,@"Token",self.user.accountName,@"AccountName",@"GetIOSVersion",@"opeType",nil];
    
    NSURL *url = [[NSURL alloc] initWithString:Check_api];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    if (params) {
        NSArray *array = [params allKeys];
        for (int i= 0; i <[array count]; i++) {
            [request setPostValue:[params objectForKey:[array objectAtIndex:i]] forKey:[array objectAtIndex:i]];
        }
    }
    [request setAuthenticationScheme:@"https"];
    [request setValidatesSecureCertificate:NO];
    [request setShouldAttemptPersistentConnection:NO];
    [request setDidFinishSelector:@selector(endCheckVersionFin:)];
    [request setDidFailSelector:@selector(endCheckVersionFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) endCheckVersionFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endCheckVersionString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endCheckVersionFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endCheckVersionStringFail:) withObject:responsestring waitUntilDone:YES];
}

-(void)endCheckVersionStringFail:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"服务器连接失败,请检查网络!"];
    //    [self logoutAction];
}

-(void)endCheckVersionString:(NSString *)msg
{
    [SVProgressHUD dismiss];
    NSError *error;
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [json objectForKey:@"Success"];
    if([result boolValue])
    {
        NSArray *contents = [json objectForKey:@"Content"];
        if([contents count] <= 0)
        {
            //            [SVProgressHUD dismiss];
            return;
        }
        NSDictionary *content = [contents objectAtIndex:0];
        NSString *remoteVersion = [content objectForKey:@"version"];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
        NSString *downloadString = [content objectForKey:@"download"];
        NSString *infoString = [content objectForKey:@"info"];
        [HYHelper setDownloadURL:downloadString];
        //        app_build = @"0";
        if([app_build intValue] < [remoteVersion intValue])
        {
            //更新
            //NSLog(@"更新");
            [Harpy showAlertWithVersion:[NSString stringWithFormat:@"%@",remoteVersion] info:infoString download:downloadString];
        }else
        {
            //不更新
            //NSLog(@"NO更新");
            [SVProgressHUD showSuccessWithStatus:@"已经是最新版本"];
        }
    }else
    {
        [super logoutAction];
    }
}

-(void)helpActions:(UIGestureRecognizer *)myProxy
{
    HYHelpViewController *helpView = [[HYHelpViewController alloc] init];
    helpView.user = [HYHelper getUser];
    [[self getNavigationController] pushController:helpView];
}


-(void)checkVersionActions:(UIGestureRecognizer *)myProxy
{
    [self checkVersion];
}

-(void)myProxyActions:(UIGestureRecognizer *)myProxy
{
    HYMyProxyViewController *myProxyView = [[HYMyProxyViewController alloc] init];
    myProxyView.user = [HYHelper getUser];
    [[self getNavigationController] pushController:myProxyView];
}

-(void)upHeadImgActions:(UIGestureRecognizer *)upHeadImg
{
    HYHeadImgViewController *headImgView = [[HYHeadImgViewController alloc] init];
    headImgView.user = self.user;
    [[self getNavigationController] pushController:headImgView];
}

-(void)logoutAction
{
    for (UIView *oneView in self.view.subviews ) {
        if ([oneView isKindOfClass:[UIView class]]) {
            [oneView removeFromSuperview];
        }
    }
    [super logoutRealAction];
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
