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
#import "HYAudio.h"
#import "Pull2RefreshMsgTableView.h"
#import "HYHelper.h"

static NSString *const cellIdentifier=@"MessageTab";
@interface HYMessageViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    HYMenuView *menuView;
    UIImageView *bottomBgImgLittle;
    UIImageView *bottomBgImgMore;
    BOOL isLittle;
    UIScrollView *bgimg;
    UIImageView *bottomAddImg;
    UIButton *bottomSpeak;
    UITextView *inputText;
    UIImageView *bottomUploadImgView;
    UIImageView *bottomUploadFileView;
    UIImageView *bottomUploadphotoView;
    NSMutableArray *allMsg;
    NSMutableArray *messages;
    UIButton *speakButton;
    NSString *getRecordType;
    BOOL isSpeak;
    NSString *comment;
    HYAudio *audioARM;
    NSTimer *timer;
    NSTimer *compeletTimer;
    UIImageView *audioView;
    UIImagePickerController *camera;
    NSString *lastDateString;
    NSString *currentlastDateString;
    BOOL sendFlag;
    int currentPage;
    int pageCount;
    BOOL isDidDisappear;
}

@property (nonatomic, strong) Pull2RefreshMsgTableView *mainTableView;


@end

@implementation HYMessageViewController
@synthesize taskModel;
@synthesize mainTableView;
@synthesize connectionTimer;
@synthesize isMySend,isMySendSuccess;
@synthesize isImgFlag;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    audioARM = [[HYAudio alloc] init];
    isLittle = YES;
    isSpeak = YES;
    getRecordType = @"page";
    lastDateString = @"";
    currentlastDateString = @"";
    sendFlag = NO;
    currentPage = 0;
    pageCount = 1;
    allMsg = [[NSMutableArray alloc] init];
    isMySend = NO;
    isMySendSuccess = NO;
    isDidDisappear = NO;
    isImgFlag = NO;
    
    [self initControl];
}

-(void)getTaskDetils
{
//    [SVProgressHUD showWithStatus:@"正在获取信息..." maskType:SVProgressHUDMaskTypeGradient];
    
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
    [request setAuthenticationScheme:@"https"];
    [request setValidatesSecureCertificate:NO];
    [request setShouldAttemptPersistentConnection:NO];
    [request setDidFinishSelector:@selector(endGetFunctionsFin:)];
    [request setDidFailSelector:@selector(endGetFunctionsFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) endGetFunctionsFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器连接失败,请检查网络!";
    [self performSelectorOnMainThread:@selector(endGetFunctionsString:) withObject:responsestring waitUntilDone:YES];
}

- (void)endGetFunctionsFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetFunctionsString:) withObject:responsestring waitUntilDone:YES];
}

-(void)endGetFunctionsString:(NSString *)msg
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
        //NSLog(@"taskModel.initiator = %@", taskModel.initiator);
        //NSLog(@"taskModel.initiator = %@", self.user.accountName);
        //NSLog(@"[taskModel.initiator isEqual:self.user.accountName] = %d", [taskModel.initiator isEqual:self.user.accountName]);
        //NSLog(@"[taskModel.executor isEqual:self.user.accountName] = %d", [taskModel.executor isEqual:self.user.accountName]);
        functionsModel.forwardingF = @"True";
        taskModel.functions = functionsModel;
        
        
        menuView = [[HYMenuView alloc] init];
        [menuView setShow:NO];
        [menuView initWithIcons:[taskModel.functions getIcons] showNames:[taskModel.functions getShowNames] bgImgName:@"kuang" model:taskModel user:self.user functions:taskModel.functions mainTableView:mainTableView andController:self];
    }else
    {
        [super logoutAction];
    }
    
//    [self initMainTableData];
    
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
        taskModel.ID = [content objectForKey:@"TaskID"];
        taskModel.name = [content objectForKey:@"Name"];
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
        [[self getNavigationController] setLeftTittle:taskModel.name];
        
    }else
    {
        [super logoutAction];
        return;
    }
}


-(void)initControl
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name: UITextViewTextDidChangeNotification object:nil];
    
    audioView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(([HYScreenTools getScreenWidth] - 110) / 2, 100, 110, 128) backgroundImgName:nil backgroundColor:[UIColor clearColor] isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    
    bgimg = [HYControlFactory GetScrollViewWithCGRect:CGRectMake(0 , [HYScreenTools getStatusHeight] + [[self getNavigationController] getNavigationHeight], [HYScreenTools getScreenWidth], [HYScreenTools getScreenHeight] - [HYScreenTools getStatusHeight] - [[self getNavigationController] getNavigationHeight]) backgroundColor:[UIColor clearColor] backImgName:nil delegate:self];
    
    [self.view addSubview:bgimg];

    
    //bottom little
    bottomBgImgLittle = [HYControlFactory GetImgViewWithCGRect:CGRectMake(0, bgimg.frame.size.height - 44, [HYScreenTools getScreenWidth], 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:NO closeKeyboard:YES isFrame:YES];
    [bgimg addSubview:bottomBgImgLittle];
    
    bottomAddImg = [HYControlFactory GetImgViewWithCGRect:CGRectMake(7, bottomBgImgLittle.frame.size.height - 37, 30, 30) backgroundImgName:@"jia" backgroundColor:nil isCornerRadius:NO closeKeyboard:YES isFrame:NO];
    [bottomBgImgLittle addSubview:bottomAddImg];
    
    [bottomAddImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomAddAction:)]];
    
    bottomSpeak = [HYControlFactory GetButtonWithCGRect:CGRectMake([HYScreenTools getScreenWidth] - 66, 5, 60, 34) backgroundImg:@"lis" selectBackgroundImgName:@"lis" addTarget:self action:@selector(bottomSpeakAction:) forControlEvents:UIControlEventTouchUpInside];
                   
    [bottomBgImgLittle addSubview:bottomSpeak];
    
    inputText = [HYControlFactory GetTextViewWithCGRect:CGRectMake(44, 4, [HYScreenTools getScreenWidth] - 116, 36) isCornerRaidus:YES font:[UIFont fontWithName:FONT size:14] textColor:[UIColor blackColor]];
    
    inputText.delegate = self;
    
//    inputText = [HYControlFactory GetTextFieldWithCGRect:CGRectMake(44, 4, [HYScreenTools getScreenWidth] - 116, 36) Placeholder:nil SecureTextEntry:NO];
    
    speakButton = [HYControlFactory GetButtonWithCGRect:CGRectMake(44, 4, [HYScreenTools getScreenWidth] - 116, 36) backgroundImg:@"tangchuangbtn" selectBackgroundImgName:@"tangchuangbtn" addTarget:self action:@selector(longSpeakAction:) forControlEvents:UIControlEventTouchUpInside];
    [speakButton setTitle:@"按 住 说 话" forState:UIControlStateNormal];
    [speakButton.titleLabel setTextColor:[UIColor blackColor]];
    [speakButton.titleLabel setFont:[UIFont fontWithName:FONT size:15]];
    
    [speakButton addTarget:self action:@selector(speakButtonPressDown:) forControlEvents:UIControlEventTouchDown];
    [speakButton addTarget:self action:@selector(speakButtonPressUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
//    [speakButton setTitle:@"松 开 发 送" forState:uicontrols];
    
//    [inputText setBackgroundColor:[UIColor colorWithPatternImage:[HYImageFactory GetImageByName:@"msg_input" AndType:PNG]]];
    
//    [inputText setBackground:[HYImageFactory GetImageByName:@"msg_input" AndType:PNG]];
//    inputText.delegate = self;
    [bottomBgImgLittle addSubview:inputText];
    
    bottomUploadImgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(([HYScreenTools getScreenWidth] / 4) - 22, (inputText.frame.origin.y + inputText.frame.size.height + 7), 44, 44) backgroundImgName:@"msg_image" backgroundColor:nil isCornerRadius:NO closeKeyboard:YES isFrame:NO];
    
    [bottomUploadImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoBtnAction:)]];
    
    bottomUploadphotoView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(([HYScreenTools getScreenWidth] / 2) - 22 , bottomUploadImgView.frame.origin.y, 44, 44) backgroundImgName:@"msg_photo" backgroundColor:nil isCornerRadius:NO closeKeyboard:YES isFrame:NO];
    [bottomUploadphotoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraBtnAction:)]];
    
    bottomUploadFileView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(([HYScreenTools getScreenWidth] / 4) * 3 - 22, bottomUploadImgView.frame.origin.y, 44, 44) backgroundImgName:@"msg_file" backgroundColor:nil isCornerRadius:NO closeKeyboard:YES isFrame:NO];
    
    //bottom more
    bottomBgImgMore = [HYControlFactory GetImgViewWithCGRect:CGRectMake(0, bgimg.frame.size.height - 100, [HYScreenTools getScreenWidth], 100) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:NO closeKeyboard:YES isFrame:YES];
