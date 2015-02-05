//
//  HYMainViewController.m
//  keytask
//
//  Created by 许 玮 on 14-9-22.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYMainViewController.h"
#import "HYImageFactory.h"
#import "HYConstants.h"
#import "HYTabbarController.h"
#import "HYTabItemController.h"
#import "HYScreenTools.h"
#import "HYTaskListTableViewCell.h"
#import "HYNewTaskViewController.h"
#import "pull2RefreshTableView.h"
#import "HYTaskModel.h"
#import "HYNetworkInterface.h"
#import "HYTaskOperateModel.h"
#import "Harpy.h"
#import "HYHelper.h"
#import "HYMyProxyModel.h"
#import "HYMenuNewTaskView.h"
#import "HYMessageViewController.h"


@interface HYMainViewController ()
{
    NSMutableArray        *dataSource;
    BOOL                  reload;
    int _itemTag;
    NSNumber *pageCount;
    NSNumber *recordCount;
    NSNumber *messageCount;
    BOOL ishead;
    int currentPage;
    int rows;
    UIView *nullView;
    NSMutableDictionary *allMsgCountDic;
    NSMutableArray *proxysArray;
    HYMenuNewTaskView *newMenu;
    NSString *nextPageMsg;
    BOOL nextPageFlag;
}
@property (nonatomic, strong) Pull2RefreshTableView *_dataList;


@end

@implementation HYMainViewController
@synthesize _dataList;
@synthesize currentSumMsgCount;
@synthesize switchFlag;
@synthesize isFirst;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentPage = 0;
        nextPageFlag = YES;
        rows = 10;
        pageCount = [[NSNumber alloc] initWithInt:-1];
        recordCount = [[NSNumber alloc] init];
        messageCount = [[NSNumber alloc] init];
        proxysArray = [[NSMutableArray alloc] init];
        ishead = true;
        currentSumMsgCount = 0;
        _itemTag = 0;
        switchFlag = NO;
        isFirst = YES;
        [[super getTabbarController] initItemsBar];
        allMsgCountDic = [[NSMutableDictionary alloc] init];
        nextPageMsg = nil;
    }
    return self;
}

-(void)removeAllData
{
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    if(dataSource != nil)
    {
        [dataSource removeAllObjects];
    }
    if(_dataList != nil)
    {
        [_dataList reloadData];
    }
}

-(void)setItemTag:(int)itemTag
{
    _itemTag = itemTag;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        ishead = true;
        [[[self getNavigationController] getView] setHidden:NO];
        [[[self getTabbarController] getView] setHidden:NO];
        [[self getNavigationController] setCenterTittle:MY_TASK_START];
        [[self getNavigationController] setCenterTittleFont:[UIFont fontWithName:FONT_BOLD size:16]];
        [[self getNavigationController] setCenterTittleColor:[UIColor whiteColor]];
        [[self getNavigationController] setRightButtonImage:[HYImageFactory GetImageByName:@"rightButton" AndType:PNG]];
        [[self getNavigationController] showRightButton];
        [[self getNavigationController] hideLeftButton];
        [[self getNavigationController] hideLeftTittle];
        [[self getNavigationController] setRightButtonTittle:@""];
        
        if(isFirst)
        {
            NSArray *items = [[self getTabbarController] getItems];
            HYTabItemController *itemController = [items objectAtIndex:0];
            [itemController setSelect:YES];
        }
        
        if([[self getTabbarController] getSelectItem] != nil)
        {
            //        [[[self getTabbarController] getLastSelectItem] setSelect:YES];
            [[self getNavigationController] setCenterTittle:[[[self getTabbarController] getSelectItem] getName]];
        }
        
    [self bindAction];
    [dataSource removeAllObjects];
    [_dataList reloadData];
    [self reloadData];
//        [self getNextPageData];
}

-(void)getNextPageData
{
    
    int flagPage = currentPage + 1;
    if(flagPage == [pageCount intValue])
    {
        nextPageFlag = NO;
        _dataList.pageCountFlag = YES;
        _dataList.flag = YES;
        [_dataList setSatues];
        return;
    }
     _dataList.pageCountFlag = NO;
    _dataList.flag = NO;
    NSString *listType = nil;
    if(_itemTag == TASK_START)
    {

        listType = @"Initiator";
    }
    if(_itemTag == TASK_EXC)
    {

        listType = @"Executor";
    }
    if(_itemTag == TASK_JOIN)
    {
        listType = @"Paticrpant";
    }
    
    int nextPage = currentPage + 1;
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.accountName,@"AccountName",self.user.token,@"Token",@"GetList4Mobile",@"opeType",listType,@"listType",[NSString stringWithFormat:@"%d",nextPage],@"page",[NSString stringWithFormat:@"%d",rows],@"rows",nil];
    
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
    [request setDidFinishSelector:@selector(endGetNextPageDataFin:)];
    [request setDidFailSelector:@selector(endGetNextPageDataFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
    
//    [[[DataProcessing alloc] init] sentRequest:url Parem:params Target:self];
}

- (void) endGetNextPageDataFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetNextPageDataString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endGetNextPageDataFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetNextPageDataStringFail:) withObject:responsestring waitUntilDone:YES];
}

