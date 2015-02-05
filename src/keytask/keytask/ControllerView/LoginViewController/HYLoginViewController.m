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
#import "HYHelper.h"
#import "Harpy.h"
#import "APService.h"

@interface HYLoginViewController ()
{
    UIImageView *bgImgView;
    NSString *currentPassword;
    int currentPasswordNum;
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
@synthesize isLogin;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[[self getNavigationController] getView] setHidden:YES];
        [[[self getTabbarController] getView] setHidden:YES];
        
        self.user = nil;
        self.user = [[HYUserLoginModel alloc] init];
        
        [HYHelper setUser:self.user];
        
        [self initControl];
        isLogin = YES;
        currentPassword = @"";
        currentPasswordNum = 0;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [HYHelper getUser].isLogin = false;
    if(isLogin)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"0" forKey:@"isLogin"];
        [userDefaults synchronize];
    }
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
    usernameTextView = [HYControlFactory GetTextFieldWithCGRect:CGRectMake(55, 4, (_originX - 20) - 58, 40) Placeholder:LOGIN_USERNAME_PLACEHOLDER SecureTextEntry:NO];
    
    [loginBoxImgView addSubview:usernameTextView];
    
    passwordTextView = [HYControlFactory GetTextFieldWithCGRect:CGRectMake(55, 48, (_originX - 20) - 58, 40) Placeholder:LOGIN_PASSWORD_PLACEHOLDER SecureTextEntry:YES];

    
    [loginBoxImgView addSubview:passwordTextView];
    
    
    
}

-(void)loginAction:(NSString *)username AndPassword:(NSString *)password
{
    self.user.accountName = username;
    self.user.password = password;
    
    [SVProgressHUD showWithStatus:@"正在登录系统..." maskType:SVProgressHUDMaskTypeGradient];
    
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:username,@"AccountName",password,@"PassWord",@"123123",@"UserID",@"123123",@"ChannelID",@"12312312321",@"IMEI",nil];
    
    NSURL *url = [[NSURL alloc] initWithString:Login_api];
    
    [[[DataProcessing alloc] init] sentRequest:url Parem:params Target:self];
}

-(void)push
{
    //NSLog(@"[APService registrationID] : %@", [APService registrationID]);
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.token,@"Token",@"PushInfo",@"opeType",[APService registrationID],@"ChannelID",self.user.accountName,@"AccountName",@"4",@"DeviceType",nil];
    
    NSURL *url = [[NSURL alloc] initWithString:Push_api];
    
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
    [request setDidFinishSelector:@selector(endPushFin:)];
    [request setDidFailSelector:@selector(endPushFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}


- (void) endPushFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endPushRequest:) withObject:responsestring waitUntilDone:YES];
}


- (void) endPushFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endPushFailedRequest:) withObject:responsestring waitUntilDone:YES];
}

-(void) endPushFailedRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"服务器连接失败,请检查网络!"];
    //NSLog(@"msg = %@", msg);
}

-(void) endPushRequest:(NSString *)msg
{
    //    [self checkVersion:self.user.token andAccountName:self.user.accountName];
    //NSLog(@"msg = %@", msg);
    
    NSError *error;
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *success = [json objectForKey:@"Success"];
    if([success boolValue])
    {
        NSArray *contents = [json objectForKey:@"Content"];
        if([contents count] <= 0)
        {
            return;
        }
        NSDictionary *content = [contents objectAtIndex:0];
        NSString *result = [content objectForKey:@"result"];
        NSString *message = [content objectForKey:@"message"];
        if([result boolValue])
        {
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:message];
        }
        //        NSDictionary *content = [contents objectAtIndex:0];
        
    }else
    {
        //        [SVProgressHUD showErrorWithStatus:LOGIN_ERROR];
    }
}

