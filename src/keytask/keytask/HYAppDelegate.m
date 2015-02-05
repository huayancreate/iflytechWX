//
//  HYAppDelegate.m
//  keytask
//
//  Created by 许 玮 on 14-9-16.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYAppDelegate.h"
#import "HYLoginViewController.h"
#import "HYImageFactory.h"
#import "HYConstants.h"
#import "IQKeyboardManager.h"
#import "HYTabItemController.h"
#import "DrawPatternLockViewController.h"
#import "HYMainViewController.h"
#import "HYAddPartViewController.h"
#import "HYNetworkInterface.h"
#import "Harpy.h"
#import "DrawPatternLockViewController.h"
//#import "BPush.h"
#import "HYUncaughtExceptionHandler.h"
#import "APService.h"
#import <AudioToolbox/AudioToolbox.h>
#import "HYHelper.h"
#import "HYMessageViewController.h"

//#define SUPPORT_IOS8 1

@interface HYAppDelegate()
@property (nonatomic, strong) HYNavigationController *_nav;
@property (nonatomic, strong) HYNavigationModel *_navModel;
@property (nonatomic, strong) HYTabbarController *_tabbar;
@property int errorCount;
@property BOOL foregroundFlag;

@end


@implementation HYAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize _nav;
@synthesize _navModel;
@synthesize _tabbar;
@synthesize lockVC;
@synthesize app_id;
@synthesize channel_id;
@synthesize user_id;
@synthesize downloadString;
@synthesize remoteTaskID;
@synthesize foregroundFlag;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    foregroundFlag = false;
    application.applicationIconBadgeNumber = 0;
    
    if(launchOptions)
    {
        //NSLog(@"remoteTaskID = not nil");
        
        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        remoteTaskID = [pushNotificationKey valueForKey:@"TaskID"];
        
        //NSLog(@"remoteTaskID = %@", remoteTaskID);
        [APService setBadge:0];
        
//        [SVProgressHUD showErrorWithStatus:@"1111"];
    }else
    {
        //NSLog(@"remoteTaskID = nil");
        remoteTaskID = nil;
    }
    
//    UIApplication *application = [UIApplication sharedApplication];
//    
//    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
//                                                                                             |UIRemoteNotificationTypeSound
//                                                                                             |UIRemoteNotificationTypeAlert)
//                                                                                 categories:nil];
//        [application registerUserNotificationSettings:settings];
//        [application registerForRemoteNotifications];
//    } else {
//        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge
//                                                         |UIRemoteNotificationTypeSound
//                                                         |UIRemoteNotificationTypeAlert)];
//    }
    
    
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:launchOptions];
    
    
    InstallUncaughtExceptionHandler();
    
//    [self redirectNSlogToDocumentFolder];
    self.errorCount = 3;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    [self initNavigationBar];
    
    [self initTabBar];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isLogin = [userDefaults valueForKey:@"isLogin"];
    if(isLogin == nil)
    {
        [userDefaults setObject:@"0" forKey:@"isLogin"];
        [userDefaults synchronize]; 
    }
    isLogin = [userDefaults valueForKey:@"isLogin"];
    
    
    
    if([isLogin boolValue])
    {
        lockVC = [[DrawPatternLockViewController alloc] init];
//        [lockVC forgetPassword];
        [lockVC setTarget:self withAction:@selector(lockEnteredAction:)];
        
        [HYHelper getUser].isLogin = false;
        self.window.rootViewController = lockVC;
        
        [_nav pushController:lockVC];
    }else
    {
        HYLoginViewController * rootVC = [[HYLoginViewController alloc]init];
        if(self.user == nil)
        {
            self.user = [[HYUserLoginModel alloc] init];
        }
        rootVC.user = self.user;
        self.user.isLogin = false;
        [HYHelper getUser].isLogin = false;
        self.window.rootViewController = rootVC;
        [_nav pushController:rootVC];
        
    }
    
    [self.window makeKeyAndVisible];
    
    
