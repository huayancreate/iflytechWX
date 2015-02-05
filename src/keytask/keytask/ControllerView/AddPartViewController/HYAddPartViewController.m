//
//  HYAddPartViewController.m
//  keytask
//
//  Created by 许 玮 on 14-10-23.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYAddPartViewController.h"
#import "HYControlFactory.h"
#import "HYScreenTools.h"
#import "HYConstants.h"
#import "HYPeopleInfoView.h"
#import "HYImageFactory.h"
#import "HYSmartInputViewController.h"
#import "HYSmartInputModel.h"
#import "HYNetworkInterface.h"
#import "HYSmartInputModel.h"
#import "HYHelper.h"

@interface HYAddPartViewController ()
{
    UIScrollView *scrollView;
    UIImageView *taskPartBgView;
    UIImageView *addPartPeople;
    NSMutableArray *partList;
    NSMutableArray *partNameList;
    NSString *paticrpantString;
    NSString *paticrpantNameString;
    UILabel *taskPartLabel;
    UIButton *okButton;
    BOOL isSubmit;
    NSString *firstHeadImgUrlStr;
    NSString *startHeadImgUrlStr;
    NSMutableDictionary *headImgDic;
    NSMutableArray *partHeadImgArray;
    NSMutableArray *allHeadImgArray;
    UIImageView *delPartPeople;
    UIImageView *reverPartPeople;
}

@end

@implementation HYAddPartViewController
@synthesize taskModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self bindAction];
    [self initControl];
    paticrpantString = @"";
    paticrpantNameString = @"";
    isSubmit = NO;
    firstHeadImgUrlStr = @"";
    startHeadImgUrlStr = @"";
    headImgDic = [[NSMutableDictionary alloc] init];
    partHeadImgArray = [[NSMutableArray alloc] init];
    allHeadImgArray = [[NSMutableArray alloc] init];
    
}

-(void)bindAction
{
    if(!isSubmit)
    {
        
    }
    [[self getNavigationController] setLeftButtonTarget:nil action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)backAction:(id)sender
{
    [[self getNavigationController] popController:self];
}

-(void)delPartPeopleActionView:(UIGestureRecognizer *)gestureRecognizer
{
    HYPeopleInfoView *delCurrentPartView = (HYPeopleInfoView *)gestureRecognizer.view;
    [delCurrentPartView removeFromSuperview];
    for (int i = 0 ; i < [self.user.partList count]; i++) {
        HYSmartInputModel *smartModel = [self.user.partList objectAtIndex:i];
        if([smartModel.accountName isEqual:delCurrentPartView.accountName])
        {
            [self.user.partList removeObjectAtIndex:i];
            break;
        }
    }
    for (int i = 0 ; i < [self.user.isAddPartViewList count]; i++) {
        HYSmartInputModel *smartModel = [self.user.isAddPartViewList objectAtIndex:i];
        if([smartModel.accountName isEqual:delCurrentPartView.accountName])
        {
            [self.user.isAddPartViewList removeObjectAtIndex:i];
            break;
        }
    }
    for (int i = 0; i < [partHeadImgArray count]; i++) {
        HYPeopleInfoView *pepView = [partHeadImgArray objectAtIndex:i];
        for (int j = 0; j < [partList count]; j++) {
            NSString *partName = [partList objectAtIndex:j];
            if(![pepView.accountName isEqual:partName])
            {
                [pepView addDelView];
                [pepView getView].userInteractionEnabled = YES;
                UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delPartPeopleActionView:)];
                [[pepView getView] addGestureRecognizer:tapRecognizer];
            }
        }
    }
    [delPartPeople removeFromSuperview];
    [taskPartBgView addSubview:reverPartPeople];
    [addPartPeople removeFromSuperview];
//    [self addPartPeopleView];
}