-(void)endGetNextPageDataStringFail:(NSString *)msg
{
    [SVProgressHUD dismiss];
//    [SVProgressHUD showErrorWithStatus:@"服务器连接失败,请检查网络!"];
    //    [self logoutAction];
}

-(void)endGetNextPageDataString:(NSString *)msg
{
    nextPageMsg = msg;
    currentPage = currentPage + 1;
//    [_dataList setSatues];
}


-(void)remoteLoadData
{
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
    date = [formatter stringFromDate:[NSDate date]];
    NSLog(@"客户端准备提交请求的时间: %@", date);
    if (ishead)
    {
        currentPage = 0;
        nextPageFlag = YES;
        nextPageMsg = nil;
        _dataList.pageCountFlag = NO;
        _dataList.flag = NO;
    }
//    if([pageCount intValue] == currentPage)
//    {
//        _dataList.pageCountFlag = false;
//        [_dataList completeDragRefresh];
//        return;
//    }
    
    NSString *listType = nil;
    if(_itemTag == TASK_START)
    {
        if(switchFlag)
        {
            currentPage = 0;
            _dataList.pageCountFlag = NO;
            _dataList.flag = NO;
            nextPageMsg = nil;
            nextPageFlag = YES;
            [self getNextPageData];
        }else
        {
            [self getNextPageData];
        }
        listType = @"Initiator";
    }
    if(_itemTag == TASK_EXC)
    {
        if(switchFlag)
        {
            currentPage = 0;
            _dataList.pageCountFlag = NO;
            _dataList.flag = NO;
            nextPageMsg = nil;
            nextPageFlag = YES;
            [self getNextPageData];
        }else
        {
            [self getNextPageData];
        }
        listType = @"Executor";
    }
    if(_itemTag == TASK_JOIN)
    {
        if(switchFlag)
        {
            currentPage = 0;
            _dataList.pageCountFlag = NO;
            _dataList.flag = NO;
            nextPageMsg = nil;
            nextPageFlag = YES;
            [self getNextPageData];
        }else
        {
            [self getNextPageData];
        }
        listType = @"Paticrpant";
    }
    
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.accountName,@"AccountName",self.user.token,@"Token",@"GetList4Mobile",@"opeType",listType,@"listType",[NSString stringWithFormat:@"%d",currentPage],@"page",[NSString stringWithFormat:@"%d",rows],@"rows",nil];
    
    NSURL *url = [[NSURL alloc] initWithString:TaskHandler_api];
    
    [[[DataProcessing alloc] init] sentRequest:url Parem:params Target:self];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getAllMessageCount];
        dispatch_sync(dispatch_get_main_queue(), ^{
                NSArray *allItems = self.getTabbarController.getItems;
                for (int i = 0; i< [allItems count]; i++) {
                    HYTabItemController *itemController = [allItems objectAtIndex:i];
                    NSString *badgeString = [allMsgCountDic objectForKey:itemController.getType];
                    
                    [itemController setBadgeNumber:[badgeString intValue]];
            }
        });
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getUserByProxy];
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if([proxysArray count] != 0)
            {
                newMenu = [[HYMenuNewTaskView alloc] init];
                NSMutableArray *showNames = [[NSMutableArray alloc] init];
                NSMutableArray *icons = [[NSMutableArray alloc] init];
                [showNames addObject:@"自己发起"];
                [showNames addObject:@"帮人发起"];
                [icons addObject:@"take_task"];
                [icons addObject:@"helppep"];
                [newMenu setShow:NO];
                [newMenu initWithIcons:icons showNames:showNames bgImgName:@"kuang" AndProxyArray:proxysArray];
                [[self getNavigationController] removeRightTarget];
                [[self getNavigationController] setRightButtonTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
            }
            
//
        });
    });
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
    date = [formatter stringFromDate:[NSDate date]];
    NSLog(@"客户端提交请求后的时间: %@", date);
}

-(void)showMenu:(id)sender
{
    if(!newMenu.isShow)
    {
        [self.view addSubview:newMenu];
    }else
    {
        [newMenu removeFromSuperview];
    }
    [newMenu setShow:![newMenu isShow]];
}

