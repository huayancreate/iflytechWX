//
//  HYMyProxyViewController.m
//  keytask
//
//  Created by 许 玮 on 14-10-23.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYMyProxyViewController.h"
#import "HYImageFactory.h"
#import "HYConstants.h"
#import "HYControlFactory.h"
#import "HYScreenTools.h"
#import "HYNetworkInterface.h"
#import "HYMyProxyModel.h"
#import "HYPeopleInfoView.h"
#import "HYSmartInputViewController.h"
#import "HYSmartInputModel.h"
#import "SDImageView+SDWebCache.h"

@interface HYMyProxyViewController ()<UIPickerViewDataSource,UIAlertViewDelegate>
{
    UIImageView *myProxyImgView;
    UILabel *myProxyLabel;
    UIImageView *startTimeBgView;
    UIImageView *endTimeBgView;
    UILabel *startTimeText;
    UILabel *endTimeText;
    UIAlertView *alertViewDatePicker;
    UIDatePicker *datePicker;
    UILabel *currentLabel;
    NSMutableArray *list;
    NSString *startTimeString;
    NSString *endTimeString;
    UIImageView *addPorxyPeople;
    UIImageView *delFirstPeople;
    UIImageView *reverFirstPeople;
    UIImageView *myProxyHeadView;
    HYPeopleInfoView *pepView;
    UITapGestureRecognizer *delPeopleViewRecognizer;
    NSString *headImgUrlStr;
}

@end

@implementation HYMyProxyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    list = [[NSMutableArray alloc] init];
    startTimeString = @"";
    endTimeString = @"";
    self.user.proxyList = nil;
    headImgUrlStr = @"";
    [self initControl];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getMyProxy
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.accountName,@"AccountName",self.user.token,@"Token",@"GetProxyByAccountName",@"opeType",nil];
    
    NSURL *url = [[NSURL alloc] initWithString:Proxy_api];
    
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
//            [SVProgressHUD showSuccessWithStatus:@"没有任务!"];
            return;
        }
        for (int i = 0; i < [contents count]; i++) {
            NSDictionary *dic = [contents objectAtIndex:i];
            HYMyProxyModel *proxyModel = [[HYMyProxyModel alloc] init];
            proxyModel.proxy = [dic objectForKey:@"Proxy"];
            proxyModel.proxyName = [dic objectForKey:@"ProxyName"];
            proxyModel.startTime = [dic objectForKey:@"StartTime"];
            proxyModel.endTime = [dic objectForKey:@"EndTime"];
            proxyModel.isAudit = [dic objectForKey:@"IsAudit"];
            if([proxyModel.proxy isEqual:@""] || proxyModel.proxy == nil)
            {
                NSDate *  senddate=[NSDate date];
                NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                [dateformatter setDateFormat:@"yyyy-MM-dd"];
                NSString *  locationString=[dateformatter stringFromDate:senddate];
                [startTimeText setText:locationString];
                startTimeString = locationString;
                [endTimeText setText:@"2099-12-31"];
                endTimeString = @"2099-12-31";
                proxyModel.startTime = startTimeString;
                proxyModel.endTime = endTimeString;
            }
            
            [list addObject:proxyModel];
        }
        
        
        if([list count] > 0)
        {
            HYMyProxyModel *tempModel = [list objectAtIndex:0];
            if(![tempModel.proxyName isEqual:@""] && tempModel.proxyName != nil)
            {
                pepView.icon = [HYImageFactory GetImageByName:@"newtask_people" AndType:PNG];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [self getHeadImg:tempModel.proxy];
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            if(headImgUrlStr != nil)
                            {
                                [pepView setHeadImgUrlStr:headImgUrlStr];
                            }
                        
                        });
                });
                
                pepView.name = tempModel.proxyName;
                [myProxyImgView addSubview:[pepView getViewWithWidth:35 iconHeight:35 nameWidth:35 nameHeight:15]];
                startTimeString = tempModel.startTime;
                endTimeString = tempModel.endTime;
                [startTimeText setText:tempModel.startTime];
                [endTimeText setText:tempModel.endTime];
                [addPorxyPeople removeFromSuperview];
                [myProxyImgView addSubview:delFirstPeople];
            }else
            {
                startTimeString = tempModel.startTime;
                endTimeString = tempModel.endTime;
                [startTimeText setText:tempModel.startTime];
                [endTimeText setText:tempModel.endTime];
                [list removeAllObjects];
//                list = nil;
                [pepView removeFromSuperview];
            }
        }
    }else
    {
        [super logoutAction];
    }

}