-(void)delPartPeopleAction:(UIGestureRecognizer *)gestureRecognizer
{
    //    [firstPepopleInfo addDelView];
    for (int i = 0; i < [partHeadImgArray count]; i++) {
        HYPeopleInfoView *pepView = [partHeadImgArray objectAtIndex:i];
        BOOL checkModelFlag = NO;
        for (int j = 0; j < [partList count]; j++) {
            NSString *partName = [partList objectAtIndex:j];
            if([pepView.accountName isEqual:partName])
            {
                checkModelFlag = YES;
            }
        }
        if(!checkModelFlag)
        {
            [pepView addDelView];
            [pepView getView].userInteractionEnabled = YES;
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delPartPeopleActionView:)];
            [[pepView getView] addGestureRecognizer:tapRecognizer];
        }
    }
    [delPartPeople removeFromSuperview];
    [taskPartBgView addSubview:reverPartPeople];
    [addPartPeople removeFromSuperview];
    //    [firstManBgView addSubview:reverFirstPeople];
    //    [[firstPepopleInfo getView] addGestureRecognizer:delPeopleViewRecognizer];
}

-(void)reverPartPeopleAction:(UIGestureRecognizer *)gestureRecognizer
{
    for (int i = 0; i < [partHeadImgArray count]; i++) {
        HYPeopleInfoView *pepView = [partHeadImgArray objectAtIndex:i];
        [pepView removeDelView];
        [pepView getView].userInteractionEnabled = NO;
        //        [[pepView getView] removeGestureRecognizer:delPartPeopleViewRecognizer];
    }
    [reverPartPeople removeFromSuperview];
    [taskPartBgView addSubview:addPartPeople];
    [taskPartBgView addSubview:delPartPeople];
}

-(void)initControl
{
    scrollView = [HYControlFactory GetScrollViewWithCGRect:CGRectMake(0,([HYScreenTools getStatusHeight] +  [[self getNavigationController] getNavigationHeight]), [HYScreenTools getScreenWidth], ([HYScreenTools getScreenHeight] - [HYScreenTools getStatusHeight] -[[self getNavigationController] getNavigationHeight])) backgroundColor:[UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f] backImgName:nil delegate:self];
    [self.view addSubview:scrollView];
    
    UIImageView *firstManBgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, 8, ([HYScreenTools getScreenWidth] - 16), 60) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:YES closeKeyboard:YES isFrame:NO];
    
    UILabel *firstManLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(4, 15, 90, 30) textfont:[UIFont fontWithName:FONT_BOLD size:14] text:FIRST_MAN_LABEL textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    
    HYPeopleInfoView *firstpepopleInfo = [[HYPeopleInfoView alloc] initWithFrame:CGRectMake(95, 5, 35, 50)];
    firstpepopleInfo.icon = [HYImageFactory GetImageByName:@"newtask_people" AndType:PNG];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getFirstHeadImg:taskModel.executor];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(firstHeadImgUrlStr != nil && ![firstHeadImgUrlStr isEqual:@""])
            {
                [firstpepopleInfo setHeadImgUrlStr:firstHeadImgUrlStr];
            }
        });
    });
    
    firstpepopleInfo.name = taskModel.executorName;
    
    [firstManBgView addSubview:[firstpepopleInfo getViewWithWidth:35 iconHeight:35 nameWidth:35 nameHeight:15]];
    
    [firstManBgView addSubview:firstManLabel];
    
    [scrollView addSubview:firstManBgView];
    
    UIImageView *startNameBgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, 72, ([HYScreenTools getScreenWidth] - 16), 60) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:YES closeKeyboard:YES isFrame:NO];
    
    HYPeopleInfoView *pepopleInfo = [[HYPeopleInfoView alloc] initWithFrame:CGRectMake(95, 5, 35, 50)];
    pepopleInfo.icon = [HYImageFactory GetImageByName:@"newtask_people" AndType:PNG];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getStartHeadImg:taskModel.initiator];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(startHeadImgUrlStr != nil)
            {
                [pepopleInfo setHeadImgUrlStr:startHeadImgUrlStr];
            }
        });
    });
    
    pepopleInfo.name = taskModel.initiatorName;
    
    UILabel *startNameLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(4, 15, 90, 30) textfont:[UIFont fontWithName:FONT_BOLD size:14] text:START_NAME_LABEL textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    [startNameBgView addSubview:startNameLabel];
    [startNameBgView addSubview:[pepopleInfo getViewWithWidth:35 iconHeight:35 nameWidth:35 nameHeight:15]];
    
    [scrollView addSubview:startNameBgView];
    
    taskPartLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(10, (startNameBgView.frame.origin.y + startNameBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 30) textfont:[UIFont fontWithName:FONT_BOLD size:14] text:TASK_PART_LABEL textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    [scrollView addSubview:taskPartLabel];
    
    taskPartBgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, (taskPartLabel.frame.origin.y + taskPartLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 60) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:YES closeKeyboard:YES isFrame:NO];
    
    addPartPeople = [HYControlFactory GetImgViewWithCGRect:CGRectMake((taskPartBgView.frame.size.width) - 44 , 12.5f, 35, 35) backgroundImgName:@"newtask_add" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [addPartPeople addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPartPeopleAction:)]];
    
    reverPartPeople = [HYControlFactory GetImgViewWithCGRect:CGRectMake((firstManBgView.frame.size.width) - 44 , 12.5f, 35, 35) backgroundImgName:@"taskrever" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [reverPartPeople addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reverPartPeopleAction:)]];
    
    delPartPeople = [HYControlFactory GetImgViewWithCGRect:CGRectMake((taskPartBgView.frame.size.width) - 44 , 56.5f, 35, 35) backgroundImgName:@"newtask_del" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [delPartPeople addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delPartPeopleAction:)]];
    
    [taskPartBgView addSubview:addPartPeople];
    
    [scrollView addSubview:taskPartBgView];
    
    
    