//    [bottomBgImgMore addSubview:bottomAddImg];
//    [bottomBgImgMore addSubview:bottomSpeak];
//    [bottomBgImgMore addSubview:inputText];

    //mainTableView
    mainTableView = [[Pull2RefreshMsgTableView alloc] initWithFrame:CGRectMake(0, 0, [HYScreenTools getScreenWidth], (bgimg.frame.size.height - 44)) showDragRefreshHeader:YES showDragRefreshFooter:NO];
    
    [mainTableView registerClass:[ChartCell class] forCellReuseIdentifier:cellIdentifier];
    mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    mainTableView.allowsSelection = NO;
    mainTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg_background"]];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    [bgimg addSubview:mainTableView];
    
    mainTableView.dragHeaderHeight = pull2RefreshHeaderHeight;
    mainTableView.dragFooterHeight = pull2RefreshFooterHeight;
    
    __weak HYMessageViewController *vc = self;
    mainTableView.dragEndBlock = ^(Pull2RefreshViewType type)
    {
        if (type == kPull2RefreshViewTypeHeader)
        {
//            ishead = true;
            [vc reloadInitDataInOtherThread];
        }
        else
        {
//            ishead = false;
//            [vc addMoreDataInOtherThread];
        }
    };
    
    //mainTableData
    
    
//    UIScrollView *mainScrollView = [HYControlFactory GetScrollViewWithCGRect: backgroundColor:nil backImgName:@"msg_background" delegate:self];
//    [bgimg addSubview:mainScrollView];
    
    
}

//- (void)textViewDidChange:(UITextView *)textView
//{
//    CGRect tmpRect = inputText.frame;
//    
//    CGSize size = [inputText.text sizeWithFont:[UIFont systemFontOfSize:_inputTextFontSize]
//                                  constrainedToSize:CGSizeMake(YOUR_TEXTVIEW_WIDTH, 2000)
//                                      lineBreakMode:NSLineBreakByWordWrapping];
//    
//    tmpRect.size.height = size.height + 20; // 20 points for padding
//    tmpRect.origin.y = keyboardPositionY - tmpRect.size.height;
//    
//    inputText.frame = tmpRect;
//    inputText.text = _inputTextView.text;
//}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [mainTableView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [mainTableView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}


-(void)reloadInitDataInOtherThread
{
    [self getHistoryRecord];
}

-(void)getHistoryRecord
{
    currentPage = currentPage + 1;
    if(currentPage == pageCount)
    {
        compeletTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(completeDragRefresh) userInfo:nil repeats:NO];
        currentPage = currentPage - 1;
    }else
    {
        [self getHistoryRecordPage:currentPage];
    }
//    currentPage = 0;
}

-(void)getHistoryRecordPage:(int)cPage
{
    [connectionTimer invalidate];
    connectionTimer = nil;
    NSDate *dateTime = [[NSDate alloc] init];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *stringDate = [dateFormatter stringFromDate:dateTime];
    
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.token,@"Token",@"GetRecord",@"opeType",taskModel.ID,@"TaskID",self.user.accountName,@"AccountName",getRecordType,@"Type",stringDate,@"Time",[NSString stringWithFormat:@"%d",cPage],@"page",@"10",@"rows",nil];
    
    
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
    [request setDidFinishSelector:@selector(endGetHistoryRecordPage:)];
    [request setDidFailSelector:@selector(endGetHistoryRecordPageFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) endGetHistoryRecordPage:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetHistoryRecordPageString:) withObject:responsestring waitUntilDone:YES];
}


- (void) endGetHistoryRecordPageFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器连接失败,请检查网络!";
    [self performSelectorOnMainThread:@selector(endGetHistoryRecordPageString:) withObject:responsestring waitUntilDone:YES];
}

-(void)endGetHistoryRecordPageString:(NSString *)msg
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
            [SVProgressHUD dismiss];
            [mainTableView completeDragRefresh];
            return;
        }
        NSDictionary *content = [contents objectAtIndex:0];
        lastDateString = [content objectForKey:@"LastTime"];
        NSArray *recordList = [content objectForKey:@"RecordList"];
        NSString *pageCountString = [content objectForKey:@"PageCount"];
        pageCount = [pageCountString intValue];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        tempArr = allMsg;
        
        allMsg = nil;
        allMsg = [[NSMutableArray alloc] init];
        
        if(taskModel.recordList != nil)
        {
            taskModel.recordList = nil;
            taskModel.recordList = [[NSMutableArray alloc] init];
        }else
        {
            taskModel.recordList = [[NSMutableArray alloc] init];
        }
        for (int i = 0; i < [recordList count]; i++) {
            NSDictionary *dic = [recordList objectAtIndex:i];
            HYRecordModel *recordModel = [[HYRecordModel alloc] init];
            recordModel.taskID = [dic objectForKey:@"TaskID"];
            recordModel.operate = [dic objectForKey:@"Operate"];
            recordModel.accountName = [dic objectForKey:@"AccountName"];
            recordModel.userName = [dic objectForKey:@"UserName"];
            recordModel.type = [dic objectForKey:@"Type"];
            recordModel.createTime = [dic objectForKey:@"CreateTime"];
            NSArray *tempFiles = [dic objectForKey:@"Files"];
            if([tempFiles count] > 0)
            {
                for (int x = 0; x < [tempFiles count]; x++) {
                    NSDictionary *dicFile = [tempFiles objectAtIndex:x];
                    HYFileModel *fileModel = [[HYFileModel alloc] init];
                    fileModel.ID = [dicFile objectForKey:@"ID"];
                    fileModel.type = [dicFile objectForKey:@"Type"];
                    fileModel.name = [dicFile objectForKey:@"Name"];
                    fileModel.path = [dicFile objectForKey:@"Path"];
                    
                    recordModel.fileModel = fileModel;
                }
            }
            recordModel.ID = [dic objectForKey:@"ID"];
            recordModel.headImg = [dic objectForKey:@"HeadImg"];
            recordModel.proxy = [dic objectForKey:@"Proxy"];
            recordModel.proxyName  = [dic objectForKey:@"ProxyName"];
            [taskModel.recordList addObject:recordModel];
            [allMsg addObject:recordModel];
        }
        
        for (int i = 0; i < [allMsg count]; i++) {
            [tempArr addObject:[allMsg objectAtIndex:i]];
        }
        allMsg = tempArr;
    }else
    {
        [super logoutAction];
    }
    
    if(messages != nil)
    {
        messages = nil;
        messages = [[NSMutableArray alloc] init];
    }else
    {
        messages = [[NSMutableArray alloc] init];
    }
    for (int i = ([allMsg count] - 1); i >= 0; i--) {
        HYRecordModel *tempModel = [allMsg objectAtIndex:i];
        ChartCellFrame *cellFrame = [[ChartCellFrame alloc]init];
        ChartMessage *chartMessage = [[ChartMessage alloc]init];
        NSString *headImgUrl = @"";
        NSArray *headArr = nil;
        if(tempModel.headImg != nil && ![tempModel.headImg isEqual:@""])
        {
            headArr = [tempModel.headImg componentsSeparatedByString:@"\\"];
        }
        if([headArr count] < 2 && headArr != nil)
        {
            headArr = [tempModel.headImg componentsSeparatedByString:@"//"];
        }
        if(headArr != nil)
        {
            headImgUrl = [headImgUrl stringByAppendingString:HeadImg_api];
            headImgUrl = [headImgUrl stringByAppendingString:[headArr objectAtIndex:0]];
            headImgUrl = [headImgUrl stringByAppendingString:@"/"];
            headImgUrl = [headImgUrl stringByAppendingString:[headArr objectAtIndex:1]];
        }
        chartMessage.icon = headImgUrl;
        chartMessage.time = tempModel.createTime;
        chartMessage.fileModel = tempModel.fileModel;
        chartMessage.iconAccountName = @"";
        if(self.user == nil)
        {
            self.user = [HYHelper getUser];
        }
        if([tempModel.type isEqual:@"1"])
        {
            chartMessage.iconLabelText = @"系统";
            chartMessage.icon = @"Icon";
            chartMessage.content = @"";
            chartMessage.content = [chartMessage.content stringByAppendingString:tempModel.userName];
            chartMessage.content = [chartMessage.content stringByAppendingString:@":"];
            chartMessage.content = [chartMessage.content stringByAppendingString:tempModel.operate];
            chartMessage.messageType = messageSys;
        }
        if([tempModel.type isEqual:@"2"])
        {
            if([tempModel.proxy isEqual:@""])
            {
                if([tempModel.accountName isEqual:self.user.accountName])
                {
                    chartMessage.iconLabelText = tempModel.userName;
                    chartMessage.messageType = messageTo;
                    chartMessage.content = tempModel.operate;
                }else
                {
                    chartMessage.iconLabelText = tempModel.userName;
                    chartMessage.messageType = messageFrom;
                    chartMessage.content = tempModel.operate;
                }
            }else
            {
                chartMessage.icon = @"newtask_people";
                if([tempModel.proxy isEqual:self.user.accountName])
                {
                    chartMessage.iconAccountName = tempModel.proxy;
                    chartMessage.iconLabelText = tempModel.proxyName;
                    chartMessage.messageType = messageTo;
                    chartMessage.content = tempModel.operate;
                }else
                {
                    chartMessage.iconAccountName = tempModel.proxy;
                    chartMessage.iconLabelText = tempModel.proxyName;
                    chartMessage.messageType = messageFrom;
                    chartMessage.content = tempModel.operate;
                }
            }
        }
        cellFrame.chartMessage = chartMessage;
        [messages addObject:cellFrame];
    }
    //
    [mainTableView reloadData];