//    [BPush setupChannel:launchOptions];
//    [BPush setDelegate:self];
    
//    [application setApplicationIconBadgeNumber:0];
//#if SUPPORT_IOS8
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        UIUserNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    }else
//#endif
//    {
//        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//    }
    
    return YES;
}

- (BOOL)pushNotificationOpen

{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        
    {
        
        UIUserNotificationType types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
        
        return (types & UIRemoteNotificationTypeAlert);
        
    }
    
    else
        
    {
        
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        
        return (types & UIRemoteNotificationTypeAlert);
        
    }
    
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
//    //NSLog(@"收到通知:%@", [self logDic:userInfo]);
//    //NSLog(@"推送过来的启动");
    if([HYHelper getUser].isLogin && foregroundFlag)
    {
        remoteTaskID = [userInfo valueForKey:@"TaskID"];
        //NSLog(@"123213 = %@", remoteTaskID);
        if([HYHelper getUser].isLogin && foregroundFlag)
        {
            if(remoteTaskID != nil)
            {
                [APService setBadge:0];
                //        //NSLog(@"RemoteTaskID", )
                HYMessageViewController *messageView = [[HYMessageViewController alloc] init];
                HYTaskModel *model = [[HYTaskModel alloc] init];
                model.ID = [HYHelper getRemoteTaskID];
                [messageView setTitle:@""];
                messageView.taskModel = model;
                messageView.user = [HYHelper getUser];
                [[HYHelper getNavigationController] pushController:messageView];
                //        return;
            }
        }
    }else
    {
        if([HYHelper getUser].isLogin)
        {
            [APService setBadge:0];
            remoteTaskID = nil;
        }else
        {
            [APService setBadge:0];
            remoteTaskID = [userInfo valueForKey:@"TaskID"];
        }
//        remoteTaskID = [userInfo valueForKey:@"TaskID"];
    }
    AudioServicesPlaySystemSound(1007);
    foregroundFlag = false;
  //  APService
}

//- (void)application:(UIApplication *)application
//didReceiveRemoteNotification:(NSDictionary *)userInfo
//fetchCompletionHandler:
//(void (^)(UIBackgroundFetchResult))completionHandler {
//    [APService handleRemoteNotification:userInfo];
//    
//    completionHandler(UIBackgroundFetchResultNewData);
////    AudioServicesPlaySystemSound(1007);
//    //NSLog(@"收到通知:%@", [self logDic:userInfo]);
//    
//    //NSLog(@"内部启动");
//}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
    //NSLog(@"123123");
}



// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
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
        NSString *errorStauts = [NSString stringWithFormat:@"您输入的密码不正确!您还有%d次机会",self.errorCount];
        [SVProgressHUD showErrorWithStatus:errorStauts];
        self.errorCount = self.errorCount - 1;
        if(self.errorCount < 0)
        {
            self.errorCount = 3;
            HYLoginViewController * rootVC = [[HYLoginViewController alloc]init];
            if(self.user == nil)
            {
                self.user = [[HYUserLoginModel alloc] init];
            }
            rootVC.user = self.user;
            self.window.rootViewController = rootVC;
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
        
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.accountName,@"AccountName",self.user.password,@"PassWord",@"112",@"UserID",@"123123",@"ChannelID",@"12312312321",@"IMEI",nil];
        
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
        [request setDidFinishSelector:@selector(endLoginFin:)];
        [request setDidFailSelector:@selector(endLoginFail:)];
        [request setPersistentConnectionTimeoutSeconds:15];
        [request setNumberOfTimesToRetryOnTimeout:1];
        [request startAsynchronous];
    }
}

- (void) endLoginFin:(ASIHTTPRequest *)request
{
    [APService setBadge:0];
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endRequest:) withObject:responsestring waitUntilDone:YES];
}