-(void)getHeadImg:(NSString *)accountName
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.accountName,@"AccountName",self.user.token,@"Token",@"GetHeadImg",@"opeType",accountName,@"UserAccount",nil];
    
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
    [request startSynchronous];
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
        headImgUrlStr = headImgUrl;
    }else
    {
        [self logoutAction];
    }
}



-(void)reverFirstPeopleAction:(UIGestureRecognizer *)gestureRecognizer
{
    [pepView removeDelView];
    [[pepView getView] removeGestureRecognizer:delPeopleViewRecognizer];
    [myProxyImgView addSubview:[pepView getView]];
    [reverFirstPeople removeFromSuperview];
    [myProxyImgView addSubview:delFirstPeople];
}

-(void)delFirstPeopleAction:(UIGestureRecognizer *)gestureRecognizer
{
    [pepView addDelView];
    [delFirstPeople removeFromSuperview];
    [myProxyImgView addSubview:reverFirstPeople];
    [[pepView getView] addGestureRecognizer:delPeopleViewRecognizer];
}

-(void)delFirstPeopleActionView:(UIGestureRecognizer *)gestureRecognizer
{
    [list removeAllObjects];
//    list = nil;
    [[pepView getView] removeGestureRecognizer:delPeopleViewRecognizer];
    [[pepView getView] removeFromSuperview];
    [reverFirstPeople removeFromSuperview];
    pepView = nil;
    [myProxyImgView addSubview:addPorxyPeople];
}

#pragma alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView == alertViewDatePicker)
    {
        if (buttonIndex == 0) {
            //NSLog(@"点击了确定按钮");
            NSDate *selectDate = [datePicker date];
            NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
            selectDateFormatter.dateFormat = @"yyyy-MM-dd";
            NSString *dateString = [selectDateFormatter stringFromDate:selectDate];
            [currentLabel setText:dateString];
            if(currentLabel ==  startTimeText)
            {
                startTimeString = dateString;
            }
            if(currentLabel ==  endTimeText)
            {
                endTimeString = dateString;
            }
        }
        else {
            //NSLog(@"点击了取消按钮");
        }
    }
}