//    [self tableViewScrollCurrentIndexPath];
    [mainTableView completeDragRefresh];
    if(connectionTimer == nil && isDidDisappear == NO)
    {
        connectionTimer =  [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getLastRecord) userInfo:nil repeats:YES];
    }
    [SVProgressHUD dismiss];
}

-(void)completeDragRefresh
{
    [compeletTimer invalidate];
    [mainTableView completeDragRefresh];
}

-(void)longSpeakAction:(id)sender
{

}


-(void)speakButtonPressUp:(id)sender
{
    [audioView removeFromSuperview];
    [timer invalidate];
    
    [speakButton setTitle:@"按 住 录 音" forState:UIControlStateNormal];
    [speakButton.titleLabel setTextColor:[UIColor blackColor]];
    if(![audioARM stopRecord])
    {
        [SVProgressHUD showErrorWithStatus:@"录音时间过短"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在发送语音..." maskType:SVProgressHUDMaskTypeGradient];
    
//    ChartCellFrame *cellFrame = [[ChartCellFrame alloc]init];
//    ChartMessage *chartMessage = [[ChartMessage alloc]init];
//    chartMessage.icon = @"newtask_people";
//    chartMessage.iconLabelText = self.user.username;
//    chartMessage.content = @"";
//    chartMessage.messageType = messageTo;
//    cellFrame.chartMessage = chartMessage;
//    [messages addObject:cellFrame];
//    [mainTableView reloadData];
    
//    chartMessage.time = tempModel.createTime;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"tempUpAudio.AMR"];
    
    [self sendImgFile:uniquePath];
//    NSData *playAudio = [NSData dataWithContentsOfFile:uniquePath];
//    [audioARM playAudio:playAudio];
    
}

- (void)detectionVoice
{
     [bgimg addSubview:audioView];
    
//    [[audioARM getRecorder] updateMeters];
//    
////    //NSLog(@"xuwei  =====  %lf",([[audioARM getRecorder] peakPowerForChannel:0]));
//    double lowPassResults = pow(10, (0.05 * [[audioARM getRecorder] peakPowerForChannel:0]));
//    //NSLog(@"lowPassResults ＝ %lf",[[audioARM getRecorder] peakPowerForChannel:0]);
    
    double lowPassResults = [audioARM getRecorderPeakPower];
    //最大50  0
    //图片 小-》大
    if (0<lowPassResults<=0.06) {
        [audioView setImage:[UIImage imageNamed:@"record_animate_01.png"]];
    }else if (0.06<lowPassResults<=0.13) {
        [audioView setImage:[UIImage imageNamed:@"record_animate_02.png"]];
    }else if (0.13<lowPassResults<=0.20) {
        [audioView setImage:[UIImage imageNamed:@"record_animate_03.png"]];
    }else if (0.20<lowPassResults<=0.27) {
        [audioView setImage:[UIImage imageNamed:@"record_animate_04.png"]];
    }else if (0.27<lowPassResults<=0.34) {
        [audioView setImage:[UIImage imageNamed:@"record_animate_05.png"]];
    }else if (0.34<lowPassResults<=0.41) {
        [audioView setImage:[UIImage imageNamed:@"record_animate_06.png"]];
    }else if (0.41<lowPassResults<=0.48) {
        [audioView setImage:[UIImage imageNamed:@"record_animate_07.png"]];
    }else if (0.48<lowPassResults<=0.55) {
        [audioView setImage:[UIImage imageNamed:@"record_animate_08.png"]];
    }else if (0.55<lowPassResults<=0.62) {
        [audioView setImage:[UIImage imageNamed:@"record_animate_09.png"]];
    }else if (0.62<lowPassResults<=0.69) {
        [audioView setImage:[UIImage imageNamed:@"record_animate_10.png"]];
    }else if (0.69<lowPassResults<=0.76) {
        [audioView setImage:[UIImage imageNamed:@"record_animate_11.png"]];
    }else if (0.76<lowPassResults<=0.83) {
        [audioView setImage:[UIImage imageNamed:@"record_animate_12.png"]];
    }else if (0.83<lowPassResults<=0.9) {
        [audioView setImage:[UIImage imageNamed:@"record_animate_13.png"]];
    }else {
        [audioView setImage:[UIImage imageNamed:@"record_animate_14.png"]];
    }
}

-(void)speakButtonPressDown:(id)sender
{
    [connectionTimer invalidate];
    connectionTimer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
    [audioARM initAudio];
    [audioARM startRecord];
    [speakButton setTitle:@"松 开 发 送" forState:UIControlStateNormal];
    [speakButton.titleLabel setTextColor:[UIColor blackColor]];
}


-(void)getSendLastRecord
{
//    [SVProgressHUD showWithStatus:@"正在获取信息..." maskType:SVProgressHUDMaskTypeGradient];
    //NSLog(@"lastDateString = %@", lastDateString);
    if([lastDateString isEqual:@""])
    {
        return;
    }
    NSDate *dateTime = [[NSDate alloc] init];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *stringDate = [dateFormatter stringFromDate:dateTime];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.token,@"Token",@"GetRecord",@"opeType",taskModel.ID,@"TaskID",self.user.accountName,@"AccountName",@"all",@"Type",stringDate,@"Time",@"0",@"page",@"10",@"rows",lastDateString,@"LastTime",nil];
    
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
    [request setDidFinishSelector:@selector(endGetSendLastRecordFin:)];
    [request setDidFailSelector:@selector(endGetSendLastRecordFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) endGetSendLastRecordFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器连接失败,请检查网络!";
    [self performSelectorOnMainThread:@selector(endGetSendLastRecordFailString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endGetSendLastRecordFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetSendLastRecordString:) withObject:responsestring waitUntilDone:YES];
}

-(void)endGetSendLastRecordFailString:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:msg];
}

