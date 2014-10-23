//
//  HYMessageViewController.m
//  keytask
//
//  Created by 许 玮 on 14-10-14.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYMessageViewController.h"
#import "HYImageFactory.h"
#import "HYConstants.h"
#import "HYMenuView.h"
#import "HYControlFactory.h"
#import "HYScreenTools.h"
#import "ChartMessage.h"
#import "ChartCellFrame.h"
#import "ChartCell.h"
#import "HYNetworkInterface.h"
#import "HYFunctionsModel.h"
#import "HYRecordModel.h"

static NSString *const cellIdentifier=@"MessageTab";
@interface HYMessageViewController ()
{
    BOOL isShowMenu;
    HYMenuView *menuView;
    UIImageView *bottomBgImgLittle;
    UIImageView *bottomBgImgMore;
    BOOL isLittle;
    UIScrollView *bgimg;
    UIImageView *bottomAddImg;
    UIImageView *bottomSpeak;
    UITextField *inputText;
    UIImageView *bottomUploadImgView;
    UIImageView *bottomUploadFileView;
    UIImageView *bottomUploadphotoView;
    UITableView *mainTableView;
    NSMutableArray *messages;
    UIImageView *speakImg;
    NSString *getRecordType;
    BOOL isSpeak;
    NSString *comment;
}

@end

@implementation HYMessageViewController
@synthesize taskModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    isShowMenu = NO;
    isLittle = YES;
    isSpeak = YES;
    getRecordType = @"page";
    [self getTaskDetils];
    
}

-(void)getTaskDetils
{
    [SVProgressHUD showWithStatus:@"正在获取信息..." maskType:SVProgressHUDMaskTypeGradient];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.token,@"Token",self.user.accountName,@"AccountName",@"GetModelByID4Mobile",@"opeType",taskModel.ID,@"TaskID",nil];
    
    NSURL *url = [[NSURL alloc] initWithString:TaskHandler_api];
    
    [[[DataProcessing alloc] init] sentRequest:url Parem:params Target:self];
}

-(void)getFunctions
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.token,@"Token",self.user.accountName,@"AccountName",@"GetFunctions",@"opeType",taskModel.ID,@"TaskID",nil];
    
    NSURL *url = [[NSURL alloc] initWithString:TaskHandler_api];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    if (params) {
        NSArray *array = [params allKeys];
        for (int i= 0; i <[array count]; i++) {
            [request setPostValue:[params objectForKey:[array objectAtIndex:i]] forKey:[array objectAtIndex:i]];
        }
    }
    [request setDidFinishSelector:@selector(endGetFunctionsFin:)];
    [request setDidFailSelector:@selector(endGetFunctionsFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) endGetFunctionsFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器连接失败";
    [self performSelectorOnMainThread:@selector(endGetFunctionsString:) withObject:responsestring waitUntilDone:YES];
}

- (void)endGetFunctionsFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetFunctionsString:) withObject:responsestring waitUntilDone:YES];
}

-(void)endGetFunctionsString:(NSString *)msg
{
    
    NSLog(@"msg = %@", msg);
    
    NSError *error;
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSString *result = [json objectForKey:@"Success"];
    if([result boolValue])
    {
        NSArray *contents = [json objectForKey:@"Content"];
        if([contents count] <= 0)
        {
            [SVProgressHUD showSuccessWithStatus:@"没有权限!"];
            return;
        }
        NSDictionary *content = [contents objectAtIndex:0];
        HYFunctionsModel *functionsModel = [[HYFunctionsModel alloc] init];
        functionsModel.auditF = [content objectForKey:@"Audit"];
        functionsModel.editF = [content objectForKey:@"Edit"];
        functionsModel.deleteF = [content objectForKey:@"Delete"];
        functionsModel.finishF = [content objectForKey:@"Finish"];
        functionsModel.endF = [content objectForKey:@"END"];
        functionsModel.discussF = [content objectForKey:@"Discuss"];
        functionsModel.receiverF = [content objectForKey:@"Receiver"];
        NSLog(@"taskModel.initiator = %@", taskModel.initiator);
        NSLog(@"taskModel.initiator = %@", self.user.accountName);
        NSLog(@"[taskModel.initiator isEqual:self.user.accountName] = %d", [taskModel.initiator isEqual:self.user.accountName]);
        NSLog(@"[taskModel.executor isEqual:self.user.accountName] = %d", [taskModel.executor isEqual:self.user.accountName]);
        if([taskModel.initiator isEqual:self.user.accountName] || [taskModel.executor isEqual:self.user.accountName])
        {
            functionsModel.forwardingF = @"True";
        }
        taskModel.functions = functionsModel;
    }else
    {
        [super logoutAction];
    }
    
    [self initMainTableData];
    
}

