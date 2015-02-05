//
//  HYHelpViewController.m
//  keytask
//
//  Created by 许 玮 on 14/12/17.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYHelpViewController.h"
#import "HYImageFactory.h"
#import "HYConstants.h"
#import "HYControlFactory.h"
#import "HYScreenTools.h"
#import "HYNetworkInterface.h"

@interface HYHelpViewController ()
{
    UITextField *titleTextView;
    UITextField *contentTextView;
    UITextField *telTextView;
}

@end

@implementation HYHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initControl
{
    [self.view setBackgroundColor:[UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f]];
    
    
    UIImageView *titleImgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(0, [HYScreenTools getStatusHeight] + [[self getNavigationController] getNavigationHeight] + 20, [HYScreenTools getScreenWidth], 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:NO closeKeyboard:NO isFrame:YES];
    
    
    UILabel *titileLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(15, 7, 55, 30) textfont:[UIFont fontWithName:FONT size:17] text:@"标题 : " textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentCenter];
    
    titleTextView = [HYControlFactory GetTextFieldWithCGRect:CGRectMake(75, 7, 200, 30) Placeholder:@"" SecureTextEntry:NO];
    titleTextView.text = @"";
    
    [titleImgView addSubview:titleTextView];
    [titleImgView addSubview:titileLabel];
    
    [self.view addSubview:titleImgView];
    
    
    UIImageView *contentImgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(0, titleImgView.frame.origin.y + titleImgView.frame.size.height + 30, [HYScreenTools getScreenWidth], 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:NO closeKeyboard:NO isFrame:YES];
    
    contentTextView = [HYControlFactory GetTextFieldWithCGRect:CGRectMake(75, 7, 200, 30) Placeholder:@"" SecureTextEntry:NO];
    contentTextView.text = @"";
    
    UILabel *contentLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(15, 7, 55, 30) textfont:[UIFont fontWithName:FONT size:17] text:@"内容 : " textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentCenter];
    
    [contentImgView addSubview:contentTextView];
    [contentImgView addSubview:contentLabel];
    
    [self.view addSubview:contentImgView];
    
    UIImageView *telImgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(0, contentImgView.frame.origin.y + contentImgView.frame.size.height + 15, [HYScreenTools getScreenWidth], 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:NO closeKeyboard:NO isFrame:YES];
    
    telTextView = [HYControlFactory GetTextFieldWithCGRect:CGRectMake(75, 7, 200, 30) Placeholder:@"" SecureTextEntry:NO];
    telTextView.text = @"";
    
    UILabel *telLabelInImgView = [HYControlFactory GetLableWithCGRect:CGRectMake(15, 7, 55, 30) textfont:[UIFont fontWithName:FONT size:17] text:@"电话 : " textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentCenter];
    
    [telImgView addSubview:telLabelInImgView];
    [telImgView addSubview:telTextView];
    
    [self.view addSubview:telImgView];
    
    
    UIButton *submitBtn = [HYControlFactory GetButtonWithCGRect:CGRectMake(10, telImgView.frame.origin.y + telImgView.frame.size.height + 40, [HYScreenTools getScreenWidth] - 20, 44) backgroundImg:@"more_btn" selectBackgroundImgName:@"more_btn_hover" addTarget:self action:@selector(_submitAction) forControlEvents:UIControlEventTouchUpInside];
    
    [submitBtn setTitle:@"提  交" forState:UIControlStateNormal];
    
    [self.view addSubview:submitBtn];
    
    
    UILabel *helpLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(15, submitBtn.frame.origin.y + submitBtn.frame.size.height + 30, [HYScreenTools getScreenWidth] - 30, 30) textfont:[UIFont fontWithName:FONT size:15] text:@"使用过程中遇到任何问题请与我们联系" textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    
    [self.view addSubview:helpLabel];
    
    
    UILabel *mailLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(15, helpLabel.frame.origin.y + helpLabel.frame.size.height + 20, [HYScreenTools getScreenWidth] - 30, 30) textfont:[UIFont fontWithName:FONT size:15] text:@"邮件 : task_service@iflytek.com" textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    
    [self.view addSubview:mailLabel];
    
    UILabel *telLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(15, mailLabel.frame.origin.y + mailLabel.frame.size.height + 20, 40, 30) textfont:[UIFont fontWithName:FONT size:15] text:@"电话 : " textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    
    UILabel *telNoLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(mailLabel.frame.origin.x + 40, mailLabel.frame.origin.y + mailLabel.frame.size.height + 20, 200, 30) textfont:[UIFont fontWithName:FONT size:15] text:@"" textColor:[UIColor greenColor] TextAlignment:NSTextAlignmentLeft];
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"0551-65309382"]];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    
    telNoLabel.attributedText = content;
    
    
    
    telNoLabel.userInteractionEnabled = YES;
    
    [telNoLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(telNoAction)]];
    
    [self.view addSubview:telLabel];
    [self.view addSubview:telNoLabel];
}

-(void)_submitAction
{
    [SVProgressHUD showWithStatus:@"正在提交反馈信息..." maskType:SVProgressHUDMaskTypeGradient];
    
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.token,@"Token",@"AddSuggest",@"opeType",self.user.accountName,@"AccountName",titleTextView.text,@"Title",contentTextView.text,@"Contents",telTextView.text,@"Tel",nil];
    
    NSURL *url = [[NSURL alloc] initWithString:Suggest_api];
    
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
    //NSLog(@"msg = %@", msg);
    
    NSError *error;
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    
    NSArray *contents =  nil;
    NSString *success = [json objectForKey:@"Success"];
    contents = [json objectForKey:@"Content"];
    NSDictionary *content = nil;
    if([contents count] <= 0)
    {
        return;
    }
    content = [contents objectAtIndex:0];
    if([success boolValue])
    {
        NSString *result = [content objectForKey:@"result"];
        NSString *message = [content objectForKey:@"message"];
        if([result boolValue])
        {
            [SVProgressHUD showSuccessWithStatus:message];
            titleTextView.text = @"";
            contentTextView.text = @"";
            telTextView.text = @"";
        }else
        {
            [SVProgressHUD showErrorWithStatus:message];
        }
    }else
    {
    }
}


-(void)telNoAction
{
    UIWebView *callWebview =[[UIWebView alloc] init] ;
    
    NSURL *telURL =[NSURL URLWithString:@"telprompt://0551-65309382"];
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    [self.view addSubview:callWebview];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[[self getNavigationController] getView] setHidden:NO];
    [[[self getTabbarController] getView] setHidden:YES];
    [[self getNavigationController] setCenterTittle:[self title]];
    [[self getNavigationController] setLeftButtonImage:[HYImageFactory GetImageByName:@"leftButton" AndType:PNG]];
    [[self getNavigationController] setLeftTittle:@"问题反馈"];
    [[self getNavigationController] setLeftTittleFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [[self getNavigationController] setLeftTittleColor:[UIColor whiteColor]];
    
    [[self getNavigationController] hideRightButton];
    [[self getNavigationController] showLeftButton];
    [[self getNavigationController] showLeftTittle];
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