//    okButton = [HYControlFactory GetButtonWithCGRect:CGRectMake(8, (taskPartBgView.frame.origin.y + taskPartBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44) backgroundImg:@"newtask_ok" selectBackgroundImgName:@"newtask_ok_hover" addTarget:self action:@selector(_submitAction) forControlEvents:UIControlEventTouchUpInside];
//    [okButton setTitle:@"添     加" forState:UIControlStateNormal];
//    [okButton.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:20]];
//    [okButton.titleLabel setTextColor:[UIColor whiteColor]];
//    [okButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [scrollView addSubview:okButton];
}

-(void)getStartHeadImg:(NSString *)accountName
{
    if(self.user == nil)
    {
        self.user = [HYHelper getUser];
    }
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
    [request setDidFinishSelector:@selector(endGetStartHeadImgFin:)];
    [request setDidFailSelector:@selector(endGetStartHeadImgFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startSynchronous];
}

- (void) endGetStartHeadImgFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetStartHeadImgString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endGetStartHeadImgFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetStartHeadImgStringFail:) withObject:responsestring waitUntilDone:YES];
}

-(void)endGetStartHeadImgStringFail:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"服务器连接失败,请检查网络!"];
    //    [self logoutAction];
}

-(void)endGetStartHeadImgString:(NSString *)msg
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
        //firstHeadImgUrlStr = headImgUrl;
        startHeadImgUrlStr = headImgUrl;
    }else
    {
        //        [self logoutAction];
    }
}

-(void)getFirstHeadImg:(NSString *)accountName
{
    if(self.user == nil)
    {
        self.user = [HYHelper getUser];
    }
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
    [request setDidFinishSelector:@selector(endGetFirstHeadImgFin:)];
    [request setDidFailSelector:@selector(endGetFirstHeadImgFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startSynchronous];
}

- (void) endGetFirstHeadImgFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetFirstHeadImgString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endGetFirstHeadImgFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetFirstHeadImgStringFail:) withObject:responsestring waitUntilDone:YES];
}