-(void)endFailedRequest:(NSString *)msg
{
    NSLog(@"%@",msg);
}

-(void)endRequest:(NSString *)msg
{
    NSLog(@"msg = %@", msg);
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
        taskModel.initiator = [content objectForKey:@"Initiator"];
        taskModel.initiatorName = [content objectForKey:@"InitiatorName"];
        taskModel.executor = [content objectForKey:@"Executor"];
        taskModel.executorName = [content objectForKey:@"ExecutorName"];
        taskModel.endTime = [content objectForKey:@"EndTime"];
        taskModel.paticrpant = [content objectForKey:@"Paticrpant"];
        taskModel.paticrpantName = [content objectForKey:@"PaticrpantName"];
        taskModel.documentMarker = [content objectForKey:@"DocumentMarker"];
        taskModel.goal = [content objectForKey:@"Goal"];
        taskModel.days = [content objectForKey:@"Days"];
        taskModel.product = [content objectForKey:@"Product"];
        taskModel.description = [content objectForKey:@"Description"];
        taskModel.status = [content objectForKey:@"TaskStatus"];
        
        
    }else
    {
        [super logoutAction];
    }
    
    [self getFunctions];
}


-(void)initControl
{
    menuView = [[HYMenuView alloc] init];
    [menuView initWithIcons:[taskModel.functions getIcons] showNames:[taskModel.functions getShowNames] bgImgName:@"kuang" model:taskModel user:self.user];
    
    bgimg = [HYControlFactory GetScrollViewWithCGRect:CGRectMake(0 , [HYScreenTools getStatusHeight] + [[self getNavigationController] getNavigationHeight], [HYScreenTools getScreenWidth], [HYScreenTools getScreenHeight] - [HYScreenTools getStatusHeight] - [[self getNavigationController] getNavigationHeight]) backgroundColor:[UIColor clearColor] backImgName:nil delegate:self];
    
    [self.view addSubview:bgimg];
    

    
    //bottom little
    bottomBgImgLittle = [HYControlFactory GetImgViewWithCGRect:CGRectMake(0, bgimg.frame.size.height - 44, [HYScreenTools getScreenWidth], 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:NO closeKeyboard:YES isFrame:YES];
    [bgimg addSubview:bottomBgImgLittle];
    
    bottomAddImg = [HYControlFactory GetImgViewWithCGRect:CGRectMake(7, 7, 30, 30) backgroundImgName:@"jia" backgroundColor:nil isCornerRadius:NO closeKeyboard:YES isFrame:NO];
    [bottomBgImgLittle addSubview:bottomAddImg];
    
    [bottomAddImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomAddAction:)]];
    
    bottomSpeak = [HYControlFactory GetImgViewWithCGRect:CGRectMake([HYScreenTools getScreenWidth] - 66, 5, 60, 34) backgroundImgName:@"lis" backgroundColor:nil isCornerRadius:NO closeKeyboard:YES isFrame:NO];
    
    
    [bottomSpeak addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomSpeakAction:)]];
    
    [bottomBgImgLittle addSubview:bottomSpeak];
    
    inputText = [HYControlFactory GetTextFieldWithCGRect:CGRectMake(44, 4, [HYScreenTools getScreenWidth] - 116, 36) Placeholder:nil SecureTextEntry:NO];
    speakImg = [HYControlFactory GetImgViewWithCGRect:CGRectMake(44, 4, [HYScreenTools getScreenWidth] - 116, 36) backgroundImgName:@"tangchuangbtn" backgroundColor:nil isCornerRadius:NO closeKeyboard:YES isFrame:NO];
    
    [inputText setBackground:[HYImageFactory GetImageByName:@"msg_input" AndType:PNG]];
    inputText.delegate = self;
    [bottomBgImgLittle addSubview:inputText];
    
    bottomUploadImgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(([HYScreenTools getScreenWidth] / 4) - 22, (inputText.frame.origin.y + inputText.frame.size.height + 7), 44, 44) backgroundImgName:@"msg_image" backgroundColor:nil isCornerRadius:NO closeKeyboard:YES isFrame:NO];
    
    bottomUploadphotoView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(([HYScreenTools getScreenWidth] / 2) - 22 , bottomUploadImgView.frame.origin.y, 44, 44) backgroundImgName:@"msg_photo" backgroundColor:nil isCornerRadius:NO closeKeyboard:YES isFrame:NO];
    
    bottomUploadFileView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(([HYScreenTools getScreenWidth] / 4) * 3 - 22, bottomUploadImgView.frame.origin.y, 44, 44) backgroundImgName:@"msg_file" backgroundColor:nil isCornerRadius:NO closeKeyboard:YES isFrame:NO];
    
    //bottom more
    bottomBgImgMore = [HYControlFactory GetImgViewWithCGRect:CGRectMake(0, bgimg.frame.size.height - 100, [HYScreenTools getScreenWidth], 100) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:NO closeKeyboard:YES isFrame:YES];
