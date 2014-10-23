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
#import <QuartzCore/QuartzCore.h>
#import "HYControlFactory.h"
#import "HYNetworkInterface.h"
#import "HYMainViewController.h"
#import "HYUserLoginModel.h"
#import "RatingBar.h"
#import "DrawPatternLockViewController.h"

@interface HYLoginViewController ()
{
    UIImageView *bgImgView;
}
@property float _statusHeight;
@property float _originX;
@property float _originY;
@property (nonatomic, strong) HYMainViewController *mainView;
@property (nonatomic, strong) UITextField *usernameTextView;
@property (nonatomic, strong) UITextField *passwordTextView;

@end

@implementation HYLoginViewController
@synthesize _statusHeight;
@synthesize _originX;
@synthesize _originY;
@synthesize mainView;
@synthesize usernameTextView;
@synthesize passwordTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[[self getNavigationController] getView] setHidden:YES];
        [[[self getTabbarController] getView] setHidden:YES];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"lockPlist" ofType:@"plist"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        if(![data objectForKey:@"isLogin"])
        {
            
        }
        [self initControl];
    }
    return self;
}

-(void)initControl
{
    _statusHeight = [HYScreenTools getStatusHeight];
    _originX = [HYScreenTools getScreenWidth];
    _originY = [HYScreenTools getScreenHeight];
    bgImgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(0, 0 + _statusHeight, _originX, _originY) backgroundImgName:@"login_bg" backgroundColor:nil isCornerRadius:NO closeKeyboard:YES isFrame:NO];
    
    [self.view addSubview:bgImgView];
    
    UIImageView *loginBoxImgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(10, 190 + _statusHeight, (_originX - 20), 93) backgroundImgName:@"loginbox" backgroundColor:nil isCornerRadius:NO closeKeyboard:YES isFrame:NO];
    
    [bgImgView addSubview:loginBoxImgView];
    
    
    UIButton *loginBtn = [HYControlFactory GetButtonWithCGRect:CGRectMake(((_originX - 294)/2), 315 + _statusHeight, 294, 40) backgroundImg:@"loginbtn_hover" selectBackgroundImgName:@"loginbtn" addTarget:self action:@selector(_loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:loginBtn];
    
    //添加textView
    usernameTextView = [HYControlFactory GetTextFieldWithCGRect:CGRectMake(55, 6, 230, 36) Placeholder:LOGIN_USERNAME_PLACEHOLDER SecureTextEntry:NO];
    
    [loginBoxImgView addSubview:usernameTextView];
    
    passwordTextView = [HYControlFactory GetTextFieldWithCGRect:CGRectMake(55, 50, 230, 36) Placeholder:LOGIN_PASSWORD_PLACEHOLDER SecureTextEntry:YES];
    
    [loginBoxImgView addSubview:passwordTextView];
    
    
    
}

-(void)_loginAction
{
    //TEST
    
    //登录
    NSString *username = usernameTextView.text;
    NSString *password = passwordTextView.text;
    
    if([username  isEqual: @""] || [password  isEqual: @""])
    {
        [SVProgressHUD showErrorWithStatus:@"用户名或密码不能为空"];
        return;
    }
    self.user.accountName = username;
    
    [SVProgressHUD showWithStatus:@"正在登录系统..." maskType:SVProgressHUDMaskTypeGradient];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:username,@"AccountName",password,@"PassWord",@"123123",@"UserID",@"123123",@"ChannelID",@"12312312321",@"IMEI",nil];
    
    NSURL *url = [[NSURL alloc] initWithString:Login_api];
    
    [[[DataProcessing alloc] init] sentRequest:url Parem:params Target:self];
    
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


#pragma mark -
#pragma mark DataProcesse
-(void) endFailedRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    NSLog(@"msg = %@", msg);
}

-(void) endRequest:(NSString *)msg
{
    NSLog(@"msg = %@", msg);
    usernameTextView.text = @"";
    passwordTextView.text = @"";
    
    NSError *error;
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    
    NSString *token =  nil;
    NSString *result = [json objectForKey:@"result"];
    if([result boolValue])
    {
        token = [json objectForKey:@"message"];
        self.user.token = token;
        [self getNameByID];
    }else
    {
        [SVProgressHUD showErrorWithStatus:LOGIN_ERROR];
    }
}


-(void)getNameByID
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.accountName,@"AccountName",self.user.token,@"Token",@"GetNameByAccount",@"opeType",nil];
    
    NSURL *url = [[NSURL alloc] initWithString:TaskHandler_api];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    if (params) {
        NSArray *array = [params allKeys];
        for (int i= 0; i <[array count]; i++) {
            [request setPostValue:[params objectForKey:[array objectAtIndex:i]] forKey:[array objectAtIndex:i]];
        }
    }
    [request setDidFinishSelector:@selector(endGetNameByIDFin:)];
    [request setDidFailSelector:@selector(endGetNameByIDFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) endGetNameByIDFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetNameByIDString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endGetNameByIDFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetNameByIDString:) withObject:responsestring waitUntilDone:YES];
}

-(void)endGetNameByIDString:(NSString *)msg
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
            return;
        }
        NSDictionary *content = [contents objectAtIndex:0];
        self.user.username = [content objectForKey:@"Name"];
        
        mainView = [[HYMainViewController alloc] init];
        mainView.user = self.user;
        [mainView setItemTag:TASK_START];
        [[self getNavigationController] pushController:mainView];
//
//        DrawPatternLockViewController *lockVC = [[DrawPatternLockViewController alloc] init];
//        lockVC.user = self.user;
//        [lockVC setTarget:self withAction:@selector(lockEntered:)];
//        [[self getNavigationController] pushController:lockVC];
    }else
    {
        [super logoutAction];
    }
    
}

- (void)lockEntered:(NSString*)key {
    NSLog(@"key: %@", key);
    if([key length] >= 10)
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"lockPlist" ofType:@"plist"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        
        
        mainView = [[HYMainViewController alloc] init];
        mainView.user = self.user;
        [mainView setItemTag:TASK_START];
        [[self getNavigationController] pushController:mainView];
    }

}

@end
