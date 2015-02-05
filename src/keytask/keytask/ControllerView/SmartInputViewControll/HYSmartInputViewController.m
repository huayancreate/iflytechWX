//
//  HYSmartInputViewController.m
//  keytask
//
//  Created by 许 玮 on 14-10-22.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYSmartInputViewController.h"
#import "HYImageFactory.h"
#import "HYConstants.h"
#import "HYControlFactory.h"
#import "HYScreenTools.h"
#import "HYNetworkInterface.h"
#import "HYSmartInputModel.h"
#import "HYScrollView.h"

@interface HYSmartInputViewController ()
{
    UIScrollView *scrollView;
    NSMutableArray *dataSource;
    UITextField *inputText;
    UITableView *resultNameList;
    UIScrollView *resultView;
    NSMutableArray *selectList;
    NSMutableArray *selectListView;
    NSMutableArray *lastPartList;
    NSMutableArray *lastExcList;
    NSMutableArray *lastProxyList;
    int selectRows;
    float rowsWidth;
    UIImageView *inputscrollView;
    NSMutableArray *lastAddPartViewList;
    NSMutableArray *addPartViewList;
}

@end

@implementation HYSmartInputViewController
@synthesize current;
@synthesize proxyList;
@synthesize partList;
@synthesize isFirstManInput;
@synthesize excList;
@synthesize isAddPartViewInput;
@synthesize isProxyInput;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(dataSource == nil)
    {
        dataSource = [[NSMutableArray alloc] init];
        selectList = [[NSMutableArray alloc] init];
        selectListView = [[NSMutableArray alloc] init];
    }
    lastPartList = [[NSMutableArray alloc] init];
    lastExcList = [[NSMutableArray alloc] init];
    lastProxyList = [[NSMutableArray alloc] init];
    selectRows = 0;
    rowsWidth = 0.0;
    addPartViewList = [[NSMutableArray alloc] init];