-(void)getUserByProxy
{
    if(self.user == nil)
    {
        self.user = [HYHelper getUser];
    }
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.accountName,@"AccountName",self.user.token,@"Token",@"GetUserByProxy",@"opeType",nil];
    
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
    [request setDidFinishSelector:@selector(endGetUserByProxyFin:)];
    [request setDidFailSelector:@selector(endGetUserByProxyFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startSynchronous];
}

- (void) endGetUserByProxyFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetUserByProxyString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endGetUserByProxyFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetUserByProxyStringFail:) withObject:responsestring waitUntilDone:YES];
}

-(void)endGetUserByProxyStringFail:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"服务器连接失败,请检查网络!"];
    //    [self logoutAction];
}

-(void)endGetUserByProxyString:(NSString *)msg
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
        [proxysArray removeAllObjects];
        for (int i = 0; i < [contents count]; i++) {
            NSDictionary *dic = [contents objectAtIndex:i];
            HYMyProxyModel *proxyModel = [[HYMyProxyModel alloc] init];
            proxyModel.proxy = [dic objectForKey:@"AccountName"];
            proxyModel.proxyName = [dic objectForKey:@"UserName"];
            [proxysArray addObject:proxyModel];
            
        }
    }else
    {
        //        [self logoutAction];
    }
}

-(void)getAllMessageCount
{
    if(self.user == nil)
    {
        self.user = [HYHelper getUser];
    }
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.accountName,@"AccountName",self.user.token,@"Token",@"MessageCount",@"opeType",nil];
    
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
    [request setDidFinishSelector:@selector(endGetAllMessageCountFin:)];
    [request setDidFailSelector:@selector(endGetAllMessageCountFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startSynchronous];
}

- (void) endGetAllMessageCountFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetAllMessageCountString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endGetAllMessageCountFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetAllMessageCountStringFail:) withObject:responsestring waitUntilDone:YES];
}

-(void)endGetAllMessageCountStringFail:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"服务器连接失败,请检查网络!"];
    //    [self logoutAction];
}

-(void)endGetAllMessageCountString:(NSString *)msg
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
        [allMsgCountDic removeAllObjects];
        for (int i = 0; i < [contents count]; i++) {
            NSDictionary *dic = [contents objectAtIndex:i];
            [allMsgCountDic setObject:[dic objectForKey:@"Count"] forKey:[dic objectForKey:@"ListType"]];
        }
    }else
    {
        //        [self logoutAction];
    }
}


-(void)endFailedRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    //NSLog(@"msg = %@", msg);
    [SVProgressHUD showErrorWithStatus:msg];
    [_dataList completeDragRefresh];
    return;
}

-(void)checkVersion:(NSString *)token andAccountName:(NSString *)username
{
    [Harpy checkVersion:token andAccountName:username];
}

