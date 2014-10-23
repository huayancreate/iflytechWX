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

@interface HYSmartInputViewController ()
{
    UIScrollView *scrollView;
    NSMutableArray *dataSource;
    UITextField *inputText;
    UITableView *resultNameList;
    UIScrollView *resultView;
    NSMutableArray *selectList;
    NSMutableArray *selectListView;
    int selectRows;
    float rowsWidth;
}

@end

@implementation HYSmartInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(dataSource == nil)
    {
        dataSource = [[NSMutableArray alloc] init];
        selectList = [[NSMutableArray alloc] init];
        selectListView = [[NSMutableArray alloc] init];
    }
    selectRows = 0;
    rowsWidth = 0.0;
    [self initControl];
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
    [self getSmartInput];
}

-(void)selectAction:(id)sender
{
    if(self.user.selectList == nil)
    {
        self.user.selectList = [[NSMutableArray alloc] init];
    }
    [self.user.selectList removeAllObjects];
    self.user.selectList = selectList;
    [[self getNavigationController] popController:self];
}

-(void)initControl
{
    scrollView = [HYControlFactory GetScrollViewWithCGRect:CGRectMake(0,([HYScreenTools getStatusHeight] +  [[self getNavigationController] getNavigationHeight]), [HYScreenTools getScreenWidth], ([HYScreenTools getScreenHeight] - [HYScreenTools getStatusHeight] -[[self getNavigationController] getNavigationHeight])) backgroundColor:[UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f] backImgName:nil delegate:self];
    
    [self.view addSubview:scrollView];
    
    resultView = [HYControlFactory GetScrollViewWithCGRect:CGRectMake(5, 2, [HYScreenTools getScreenWidth] - 10, 40)  backgroundColor:[UIColor whiteColor] backImgName:nil delegate:self];
    [resultView.layer setMasksToBounds:YES];
    [resultView.layer setBorderWidth:1];
    [resultView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
//    resultView.directionalLockEnabled = YES;
    
    [scrollView addSubview:resultView];
    
    
    resultNameList = [[UITableView alloc] init];
    [resultNameList setBackgroundColor:[UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f]];
    resultNameList.dataSource = self;
    resultNameList.delegate = self;
    [scrollView addSubview:resultNameList];
    
    inputText = [HYControlFactory GetTextFieldWithCGRect:CGRectMake(5, (scrollView.frame.size.height - 33), resultView.frame.size.width - 62, 30) Placeholder:@"请输入域账号查询" SecureTextEntry:NO];
    [inputText setBackgroundColor:[UIColor whiteColor]];
    inputText.layer.cornerRadius = 2.0f;
    inputText.layer.masksToBounds = YES;
    inputText.layer.borderWidth = 1.0f;
    inputText.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [scrollView addSubview:inputText];
    
    UIButton *searchBtn = [HYControlFactory GetButtonWithCGRect:CGRectMake(inputText.frame.origin.x + inputText.frame.size.width + 3, inputText.frame.origin.y, scrollView.frame.size.width - inputText.frame.origin.x - inputText.frame.size.width - 6, 30) backgroundImg:@"smartsearch" selectBackgroundImgName:@"smartsearch_hover" addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setTitle:@"查 询" forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:[UIFont fontWithName:FONT size:14]];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scrollView addSubview:searchBtn];
    
}

-(void)searchAction
{
    NSString *inputString = inputText.text;
    if(inputString == nil)
    {
        inputString = @"";
    }
    [self getSmartInputThread:inputString];
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
    [request setDidFinishSelector:@selector(endSmartInputFin:)];
    [request setDidFailSelector:@selector(endSmartInputFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}


- (void) endSmartInputFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endSmartInputString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endSmartInputFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endSmartInputString:) withObject:responsestring waitUntilDone:YES];
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
    if([dataSource count] <= 6)
    {
        resultNameListHeight = 40 * [dataSource count];
    }else
    {
        resultNameListHeight = 40 * 6;
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
    UIImageView *selectView = [smartModel getSelectImg];
    UIImageView *lastSelectView = [selectListView lastObject];
    NSLog(@"resultView.frame.size.width = %f",resultView.frame.size.width);
    if(rowsWidth + selectView.frame.size.width + 9 > resultView.frame.size.width)
    {
        selectRows = selectRows + 1;
        float ory = 0.0;
        if(selectRows == 1)
        {
            ory = selectRows * 40;
        }else
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
        if(selectRows <= 3)
        {
            [resultView setFrame:CGRectMake(5, 2, [HYScreenTools getScreenWidth] - 10, 40 * selectRows + 40)];
            [resultNameList setFrame:CGRectMake(5, (resultView.frame.origin.y + resultView.frame.size.height + 2), resultNameList.frame.size.width , resultNameList.frame.size.height)];
        }else
        {
            float sumRowsWidth = (selectRows + 1) * 33;
            resultView.userInteractionEnabled = YES;
            resultView.showsHorizontalScrollIndicator = NO;
            [resultView setContentSize:CGSizeMake(resultView.frame.size.width, sumRowsWidth + 7)];
        }
        
    }
    [selectListView addObject:selectView];
    [selectList addObject:smartModel];
    [resultView addSubview:selectView];
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
