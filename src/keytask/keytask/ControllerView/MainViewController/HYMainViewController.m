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
}
@property (nonatomic, strong) Pull2RefreshTableView *_dataList;
@property (strong, nonatomic) HYNewTaskViewController *createTask;


@end

@implementation HYMainViewController
@synthesize _dataList;
@synthesize createTask;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentPage = 0;
        rows = 10;
        pageCount = [[NSNumber alloc] init];
        recordCount = [[NSNumber alloc] init];
        messageCount = [[NSNumber alloc] init];
        ishead = true;
    }
    return self;
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
    
    if([[self getTabbarController] getLastSelectItem] != nil)
    {
        [[self getNavigationController] setCenterTittle:[[[self getTabbarController] getLastSelectItem] getName]];
    }
    
    [self bindAction];
    [self reloadData];
}

-(void)remoteLoadData
{
    if (ishead)
    {
        currentPage = 0;
    }
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
    
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.accountName,@"AccountName",self.user.token,@"Token",@"GetList4Mobile",@"opeType",listType,@"listType",[NSString stringWithFormat:@"%d",currentPage],@"page",[NSString stringWithFormat:@"%d",rows],@"rows",nil];
    
    NSURL *url = [[NSURL alloc] initWithString:TaskHandler_api];
    
    [[[DataProcessing alloc] init] sentRequest:url Parem:params Target:self];
}
-(void)endFailedRequest:(NSString *)msg
{
    NSLog(@"%@", msg);
}

-(void) endRequest:(NSString *)msg
{
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
    if([result boolValue])
    {
        contents = [json objectForKey:@"Content"];
        if([contents count] <= 0)
        {
            [SVProgressHUD showSuccessWithStatus:@"没有任务!"];
            return;
        }
        NSDictionary *content = [contents objectAtIndex:0];
        pageCount = [content objectForKey:@"PageCount"];
        recordCount = [content objectForKey:@"RecordCount"];
        taskList = [content objectForKey:@"TaskList"];
        if([taskList count] == 0)
        {
            [_dataList completeDragRefresh];
            return;
        }
        for (int i = 0; i < [taskList count]; i++) {
            HYTaskModel *taskModel = [[HYTaskModel alloc] init];
            taskModel.operateList = [[NSMutableArray alloc] init];
            NSDictionary *taskDic = [taskList objectAtIndex:i];
            taskModel.ID = [taskDic objectForKey:@"ID"];
            taskModel.name = [taskDic objectForKey:@"Name"];
            taskModel.endTime = [taskDic objectForKey:@"EndTime"];
            taskModel.type = _itemTag;
            taskModel.status = [taskDic objectForKey:@"TaskStatus"];
            NSArray *operateList = [taskDic objectForKey:@"Operate"];
            for (int j = 0; j < [operateList count]; j++) {
                HYTaskOperateModel *opModel = [[HYTaskOperateModel alloc] init];
                NSDictionary *opDic = [operateList objectAtIndex:j];
                opModel.taskID = [opDic objectForKey:@"TaskID"];
                opModel.operate = [opDic objectForKey:@"Operate"];
                opModel.accountName = [opDic objectForKey:@"AccountName"];
                opModel.username = [opDic objectForKey:@"UserName"];
                opModel.ID = [opDic objectForKey:@"ID"];
                opModel.headImg = [opDic objectForKey:@"HeadImg"];
                opModel.createTime = [opDic objectForKey:@"CreateTime"];
                [taskModel.operateList addObject:opModel];
            }
            [dataSource addObject:taskModel];
            NSLog(@"HYMainViewController datasource count = %d", [dataSource count]);
        }
//        NSLog(@"HYMainViewController datasource count = %@", test.name);
        [_dataList reloadData];
        [SVProgressHUD dismiss];
    }else
    {
        [super logoutAction];
        [SVProgressHUD showErrorWithStatus:@"任务获取失败!"];
    }
    [_dataList completeDragRefresh];
    currentPage = currentPage + 1;
}

-(void)reloadData
{
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    if(dataSource == nil)
    {
        dataSource = [[NSMutableArray alloc] init];
    }
    [dataSource removeAllObjects];
    
    [self remoteLoadData];
    [self initMainDataList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    createTask = [[HYNewTaskViewController alloc] init];
    createTask.user = self.user;
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
            [vc reloadInitDataInOtherThread];
        }
        else
        {
            ishead = false;
            [vc addMoreDataInOtherThread];
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
    NSLog(@"dataSource count = %d", [dataSource count]);
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
    [self addMoreData];
    [self remoteLoadData];
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
    [self remoteLoadData];
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