-(void)endGetSendLastRecordString:(NSString *)msg
{
    if(sendFlag)
    {
        [SVProgressHUD dismiss];
//        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        sendFlag = NO;
        if(connectionTimer == nil && isDidDisappear == NO)
        {
            connectionTimer =  [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getLastRecord) userInfo:nil repeats:YES];
        }
    }
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
        //        lastDateString = [content objectForKey:@"LastTime"];
        NSArray *recordList = [content objectForKey:@"RecordList"];
        [taskModel.recordList removeAllObjects];
        if([recordList count] > 0)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            currentlastDateString = [content objectForKey:@"LastTime"];
            
            //NSLog(@"endGetLastRecordString currentlastDateString = %@", currentlastDateString);
            //            lastDateString =
            
            NSDate *remoteDateTime = [formatter dateFromString:currentlastDateString];
            //
            NSDate *localDateTime = [formatter dateFromString:lastDateString];
            
            //NSLog(@"endGetLastRecordString lastDateString = %@", lastDateString);
            
            if([remoteDateTime isEqual:localDateTime])
            {
                if(connectionTimer == nil && isDidDisappear == NO)
                {
                    connectionTimer =  [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getLastRecord) userInfo:nil repeats:YES];
                }
                [SVProgressHUD dismiss];
                return;
            }else
            {
                lastDateString = currentlastDateString;
            }
        }else
        {
            if(connectionTimer == nil && isDidDisappear == NO)
            {
                connectionTimer =  [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getLastRecord) userInfo:nil repeats:YES];
            }
            [SVProgressHUD dismiss];
            return;
        }
        for (int i = 0; i < [recordList count]; i++) {
            NSDictionary *dic = [recordList objectAtIndex:i];
            HYRecordModel *recordModel = [[HYRecordModel alloc] init];
            recordModel.taskID = [dic objectForKey:@"TaskID"];
            recordModel.operate = [dic objectForKey:@"Operate"];
            recordModel.accountName = [dic objectForKey:@"AccountName"];
            recordModel.userName = [dic objectForKey:@"UserName"];
            recordModel.type = [dic objectForKey:@"Type"];
            recordModel.createTime = [dic objectForKey:@"CreateTime"];
            NSArray *tempFiles = [dic objectForKey:@"Files"];
            if([tempFiles count] > 0)
            {
                for (int x = 0; x < [tempFiles count]; x++) {
                    NSDictionary *dicFile = [tempFiles objectAtIndex:x];
                    HYFileModel *fileModel = [[HYFileModel alloc] init];
                    fileModel.ID = [dicFile objectForKey:@"ID"];
                    fileModel.type = [dicFile objectForKey:@"Type"];
                    fileModel.name = [dicFile objectForKey:@"Name"];
                    fileModel.path = [dicFile objectForKey:@"Path"];
                    recordModel.fileModel = fileModel;
                }
            }
            recordModel.ID = [dic objectForKey:@"ID"];
            recordModel.headImg = [dic objectForKey:@"HeadImg"];
            recordModel.proxy = [dic objectForKey:@"Proxy"];
            recordModel.proxyName  = [dic objectForKey:@"ProxyName"];
            [taskModel.recordList addObject:recordModel];
            //            [allMsg addObject:recordModel];
        }
        NSMutableArray *tempArrLast = [[NSMutableArray alloc] init];
        tempArrLast = [allMsg mutableCopy];
        for (int i = 0; i < [tempArrLast count]; i++) {
            HYRecordModel *iRecordModel = [tempArrLast objectAtIndex:i];
            BOOL checkFlag = NO;
            NSString *ID = @"";
            for (int j = 0; j < [taskModel.recordList count]; j++) {
                HYRecordModel *jRecordModel = [taskModel.recordList objectAtIndex:j];
                if([iRecordModel.ID isEqual:jRecordModel.ID])
                {
                    ID = iRecordModel.ID;
                    checkFlag = YES;
                    break;
                }
            }
            if(checkFlag)
            {
                for (int j = 0; j < [taskModel.recordList count]; j++) {
                    HYRecordModel *jRecordModel = [taskModel.recordList objectAtIndex:j];
                    if([ID isEqual:jRecordModel.ID])
                    {
                        [taskModel.recordList removeObject:jRecordModel];
                        break;
                    }
                }
            }
        }
        allMsg = nil;
        allMsg = [[NSMutableArray alloc] init];
        allMsg = [taskModel.recordList mutableCopy];
        for (int i = 0; i < [tempArrLast count]; i++) {
            [allMsg addObject:[tempArrLast objectAtIndex:i]];
        }
    }else
    {
        [connectionTimer invalidate];
        connectionTimer = nil;
        isDidDisappear = YES;
        [super logoutAction];
    }
    if(messages == nil)
    {
        messages = [[NSMutableArray alloc] init];
    }else
    {
        [messages removeAllObjects];
    }
    for (int i = ([allMsg count] - 1); i >= 0; i--) {
        HYRecordModel *tempModel = [allMsg objectAtIndex:i];
        ChartCellFrame *cellFrame = [[ChartCellFrame alloc]init];
        ChartMessage *chartMessage = [[ChartMessage alloc]init];
        NSString *headImgUrl = @"";
        NSArray *headArr = nil;
        if(tempModel.headImg != nil && ![tempModel.headImg isEqual:@""])
        {
            headArr = [tempModel.headImg componentsSeparatedByString:@"\\"];
        }
        if([headArr count] < 2 && headArr != nil)
        {
            headArr = [tempModel.headImg componentsSeparatedByString:@"//"];
        }
        if(headArr != nil)
        {
            headImgUrl = [headImgUrl stringByAppendingString:HeadImg_api];
            headImgUrl = [headImgUrl stringByAppendingString:[headArr objectAtIndex:0]];
            headImgUrl = [headImgUrl stringByAppendingString:@"/"];
            headImgUrl = [headImgUrl stringByAppendingString:[headArr objectAtIndex:1]];
        }
        chartMessage.icon = headImgUrl;
        chartMessage.time = tempModel.createTime;
        chartMessage.fileModel = tempModel.fileModel;
        chartMessage.iconAccountName = @"";
        if(self.user == nil)
        {
            self.user = [HYHelper getUser];
        }
        if([tempModel.type isEqual:@"1"])
        {
            chartMessage.iconLabelText = @"系统";
            chartMessage.icon = @"Icon";
            chartMessage.content = @"";
            chartMessage.content = [chartMessage.content stringByAppendingString:tempModel.userName];
            chartMessage.content = [chartMessage.content stringByAppendingString:@":"];
            chartMessage.content = [chartMessage.content stringByAppendingString:tempModel.operate];
            chartMessage.messageType = messageSys;
        }
        if([tempModel.type isEqual:@"2"])
        {
            if([tempModel.proxy isEqual:@""])
            {
                if([tempModel.accountName isEqual:self.user.accountName])
                {
                    chartMessage.iconLabelText = tempModel.userName;
                    chartMessage.messageType = messageTo;
                    chartMessage.content = tempModel.operate;
                }else
                {
                    chartMessage.iconLabelText = tempModel.userName;
                    chartMessage.messageType = messageFrom;
                    chartMessage.content = tempModel.operate;
                }
            }else
            {
                chartMessage.icon = @"newtask_people";
                if([tempModel.proxy isEqual:self.user.accountName])
                {
                    chartMessage.iconAccountName = tempModel.proxy;
                    chartMessage.iconLabelText = tempModel.proxyName;
                    chartMessage.messageType = messageTo;
                    chartMessage.content = tempModel.operate;
                }else
                {
                    chartMessage.iconAccountName = tempModel.proxy;
                    chartMessage.iconLabelText = tempModel.proxyName;
                    chartMessage.messageType = messageFrom;
                    chartMessage.content = tempModel.operate;
                }
            }
        }
        cellFrame.chartMessage = chartMessage;
        [messages addObject:cellFrame];
    }
    //
    [mainTableView reloadData];
    if(connectionTimer == nil && isDidDisappear == NO)
    {
        connectionTimer =  [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getLastRecord) userInfo:nil repeats:YES];
    }
    [self tableViewScrollCurrentIndexPath];
}