- (void) endLoginFail:(ASIHTTPRequest *)request
{
    [APService setBadge:0];
    NSString *responsestring = @"服务器链接失败";
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endFailedRequest:) withObject:responsestring waitUntilDone:YES];
}

-(void) endFailedRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"服务器连接失败,请检查网络!"];
    //NSLog(@"msg = %@", msg);
}

-(void) endRequest:(NSString *)msg
{
    //    [self checkVersion:self.user.token andAccountName:self.user.accountName];
    //NSLog(@"msg = %@", msg);
    [SVProgressHUD dismiss];
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
        [self logoutAction];
    }
    
}

-(void)logoutAction
{
    HYNavigationModel * model = [_nav getModel];
    NSArray *delArr = [model getStock];
    for (int i = 0; i < [delArr count]; i++) {
        HYBaseViewController *vc = [delArr objectAtIndex:i];
        vc = nil;
    }
    [[_nav getModel] removeAll];
    HYLoginViewController *loginView = [[HYLoginViewController alloc] init];
    loginView.user = [[HYUserLoginModel alloc] init];
    [_nav pushController:loginView];
    
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
            [self checkVersion];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *isLoginDefault = [userDefaults valueForKey:@"isLogin"];
            
            if(![isLoginDefault boolValue])
            {
                DrawPatternLockViewController *lockVc = lockVC;
                [lockVc setTarget:self withAction:@selector(lockEnteredAction:)];
                lockVc.user = self.user;
                [lockVc setSetting:NO];
                [lockVC getDraw].flag = NO;
//                [lockVC forgetPassword];
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

-(void)afterLogin
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isLoginDefaults = [userDefaults valueForKey:@"isLogin"];
    
    if(![isLoginDefaults boolValue])
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
        self.downloadString = [content objectForKey:@"download"];
        NSString *infoString = [content objectForKey:@"info"];
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

-(void)initTabBar
{
    HYTabItemModel *itemstartModel = [[HYTabItemModel alloc] init];
    HYTabItemController *itemstart = [[HYTabItemController alloc] initWithModel:itemstartModel];
    [itemstart setUnselectBackgroudImage:[HYImageFactory GetImageByName:@"start" AndType:PNG]];
    [itemstart setSelectBackgroundImage:[HYImageFactory GetImageByName:@"start_hover" AndType:PNG]];
    [itemstart setName:MY_TASK_START];
    [itemstart setType:@"Initiator"];
    
    HYTabItemModel *itemexcModel = [[HYTabItemModel alloc] init];
    HYTabItemController *itemexc = [[HYTabItemController alloc] initWithModel:itemexcModel];
    [itemexc setUnselectBackgroudImage:[HYImageFactory GetImageByName:@"exc" AndType:PNG]];
    [itemexc setSelectBackgroundImage:[HYImageFactory GetImageByName:@"exc_hover" AndType:PNG]];
    [itemexc setName:MY_TASK_EXC];
    [itemexc setType:@"Executor"];
    
    HYTabItemModel *itemjionModel = [[HYTabItemModel alloc] init];
    HYTabItemController *itemjion = [[HYTabItemController alloc] initWithModel:itemjionModel];
    [itemjion setUnselectBackgroudImage:[HYImageFactory GetImageByName:@"jion" AndType:PNG]];
    [itemjion setSelectBackgroundImage:[HYImageFactory GetImageByName:@"jion_hover" AndType:PNG]];
    [itemjion setName:MY_TASK_JOIN];
    [itemjion setType:@"Paticrpant"];
    
    HYTabItemModel *itemmoreModel = [[HYTabItemModel alloc] init];
    HYTabItemController *itemmore = [[HYTabItemController alloc] initWithModel:itemmoreModel];
    [itemmore setUnselectBackgroudImage:[HYImageFactory GetImageByName:@"more" AndType:PNG]];
    [itemmore setSelectBackgroundImage:[HYImageFactory GetImageByName:@"more_hover" AndType:PNG]];
    
    
    NSArray *items = [[NSArray alloc] initWithObjects:itemstart,itemexc, itemjion,itemmore,nil];
    _tabbar = [[HYTabbarController alloc] initWithTabbarItem:items];
    [_tabbar setBackgroudImage:[HYImageFactory GetImageByName:@"tabbarbg" AndType:PNG]];
    
    [_tabbar initItems];
}

-(void)initNavigationBar
{
    _navModel = [[HYNavigationModel alloc] init];
    _navModel._backgroudImg = [HYImageFactory GetImageByName:@"topbg" AndType:PNG];
    
    _nav = [[HYNavigationController alloc] initWithModel:_navModel];
    
    [_nav setBackgroudImageByModel];
    [_nav initLeftButton];
    [_nav initRightButton];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //NSLog(@"切换到后台");
    foregroundFlag = true;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //NSLog(@"切换到前台");
//    foregroundFlag = true;
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"keytask" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"keytask.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(HYNavigationController *)getNavigation
{
    return _nav;
}

-(HYTabbarController *)getTabbar
{
    return _tabbar;
}

#pragma mark - 用户方法,将nslog的输出信息写入到dr.log文件中；
// 将NSlog打印信息保存到Document目录下的文件中
- (void)redirectNSlogToDocumentFolder
{
    
    //如果已经连接Xcode调试则不输出到文件
    //    if(isatty(STDOUT_FILENO)) {
    //        return;
    //    }
    //
    //    UIDevice *device = [UIDevice currentDevice];
    //    if([[device model] hasSuffix:@"Simulator"]){ //在模拟器不保存到文件中
    //        return;
    //    }
    
    
    
    
    //将NSlog打印信息保存到Document目录下的Log文件夹下
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Log"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:logDirectory];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:logDirectory  withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //每次启动后都保存一个新的日志文件中
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSString *logFilePath = [logDirectory stringByAppendingFormat:@"/%@.log",dateStr];
    
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    
    //未捕获的Objective-C异常日志
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentDirectory = [paths objectAtIndex:0];
    //    NSString *fileName = [NSString stringWithFormat:@"dr.log"];// 注意不是NSData!
    //    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    //    // 先删除已经存在的文件
    //    NSFileManager *defaultManager = [NSFileManager defaultManager];
    //    [defaultManager removeItemAtPath:logFilePath error:nil];
    //
    //    // 将log输入到文件
    //    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    //    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    //    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdin);
    
    
    
}


void UncaughtExceptionHandler(NSException* exception)
{
    NSString* name = [ exception name ];
    NSString* reason = [ exception reason ];
    NSArray* symbols = [ exception callStackSymbols ]; // 异常发生时的调用栈
    NSMutableString* strSymbols = [ [ NSMutableString alloc ] init ]; //将调用栈拼成输出日志的字符串
    for ( NSString* item in symbols )
    {
        [ strSymbols appendString: item ];
        [ strSymbols appendString: @"\r\n" ];
    }
    
    //将crash日志保存到Document目录下的Log文件夹下
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Log"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:logDirectory]) {
        [fileManager createDirectoryAtPath:logDirectory  withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *logFilePath = [logDirectory stringByAppendingPathComponent:@"UncaughtException.log"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    NSString *crashString = [NSString stringWithFormat:@"<- %@ ->[ Uncaught Exception ]\r\nName: %@, Reason: %@\r\n[ Fe Symbols Start ]\r\n%@[ Fe Symbols End ]\r\n\r\n", dateStr, name, reason, strSymbols];
    //把错误日志写到文件中
    if (![fileManager fileExistsAtPath:logFilePath]) {
        [crashString writeToFile:logFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }else{
        NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
        [outFile seekToEndOfFile];
        [outFile writeData:[crashString dataUsingEncoding:NSUTF8StringEncoding]];
        [outFile closeFile];
    }
}

@end