-(void)_loginAction
{
    //TEST
    //登录
    NSString *username = usernameTextView.text;
    username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    username = [username lowercaseString];
    NSString *password = passwordTextView.text;
//    username = @"bgfang";
////    username = @"tingfu";
//    password = @"Mcming1989";
    if([username  isEqual: @""] || [password  isEqual: @""])
    {
        [SVProgressHUD showErrorWithStatus:@"用户名或密码不能为空"];
        return;
    }
    self.user.accountName = username;
    self.user.password = password;
    
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
    //NSLog(@"msg = %@", msg);
    [SVProgressHUD showErrorWithStatus:msg];
    return;
}

-(void) endRequest:(NSString *)msg
{
//    [self checkVersion:self.user.token andAccountName:self.user.accountName];
    //NSLog(@"msg = %@", msg);
    
    [APService setBadge:0];
    NSError *error;
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    
    NSString *token =  nil;
    NSString *result = [json objectForKey:@"result"];
    if([result boolValue])
    {
        token = [json objectForKey:@"message"];
        self.user.token = token;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [self getStartHeadImg:chartMessage.iconAccountName];
            [self push];
            [self getNameByID];
            [self getHeadImg];
            [self checkVersion];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self afterLogin];
                
            });
        });
        usernameTextView.text = @"";
        passwordTextView.text = @"";
    }else
    {
        passwordTextView.text = @"";
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
    [request setAuthenticationScheme:@"https"];
    [request setValidatesSecureCertificate:NO];
    [request setShouldAttemptPersistentConnection:NO];
    [request setDidFinishSelector:@selector(endGetNameByIDFin:)];
    [request setDidFailSelector:@selector(endGetNameByIDFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) endGetNameByIDFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetNameByIDString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endGetNameByIDFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetNameByIDStringFail:) withObject:responsestring waitUntilDone:YES];
}

-(void)endGetNameByIDStringFail:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"服务器连接失败,请检查网络!"];
    //    [self logoutAction];
}

-(void)endGetNameByIDString:(NSString *)msg
{
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
        
//        [self getHeadImg];
        
    }else
    {
        [super logoutAction];
    }
    
}

-(void)getHeadImg
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.accountName,@"AccountName",self.user.token,@"Token",@"GetHeadImg",@"opeType",nil];
    
    NSURL *url = [[NSURL alloc] initWithString:TaskHandler_api];
    
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
    [request setDidFinishSelector:@selector(endGetHeadImgFin:)];
    [request setDidFailSelector:@selector(endGetHeadImgFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) endGetHeadImgFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetHeadImgString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endGetHeadImgFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetHeadImgStringFail:) withObject:responsestring waitUntilDone:YES];
}

-(void)endGetHeadImgStringFail:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"服务器连接失败,请检查网络!"];
    //    [self logoutAction];
}