-(void)getLastRecord
{
    if(connectionTimer == nil)
    {
        return;
    }
    
    //NSLog(@"lastDateString = %@", lastDateString);
    if([lastDateString isEqual:@""])
    {
        return;
    }
    NSDate *dateTime = [[NSDate alloc] init];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *stringDate = [dateFormatter stringFromDate:dateTime];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.token,@"Token",@"GetRecord",@"opeType",taskModel.ID,@"TaskID",self.user.accountName,@"AccountName",@"all",@"Type",stringDate,@"Time",@"0",@"page",@"10",@"rows",lastDateString,@"LastTime",nil];
    
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
    [request setDidFinishSelector:@selector(endGetLastRecordFin:)];
    [request setDidFailSelector:@selector(endGetLastRecordFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) endGetLastRecordFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器连接失败,请检查网络!";
    [self performSelectorOnMainThread:@selector(endGetLastRecordFailString:) withObject:responsestring waitUntilDone:YES];
}

-(void)endGetLastRecordFailString:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:msg];
}

- (void) endGetLastRecordFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetLastRecordString:) withObject:responsestring waitUntilDone:YES];
}

-(void)endGetLastRecordString:(NSString *)msg
{
//    [self initControl];
//    messages = nil;
    if(sendFlag)
    {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        sendFlag = NO;
        if(connectionTimer == nil && isDidDisappear == NO)
        {
            connectionTimer =  [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getLastRecord) userInfo:nil repeats:YES];
        }
    }
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
//        lastDateString = [content objectForKey:@"LastTime"];
        NSArray *recordList = [content objectForKey:@"RecordList"];
        [taskModel.recordList removeAllObjects];
        if([recordList count] > 0)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            currentlastDateString = [content objectForKey:@"LastTime"];
            
            //NSLog(@"endGetLastRecordString currentlastDateString = %@", currentlastDateString);
//            lastDateString =
            
            NSDate *remoteDateTime = [formatter dateFromString:currentlastDateString];
//            
            NSDate *localDateTime = [formatter dateFromString:lastDateString];
            
            //NSLog(@"endGetLastRecordString lastDateString = %@", lastDateString);
            
            if([remoteDateTime isEqual:localDateTime])
            {
                if(connectionTimer == nil && isDidDisappear == NO)
                {
                    connectionTimer =  [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getLastRecord) userInfo:nil repeats:YES];
                }
                [SVProgressHUD dismiss];
                return;
            }else
            {
                lastDateString = currentlastDateString;
            }
        }else
        {
            if(connectionTimer == nil && isDidDisappear == NO)
            {
                connectionTimer =  [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getLastRecord) userInfo:nil repeats:YES];
            }
            [SVProgressHUD dismiss];
            return;
        }
        for (int i = 0; i < [recordList count]; i++) {
            NSDictionary *dic = [recordList objectAtIndex:i];
            HYRecordModel *recordModel = [[HYRecordModel alloc] init];
            recordModel.taskID = [dic objectForKey:@"TaskID"];
            recordModel.operate = [dic objectForKey:@"Operate"];
            recordModel.accountName = [dic objectForKey:@"AccountName"];
            recordModel.userName = [dic objectForKey:@"UserName"];
            recordModel.type = [dic objectForKey:@"Type"];
            recordModel.createTime = [dic objectForKey:@"CreateTime"];
            NSArray *tempFiles = [dic objectForKey:@"Files"];
            if([tempFiles count] > 0)
            {
                for (int x = 0; x < [tempFiles count]; x++) {
                    NSDictionary *dicFile = [tempFiles objectAtIndex:x];
                    HYFileModel *fileModel = [[HYFileModel alloc] init];
                    fileModel.ID = [dicFile objectForKey:@"ID"];
                    fileModel.type = [dicFile objectForKey:@"Type"];
                    fileModel.name = [dicFile objectForKey:@"Name"];
                    fileModel.path = [dicFile objectForKey:@"Path"];
                    recordModel.fileModel = fileModel;
                }
            }
            recordModel.ID = [dic objectForKey:@"ID"];
            recordModel.headImg = [dic objectForKey:@"HeadImg"];
            recordModel.proxy = [dic objectForKey:@"Proxy"];
            recordModel.proxyName  = [dic objectForKey:@"ProxyName"];
            [taskModel.recordList addObject:recordModel];
//            [allMsg addObject:recordModel];
        }
        NSMutableArray *tempArrLast = [[NSMutableArray alloc] init];
        tempArrLast = [allMsg mutableCopy];
        for (int i = 0; i < [tempArrLast count]; i++) {
            HYRecordModel *iRecordModel = [tempArrLast objectAtIndex:i];
            BOOL checkFlag = NO;
            NSString *ID = @"";
            for (int j = 0; j < [taskModel.recordList count]; j++) {
                HYRecordModel *jRecordModel = [taskModel.recordList objectAtIndex:j];
                if([iRecordModel.ID isEqual:jRecordModel.ID])
                {
                    ID = iRecordModel.ID;
                    checkFlag = YES;
                    break;
                }
            }
            if(checkFlag)
            {
                for (int j = 0; j < [taskModel.recordList count]; j++) {
                    HYRecordModel *jRecordModel = [taskModel.recordList objectAtIndex:j];
                    if([ID isEqual:jRecordModel.ID])
                    {
                        [taskModel.recordList removeObject:jRecordModel];
                        break;
                    }
                }
            }
        }
        allMsg = nil;
        allMsg = [[NSMutableArray alloc] init];
        allMsg = [taskModel.recordList mutableCopy];
        for (int i = 0; i < [tempArrLast count]; i++) {
            [allMsg addObject:[tempArrLast objectAtIndex:i]];
        }
    }else
    {
        [connectionTimer invalidate];
        connectionTimer = nil;
        isDidDisappear = YES;
        [super logoutAction];
    }
    if(messages == nil)
    {
        messages = [[NSMutableArray alloc] init];
    }else
    {
        [messages removeAllObjects];
    }
    for (int i = ([allMsg count] - 1); i >= 0; i--) {
        HYRecordModel *tempModel = [allMsg objectAtIndex:i];
        ChartCellFrame *cellFrame = [[ChartCellFrame alloc]init];
        ChartMessage *chartMessage = [[ChartMessage alloc]init];
        NSString *headImgUrl = @"";
        NSArray *headArr = nil;
        if(tempModel.headImg != nil && ![tempModel.headImg isEqual:@""])
        {
            headArr = [tempModel.headImg componentsSeparatedByString:@"\\"];
        }
        if([headArr count] < 2 && headArr != nil)
        {
            headArr = [tempModel.headImg componentsSeparatedByString:@"//"];
        }
        if(headArr != nil)
        {
            headImgUrl = [headImgUrl stringByAppendingString:HeadImg_api];
            headImgUrl = [headImgUrl stringByAppendingString:[headArr objectAtIndex:0]];
            headImgUrl = [headImgUrl stringByAppendingString:@"/"];
            headImgUrl = [headImgUrl stringByAppendingString:[headArr objectAtIndex:1]];
        }
        chartMessage.icon = headImgUrl;
        chartMessage.time = tempModel.createTime;
        chartMessage.fileModel = tempModel.fileModel;
        chartMessage.iconAccountName = @"";
        if(self.user == nil)
        {
            self.user = [HYHelper getUser];
        }
        if([tempModel.type isEqual:@"1"])
        {
            chartMessage.iconLabelText = @"系统";
            chartMessage.icon = @"Icon";
            chartMessage.content = @"";
            chartMessage.content = [chartMessage.content stringByAppendingString:tempModel.userName];
            chartMessage.content = [chartMessage.content stringByAppendingString:@":"];
            chartMessage.content = [chartMessage.content stringByAppendingString:tempModel.operate];
            chartMessage.messageType = messageSys;
        }
        if([tempModel.type isEqual:@"2"])
        {
            if([tempModel.proxy isEqual:@""])
            {
                if([tempModel.accountName isEqual:self.user.accountName])
                {
                    chartMessage.iconLabelText = tempModel.userName;
                    chartMessage.messageType = messageTo;
                    chartMessage.content = tempModel.operate;
                }else
                {
                    chartMessage.iconLabelText = tempModel.userName;
                    chartMessage.messageType = messageFrom;
                    chartMessage.content = tempModel.operate;
                }
            }else
            {
                chartMessage.icon = @"newtask_people";
                if([tempModel.proxy isEqual:self.user.accountName])
                {
                    chartMessage.iconAccountName = tempModel.proxy;
                    chartMessage.iconLabelText = tempModel.proxyName;
                    chartMessage.messageType = messageTo;
                    chartMessage.content = tempModel.operate;
                }else
                {
                    chartMessage.iconAccountName = tempModel.proxy;
                    chartMessage.iconLabelText = tempModel.proxyName;
                    chartMessage.messageType = messageFrom;
                    chartMessage.content = tempModel.operate;
                }
            }
        }
        cellFrame.chartMessage = chartMessage;
        [messages addObject:cellFrame];
    }
    //
    [mainTableView reloadData];
    if(connectionTimer == nil && isDidDisappear == NO)
    {
        connectionTimer =  [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getLastRecord) userInfo:nil repeats:YES];
    }
    [self tableViewScrollCurrentIndexPath];
}