-(void)initControl
{
    UIImageView *bgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(0, ([HYScreenTools getStatusHeight] + [[self getNavigationController] getNavigationHeight]), [HYScreenTools getScreenWidth], ([HYScreenTools getScreenHeight] - [HYScreenTools getStatusHeight]- [[self getNavigationController] getNavigationHeight])) backgroundImgName:nil backgroundColor:[UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f] isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [self.view addSubview:bgView];
    
    myProxyImgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, 8, ([HYScreenTools getScreenWidth] - 16), 60) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:YES closeKeyboard:YES isFrame:NO];
    
    myProxyHeadView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, 15, 30, 30) backgroundImgName:@"more_proxy" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    
    myProxyLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(46, 15, 70, 30) textfont:[UIFont fontWithName:FONT_BOLD size:14] text:@"我的助理:" textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];

    
    addPorxyPeople = [HYControlFactory GetImgViewWithCGRect:CGRectMake((myProxyImgView.frame.size.width) - 44 , 12.5f, 35, 35) backgroundImgName:@"newtask_add" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [addPorxyPeople addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPorxyPeopleAction)]];
    
    
    
    delFirstPeople = [HYControlFactory GetImgViewWithCGRect:CGRectMake((myProxyImgView.frame.size.width) - 44 , 12.5f, 35, 35) backgroundImgName:@"newtask_del" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [delFirstPeople addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delFirstPeopleAction:)]];
    
    
    reverFirstPeople = [HYControlFactory GetImgViewWithCGRect:CGRectMake((myProxyImgView.frame.size.width) - 44 , 12.5f, 35, 35) backgroundImgName:@"taskrever" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [reverFirstPeople addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reverFirstPeopleAction:)]];
    
    
    
    [myProxyImgView addSubview:myProxyHeadView];
    
    [myProxyImgView addSubview:addPorxyPeople];
    [myProxyImgView addSubview:myProxyLabel];
    
    [bgView addSubview:myProxyImgView];
    
    startTimeBgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, myProxyImgView.frame.origin.y + myProxyImgView.frame.size.height + 8, ([HYScreenTools getScreenWidth] - 16), 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:YES closeKeyboard:YES isFrame:NO];
    startTimeBgView.tag = 100;
    [startTimeBgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePickerAction:)]];
    
    UIImageView *startTimeClockView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(6, 9, 26, 26) backgroundImgName:@"newtask_time" backgroundColor:nil isCornerRadius:NO closeKeyboard:YES isFrame:NO];
    [startTimeBgView addSubview:startTimeClockView];
    
    UILabel *startTimeLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(46, 7, 70, 30) textfont:[UIFont fontWithName:FONT_BOLD size:14] text:@"生效日期:" textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    [startTimeBgView addSubview:startTimeLabel];
    
    startTimeText = [HYControlFactory GetLableWithCGRect:CGRectMake(myProxyLabel.frame.origin.x + myProxyLabel.frame.size.width + 5, 7, 70, 30) textfont:[UIFont fontWithName:FONT size:12] text:@"" textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    [startTimeBgView addSubview:startTimeText];
    
    
    UIImageView *startTimeRightView = [HYControlFactory GetImgViewWithCGRect:CGRectMake((startTimeBgView.frame.size.width) - 35 , 10, 35, 25) backgroundImgName:@"newtask_right" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    
    startTimeRightView.tag = 100;
    [startTimeRightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePickerAction:)]];
    
    [startTimeBgView addSubview:startTimeRightView];
    
    
    
    //ENDTIME
    endTimeBgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, startTimeBgView.frame.origin.y + startTimeBgView.frame.size.height + 8, ([HYScreenTools getScreenWidth] - 16), 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:YES closeKeyboard:YES isFrame:NO];
    endTimeBgView.tag = 200;
    [endTimeBgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePickerAction:)]];
    
    UIImageView *endTimeClockView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(6, 9, 26, 26) backgroundImgName:@"newtask_time" backgroundColor:nil isCornerRadius:NO closeKeyboard:YES isFrame:NO];
    [endTimeBgView addSubview:endTimeClockView];
    
    UILabel *endTimeLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(46, 7, 70, 30) textfont:[UIFont fontWithName:FONT_BOLD size:14] text:@"结束日期:" textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    [endTimeBgView addSubview:endTimeLabel];
    
    endTimeText = [HYControlFactory GetLableWithCGRect:CGRectMake(myProxyLabel.frame.origin.x + myProxyLabel.frame.size.width + 5, 7, 70, 30) textfont:[UIFont fontWithName:FONT size:12] text:@"" textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    [endTimeBgView addSubview:endTimeText];
    
    
    UIImageView *endTimeRightView = [HYControlFactory GetImgViewWithCGRect:CGRectMake((endTimeBgView.frame.size.width) - 35 , 10, 35, 25) backgroundImgName:@"newtask_right" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    endTimeRightView.tag = 200;
    [endTimeRightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePickerAction:)]];
    
    [endTimeBgView addSubview:endTimeRightView];
    
    [bgView addSubview:startTimeBgView];
    [bgView addSubview:endTimeBgView];
    
    
    UIButton *okButton = [HYControlFactory GetButtonWithCGRect:CGRectMake(8, (endTimeBgView.frame.origin.y + endTimeBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44) backgroundImg:@"newtask_ok" selectBackgroundImgName:@"newtask_ok_hover" addTarget:self action:@selector(_submitAction) forControlEvents:UIControlEventTouchUpInside];
    [okButton setTitle:OK_BUTTON_TEXT forState:UIControlStateNormal];
    [okButton.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:20]];
    [okButton.titleLabel setTextColor:[UIColor whiteColor]];
    [okButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [bgView addSubview:okButton];
    
    
}

-(void)addPorxyPeopleAction
{
    HYSmartInputViewController *smartInput = [[HYSmartInputViewController alloc] init];
    smartInput.proxyList = [[NSMutableArray alloc] init];
    NSMutableArray *proxyList = [[NSMutableArray alloc] init];
    for (int i = 0; i < [list count]; i++) {
        HYSmartInputModel *smartModel = [[HYSmartInputModel alloc] init];
        HYMyProxyModel *proxyModel = [list objectAtIndex:i];
        smartModel.accountName = proxyModel.proxy;
        smartModel.name = proxyModel.proxyName;
        [proxyList addObject:smartModel];
    }
    smartInput.proxyList = proxyList;
    smartInput.excList = nil;
    smartInput.partList = nil;
    smartInput.isAddPartViewInput = NO;
    smartInput.isFirstManInput = NO;
    smartInput.isProxyInput = YES;
    smartInput.current = @"proxy";
    smartInput.user = self.user;
    smartInput.title = @"智能输入";
    [[self getNavigationController] pushController:smartInput];
}