-(void)endGetFirstHeadImgStringFail:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"服务器连接失败,请检查网络!"];
    //    [self logoutAction];
}

-(void)endGetFirstHeadImgString:(NSString *)msg
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
        firstHeadImgUrlStr = headImgUrl;
        //        startHeadImgUrlStr = headImgUrl;
    }else
    {
        //        [self logoutAction];
    }
}

-(void)addPartPeopleView
{
    //添加参与人
    if(self.user.partList != nil)
    {
        paticrpantString = @"";
        paticrpantNameString = @"";
        for (UIImageView *oneView in taskPartBgView.subviews ) {
            if ([oneView isKindOfClass:[UIView class]]) {
                [oneView removeFromSuperview];
            }
        }
        [taskPartBgView addSubview:addPartPeople];
        int line = 0;
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        [headImgDic removeAllObjects];
        [partHeadImgArray removeAllObjects];
        [allHeadImgArray removeAllObjects];
        for (int i = 0; i < [self.user.partList count]; i++) {
            HYSmartInputModel *smartModel = [self.user.partList objectAtIndex:i];
            line = i / 4;
            int modeline = i % 4;
            HYPeopleInfoView *partPeople = [[HYPeopleInfoView alloc] initWithFrame:CGRectMake(10 + modeline * 50, 5 + line * 65, 45, 60)];
            partPeople.name = smartModel.name;
            partPeople.accountName = smartModel.accountName;
            dispatch_group_async(group, queue, ^{
                [self getPartHeadImg:smartModel.accountName];
            });
            [allHeadImgArray addObject:partPeople];
            for (int j = 0; j < [self.user.isAddPartViewList count]; j++) {
                HYSmartInputModel *testModel = [self.user.isAddPartViewList objectAtIndex:j];
                if([testModel.accountName isEqual:smartModel.accountName])
                {
                    [partHeadImgArray addObject:partPeople];
                    break;
                }
            }
            partPeople.icon = [HYImageFactory GetImageByName:@"newtask_people" AndType:PNG];
            [taskPartBgView addSubview:[partPeople getViewWithWidth:45 iconHeight:45 nameWidth:45 nameHeight:15]];
            paticrpantString = [paticrpantString stringByAppendingString:smartModel.accountName];
            paticrpantNameString = [paticrpantNameString stringByAppendingString:smartModel.name];
            if(i != ([self.user.partList count] -1))
            {
                paticrpantString = [paticrpantString stringByAppendingString:@","];
                paticrpantNameString = [paticrpantNameString stringByAppendingString:@","];
            }
        }
//        taskModel.paticrpant = paticrpantString;
//        taskModel.paticrpantName = paticrpantNameString;
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            for (int j = 0; j < [allHeadImgArray count]; j++) {
                HYPeopleInfoView *partPeopleView = [allHeadImgArray objectAtIndex:j];
                [partPeopleView setHeadImgUrlStr:[headImgDic objectForKey:partPeopleView.accountName]];
            }
        });
        [taskPartBgView setFrame:CGRectMake(8, (taskPartLabel.frame.origin.y + taskPartLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), (70 * line + 70))];
        
        if(self.user.isAddPartViewList != nil && [self.user.isAddPartViewList count] != 0)
        {
            if(line < 1)
            {
                [taskPartBgView setFrame:CGRectMake(8, (taskPartLabel.frame.origin.y + taskPartLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 120)];
            }else
            {
                [taskPartBgView setFrame:CGRectMake(8, (taskPartLabel.frame.origin.y + taskPartLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), (70 * line + 70))];
            }
            [taskPartBgView addSubview:delPartPeople];
        }
            
    }
    
    if(![taskModel.paticrpant isEqual:@""] && self.user.partList == nil)
    {
        partList = [taskModel.paticrpant componentsSeparatedByString:@","];
        partNameList = [taskModel.paticrpantName componentsSeparatedByString:@","];
        
        int partCount = 0;
        if([partList count] < [partNameList count])
        {
            partCount = [partList count];
        }else
        {
            partCount = [partNameList count];
        }
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        [headImgDic removeAllObjects];
        [partHeadImgArray removeAllObjects];
        int line = 0;
        for (int i = 0; i < partCount; i++) {
            line = i / 4;
            int modeline = i % 4;
            HYPeopleInfoView *partPeople = [[HYPeopleInfoView alloc] initWithFrame:CGRectMake(10 + modeline * 50, 5 + line * 65, 45, 60)];
            partPeople.accountName = [partList objectAtIndex:i];
            partPeople.name = [partNameList objectAtIndex:i];
            dispatch_group_async(group, queue, ^{
                [self getPartHeadImg:[partList objectAtIndex:i]];
            });
            [partHeadImgArray addObject:partPeople];
            partPeople.icon = [HYImageFactory GetImageByName:@"newtask_people" AndType:PNG];
            [taskPartBgView addSubview:[partPeople getViewWithWidth:45 iconHeight:45 nameWidth:45 nameHeight:15]];
        }
        
        [taskPartBgView setFrame:CGRectMake(8, (taskPartLabel.frame.origin.y + taskPartLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), (70 * line + 70))];
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            for (int j = 0; j < [partHeadImgArray count]; j++) {
                HYPeopleInfoView *partPeopleView = [partHeadImgArray objectAtIndex:j];
                [partPeopleView setHeadImgUrlStr:[headImgDic objectForKey:partPeopleView.accountName]];
            }
        });
    }
    
    [okButton removeFromSuperview];
    okButton = [HYControlFactory GetButtonWithCGRect:CGRectMake(8, (taskPartBgView.frame.origin.y + taskPartBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44) backgroundImg:@"newtask_ok" selectBackgroundImgName:@"newtask_ok_hover" addTarget:self action:@selector(_submitAction) forControlEvents:UIControlEventTouchUpInside];
    [okButton setTitle:@"添     加" forState:UIControlStateNormal];
    [okButton.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:20]];
    [okButton.titleLabel setTextColor:[UIColor whiteColor]];
    [okButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [scrollView addSubview:okButton];
    [scrollView setContentSize:CGSizeMake([HYScreenTools getScreenWidth],okButton.frame.origin.y + okButton.frame.size.height + 10 )];

}

