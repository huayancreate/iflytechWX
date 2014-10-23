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


@interface HYBaseViewController ()
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
        // Custom initialization
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
            user = [[HYUserLoginModel alloc] init];
        }
    }
    return self;
}


-(void)logoutAction
{
    [[[self getNavigationController] getModel] removeAll];
    HYLoginViewController *loginView = [[HYLoginViewController alloc] init];
    [[self getNavigationController] pushController:loginView];
    
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
    NSString *responsestring = @"服务器连接失败";
    [self performSelectorOnMainThread:@selector(endFailedRequest:) withObject:responsestring waitUntilDone:YES];
}


@end