-(void)addTaskInList:(NSString *)msg
{
    currentSumMsgCount = 0;
    if(ishead)
    {
        [dataSource removeAllObjects];
    }
    NSError *error;
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *taskList = nil;
    NSArray *contents = nil;
    NSString *result = [json objectForKey:@"Success"];
//    HYTabItemController *currentSelect = [[self getTabbarController] getSelectItem];
    if([result boolValue])
    {
        contents = [json objectForKey:@"Content"];
        if([contents count] <= 0)
        {
//            [SVProgressHUD dismiss];
            UIImageView *nullImgView = nil;
            if(nullView == nil)
            {
                nullView = [[UIView alloc] initWithFrame:CGRectMake(([HYScreenTools getScreenWidth] - 300) / 2, (_dataList.frame.size.height - 300) / 2, 300, 300)];
                nullImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 300, 300)];
                [nullView addSubview:nullImgView];
            }
            if(_itemTag == TASK_START)
            {
                [nullImgView setImage:[HYImageFactory GetImageByName:@"b" AndType:PNG]];
            }
            if(_itemTag == TASK_EXC)
            {
                [nullImgView setImage:[HYImageFactory GetImageByName:@"a" AndType:PNG]];
            }
            if(_itemTag == TASK_JOIN)
            {
                [nullImgView setImage:[HYImageFactory GetImageByName:@"c" AndType:PNG]];
            }
            if(!ishead)
            {
                [nullView removeFromSuperview];
                [_dataList setBackgroundView:nullView];
                [_dataList removeDragFooterView];
                //                currentSumMsgCount = 0;
                //                [currentSelect setBadgeNumber:currentSumMsgCount];
            }
            [_dataList completeDragRefresh];
            [SVProgressHUD dismiss];
            return;
        }
        NSDictionary *content = [contents objectAtIndex:0];
        pageCount = [content objectForKey:@"PageCount"];
        recordCount = [content objectForKey:@"RecordCount"];
        taskList = [content objectForKey:@"TaskList"];
        if([taskList count] == 0)
        {
            UIImageView *nullImgView = nil;
            if(nullImgView == nil)
            {
                nullImgView = [[UIImageView alloc] initWithFrame:CGRectMake(([HYScreenTools getScreenWidth] - 300) / 2, (_dataList.frame.size.height - 300) / 2, 300, 300)];
            }
            if(_itemTag == TASK_START)
            {
                [nullImgView setImage:[HYImageFactory GetImageByName:@"b" AndType:PNG]];
            }
            if(_itemTag == TASK_EXC)
            {
                [nullImgView setImage:[HYImageFactory GetImageByName:@"a" AndType:PNG]];
            }
            if(_itemTag == TASK_JOIN)
            {
                [nullImgView setImage:[HYImageFactory GetImageByName:@"c" AndType:PNG]];
            }
            if(ishead)
            {
                //                currentSumMsgCount = 0;
                //                [currentSelect setBadgeNumber:currentSumMsgCount];
                [_dataList removeDragFooterView];
                [_dataList reloadData];
                
                [nullImgView removeFromSuperview];
                [_dataList addSubview:nullImgView];
            }
        }else
        {
            for (int i = 0; i < [taskList count]; i++) {
                HYTaskModel *taskModel = [[HYTaskModel alloc] init];
                taskModel.messageCount = 0;
                taskModel.lastOperateInfo = @"";
                //            taskModel.operateList = [[NSMutableArray alloc] init];
                NSDictionary *taskDic = [taskList objectAtIndex:i];
                taskModel.ID = [taskDic objectForKey:@"ID"];
                taskModel.name = [taskDic objectForKey:@"Name"];
                taskModel.endTime = [taskDic objectForKey:@"EndTime"];
                taskModel.type = _itemTag;
                taskModel.status = [taskDic objectForKey:@"TaskStatus"];
                NSString *operateInfo = [taskDic objectForKey:@"Operate"];
                taskModel.lastOperateInfo = operateInfo;
                //            for (int j = 0; j < [operateList count]; j++) {
                //                HYTaskOperateModel *opModel = [[HYTaskOperateModel alloc] init];
                //                NSDictionary *opDic = [operateList objectAtIndex:j];
                //                opModel.taskID = [opDic objectForKey:@"TaskID"];
                //                opModel.operate = [opDic objectForKey:@"Operate"];
                //                opModel.accountName = [opDic objectForKey:@"AccountName"];
                //                opModel.username = [opDic objectForKey:@"UserName"];
                //                opModel.ID = [opDic objectForKey:@"ID"];
                //                opModel.headImg = [opDic objectForKey:@"HeadImg"];
                //                opModel.createTime = [opDic objectForKey:@"CreateTime"];
                //                opModel.type = [opDic objectForKey:@"Type"];
                //                opModel.proxy = [opDic objectForKey:@"Proxy"];
                //                opModel.proxyName = [opDic objectForKey:@"ProxyName"];
                //                [taskModel.operateList addObject:opModel];
                //            }
                taskModel.messageCount = [[taskDic objectForKey:@"MessageCount"] intValue];
                //            currentSumMsgCount = currentSumMsgCount + taskModel.messageCount;
                [dataSource addObject:taskModel];
                //NSLog(@"HYMainViewController datasource count = %d", [dataSource count]);
            }
            //        //NSLog(@"HYMainViewController datasource count = %@", test.name);
            [_dataList reloadData];
            
            //        [currentSelect setBadgeNumber:currentSumMsgCount];
            [SVProgressHUD dismiss];
            
            if([HYHelper getRemoteTaskID] != nil)
            {
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
        [SVProgressHUD dismiss];
        [super logoutAction];
        [SVProgressHUD showErrorWithStatus:@"任务获取失败!"];
    }
    [SVProgressHUD dismiss];
    [_dataList completeDragRefresh];
}


-(void) endRequest:(NSString *)msg
{
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
    date = [formatter stringFromDate:[NSDate date]];
    NSLog(@"服务器回应数据的时间: %@", date);
    [self addTaskInList:msg];
    
    date = [formatter stringFromDate:[NSDate date]];
    NSLog(@"服务器回应后数据处理的时间: %@", date);
//    if(currentPage == )
}