-(void)getPartHeadImg:(NSString *)accountName
{
    if(self.user == nil)
    {
        self.user = [HYHelper getUser];
    }
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
    [request setDidFinishSelector:@selector(endGetPartHeadImgFin:)];
    [request setDidFailSelector:@selector(endGetPartHeadImgFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startSynchronous];
}

- (void) endGetPartHeadImgFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetPartHeadImgString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endGetPartHeadImgFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetPartHeadImgStringFail:) withObject:responsestring waitUntilDone:YES];
}

-(void)endGetPartHeadImgStringFail:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"服务器连接失败,请检查网络!"];
    //    [self logoutAction];
}

-(void)endGetPartHeadImgString:(NSString *)msg
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
        NSString *accountNameString = [content objectForKey:@"AccountName"];
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
        //firstHeadImgUrlStr = headImgUrl;
        [headImgDic setObject:headImgUrl forKey:accountNameString];
        //        [headImgArray addObject:headImgUrl];
    }else
    {
        //        [self logoutAction];
    }
}

-(void)addPartPeopleAction:(UIGestureRecognizer *)gestureRecognizer
{
    HYSmartInputViewController *smartInput = [[HYSmartInputViewController alloc] init];
    smartInput.excList = nil;
    smartInput.isFirstManInput = NO;
    smartInput.isAddPartViewInput = YES;
    smartInput.isProxyInput = NO;
    smartInput.partList = [[NSMutableArray alloc] init];
    if(![taskModel.paticrpant isEqual:@""])
    {
        NSArray *temppatArr = [taskModel.paticrpant componentsSeparatedByString:@","];
        NSArray *temppatnameArr = [taskModel.paticrpantName componentsSeparatedByString:@","];
        int partCount = 0;
        if([temppatArr count] < [temppatnameArr count])
        {
            partCount = [temppatArr count];
        }else
        {
            partCount = [temppatnameArr count];
        }
        for (int i = 0; i < partCount; i++) {
            HYSmartInputModel *tempSmartModel = [[HYSmartInputModel alloc] init];
            tempSmartModel.accountName = [temppatArr objectAtIndex:i];
            tempSmartModel.name = [temppatnameArr objectAtIndex:i];
            [smartInput.partList addObject:tempSmartModel];
        }
    }
    if(self.user.partList != nil)
    {
        smartInput.partList = self.user.partList;
    }
    if(self.user == nil)
    {
        self.user = [HYHelper getUser];
    }else
    {
        smartInput.user = self.user;
    }
    smartInput.title = @"智能输入";
    [[self getNavigationController] pushController:smartInput];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[[self getNavigationController] getView] setHidden:NO];
    [[[self getTabbarController] getView] setHidden:YES];
    [[self getNavigationController] setCenterTittle:[self title]];
    [[self getNavigationController] setLeftButtonImage:[HYImageFactory GetImageByName:@"leftButton" AndType:PNG]];
    [[self getNavigationController] setLeftTittleFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [[self getNavigationController] setLeftTittleColor:[UIColor whiteColor]];
    
    [[self getNavigationController] hideRightButton];
    [[self getNavigationController] showLeftButton];
    [[self getNavigationController] showLeftTittle];
//    int line = 0;
    if(taskModel.paticrpant != nil)
    {
        paticrpantString = taskModel.paticrpant;
    }else
    {
        paticrpantString = @"";
    }
    [okButton removeFromSuperview];
    okButton = [HYControlFactory GetButtonWithCGRect:CGRectMake(8, (taskPartBgView.frame.origin.y + taskPartBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44) backgroundImg:@"newtask_ok" selectBackgroundImgName:@"newtask_ok_hover" addTarget:self action:@selector(_submitAction) forControlEvents:UIControlEventTouchUpInside];
    [okButton setTitle:@"添     加" forState:UIControlStateNormal];
    [okButton.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:20]];
    [okButton.titleLabel setTextColor:[UIColor whiteColor]];
    [okButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [scrollView addSubview:okButton];
    [scrollView setContentSize:CGSizeMake([HYScreenTools getScreenWidth],okButton.frame.origin.y + okButton.frame.size.height + 10 )];
    
    [self addPartPeopleView];
}

-(void)_submitAction
{
    NSString *submitPaticrpantString = @"";
    if([self.user.isAddPartViewList count] == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"没有添加新参与人!"];
        return;
    }else
    {
        for (int i = 0; i < [self.user.isAddPartViewList count]; i++) {
            HYSmartInputModel *smartModel = [self.user.isAddPartViewList objectAtIndex:i];
            submitPaticrpantString = [submitPaticrpantString stringByAppendingString:smartModel.accountName];
            if(i != ([self.user.isAddPartViewList count] -1))
            {
                submitPaticrpantString = [submitPaticrpantString stringByAppendingString:@","];
            }
        }
    }
    [SVProgressHUD showWithStatus:@"正在添加参与人..." maskType:SVProgressHUDMaskTypeGradient];
    
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.token,@"Token",@"AddPaticrpants",@"opeType",self.user.accountName,@"AccountName",taskModel.ID,@"TaskID",submitPaticrpantString,@"Paticrpants",nil];
    
    NSURL *url = [[NSURL alloc] initWithString:TaskHandler_api];
    
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
            [SVProgressHUD dismiss];
            return;
        }
        NSDictionary *content = [contents objectAtIndex:0];
        [SVProgressHUD showSuccessWithStatus:[content objectForKey:@"message"]];
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