-(void)getFirstRecordPages:(int)page
{
    [allMsg removeAllObjects];
    NSDate *dateTime = [[NSDate alloc] init];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *stringDate = [dateFormatter stringFromDate:dateTime];
    
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.token,@"Token",@"GetRecord",@"opeType",taskModel.ID,@"TaskID",self.user.accountName,@"AccountName",getRecordType,@"Type",stringDate,@"Time",[NSString stringWithFormat:@"%d",page],@"page",@"10",@"rows",nil];
    
    
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
    [request setDidFinishSelector:@selector(endFirstGetRecord:)];
    [request setDidFailSelector:@selector(endFirstGetRecordFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) endFirstGetRecord:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endFirstGetRecordString:) withObject:responsestring waitUntilDone:YES];
}


- (void) endFirstGetRecordFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器连接失败,请检查网络!";
    [self performSelectorOnMainThread:@selector(endFirstGetRecordString:) withObject:responsestring waitUntilDone:YES];
}

-(void)endFirstGetRecordString:(NSString *)msg
{
    if(connectionTimer == nil && isDidDisappear == NO)
    {
        connectionTimer =  [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getLastRecord) userInfo:nil repeats:YES];
    }
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
        lastDateString = [content objectForKey:@"LastTime"];
        NSArray *recordList = [content objectForKey:@"RecordList"];
        NSString *pageCountString = [content objectForKey:@"PageCount"];
        pageCount = [pageCountString intValue];
        for (int i = 0; i < [recordList count]; i++) {
            NSDictionary *dic = [recordList objectAtIndex:i];
            HYRecordModel *recordModel = [[HYRecordModel alloc] init];
            recordModel.taskID = [dic objectForKey:@"TaskID"];
            recordModel.operate = [dic objectForKey:@"Operate"];
            recordModel.accountName = [dic objectForKey:@"AccountName"];
            recordModel.userName = [dic objectForKey:@"UserName"];
            recordModel.type = [dic objectForKey:@"Type"];
            recordModel.createTime = [dic objectForKey:@"CreateTime"];
            NSArray *tempFiles = [dic objectForKey:@"Files"];
            if([tempFiles count] > 0)
            {
                for (int x = 0; x < [tempFiles count]; x++) {
                    NSDictionary *dicFile = [tempFiles objectAtIndex:x];
                    HYFileModel *fileModel = [[HYFileModel alloc] init];
                    fileModel.ID = [dicFile objectForKey:@"ID"];
                    fileModel.type = [dicFile objectForKey:@"Type"];
                    fileModel.name = [dicFile objectForKey:@"Name"];
                    fileModel.path = [dicFile objectForKey:@"Path"];
                    
                    recordModel.fileModel = fileModel;
                }
            }
            recordModel.ID = [dic objectForKey:@"ID"];
            recordModel.headImg = [dic objectForKey:@"HeadImg"];
            recordModel.proxy = [dic objectForKey:@"Proxy"];
            recordModel.proxyName  = [dic objectForKey:@"ProxyName"];
            if(taskModel.recordList == nil)
            {
                taskModel.recordList = [[NSMutableArray alloc] init];
            }
            [taskModel.recordList addObject:recordModel];
            [allMsg addObject:recordModel];
        }
    }else
    {
        [super logoutAction];
    }
    
    if(messages == nil)
    {
        messages = [[NSMutableArray alloc] init];
    }else
    {
        [messages removeAllObjects];
    }
    for (int i = ([allMsg count] - 1); i >= 0; i--) {
        HYRecordModel *tempModel = [allMsg objectAtIndex:i];
        ChartCellFrame *cellFrame = [[ChartCellFrame alloc]init];
        ChartMessage *chartMessage = [[ChartMessage alloc]init];
        NSString *headImgUrl = @"";
        NSArray *headArr = nil;
        if(tempModel.headImg != nil && ![tempModel.headImg isEqual:@""])
        {
            headArr = [tempModel.headImg componentsSeparatedByString:@"\\"];
        }
        if([headArr count] < 2 && headArr != nil)
        {
            headArr = [tempModel.headImg componentsSeparatedByString:@"//"];
        }
        if(headArr != nil)
        {
            headImgUrl = [headImgUrl stringByAppendingString:HeadImg_api];
            headImgUrl = [headImgUrl stringByAppendingString:[headArr objectAtIndex:0]];
            headImgUrl = [headImgUrl stringByAppendingString:@"/"];
            headImgUrl = [headImgUrl stringByAppendingString:[headArr objectAtIndex:1]];
        }
        chartMessage.icon = headImgUrl;
        chartMessage.time = tempModel.createTime;
        chartMessage.fileModel = tempModel.fileModel;
        chartMessage.iconAccountName = @"";
        if(self.user == nil)
        {
            self.user = [HYHelper getUser];
        }
        //NSLog(@"HYMessageViewController 7.1 test tempMOdel.type = %@ ",tempModel.type);
        //NSLog(@"HYMessageViewController 7.1 test tempMOdel.proxy = %@ ",tempModel.proxy);
        if([tempModel.type isEqual:@"1"])
        {
            chartMessage.iconLabelText = @"系统";
            chartMessage.icon = @"Icon";
            chartMessage.content = @"";
            chartMessage.content = [chartMessage.content stringByAppendingString:tempModel.userName];
            chartMessage.content = [chartMessage.content stringByAppendingString:@":"];
            chartMessage.content = [chartMessage.content stringByAppendingString:tempModel.operate];
            chartMessage.messageType = messageSys;
        }
        if([tempModel.type isEqual:@"2"])
        {
            if([tempModel.proxy isEqual:@""])
            {
                if([tempModel.accountName isEqual:self.user.accountName])
                {
                    chartMessage.iconLabelText = tempModel.userName;
                    chartMessage.messageType = messageTo;
                    chartMessage.content = tempModel.operate;
                }else
                {
                    chartMessage.iconLabelText = tempModel.userName;
                    chartMessage.messageType = messageFrom;
                    chartMessage.content = tempModel.operate;
                }
            }else
            {
                chartMessage.icon = @"newtask_people";
                if([tempModel.proxy isEqual:self.user.accountName])
                {
                    chartMessage.iconAccountName = tempModel.proxy;
                    chartMessage.iconLabelText = tempModel.proxyName;
                    chartMessage.messageType = messageTo;
                    chartMessage.content = tempModel.operate;
                }else
                {
                    chartMessage.iconAccountName = tempModel.proxy;
                    chartMessage.iconLabelText = tempModel.proxyName;
                    chartMessage.messageType = messageFrom;
                    chartMessage.content = tempModel.operate;
                }
            }
        }
        cellFrame.chartMessage = chartMessage;
        [messages addObject:cellFrame];
    }
