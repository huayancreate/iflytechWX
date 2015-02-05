//
//  HYBaseViewController.m
//  keytask
//
//  Created by 许 玮 on 14-9-22.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYBaseViewController.h"
#import "HYNavigationController.h"
#import "HYHelper.h"
#import "DataProcessing.h"
#import "HYLoginViewController.h"
#import "HYConstants.h"
#import "HYNetworkInterface.h"
#import "HYMainViewController.h"
#import "Harpy.h"
#import "APService.h"


@interface HYBaseViewController ()
{
    DrawPatternLockViewController *lockVC;
    int errorCount;
}
@property (nonatomic, strong) HYNavigationController *_nav;
@property (nonatomic, strong) HYTabbarController *_tabbar;

@end

@implementation HYBaseViewController
@synthesize _nav;
@synthesize _tabbar;
@synthesize user;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        errorCount = 3;
        // Custom initialization
        [[HYHelper getLockView] getDraw].flag = YES;
        if(_nav == nil)
        {
            _nav = [HYHelper getNavigationController];
        }
        if(_tabbar == nil)
        {
            _tabbar = [HYHelper getTabbarController];
        }
        if(user == nil)
        {
            user = [HYHelper getUser];
        }
        user.isLogin = true;
    }
    return self;
}

-(void)logoutRealAction
{
    [HYHelper getUser].isLogin = false;
    HYNavigationModel * model = [[self getNavigationController] getModel];
    NSArray *delArr = [model getStock];
    for (int i = 0; i < [delArr count]; i++) {
        HYBaseViewController *vc = [delArr objectAtIndex:i];
        vc = nil;
    }
    
    
    [[[self getNavigationController] getModel] removeAll];
    HYLoginViewController *loginView = [[HYLoginViewController alloc] init];
    loginView.user = [[HYUserLoginModel alloc] init];
    [[self getNavigationController] pushController:loginView];
    
}


-(void)logoutAction
{
    [HYHelper getUser].isLogin = false;
    HYNavigationModel * model = [[self getNavigationController] getModel];
    NSArray *delArr = [model getStock];
    for (int i = 0; i < [delArr count]; i++) {
        HYBaseViewController *vc = [delArr objectAtIndex:i];
        vc = nil;
    }
    
    
    [[[self getNavigationController] getModel] removeAll];
    
    lockVC = [[DrawPatternLockViewController alloc] init];
    lockVC.user = [[HYUserLoginModel alloc] init];
//    [lockVC forgetPassword];
    [lockVC setTarget:self withAction:@selector(lockEnteredAction:)];
    [[self getNavigationController] pushController:lockVC];
//    
//    [_nav pushController:lockVC];
//    HYLoginViewController *loginView = [[HYLoginViewController alloc] init];
//    loginView.user = [[HYUserLoginModel alloc] init];
//    [[self getNavigationController] pushController:loginView];
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![key isEqualToString:[userDefaults objectForKey:@"key"]]) {
//        [lockVC forgetPassword];
        NSString *errorStauts = [NSString stringWithFormat:@"您输入的密码不正确!您还有%d次机会",errorCount];
        [SVProgressHUD showErrorWithStatus:errorStauts];
        errorCount = errorCount - 1;
        if(errorCount < 0)
        {
            errorCount = 3;
            HYLoginViewController * rootVC = [[HYLoginViewController alloc]init];
            if(self.user == nil)
            {
                self.user = [[HYUserLoginModel alloc] init];
            }
            rootVC.user = self.user;
            [_nav pushController:rootVC];
        }
    }else
    {
        //        HYMainViewController *mainView = [[HYMainViewController alloc] init];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if(self.user == nil)
        {
            self.user = [[HYUserLoginModel alloc] init];
        }
        //        //NSLog(@"[userDefaults objectForKey:token]; %@",[userDefaults objectForKey:@"token"];)
        //        self.user.token = [userDefaults objectForKey:@"token"];
        self.user.accountName = [userDefaults objectForKey:@"accountName"];
        self.user.password = [userDefaults objectForKey:@"password"];
        //        self.user.headImg = [userDefaults objectForKey:@"headImg"];
        //        HYLoginViewController *loginView = [[HYLoginViewController alloc] init];
        //        loginView.isLogin = NO;
        //        [loginView loginAction:self.user.accountName AndPassword:self.user.password];
        //        self.user.token =
        //        self.user.
        //        mainView.user = loginView.user;
        //        mainView.user = self.user;
        //        [mainView setItemTag:TASK_START];
        //
        //        [_nav pushController:mainView];
        
        //        [mainView setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        //        [lockVC presentViewController:mainView animated:YES completion:nil];
        [SVProgressHUD showWithStatus:@"正在登录系统..." maskType:SVProgressHUDMaskTypeGradient];
        
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.accountName,@"AccountName",self.user.password,@"PassWord",@"123123",@"UserID",@"123123",@"ChannelID",@"12312312321",@"IMEI",nil];
        
        NSURL *url = [[NSURL alloc] initWithString:Login_api];
        
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
        [request setDidFinishSelector:@selector(endBaseLoginFin:)];
        [request setDidFailSelector:@selector(endBaseLoginFail:)];
        [request setPersistentConnectionTimeoutSeconds:15];
        [request setNumberOfTimesToRetryOnTimeout:1];
        [request startAsynchronous];
    }
}