-(void)endGetHeadImgString:(NSString *)msg
{
    NSError *error;
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [json objectForKey:@"Success"];
    if([result boolValue])
    {
        NSArray *contents = [json objectForKey:@"Content"];
        if([contents count] <= 0)
        {
//            [self checkVersion];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *isLoginHeadImg = [userDefaults valueForKey:@"isLogin"];
            
            if(![isLoginHeadImg boolValue])
            {
                DrawPatternLockViewController *lockVc = [[DrawPatternLockViewController alloc] init];
                [HYHelper setLockView:lockVc];
                [lockVc setSetting:YES];
                [lockVc getDraw].flag = NO;
                [lockVc setTarget:self withAction:@selector(lockEnteredAction:)];
                lockVc.user = self.user;
                
                [HYHelper getUser].isLogin = false;
                self.user.isLogin = false;
                [[self getNavigationController] pushController:lockVc];
            }
            return;
        }
        NSDictionary *content = [contents objectAtIndex:0];
        NSString *headImgUrl = @"";
        NSArray *headArr = nil;
        if(![[content objectForKey:@"Img"] isEqualToString:@""])
        {
            headArr = [[content objectForKey:@"Img"] componentsSeparatedByString:@"\\"];
        }
        if([headArr count] != 2 && headArr != nil)
        {
            headArr = [[content objectForKey:@"Img"] componentsSeparatedByString:@"//"];
        }
        if(headArr != nil)
        {
            headImgUrl = [headImgUrl stringByAppendingString:HeadImg_api];
            headImgUrl = [headImgUrl stringByAppendingString:[headArr objectAtIndex:0]];
            headImgUrl = [headImgUrl stringByAppendingString:@"/"];
            headImgUrl = [headImgUrl stringByAppendingString:[headArr objectAtIndex:1]];
        }
        self.user.headImg = headImgUrl;
        self.user.lastTimeHeadImg = [content objectForKey:@"LastTime"];
        
//        [self checkVersion];
//        
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        NSString *isLoginDefaults = [userDefaults valueForKey:@"isLogin"];
//        
//        if(![isLoginDefaults boolValue])
//        {
//            DrawPatternLockViewController *lockVc = [[DrawPatternLockViewController alloc] init];
//            [HYHelper setLockView:lockVc];
//            [lockVc getDraw].flag = NO;
//            [lockVc setTarget:self withAction:@selector(lockEnteredAction:)];
//            [lockVc setSetting:YES];
//            lockVc.user = self.user;
//            
//            [HYHelper getUser].isLogin = false;
//            self.user.isLogin = false;
//            [[self getNavigationController] pushController:lockVc];
//        }
        
        
//            mainView = [[HYMainViewController alloc] init];
//            mainView.user = self.user;
//            [mainView setItemTag:TASK_START];
//            [[self getNavigationController] pushController:mainView];
//        
//            DrawPatternLockViewController *lockVC = [[DrawPatternLockViewController alloc] init];
//            lockVC.user = self.user;
        //        [lockVC setTarget:self withAction:@selector(lockEntered:)];
        //        [[self getNavigationController] pushController:lockVC];
        
        
    }else
    {
        [super logoutAction];
    }
}


-(void)afterLogin
{
//    [self checkVersion];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isLoginDefaults = [userDefaults valueForKey:@"isLogin"];
    
    if(![isLoginDefaults boolValue])
    {
        DrawPatternLockViewController *lockVc = [[DrawPatternLockViewController alloc] init];
        [HYHelper setLockView:lockVc];
        [lockVc getDraw].flag = NO;
        [lockVc setTarget:self withAction:@selector(lockEnteredAction:)];
        [lockVc setSetting:YES];
        lockVc.user = self.user;
        
        [HYHelper getUser].isLogin = false;
        self.user.isLogin = false;
        [[self getNavigationController] pushController:lockVc];
    }
}


-(void)checkVersion
{
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
//          [SVProgressHUD showSuccessWithStatus:@"当前最新版本"];
        }
        
//        mainView = [[HYMainViewController alloc] init];
//        mainView.user = self.user;
//        [mainView setItemTag:TASK_START];
//        [[self getNavigationController] pushController:mainView];
//        
//        [HYHelper setUser:self.user];
    }else
    {
        [super logoutAction];
    }
}

- (void)lockEnteredAction:(NSString*)key {
    //NSLog(@"key: %@", key);
    if([key isEqual:@""])
    {
        return;
    }
    if([key isEqual:@"00"])
    {
        return;
    }
    if([key length] >= 8)
    {
        if([currentPassword isEqual:@""])
        {
            currentPassword = key;
            [[HYHelper getLockView] secondPassword];
//            [tipsLabel setText:@"请再次输入确认密码"];
//            [drawView addSubview:tipsLabel];
        }else
        {
            //NSLog(@"currentPassword: %@", currentPassword);
            if([currentPassword isEqual:key])
            {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:@"1" forKey:@"isLogin"];
                [userDefaults setObject:key forKey:@"key"];
                [userDefaults setObject:self.user.accountName forKey:@"accountName"];
                [userDefaults setObject:self.user.password forKey:@"password"];
                [userDefaults synchronize]; 
                
                mainView = [[HYMainViewController alloc] init];
                [HYHelper setUser:self.user];
                mainView.user = self.user;
                [mainView setItemTag:TASK_START];
                [[self getNavigationController] pushController:mainView];
            }else
            {
                currentPassword = @"";
                [[HYHelper getLockView] firstPassword];
            }
        }
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"密码不能少于四位!"];
    }

}

@end