//
    [mainTableView reloadData];
    [self tableViewScrollCurrentIndexPath];
    [SVProgressHUD dismiss];
    connectionTimer =  [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getLastRecord) userInfo:nil repeats:YES];
    
}


-(void)initMainTableData
{
    //GetRecord
    
    [self getFirstRecordPages:currentPage];
}

#pragma textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [self sendMessage];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self tableViewScrollCurrentIndexPath];
    
//    [bottomSpeak setBackgroundImage:[HYImageFactory GetImageByName:@"smartsearch" AndType:PNG] forState:UIControlStateNormal];
////    bottomSpeak
//    [bottomSpeak setTitle:@"发送" forState:UIControlStateNormal];
//    [bottomSpeak.titleLabel setFont:[UIFont fontWithName:FONT size:12]];
//    [bottomSpeak removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
//    [bottomSpeak addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
//    [bottomSpeak addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomSpeakAction:)]];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(bottomSpeak.tag != 1000)
    {
        [bottomSpeak setBackgroundImage:[HYImageFactory GetImageByName:@"smartsearch" AndType:PNG] forState:UIControlStateNormal];
        bottomSpeak.tag = 1000;
        //    bottomSpeak
        [bottomSpeak setTitle:@"发送" forState:UIControlStateNormal];
        [bottomSpeak.titleLabel setFont:[UIFont fontWithName:FONT size:12]];
        [bottomSpeak removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
        [bottomSpeak addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    }
    return YES;
}


#pragma textView
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(bottomSpeak.tag != 1000)
    {
        [bottomSpeak setBackgroundImage:[HYImageFactory GetImageByName:@"smartsearch" AndType:PNG] forState:UIControlStateNormal];
        bottomSpeak.tag = 1000;
        //    bottomSpeak
        [bottomSpeak setTitle:@"发送" forState:UIControlStateNormal];
        [bottomSpeak.titleLabel setFont:[UIFont fontWithName:FONT size:12]];
        [bottomSpeak removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
        [bottomSpeak addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    }
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if(![inputText.text isEqual:@""])
    {
        [self sendMessage];
    }
    [bottomBgImgLittle setFrame:CGRectMake(0, bgimg.frame.size.height - 44, [HYScreenTools getScreenWidth], 44)];
    [mainTableView setFrame:CGRectMake(0, 0, [HYScreenTools getScreenWidth], (bgimg.frame.size.height - 44))];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(inputText.contentSize.height >= 80)
    {
        if(isLittle)
        {
            [mainTableView setFrame:CGRectMake(0, 0, [HYScreenTools getScreenWidth], (bgimg.frame.size.height - 90))];
            [bottomBgImgLittle setFrame:CGRectMake(0, bgimg.frame.size.height - 90, [HYScreenTools getScreenWidth], 90)];
        }
        [inputText setFrame:CGRectMake(44, 4, [HYScreenTools getScreenWidth] - 116, 80)];
    }else
    {
        if(isLittle)
        {
            [mainTableView setFrame:CGRectMake(0, 0, [HYScreenTools getScreenWidth], (bgimg.frame.size.height - (inputText.contentSize.height + 10)))];
            [bottomBgImgLittle setFrame:CGRectMake(0, bgimg.frame.size.height - (inputText.contentSize.height + 10), [HYScreenTools getScreenWidth], inputText.contentSize.height + 10)];
        }
        [inputText setFrame:CGRectMake(44, 4, [HYScreenTools getScreenWidth] - 116, inputText.contentSize.height)];
    }
}

#pragma tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"message count = %d", [messages count]);
    return messages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChartCell *cell = [[ChartCell alloc] init];
    
    cell.delegate = self;
    cell.cellFrame = messages[indexPath.row];
    //NSLog(@"cell.cellFrame.chartMessage.fileModel.path = %@",cell.cellFrame.chartMessage.fileModel.path);
    return cell;
    
}

-(void)tableViewScrollCurrentIndexPath
{
    if([messages count] <= 0)
    {
        return;
    }
    //NSLog(@"messages count %d", [messages count]);
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:messages.count-1 inSection:0];
    [mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [messages[indexPath.row] cellHeight];
}

-(void)bottomSpeakAction:(id)sender
{
    if(isSpeak)
    {
        [inputText removeFromSuperview];
        if(isLittle)
        {
            [bottomBgImgLittle addSubview:speakButton];
        }else
        {
            [bottomBgImgMore addSubview:speakButton];
        }
        
    }else
    {
        [speakButton removeFromSuperview];
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
        [bottomAddImg setFrame:CGRectMake(7, 7, 30, 30)];
        [bottomAddImg setImage:[HYImageFactory GetImageByName:@"jia2" AndType:PNG]];
        [bottomBgImgLittle removeFromSuperview];
        [bottomBgImgMore addSubview:bottomAddImg];
        [bottomBgImgMore addSubview:bottomSpeak];
        [bottomBgImgMore addSubview:inputText];
        [bottomBgImgMore addSubview:bottomUploadImgView];
        [bottomBgImgMore addSubview:bottomUploadphotoView];
//        [bottomBgImgMore addSubview:bottomUploadFileView];
        [bgimg addSubview:bottomBgImgMore];
    }else
    {
        [bottomAddImg setFrame:CGRectMake(7, bottomBgImgLittle.frame.size.height - 37, 30, 30)];
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
    [super viewWillAppear:YES];
    
    [[[self getNavigationController] getView] setHidden:NO];
    [[[self getTabbarController] getView] setHidden:YES];
    [[self getNavigationController] setCenterTittle:[self title]];
    [[self getNavigationController] setLeftButtonImage:[HYImageFactory GetImageByName:@"leftButton" AndType:PNG]];
    
    [[self getNavigationController] setLeftTittleFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [[self getNavigationController] setLeftTittleColor:[UIColor whiteColor]];
    [[self getNavigationController] setRightButtonTittle:@""];
    
    [[self getNavigationController] setRightButtonImage:[HYImageFactory GetImageByName:@"message_rightButton" AndType:PNG]];
    
    [self bindAction];
    //    [[self getNavigationController] hideRightButton];
    [[self getNavigationController] showLeftButton];
    [[self getNavigationController] showLeftTittle];
    [[self getNavigationController] showRightButton];
    [self tableViewScrollCurrentIndexPath];
    if(!isImgFlag)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getTaskDetils];
            [self getFunctions];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self initMainTableData];
            });
        });
    }
    

}