-(void)_submitAction
{
    
    [SVProgressHUD showWithStatus:@"正在提交数据..." maskType:SVProgressHUDMaskTypeGradient];
    NSDictionary *params = nil;
    if(self.user.proxyList != nil && [self.user.proxyList count] != 0)
    {
        HYSmartInputModel *tempModel = [self.user.proxyList objectAtIndex:0];
        params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.accountName,@"AccountName",self.user.token,@"Token",@"SetProxy",@"opeType",tempModel.accountName,@"Proxy",startTimeString,@"StartTime",endTimeString,@"EndTime",nil];
    }else if(list != 0 && [list count] != 0)
    {
        HYMyProxyModel *tempModel = [list objectAtIndex:0];
        params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.accountName,@"AccountName",self.user.token,@"Token",@"SetProxy",@"opeType",tempModel.proxy,@"Proxy",startTimeString,@"StartTime",endTimeString,@"EndTime",nil];
    }else
    {
        params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.accountName,@"AccountName",self.user.token,@"Token",@"SetProxy",@"opeType",@"",@"Proxy",startTimeString,@"StartTime",endTimeString,@"EndTime",nil];
    }
    
    NSURL *url = [[NSURL alloc] initWithString:Proxy_api];
    
    [[[DataProcessing alloc] init] sentRequest:url Parem:params Target:self];
}

-(void)endFailedRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    //NSLog(@"msg = %@", msg);
    [SVProgressHUD showErrorWithStatus:msg];
    return;
}

-(void)endRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    //NSLog(@"msg = %@", msg);
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
        [SVProgressHUD showSuccessWithStatus:[content objectForKey:@"message"]];
    }else
    {
        [super logoutAction];
    }
}

-(void)datePickerAction:(UIGestureRecognizer *)gestureRecognizer
{
    //    HYDatePickerViewController *datePickerView = [[HYDatePickerViewController alloc] init];
    //    [datePickerView initDatePicker];
    //    [datePickerView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    //    [datePickerView setModalPresentationStyle:UIModalPresentationFormSheet];
    //    [self presentViewController:datePickerView animated:YES completion:nil];
    
    UIImageView *temp = (UIImageView *)gestureRecognizer.view;
    if(temp.tag == 100)
    {
        currentLabel = startTimeText;
    }
    if(temp.tag == 200)
    {
        currentLabel = endTimeText;
    }
    alertViewDatePicker = [[UIAlertView alloc] initWithTitle:@"请选择时间" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(10 ,0,alertViewDatePicker.frame.size.width - 20,80)];
    datePicker.date = [NSDate date];
    datePicker.datePickerMode = UIDatePickerModeDate;
    //    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertView.frame.size.width,alertView.frame.size.height)];
    //    [v addSubview:datePicker];
    [alertViewDatePicker setValue:datePicker forKey:@"accessoryView"];
    [alertViewDatePicker show];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    pepView = [[HYPeopleInfoView alloc] initWithFrame:CGRectMake(myProxyLabel.frame.origin.x + myProxyLabel.frame.size.width + 5, 5, 35, 50)];
    
    delPeopleViewRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delFirstPeopleActionView:)];
    
    [[[self getNavigationController] getView] setHidden:NO];
    [[[self getTabbarController] getView] setHidden:YES];
    [[self getNavigationController] setCenterTittle:[self title]];
    [[self getNavigationController] setLeftButtonImage:[HYImageFactory GetImageByName:@"leftButton" AndType:PNG]];
    [[self getNavigationController] setLeftTittle:@"我的助理"];
    [[self getNavigationController] setLeftTittleFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [[self getNavigationController] setLeftTittleColor:[UIColor whiteColor]];
    
    [[self getNavigationController] hideRightButton];
    [[self getNavigationController] showLeftButton];
    [[self getNavigationController] showLeftTittle];
    
    if(self.user.proxyList == nil || [self.user.proxyList count] == 0)
    {
        [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeGradient];
        [self getMyProxy];
    }else
    {
        for (UIImageView *oneView in myProxyImgView.subviews ) {
            if ([oneView isKindOfClass:[UIView class]]) {
                [oneView removeFromSuperview];
            }
        }
        [myProxyImgView addSubview:addPorxyPeople];
        [myProxyImgView addSubview:myProxyHeadView];
        [myProxyImgView addSubview:myProxyLabel];
        HYSmartInputModel *tempModel = [self.user.proxyList objectAtIndex:0];
        pepView.icon = [HYImageFactory GetImageByName:@"newtask_people" AndType:PNG];
        pepView.name = tempModel.name;
        [myProxyImgView addSubview:[pepView getViewWithWidth:35 iconHeight:35 nameWidth:35 nameHeight:15]];
        
        [addPorxyPeople removeFromSuperview];
        [myProxyImgView addSubview:delFirstPeople];
        
//        if(list != nil && [list count] != 0)
//        {
//            HYMyProxyModel *proxyModel = [list objectAtIndex:0];
//            proxyModel.proxyName = tempModel.name;
//            proxyModel.proxy = tempModel.accountName;
//        }
        
    }
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