//    isAddPartViewInput = NO;
//    isFirstManInput = NO;
    [self bindAction];
    [self initControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [addPartViewList removeAllObjects];
    [super viewWillAppear:animated];
    [[[self getNavigationController] getView] setHidden:NO];
    [[[self getTabbarController] getView] setHidden:YES];
    [[self getNavigationController] setCenterTittle:[self title]];
    [[self getNavigationController] setLeftButtonImage:[HYImageFactory GetImageByName:@"leftButton" AndType:PNG]];
    [[self getNavigationController] setCenterTittle:self.title];
//    [[self getNavigationController] hideRightButton];
    
    [[[self getNavigationController] getRightButton] setBackgroundImage:nil forState:UIControlStateNormal];
    [[self getNavigationController] showLeftButton];
    [[self getNavigationController] hideLeftTittle];
    [[self getNavigationController] showRightButton];
    [[self getNavigationController] removeRightTarget];
    [[self getNavigationController] setRightButtonImage:[HYImageFactory GetImageByName:@"topbg" AndType:PNG]];
    [[self getNavigationController] setRightButtonTittle:@"确 定"];
    [[self getNavigationController] setRightButtonTarget:nil action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
//    [[[self getNavigationController] getRightButton] setTitle:@"确 定" forState:UIControlStateNormal];
    
//    [SVProgressHUD showWithStatus:@"获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    //TEST
    if(selectList != nil)
    {
        [selectList removeAllObjects];
    }
    if(proxyList != nil)
    {
        selectList = proxyList;
        lastProxyList = [proxyList mutableCopy];
        [self addSelectViewInReusltView];
    }
    
    if(partList != nil)
    {
        if(isAddPartViewInput)
        {
            if(self.user.partList == nil)
            {
                self.user.partList = [[NSMutableArray alloc] init];
                self.user.partList = partList;
            }
            lastPartList = [partList mutableCopy];
            if([self.user.isAddPartViewList count] > 0)
            {
                lastAddPartViewList = [self.user.isAddPartViewList mutableCopy];
            }
            selectList = nil;
            selectList = [[NSMutableArray alloc] init];
        }else
        {
            selectList = partList;
            lastPartList = [partList mutableCopy];
        }
        [self addSelectViewInReusltView];
        
    }
    if(excList != nil)
    {
        selectList = excList;
        lastExcList = [excList mutableCopy];
        [self addSelectViewInReusltView];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [SVProgressHUD showWithStatus:@"获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    [self getSmartInput];
}

-(void)bindAction
{
    [[self getNavigationController] setLeftButtonTarget:nil action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)backAction:(id)sender
{
    if(proxyList != nil)
    {
        self.user.proxyList = lastProxyList;
        self.user.partList = nil;
        self.user.excList = nil;
    }
    
    if(partList != nil)
    {
        if(isAddPartViewInput)
        {
            self.user.partList = lastPartList;
            self.user.isAddPartViewList = lastAddPartViewList;
            self.user.excList = nil;
            self.user.proxyList = nil;
        }else
        {
            
            self.user.partList = lastPartList;
            self.user.excList = nil;
            self.user.proxyList = nil;
        }
        
    }
    if(excList != nil)
    {
        self.user.excList = lastExcList;
        self.user.partList = nil;
        self.user.proxyList = nil;
    }
    
    
    [[self getNavigationController] popController:self];
    [[[self getTabbarController] getSelectItem] setSelect:NO];
    [[[self getTabbarController] getLastSelectItem] setSelect:YES];
}

-(void)selectAction:(id)sender
{
    if([addPartViewList count] > 0)
    {
        for (int i = 0; i < [addPartViewList count]; i++) {
            [self.user.partList addObject:[addPartViewList objectAtIndex:i]];
            [self.user.isAddPartViewList addObject:[addPartViewList objectAtIndex:i]];
        }
    }
    
    
    [[self getNavigationController] popController:self];
}

-(void)testAction
{
    //NSLog(@"12312312312");
}

-(void)initControl
{
    inputscrollView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(0, ([HYScreenTools getStatusHeight] +  [[self getNavigationController] getNavigationHeight] + 2), [HYScreenTools getScreenWidth], 40) backgroundImgName:nil backgroundColor:[UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f] isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f]];
//    self.view.userInteractionEnabled = YES;
    
    resultView = [[HYScrollView alloc] initWithFrame:CGRectMake(5, (inputscrollView.frame.origin.y + inputscrollView.frame.size.height + 2), [HYScreenTools getScreenWidth] - 10, 40)];
    [resultView setBackgroundColor:[UIColor whiteColor]];
    [resultView.layer setMasksToBounds:YES];
    [resultView.layer setBorderWidth:1];
    [resultView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    resultView.delegate = self;
    resultView.userInteractionEnabled = YES;
    
//    scrollView = [HYControlFactory GetScrollViewWithCGRect:CGRectMake(0,([HYScreenTools getStatusHeight] +  [[self getNavigationController] getNavigationHeight]), [HYScreenTools getScreenWidth], ([HYScreenTools getScreenHeight] - [HYScreenTools getStatusHeight] -[[self getNavigationController] getNavigationHeight] - 180)) backgroundColor:[UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f] backImgName:nil delegate:self];
    

//    scrollView.userInteractionEnabled = YES;
//    scrollView.delegate = self;
    
    [self.view addSubview:inputscrollView];
//    [self.view addSubview:scrollView];
//    resultView.directionalLockEnabled = YES;
    
//    [scrollView addSubview:resultView];
    [self.view addSubview:resultView];
    
    
    resultNameList = [[UITableView alloc] init];
    [resultNameList setBackgroundColor:[UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f]];
    resultNameList.dataSource = self;
    resultNameList.delegate = self;
    [self.view addSubview:resultNameList];
//    [scrollView addSubview:resultNameList];
    
    inputText = [HYControlFactory GetTextFieldWithCGRect:CGRectMake(5, 5, 255, 30) Placeholder:@"请输入域账号查询" SecureTextEntry:NO];
    [inputText setBackgroundColor:[UIColor whiteColor]];
    inputText.layer.cornerRadius = 2.0f;
    inputText.layer.masksToBounds = YES;
    inputText.layer.borderWidth = 1.0f;
    inputText.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [inputscrollView addSubview:inputText];
    
    UIButton *searchBtn = [HYControlFactory GetButtonWithCGRect:CGRectMake(inputText.frame.origin.x + inputText.frame.size.width + 3, inputText.frame.origin.y, inputscrollView.frame.size.width - inputText.frame.origin.x - inputText.frame.size.width - 6, 30) backgroundImg:@"smartsearch" selectBackgroundImgName:@"smartsearch_hover" addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setTitle:@"查 询" forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:[UIFont fontWithName:FONT size:14]];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [inputscrollView addSubview:searchBtn];
    
}

-(void)searchAction
{
    NSString *inputString = inputText.text;
    if(inputString == nil)
    {
        inputString = @"";
    }
    [self getSmartInputThread:inputString];
//    inputText.text = @"";
}

-(void)getSmartInput
{
    NSString *inputString = inputText.text;
    if(inputString == nil)
    {
        inputString = @"";
    }
    [self getSmartInputThread:inputString];
}

-(void)getSmartInputThread:(NSString *)searchString
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.accountName,@"AccountName",searchString,@"worker",nil];
    
    NSURL *url = [[NSURL alloc] initWithString:SmartInput_api];
    
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
    [request setDidFinishSelector:@selector(endSmartInputFin:)];
    [request setDidFailSelector:@selector(endSmartInputFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}


- (void) endSmartInputFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endSmartInputString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endSmartInputFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endSmartInputStringFail:) withObject:responsestring waitUntilDone:YES];
}