//    [bottomBgImgMore addSubview:bottomAddImg];
//    [bottomBgImgMore addSubview:bottomSpeak];
//    [bottomBgImgMore addSubview:inputText];

    //mainTableView
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [HYScreenTools getScreenWidth], (bgimg.frame.size.height - 44)) style:UITableViewStylePlain];
    
    [mainTableView registerClass:[ChartCell class] forCellReuseIdentifier:cellIdentifier];
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    mainTableView.allowsSelection = NO;
    mainTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg_background"]];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    [bgimg addSubview:mainTableView];
    
    //mainTableData
    
    
//    UIScrollView *mainScrollView = [HYControlFactory GetScrollViewWithCGRect: backgroundColor:nil backImgName:@"msg_background" delegate:self];
//    [bgimg addSubview:mainScrollView];
    
    
}

-(void)firstGetRecord
{
   
    NSDate *dateTime = [[NSDate alloc] init];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *stringDate = [dateFormatter stringFromDate:dateTime];
    
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.token,@"Token",@"GetRecord",@"opeType",taskModel.ID,@"TaskID",self.user.accountName,@"AccountName",getRecordType,@"Type",stringDate,@"Time",@"0",@"page",@"10",@"rows",nil];
    
    
    NSURL *url = [[NSURL alloc] initWithString:TaskHandler_api];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    if (params) {
        NSArray *array = [params allKeys];
        for (int i= 0; i <[array count]; i++) {
            [request setPostValue:[params objectForKey:[array objectAtIndex:i]] forKey:[array objectAtIndex:i]];
        }
    }
    [request setDidFinishSelector:@selector(endFirstGetRecord:)];
    [request setDidFailSelector:@selector(endFirstGetRecordFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) endFirstGetRecord:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endFirstGetRecordString:) withObject:responsestring waitUntilDone:YES];
}