- (void) endBaseLoginFin:(ASIHTTPRequest *)request
{
    [APService setBadge:0];
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endBaseLoginRequest:) withObject:responsestring waitUntilDone:YES];
}

-(void)afterBaseLogin
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isLoginDefaults = [userDefaults valueForKey:@"isLogin"];
    
    if(![isLoginDefaults boolValue])
    {
        DrawPatternLockViewController *lockVc = lockVC;
        [lockVc setTarget:self withAction:@selector(lockEnteredAction:)];
        lockVc.user = self.user;
        self.user.isLogin = false;
        [HYHelper getUser].isLogin = false;
        [lockVC getDraw].flag = NO;
        [lockVc setSetting:NO];
        [_nav pushController:lockVc];
    }
    
//    [self baseCheckVersion];
    HYMainViewController *mainView = [[HYMainViewController alloc] init];
    mainView = [[HYMainViewController alloc] init];
    mainView.user = self.user;
    [mainView setItemTag:TASK_START];
    [_nav pushController:mainView];
    
}

- (void) endBaseLoginFail:(ASIHTTPRequest *)request
{
    [APService setBadge:0];
    NSString *responsestring = @"服务器链接失败";
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endBaseLoginFailedRequest:) withObject:responsestring waitUntilDone:YES];
}

-(void) endBaseLoginFailedRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"服务器连接失败,请检查网络!"];
    //NSLog(@"msg = %@", msg);
}

-(void) endBaseLoginRequest:(NSString *)msg
{
    //    [self checkVersion:self.user.token andAccountName:self.user.accountName];
    //NSLog(@"msg = %@", msg);
    
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
            [self getBaseNameByID];
            [self getBaseHeadImg];
            [self baseCheckVersion];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self afterBaseLogin];
                
            });
        });
    }else
    {
        [SVProgressHUD showErrorWithStatus:LOGIN_ERROR];
    }
}

-(void)push
{
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



-(void)getBaseNameByID
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
    [request setDidFinishSelector:@selector(endBaseGetNameByIDFin:)];
    [request setDidFailSelector:@selector(endBaseGetNameByIDFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) endBaseGetNameByIDFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endBaseGetNameByIDString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endBaseGetNameByIDFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endBaseGetNameByIDStringFail:) withObject:responsestring waitUntilDone:YES];
}

-(void)endBaseGetNameByIDStringFail:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"服务器连接失败,请检查网络!"];
    //    [self logoutAction];
}


-(void)endBaseGetNameByIDString:(NSString *)msg
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
        
    }else
    {
        [self logoutAction];
    }
    
}

-(void)getBaseHeadImg
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
    [request setDidFinishSelector:@selector(endBaseGetHeadImgFin:)];
    [request setDidFailSelector:@selector(endBaseGetHeadImgFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) endBaseGetHeadImgFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endBaseGetHeadImgString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endBaseGetHeadImgFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endBaseGetHeadImgStringFail:) withObject:responsestring waitUntilDone:YES];
}

-(void)endBaseGetHeadImgStringFail:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"服务器连接失败,请检查网络!"];
    //    [self logoutAction];
}

-(void)endBaseGetHeadImgString:(NSString *)msg
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
//            [self baseCheckVersion];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *isLoginDefault = [userDefaults valueForKey:@"isLogin"];
            
            if(![isLoginDefault boolValue])
            {
                DrawPatternLockViewController *lockVc = lockVC;
                [lockVc setTarget:self withAction:@selector(lockEnteredAction:)];
                lockVc.user = self.user;
                [lockVC getDraw].flag = NO;
                [lockVc setSetting:NO];
                [_nav pushController:lockVc];
            }
            HYMainViewController *mainView = [[HYMainViewController alloc] init];
            mainView = [[HYMainViewController alloc] init];
            mainView.user = self.user;
            [mainView setItemTag:TASK_START];
            [_nav pushController:mainView];
            
            
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
        [self logoutAction];
    }
}

-(void)baseCheckVersion
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
    [request setDidFinishSelector:@selector(endBaseCheckVersionFin:)];
    [request setDidFailSelector:@selector(endBaseCheckVersionFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) endBaseCheckVersionFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endBaseCheckVersionString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endBaseCheckVersionFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endBaseCheckVersionStringFail:) withObject:responsestring waitUntilDone:YES];
}

-(void)endBaseCheckVersionStringFail:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"服务器连接失败,请检查网络!"];
    //    [self logoutAction];
}

-(void)endBaseCheckVersionString:(NSString *)msg
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
        [self logoutAction];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.view addSubview:[_nav getView]];
    [self.view addSubview:[_tabbar getView]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(HYNavigationController *) getNavigationController
{
    return _nav;
}

-(HYTabbarController *)getTabbarController
{
    return _tabbar;
}

-(void)initKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除观察者
}

- (void) requestFinished:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    [self performSelectorOnMainThread:@selector(endRequest:) withObject:responsestring waitUntilDone:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器连接失败,请检查网络!";
    [self performSelectorOnMainThread:@selector(endFailedRequest:) withObject:responsestring waitUntilDone:YES];
}


@end