-(void)reloadData
{
    if(dataSource == nil)
    {
        dataSource = [[NSMutableArray alloc] init];
    }
    [dataSource removeAllObjects];
    
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self remoteLoadData];
        dispatch_sync(dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
        });
    });
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMainDataList];
    // Do any additional setup after loading the view.
    //初始化主窗体
   
    
    //绑定事件
//    [self pull2RefreshTableView];
    
}


-(void)bindAction
{
    [[self getNavigationController] setRightButtonTarget:self action:@selector(newTaskAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)newTaskAction:(id)sender
{
    HYNewTaskViewController *createTask = [[HYNewTaskViewController alloc] init];
//    createTask.isNew = YES;
    createTask.user = self.user;
    self.user.isNew = YES;
    self.user.selectPartList = nil;
    self.user.partList = nil;
    self.user.excList = nil;
    self.user.paticrpantString = @"";
    self.user.executorString = @"";
    self.user.endTimeString = @"";
    [createTask setTitle:@""];
    [[self getNavigationController] pushController:createTask];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initMainDataList
{
    _dataList = [[Pull2RefreshTableView alloc] initWithFrame:CGRectMake(0, ([[self getNavigationController] getNavigationHeight] + [HYScreenTools getStatusHeight]), [HYScreenTools getScreenWidth], ([HYScreenTools getScreenHeight] - [HYScreenTools getStatusHeight] - [[self getNavigationController] getNavigationHeight] - [[self getTabbarController] getTabbarHeight])) showDragRefreshHeader:YES showDragRefreshFooter:NO];
    _dataList.dragHeaderHeight = pull2RefreshHeaderHeight;
    _dataList.dragFooterHeight = pull2RefreshFooterHeight;
    
    __weak HYMainViewController *vc = self;
    _dataList.dragEndBlock = ^(Pull2RefreshViewType type)
    {
        if (type == kPull2RefreshViewTypeHeader)
        {
            ishead = true;
            _dataList.pageCountFlag = NO;
            _dataList.flag = NO;
            _dataList.ishead = YES;
            [vc reloadInitDataInOtherThread];
        }
        else
        {
            ishead = false;
            if(nextPageFlag)
            {
//                _dataList.pageCountFlag = NO;
                [vc addMoreDataInOtherThread];
            }else
            {
//                [_dataList completeDragRefresh];
                _dataList.pageCountFlag = YES;
                _dataList.flag = YES;
//                [_dataList completeDragRefresh];
                
            }
        }
    };
    if(_dataList.dic == nil)
    {
        _dataList.dic = [[NSMutableArray alloc] init];
    }
    _dataList.user = self.user;
    _dataList.dic = dataSource;
    _dataList.dataSource = self;
    
    [self.view addSubview:_dataList];
    
    [self addMoreData];
    
    
    
    
}

#pragma mark - TabelView
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 20;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * showUserInfoCellIdentifier = @"taskListCell";
    HYTaskListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    // Create a cell to display an ingredient.
    cell = [[HYTaskListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:showUserInfoCellIdentifier];
    //NSLog(@"dataSource count = %d", [dataSource count]);
    cell.model = [dataSource objectAtIndex:indexPath.row];
    [cell initControl];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 60;
//}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

#pragma mark - 模拟获取数据
- (void)addMoreDataInOtherThread
{
    switchFlag = NO;
    [self addMoreData];
    [self addTaskInList:nextPageMsg];
    [self getNextPageData];
//    [self remoteLoadData];
}

- (void)addMoreData
{
//    sleep(2);
//    [_dataList reloadData];
//    [_dataList completeDragRefresh];
    
    _dataList.shouldShowDragFooter = YES;
    [_dataList addDragFooterView];
}

- (void)reloadInitDataInOtherThread
{
//    [dataSource removeAllObjects];
//    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
    date = [formatter stringFromDate:[NSDate date]];
    NSLog(@"客户端上拉获取数据的的时间: %@", date);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self remoteLoadData];
        dispatch_sync(dispatch_get_main_queue(), ^{
            //            [SVProgressHUD dismiss];
        });
    });
//    [NSThread detachNewThreadSelector:@selector(remoteLoadData) toTarget:self withObject:nil];
}

- (void)reloadInitData
{
    sleep(20);
    if (dataSource.count > 0)
    {
        [dataSource removeAllObjects];
    }
    
    NSArray *initDataArr = [NSArray arrayWithObjects:@"Row", @"Row", @"Row", @"Row", @"Row", @"Row", @"Row", @"Row", @"Row", @"Row", @"Row", @"Row", @"Row", @"Row", @"Row", @"Row", @"Row", @"Row", @"Row", @"Row", nil];
    [dataSource addObject:initDataArr];
    
    [_dataList reloadData];
    [_dataList completeDragRefresh];
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

@end