-(void)endFirstGetRecordString:(NSString *)msg
{
    [self initControl];
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
        NSArray *recordList = [content objectForKey:@"RecordList"];
        for (int i = 0; i < [recordList count]; i++) {
            NSDictionary *dic = [recordList objectAtIndex:i];
            HYRecordModel *recordModel = [[HYRecordModel alloc] init];
            recordModel.taskID = [dic objectForKey:@"TaskID"];
            recordModel.operate = [dic objectForKey:@"Operate"];
            recordModel.accountName = [dic objectForKey:@"AccountName"];
            recordModel.userName = [dic objectForKey:@"UserName"];
            recordModel.type = [dic objectForKey:@"Type"];
            recordModel.createTime = [dic objectForKey:@"CreateTime"];
            recordModel.files = [dic objectForKey:@"Files"];
            recordModel.ID = [dic objectForKey:@"ID"];
            recordModel.headImg = [dic objectForKey:@"HeadImg"];
            recordModel.proxy = [dic objectForKey:@"Proxy"];
            recordModel.proxyName  = [dic objectForKey:@"ProxyName"];
            if(taskModel.recordList == nil)
            {
                taskModel.recordList = [[NSMutableArray alloc] init];
            }
            [taskModel.recordList addObject:recordModel];
        }
    }else
    {
        [super logoutAction];
    }
    
    for (int i = ([taskModel.recordList count] - 1); i >= 0; i--) {
        HYRecordModel *tempModel = [taskModel.recordList objectAtIndex:i];
        ChartCellFrame *cellFrame = [[ChartCellFrame alloc]init];
        ChartMessage *chartMessage = [[ChartMessage alloc]init];
        chartMessage.icon = tempModel.headImg;
        chartMessage.time = tempModel.createTime;
        if([tempModel.type isEqual:@"1"])
        {
            chartMessage.iconLabelText = @"系统";
            chartMessage.icon = @"Icon";
            chartMessage.content = @"";
            chartMessage.content = [chartMessage.content stringByAppendingString:tempModel.userName];
            chartMessage.content = [chartMessage.content stringByAppendingString:@":"];
            chartMessage.content = [chartMessage.content stringByAppendingString:tempModel.operate];
            chartMessage.messageType = messageSys;
        }else if([tempModel.accountName isEqual:self.user.accountName])
        {
            chartMessage.icon = @"newtask_people";
            chartMessage.messageType = messageTo;
            chartMessage.content = tempModel.operate;
        }else
        {
            chartMessage.icon = @"newtask_people";
            chartMessage.messageType = messageFrom;
            chartMessage.content = tempModel.operate;
        }
        if(![tempModel.type isEqual:@"1"])
        {
            chartMessage.iconLabelText = tempModel.userName;
        }
        cellFrame.chartMessage = chartMessage;
        if(messages == nil)
        {
            messages = [[NSMutableArray alloc] init];
        }
        [messages addObject:cellFrame];
    }
//
    [mainTableView reloadData];
    [self tableViewScrollCurrentIndexPath];
    [SVProgressHUD dismiss];
    
}

- (void) endFirstGetRecordFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器连接失败";
    [self performSelectorOnMainThread:@selector(endFirstGetRecordString:) withObject:responsestring waitUntilDone:YES];
}

-(void)initMainTableData
{
    //GetRecord
    
    [self firstGetRecord];
}

#pragma textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMessage];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self tableViewScrollCurrentIndexPath];
    return YES;
}

#pragma tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"message count = %d", [messages count]);
    return messages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChartCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.cellFrame = messages[indexPath.row];
    return cell;
    
}

-(void)tableViewScrollCurrentIndexPath
{
    NSLog(@"messages count %d", [messages count]);
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:messages.count-1 inSection:0];
    [mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [messages[indexPath.row] cellHeight];
}

-(void)bottomSpeakAction:(UIGestureRecognizer *)gestureRecognizer
{
    if(isSpeak)
    {
        [inputText removeFromSuperview];
        if(isLittle)
        {
            [bottomBgImgLittle addSubview:speakImg];
        }else
        {
            [bottomBgImgMore addSubview:speakImg];
        }
        
    }else
    {
        [speakImg removeFromSuperview];
        if(isLittle)
        {
            [bottomBgImgLittle addSubview:inputText];
        }else
        {
            [bottomBgImgMore addSubview:inputText];
        }
    }
    isSpeak = !isSpeak;
}

