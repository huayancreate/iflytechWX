//
//  HYWebViewController.m
//  keytask
//
//  Created by 许 玮 on 14-12-3.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYWebViewController.h"
#import "HYScreenTools.h"
#import "HYImageFactory.h"
#import "HYConstants.h"

@interface HYWebViewController ()<UIWebViewDelegate>
{
    UIWebView *webView;
}

@end

@implementation HYWebViewController
@synthesize link_url;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, [HYScreenTools getStatusHeight] + [[self getNavigationController] getNavigationHeight], [HYScreenTools getScreenWidth], [HYScreenTools getScreenHeight] - [HYScreenTools getStatusHeight] - [[self getNavigationController] getNavigationHeight])];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [self bindAction];
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)bindAction
{
    [[self getNavigationController] setLeftButtonTarget:nil action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)backAction:(id)sender
{
    [[self getNavigationController] popController:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[[self getNavigationController] getView] setHidden:NO];
    [[[self getTabbarController] getView] setHidden:YES];
    [[self getNavigationController] setCenterTittle:[self title]];
    [[self getNavigationController] setLeftTittle:@""];
    [[self getNavigationController] hideRightButton];
    [[self getNavigationController] setLeftButtonImage:[HYImageFactory GetImageByName:@"leftButton" AndType:PNG]];
    
    NSURL *url = [[NSURL alloc] initWithString:link_url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [webView loadRequest:request];
    
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