-(void)bindAction
{
    
    [[self getNavigationController] setLeftButtonTarget:nil action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [[self getNavigationController] removeRightTarget];
    [[self getNavigationController] setRightButtonTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)showMenu:(id)sender
{
    if(!menuView.isShow)
    {
        [self.view addSubview:menuView];
    }else
    {
        [menuView removeFromSuperview];
    }
    [menuView setShow:![menuView isShow]];
}

-(void)backAction:(id)sender
{
    [HYHelper getApp].remoteTaskID = nil;
    [[self getNavigationController] popController:self];
}

-(void)sendMessage
{
    [bottomBgImgLittle setFrame:CGRectMake(0, bgimg.frame.size.height - 44, [HYScreenTools getScreenWidth], 44)];
    [mainTableView setFrame:CGRectMake(0, 0, [HYScreenTools getScreenWidth], (bgimg.frame.size.height - 44))];
    isMySend = YES;
//    [SVProgressHUD showWithStatus:@"正在发送文字..." maskType:SVProgressHUDMaskTypeGradient];
    NSDate *dateTime = [[NSDate alloc] init];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *stringDate = [dateFormatter stringFromDate:dateTime];
//    lastDateString = stringDate;
    if([taskModel.functions getDisuss])
    {
        if([inputText.text isEqual:@""])
        {
            [SVProgressHUD showErrorWithStatus:@"评论不能为空！"];
            return;
        }
//        ChartCellFrame *cellFrame=[[ChartCellFrame alloc]init];
//        ChartMessage *chartMessage=[[ChartMessage alloc]init];
//        if(self.user.headImg == nil)
//        {
//            chartMessage.icon = @"newtask_people";
//        }else
//        {
//            chartMessage.icon = self.user.headImg;
//        }
        //
        comment = inputText.text;
//        chartMessage.iconLabelText = self.user.username;
//        chartMessage.messageType = messageTo;
//        chartMessage.content = inputText.text;
//        NSDate *dateTime = [[NSDate alloc] init];
//        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//        NSString *stringDate = [dateFormatter stringFromDate:dateTime];
//        chartMessage.time = stringDate;
//        chartMessage.messageType = messageTo;
//        cellFrame.chartMessage=chartMessage;
//        [messages addObject:cellFrame];
//        [mainTableView reloadData];
        //滚动到当前行
        [self threadSendMsg];
//        [NSThread detachNewThreadSelector:@selector(threadSendMsg) toTarget:self withObject:nil];
        [self tableViewScrollCurrentIndexPath];
        inputText.text = @"";
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"没有评论权限！"];
    }
    [bottomSpeak setBackgroundImage:[HYImageFactory GetImageByName:@"lis" AndType:PNG] forState:UIControlStateNormal];
    bottomSpeak.tag = 10;
    //    bottomSpeak
    [bottomSpeak setTitle:@"" forState:UIControlStateNormal];
//    [bottomSpeak.titleLabel setFont:[UIFont fontWithName:FONT size:12]];
    [bottomSpeak removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [bottomSpeak addTarget:self action:@selector(bottomSpeakAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)threadSendMsg
{
//    [connectionTimer invalidate];
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
    [request setAuthenticationScheme:@"https"];
    [request setValidatesSecureCertificate:NO];
    [request setShouldAttemptPersistentConnection:NO];
    [request setDidFinishSelector:@selector(endThreadSendMsg:)];
    [request setDidFailSelector:@selector(endThreadSendMsgFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) endThreadSendMsgFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器连接失败,请检查网络!";
    [self performSelectorOnMainThread:@selector(endThreadSendMsgString:) withObject:responsestring waitUntilDone:YES];
}

-(void)endThreadSendMsg:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endThreadSendMsgString:) withObject:responsestring waitUntilDone:YES];
}

-(void)endThreadSendMsgString:(NSString *)msg
{
    [connectionTimer invalidate];
    connectionTimer = nil;
    sendFlag = YES;
    //NSLog(@"msg = %@", msg);
    [self getSendLastRecord];
//    connectionTimer =  [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getLastRecord) userInfo:nil repeats:YES];
}

- (void)photoBtnAction:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    isImgFlag = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)cameraBtnAction:(id)sender {
    camera = [[UIImagePickerController alloc] init];
    camera.delegate = self;
    camera.allowsEditing = NO;
    isImgFlag = YES;
    //检查摄像头是否支持摄像机模式
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        camera.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        //NSLog(@"Camera not exist");
        return;
    }
    [self presentViewController:camera animated:YES completion:nil];
    
}


- (void) imagePickerController: (UIImagePickerController*) picker
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    isImgFlag = YES;
    [connectionTimer invalidate];
    connectionTimer = nil;
    //获得编辑过的图片
    UIImage* image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    
    //NSLog(@"ASKJDKASDJK %.2f,%.2f",image.size.width,image.size.height);
//    [headImg setImage:image];
    
    float width = 540.00;
    float height = 960.00;
    if(image.size.width > image.size.height)
    {
        width = 960.00;
        height = ((image.size.height) / (image.size.width) * 960);
    }else
    {
        height = 960.00;
        //NSLog(@"asdjas %.2f,%.2f",image.size.width,image.size.height);
        width = ((image.size.width) / (image.size.height) * 960);
    }
    
    
    
    UIImage *bigImage = [self imageWithImage:image scaledToSize:CGSizeMake(width, height)];

    [SVProgressHUD showWithStatus:@"正在发送图片..." maskType:SVProgressHUDMaskTypeGradient];
//    sendFlag = YES;
    
    [self saveImage:bigImage WithName:@"big_msgImg.jpg"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage, 0.5f);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    
    [imageData writeToFile:fullPathToFile atomically:YES];
    
    [self sendImgFile:fullPathToFile];
}

-(void)sendImgFile:(NSString *)fullPathfile
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.token,@"Token",self.user.accountName,@"AccountName",taskModel.ID,@"TaskID",nil];
    
    NSURL *url = [[NSURL alloc] initWithString:FileUpImg_api];
    NSMutableDictionary *files = [[NSMutableDictionary alloc] init];
    [files setValue:fullPathfile forKey:@"file"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    if (params) {
        NSArray *array = [params allKeys];
        for (int i= 0; i <[array count]; i++) {
            [request setPostValue:[params objectForKey:[array objectAtIndex:i]] forKey:[array objectAtIndex:i]];
        }
    }
    
    if (files) {
        NSArray *arrays = [files allKeys];
        for (int i= 0; i <[arrays count]; i++) {
            [request addFile:[files objectForKey:[arrays objectAtIndex:i]] forKey:[arrays objectAtIndex:i]];
        }
    }
    [request setAuthenticationScheme:@"https"];
    [request setValidatesSecureCertificate:NO];
    [request setShouldAttemptPersistentConnection:NO];
//    [request setRequestMethod:@"POST"];
    [request setDidFinishSelector:@selector(endImgUpFileFin:)];
    [request setDidFailSelector:@selector(endImgUpFileFail:)];
    [request buildPostBody];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
    
//        [[[DataProcessing alloc] init] sentRequest:url Parem:params Target:self];
}

- (void) endImgUpFileFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器连接失败,请检查网络!";
    [self performSelectorOnMainThread:@selector(endImgUpFileString:) withObject:responsestring waitUntilDone:YES];
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:responsestring];
}

-(void)endImgUpFileFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endImgUpFileString:) withObject:responsestring waitUntilDone:YES];
}

-(void)endImgUpFileString:(NSString *)msg
{
//    [SVProgressHUD dismiss];
    //NSLog(@"msg = %@", msg);
    sendFlag = YES;
    [self getSendLastRecord];
//    [SVProgressHUD showSuccessWithStatus:@"发送成功!"];
}



- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

-(void)viewDidDisappear:(BOOL)animated
{
    isDidDisappear = YES;
    [connectionTimer invalidate];
    connectionTimer = nil;
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