-(void)bottomAddAction:(UIGestureRecognizer *)gestureRecognizer
{
    if(isLittle)
    {
        [bottomAddImg setImage:[HYImageFactory GetImageByName:@"jia2" AndType:PNG]];
        [bottomBgImgLittle removeFromSuperview];
        [bottomBgImgMore addSubview:bottomAddImg];
        [bottomBgImgMore addSubview:bottomSpeak];
        [bottomBgImgMore addSubview:inputText];
        [bottomBgImgMore addSubview:bottomUploadImgView];
        [bottomBgImgMore addSubview:bottomUploadphotoView];
        [bottomBgImgMore addSubview:bottomUploadFileView];
        [bgimg addSubview:bottomBgImgMore];
    }else
    {
        [bottomAddImg setImage:[HYImageFactory GetImageByName:@"jia" AndType:PNG]];
        [bottomBgImgMore removeFromSuperview];
        [bottomBgImgLittle addSubview:bottomAddImg];
        [bottomBgImgLittle addSubview:bottomSpeak];
        [bottomBgImgLittle addSubview:inputText];
        [bgimg addSubview:bottomBgImgLittle];
    }
    isLittle = !isLittle;
    
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
    [[self getNavigationController] setLeftTittle:taskModel.name];
    [[self getNavigationController] setLeftTittleFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [[self getNavigationController] setLeftTittleColor:[UIColor whiteColor]];
    
    [[self getNavigationController] setRightButtonImage:[HYImageFactory GetImageByName:@"message_rightButton" AndType:PNG]];
    //    [[self getNavigationController] hideRightButton];
    [[self getNavigationController] showLeftButton];
    [[self getNavigationController] showLeftTittle];
    [[self getNavigationController] showRightButton];
    [self bindAction];
    [self tableViewScrollCurrentIndexPath];

}

-(void)bindAction
{
    [[self getNavigationController] setLeftButtonTarget:nil action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [[self getNavigationController] removeRightTarget];
    [[self getNavigationController] setRightButtonTarget:nil action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)showMenu:(id)sender
{
    if(!isShowMenu)
    {
        [self.view addSubview:menuView];
    }else
    {
        [menuView removeFromSuperview];
    }
    isShowMenu = !isShowMenu;
}

-(void)backAction:(id)sender
{
    [[self getNavigationController] popController:self];
}

-(void)sendMessage
{
    if([taskModel.functions getDisuss])
    {
        if([inputText.text isEqual:@""])
        {
            [SVProgressHUD showErrorWithStatus:@"评论不能为空！"];
            return;
        }
        ChartCellFrame *cellFrame=[[ChartCellFrame alloc]init];
        ChartMessage *chartMessage=[[ChartMessage alloc]init];
        chartMessage.icon = self.user.headImg;
        chartMessage.icon = @"newtask_people";
        chartMessage.iconLabelText = self.user.username;
        chartMessage.messageType = messageTo;
        chartMessage.content = inputText.text;
        cellFrame.chartMessage=chartMessage;
        [messages addObject:cellFrame];
        [mainTableView reloadData];
        comment = inputText.text;
        //滚动到当前行
        [self threadSendMsg];
//        [NSThread detachNewThreadSelector:@selector(threadSendMsg) toTarget:self withObject:nil];
        [self tableViewScrollCurrentIndexPath];
        inputText.text = @"";
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"没有评论权限！"];
    }
}

-(void)threadSendMsg
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.token,@"Token",@"Comment",@"opeType",taskModel.ID,@"TaskID",self.user.accountName,@"AccountName",comment,@"Comment",nil];
    
    
    NSURL *url = [[NSURL alloc] initWithString:TaskHandler_api];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    if (params) {
        NSArray *array = [params allKeys];
        for (int i= 0; i <[array count]; i++) {
            [request setPostValue:[params objectForKey:[array objectAtIndex:i]] forKey:[array objectAtIndex:i]];
        }
    }
    [request setDidFinishSelector:@selector(endThreadSendMsg:)];
    [request setDidFailSelector:@selector(endThreadSendMsgFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) endThreadSendMsgFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器连接失败";
    [self performSelectorOnMainThread:@selector(endThreadSendMsgString:) withObject:responsestring waitUntilDone:YES];
}

-(void)endThreadSendMsg:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endThreadSendMsgString:) withObject:responsestring waitUntilDone:YES];
}

-(void)endThreadSendMsgString:(NSString *)msg
{
    NSLog(@"msg = %@", msg);
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