-(void)endSmartInputStringFail:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"服务器连接失败,请检查网络!"];
    //    [self logoutAction];
}

-(void)endSmartInputString:(NSString *)msg
{
    [SVProgressHUD dismiss];
    NSError *error;
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    [dataSource removeAllObjects];
    for (int i = 0; i < [json count]; i++) {
        NSDictionary *dic = [json objectAtIndex:i];
        HYSmartInputModel *smartModel = [[HYSmartInputModel alloc] init];
        smartModel.name = [dic objectForKey:@"Name"];
        smartModel.accountName = [dic objectForKey:@"AccountName"];
        smartModel.deptName = [dic objectForKey:@"DeptName"];
        [dataSource addObject:smartModel];
    }
    
    float resultNameListHeight = 0;
    if([dataSource count] <= 4)
    {
        resultNameListHeight = 40 * [dataSource count];
    }else
    {
        resultNameListHeight = 40 * 4;
    }
    resultNameList.frame = CGRectMake(5, (resultView.frame.origin.y + resultView.frame.size.height + 2), resultView.frame.size.width, resultNameListHeight);
    [resultNameList reloadData];
}

#pragma tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * showUserInfoCellIdentifier = @"taskListCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    // Create a cell to display an ingredient.
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:showUserInfoCellIdentifier];
    [cell setBackgroundColor:[UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f]];
    HYSmartInputModel *smartModel = [dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [smartModel getString];
    [cell.textLabel setFont:[UIFont fontWithName:FONT size:12]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYSmartInputModel *smartModel = [dataSource objectAtIndex:indexPath.row];
    if(isProxyInput == YES && [selectList count] == 1)
    {
        [SVProgressHUD showErrorWithStatus:@"已经有助理了,请删除后再添加!"];
        return;
    }
    
    if(isFirstManInput == YES && [selectList count] == 1)
    {
        [SVProgressHUD showErrorWithStatus:@"已经有第一责任人,请删除后再添加!"];
        return;
    }
    BOOL checkFlag = NO;
    for (int i = 0; i < [selectList count]; i++) {
        HYSmartInputModel *checkModel = [selectList objectAtIndex:i];
        if([smartModel.accountName isEqual:checkModel.accountName])
        {
            checkFlag = YES;
            [SVProgressHUD showErrorWithStatus:@"不能添加重复的参与人!"];
            break;
        }
    }
    if(isAddPartViewInput)
    {
        for (int i = 0; i < [lastPartList count]; i++) {
            HYSmartInputModel *checkModel = [lastPartList objectAtIndex:i];
            if([smartModel.accountName isEqual:checkModel.accountName])
            {
                checkFlag = YES;
                [SVProgressHUD showErrorWithStatus:@"不能添加重复的参与人!"];
                break;
            }
        }
    }
    if (checkFlag) {
        return;
    }
    inputText.text = @"";
    
    [selectList addObject:smartModel];
    
    
    [self addSelectViewInReusltView];
}

-(void)delSelectAction:(UIGestureRecognizer *)delSelect
{
    UIImageView *delSelectView = (UIImageView *)delSelect.view;
    [selectList removeObjectAtIndex:delSelectView.tag];
    [self addSelectViewInReusltView];
}

-(void)addSelectViewInReusltView
{
    rowsWidth = 0.0;
    for (UIImageView *oneView in resultView.subviews ) {
        if ([oneView isKindOfClass:[UIImageView class]]) {
            [oneView removeFromSuperview];
        }
    }
//    [resultView removeFromSuperview];
//    [scrollView addSubview:resultView];
    [selectListView removeAllObjects];
    selectRows = 0;
    for (int i = 0; i < [selectList count]; i++) {
        UIImageView *lastSelectView = nil;
        if(i != 0)
        {
            lastSelectView = [selectListView lastObject];
            //NSLog(@"selectView.frame= %f === %f",lastSelectView.frame.origin.x,lastSelectView.frame.origin.y);
        }
        HYSmartInputModel *smartModel = [selectList objectAtIndex:i];
        UIImageView *selectView = [smartModel getSelectImg:i AndTarget:self];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delSelectAction:)];
        [selectView addGestureRecognizer:gesture];
//        NSArray *testTemp =  [selectView gestureRecognizers];
        //NSLog(@"lastSelectView.frame.origin.x = %f  + lastSelectView.frame.size.width = %f  + 3 = %f",lastSelectView.frame.origin.x, lastSelectView.frame.size.width,(lastSelectView.frame.origin.x + lastSelectView.frame.size.width + 3));
        //NSLog(@"rowsWidth = %f + selectView.frame.size.width + 9 = %f", rowsWidth, (rowsWidth + selectView.frame.size.width + 9));
        //NSLog(@"resultView.frame.size.width = %f", resultView.frame.size.width);
        if(rowsWidth + selectView.frame.size.width + 9 > resultView.frame.size.width)
        {
            selectRows = selectRows + 1;
            float ory = 0.0;
            if(selectRows == 1)
            {
                ory = selectRows * 40;
            }
            else
            {
                ory = selectRows * 40 - 7 * (selectRows - 1);
            }
            rowsWidth = 0.0;
            [selectView setFrame:CGRectMake(3, ory , selectView.frame.size.width, selectView.frame.size.height)];
        }else
        {
            if(lastSelectView != nil)
            {
                float ory = 0.0;
                if(selectRows == 0)
                {
                    ory = ory + selectRows * 40 + 7;
                }else
                {
                    if(selectRows == 1)
                    {
                        ory = selectRows * 40;
                    }else
                    {
                        ory = selectRows * 40 - 7 * (selectRows - 1);
                    }
                }
                [selectView setFrame:CGRectMake(lastSelectView.frame.origin.x + lastSelectView.frame.size.width + 3, ory , selectView.frame.size.width, selectView.frame.size.height)];
            }else
            {
                [selectView setFrame:CGRectMake(3, 7 , selectView.frame.size.width, selectView.frame.size.height)];
            }
        }
        rowsWidth = rowsWidth + selectView.frame.size.width;
        
        if(selectRows > 0)
        {
            if(selectRows <= 1 && selectRows != 0)
            {
                [resultView setFrame:CGRectMake(5, (inputscrollView.frame.origin.y + inputscrollView.frame.size.height  + 2), [HYScreenTools getScreenWidth] - 10, 40 * selectRows + 40)];
                [resultNameList setFrame:CGRectMake(5, (resultView.frame.origin.y + resultView.frame.size.height + 2), resultNameList.frame.size.width , resultNameList.frame.size.height)];
            }else
            {
                if(selectRows != 0)
                {
                    float sumRowsWidth = (selectRows + 1) * 33;
                    //                resultView.userInteractionEnabled = YES;
                    //                resultView.showsHorizontalScrollIndicator = NO;
                    [resultView setContentSize:CGSizeMake(resultView.frame.size.width, sumRowsWidth + 7)];
                }else
                {
                    
                }
            }
        }else
        {
            [resultView setFrame:CGRectMake(5, (inputscrollView.frame.origin.y + inputscrollView.frame.size.height + 2), [HYScreenTools getScreenWidth] - 10, 40)];
            [resultNameList setFrame:CGRectMake(5, (resultView.frame.origin.y + resultView.frame.size.height + 2), resultNameList.frame.size.width , resultNameList.frame.size.height)];
            [resultView setContentSize:CGSizeMake(resultView.frame.size.width, 40)];
        }
        [selectListView addObject:selectView];
//        [resultView addSubview:selectView];
        if(smartModel.selectList == nil)
        {
            smartModel.selectList = [[NSMutableArray alloc] init];
        }
//        smartModel.selectList = selectList;
    }
    
    if(proxyList != nil)
    {
        self.user.excList = nil;
        self.user.partList = nil;
        self.user.proxyList = selectList;
    }
    
    if(partList != nil)
    {
        if(isAddPartViewInput)
        {
            if(self.user.isAddPartViewList == nil)
            {
                self.user.isAddPartViewList = [[NSMutableArray alloc] init];
            }
            addPartViewList = selectList;
        }else
        {
            self.user.partList = selectList;
        }
        self.user.excList = nil;
        self.user.proxyList = nil;
    }
    if(excList != nil)
    {
        self.user.excList = selectList;
        self.user.partList = nil;
        self.user.proxyList = nil;
    }
//    resultView.userInteractionEnabled
    for (int i = 0 ; i < [selectListView count]; i++) {
        [resultView addSubview:[selectListView objectAtIndex:i]];
        //[self.view addSubview:[selectListView objectAtIndex:i]];
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
