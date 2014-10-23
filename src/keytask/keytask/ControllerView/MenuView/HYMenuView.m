//
//  HYMenuView.m
//  keytask
//
//  Created by 许 玮 on 14-10-14.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYMenuView.h"
#import "HYImageFactory.h"
#import "HYConstants.h"
#import "HYScreenTools.h"
#import "HYHelper.h"
#import "HYTaskModel.h"
#import "HYNewTaskViewController.h"
#import "STAlertView.h"
#import "HYNetworkInterface.h"
#import "RatingBar.h"


@interface HYMenuView()
{
    HYTaskModel *_model;
    STAlertView *stAlertView;
    HYUserLoginModel *_user;
    UIAlertView *auditButtonAlert;
    UIAlertView *endTaskButtonAlert;
    UIAlertView *auditButtonOKAlert;
    UIAlertView *endTaskButtonOKAlert;
    RatingBar *bar ;
    RatingBar *endTaskbar ;
}

@end

@implementation HYMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initWithIcons:(NSArray *)icons showNames:(NSArray *)showNames bgImgName:(NSString *)bgImgName model:(HYTaskModel *)model user:(HYUserLoginModel *)user
{
    assert(icons != nil && showNames != nil);
    _model = model;
    _user = user;
    int count = [showNames count];
    self.frame = CGRectMake([HYScreenTools getScreenWidth] - 140, [HYScreenTools getStatusHeight] + [[HYHelper getNavigationController] getNavigationHeight], 140, 44 * count);
    for (int i = 0; i < count; i++) {
        NSString *iconType = [icons objectAtIndex:i];
        UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, i * 44, 140, 44)];
        [bgImg setImage:[HYImageFactory GetImageByName:bgImgName AndType:PNG]];
        [bgImg setAlpha:0.7f];
        bgImg.userInteractionEnabled = YES;
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 7, 25, 25)];
        [icon setImage:[HYImageFactory GetImageByName:iconType AndType:PNG]];
        [bgImg addSubview:icon];
        icon.userInteractionEnabled = YES;
        
        UILabel *iconname = [[UILabel alloc] initWithFrame:CGRectMake(60, 9.5, 70, 25)];
        [iconname setText:[showNames objectAtIndex:i]];
        [iconname setTextColor:[UIColor whiteColor]];
        [iconname setFont:[UIFont fontWithName:FONT_BOLD size:10]];
        iconname.userInteractionEnabled = YES;
        [bgImg addSubview:icon];
        [bgImg addSubview:iconname];
        [self addSubview:bgImg];
        
        //TODO refactor
        if([iconType isEqual:@"take_task"])
        {
            [icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takeTaskAction)]];
            [iconname addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takeTaskAction)]];
        }
        if([iconType isEqual:@"refuse"])
        {
            [icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refuseAction)]];
            [iconname addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refuseAction)]];
        }
        if([iconType isEqual:@"task_information"])
        {
            [icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taskInformationAction)]];
            [iconname addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taskInformationAction)]];
        }
        if([iconType isEqual:@"jionpeople"])
        {
            [icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jionpeopleAction)]];
            [iconname addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jionpeopleAction)]];
        }
        if([iconType isEqual:@"end_apply"])
        {
            [icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endApplyAction)]];
            [iconname addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endApplyAction)]];
        }
        if([iconType isEqual:@"end_task"])
        {
            [icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endTaskAction)]];
            [iconname addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endTaskAction)]];
        }
        if([iconType isEqual:@"stop_task"])
        {
            [icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopTaskAction)]];
            [iconname addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopTaskAction)]];
        }
        if([iconType isEqual:@"audit_button"])
        {
            [icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(auditButtonAction)]];
            [iconname addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(auditButtonAction)]];
        }
        if([iconType isEqual:@"audit_no_button"])
        {
            [icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(auditNoButtonAction)]];
            [iconname addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(auditNoButtonAction)]];
        }
        if([iconType isEqual:@"forwarding"])
        {
            [icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forwardingAction)]];
            [iconname addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forwardingAction)]];
        }
        
    }
    
}

-(void)auditNoButtonAction
{
    stAlertView = [[STAlertView alloc] initWithTitle:@"此任务确定审核不通过吗？"
                                             message:@""
                                   cancelButtonTitle:@"确定"
                                   otherButtonTitles:@"取消"
                   
                                   cancelButtonBlock:^{
                                       [self sendThreadAuditNoButtonActionRequest];
                                   } otherButtonBlock:^{
                                       NSLog(@"Great! Feel free to contribute or contact me at twitter @NestorMalet!");
                                   }];

}

-(void)sendThreadAuditNoButtonActionRequest
{
    [self auditNoButtonActionThread];
}

-(void)auditNoButtonActionThread
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:_user.token,@"Token",@"TaskAudit",@"opeType",_model.ID,@"TaskID",_user.accountName,@"AccountName",@"0",@"IsPass",nil];
    
    
    NSURL *url = [[NSURL alloc] initWithString:TaskHandler_api];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    if (params) {
        NSArray *array = [params allKeys];
        for (int i= 0; i <[array count]; i++) {
            [request setPostValue:[params objectForKey:[array objectAtIndex:i]] forKey:[array objectAtIndex:i]];
        }
    }
    [request setDidFinishSelector:@selector(endAuditNoButtonActionThreadFin:)];
    [request setDidFailSelector:@selector(endAuditNoButtonActionThreadFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];

}

- (void) endAuditNoButtonActionThreadFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endAuditNoButtonActionThreadString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endAuditNoButtonActionThreadFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endAuditNoButtonActionThreadString:) withObject:responsestring waitUntilDone:YES];
}

-(void)endAuditNoButtonActionThreadString:(NSString *)msg
{
    NSLog(@"msg = %@", msg);
}

-(void)stopTaskAction
{
    [self removeFromSuperview];
    stAlertView = [[STAlertView alloc] initWithTitle:@"确定要终止此任务吗？"
                                             message:@""
                                   cancelButtonTitle:@"确定"
                                   otherButtonTitles:@"取消"
                   
                                   cancelButtonBlock:^{
                                       [self sendThreadStopTaskRequest];
                                   } otherButtonBlock:^{
                                       NSLog(@"Great! Feel free to contribute or contact me at twitter @NestorMalet!");
                                   }];
}

-(void)sendThreadStopTaskRequest
{
    [self stopTaskActionThread];
}

-(void)stopTaskActionThread
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:_user.token,@"Token",@"StopTask",@"opeType",_model.ID,@"TaskID",_user.accountName,@"AccountName",nil];
    
    
    NSURL *url = [[NSURL alloc] initWithString:TaskHandler_api];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    if (params) {
        NSArray *array = [params allKeys];
        for (int i= 0; i <[array count]; i++) {
            [request setPostValue:[params objectForKey:[array objectAtIndex:i]] forKey:[array objectAtIndex:i]];
        }
    }
    [request setDidFinishSelector:@selector(endStopTaskActionThreadFin:)];
    [request setDidFailSelector:@selector(endStopTaskActionThreadFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];

}

- (void) endStopTaskActionThreadFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endStopTaskActionThreadString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endStopTaskActionThreadFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endStopTaskActionThreadString:) withObject:responsestring waitUntilDone:YES];
}

-(void)endStopTaskActionThreadString:(NSString *)msg
{
    NSLog(@"msg = %@", msg);
}

-(void)refuseAction
{
    [self removeFromSuperview];
    stAlertView = [[STAlertView alloc] initWithTitle:@"确定拒绝此任务吗？"
                                             message:@""
                                   cancelButtonTitle:@"确定"
                                   otherButtonTitles:@"取消"
                   
                                   cancelButtonBlock:^{
                                       [self sendThreadRequest:@"0"];
                                   } otherButtonBlock:^{
                                       NSLog(@"Great! Feel free to contribute or contact me at twitter @NestorMalet!");
                                   }];
}

-(void)endApplyAction
{
    [self removeFromSuperview];
    stAlertView = [[STAlertView alloc] initWithTitle:@"此任务确定要申请结束吗？"
                                             message:@""
                                   cancelButtonTitle:@"确定"
                                   otherButtonTitles:@"取消"
                   
                                   cancelButtonBlock:^{
                                       [self sendThreadEndApplyRequest];
                                   } otherButtonBlock:^{
                                       NSLog(@"Great! Feel free to contribute or contact me at twitter @NestorMalet!");
                                   }];
}

-(void)sendThreadEndApplyRequest
{
    [NSThread detachNewThreadSelector:@selector(endApplyActionThread) toTarget:self withObject:nil];
}

-(void)takeTaskAction
{
    [self removeFromSuperview];
     stAlertView = [[STAlertView alloc] initWithTitle:@"确定接受此任务吗？"
                               message:@""
                     cancelButtonTitle:@"确定"
                     otherButtonTitles:@"取消"
     
                     cancelButtonBlock:^{
                         [self sendThreadRequest:@"1"];
                     } otherButtonBlock:^{
                         NSLog(@"Great! Feel free to contribute or contact me at twitter @NestorMalet!");
                     }];
}

-(void)sendThreadRequest:(NSString *)isReason
{
    [self takeTaskActionThread:isReason];
}

-(void)endApplyActionThread
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:_user.token,@"Token",@"ApplyEnd",@"opeType",_model.ID,@"TaskID",_user.accountName,@"AccountName",nil];
    
    
    NSURL *url = [[NSURL alloc] initWithString:TaskHandler_api];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    if (params) {
        NSArray *array = [params allKeys];
        for (int i= 0; i <[array count]; i++) {
            [request setPostValue:[params objectForKey:[array objectAtIndex:i]] forKey:[array objectAtIndex:i]];
        }
    }
    [request setDidFinishSelector:@selector(endEndApplyActionThreadFin:)];
    [request setDidFailSelector:@selector(endEndApplyActionThreadFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) endEndApplyActionThreadFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endEndApplyTaskActionThreadString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endEndApplyActionThreadFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endEndApplyTaskActionThreadString:) withObject:responsestring waitUntilDone:YES];
}

-(void)endEndApplyTaskActionThreadString:(NSString *)msg
{
    NSLog(@"msg = %@",msg);
}

-(void)takeTaskActionThread:(NSString *)isReason
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:_user.token,@"Token",@"ReceiveTask",@"opeType",_model.ID,@"TaskID",_user.accountName,@"AccountName",isReason,@"IsReason",nil];
    
    
    NSURL *url = [[NSURL alloc] initWithString:TaskHandler_api];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    if (params) {
        NSArray *array = [params allKeys];
        for (int i= 0; i <[array count]; i++) {
            [request setPostValue:[params objectForKey:[array objectAtIndex:i]] forKey:[array objectAtIndex:i]];
        }
    }
    [request setDidFinishSelector:@selector(endTakeTaskActionThreadFin:)];
    [request setDidFailSelector:@selector(endTakeTaskActionThreadFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) endTakeTaskActionThreadFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endTakeTaskActionThreadString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endTakeTaskActionThreadFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endTakeTaskActionThreadString:) withObject:responsestring waitUntilDone:YES];
}

-(void)endTakeTaskActionThreadString:(NSString *)msg
{
    NSLog(@"msg = %@",msg);
}

-(void)forwardingAction
{
    [self removeFromSuperview];
    HYNewTaskViewController *newTask = [[HYNewTaskViewController alloc] init];
    newTask.model = _model;
    [[HYHelper getNavigationController] pushController:newTask];
}

-(void)taskInformationAction
{
    [self removeFromSuperview];
    HYNewTaskViewController *newTask = [[HYNewTaskViewController alloc] init];
    newTask.model = _model;
    [[HYHelper getNavigationController] pushController:newTask];
}

-(void)jionpeopleAction
{
    [self removeFromSuperview];
    
}

-(void)endTaskAction
{
    [self removeFromSuperview];
    endTaskButtonAlert = [[UIAlertView alloc] initWithTitle:@"请给此任务打分" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    endTaskbar = [[RatingBar alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
    [endTaskbar setBackgroundColor:[UIColor clearColor]];
    endTaskButtonAlert.delegate = self;
    
    [endTaskButtonAlert setValue:endTaskbar forKey:@"accessoryView"];
    [endTaskButtonAlert show];
}

-(void)auditButtonAction
{
    [self removeFromSuperview];
    auditButtonAlert = [[UIAlertView alloc] initWithTitle:@"请给此任务打分" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    bar = [[RatingBar alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
    [bar setBackgroundColor:[UIColor clearColor]];
    auditButtonAlert.delegate = self;
    
    [auditButtonAlert setValue:bar forKey:@"accessoryView"];
    [auditButtonAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView == auditButtonAlert)
    {
        if (buttonIndex == 0) {
            NSLog(@"点击了确定按钮");
            auditButtonOKAlert = [[UIAlertView alloc] initWithTitle:@"确定要审核通过此任务吗？" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
            [auditButtonOKAlert show];
        }
        else {
            NSLog(@"点击了取消按钮");
        }
    }
    if(alertView == auditButtonOKAlert)
    {
        if (buttonIndex == 0) {
            NSLog(@"点击了确定按钮");
            [self auditButtonActionNetwork:bar.starNumber];
        }
        else {
            NSLog(@"点击了取消按钮");
        }
    }
    if(alertView == endTaskButtonAlert)
    {
        if (buttonIndex == 0) {
            NSLog(@"点击了确定按钮");
            endTaskButtonOKAlert = [[UIAlertView alloc] initWithTitle:@"确定要结束此任务吗？" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
            [endTaskButtonOKAlert show];
        }
        else {
            NSLog(@"点击了取消按钮");
        }
    }
    if(alertView == endTaskButtonOKAlert)
    {
        if (buttonIndex == 0) {
            NSLog(@"点击了确定按钮");
            [self endTaskActionNetwork:endTaskbar.starNumber];
        }
        else {
            NSLog(@"点击了取消按钮");
        }
    }
}

-(void)auditButtonActionNetwork:(NSInteger)number;
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:_user.token,@"Token",@"TaskAudit",@"opeType",_model.ID,@"TaskID",_user.accountName,@"AccountName",@"1",@"IsPass",[NSString stringWithFormat:@"%d", number],@"Score",nil];
    
    
    NSURL *url = [[NSURL alloc] initWithString:TaskHandler_api];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    if (params) {
        NSArray *array = [params allKeys];
        for (int i= 0; i <[array count]; i++) {
            [request setPostValue:[params objectForKey:[array objectAtIndex:i]] forKey:[array objectAtIndex:i]];
        }
    }
    [request setDidFinishSelector:@selector(endAuditButtonActionNetworkFin:)];
    [request setDidFailSelector:@selector(endAuditButtonActionNetworkFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) endAuditButtonActionNetworkFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endAuditButtonActionNetworkString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endAuditButtonActionNetworkFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endAuditButtonActionNetworkString:) withObject:responsestring waitUntilDone:YES];
}

-(void)endAuditButtonActionNetworkString:(NSString *)msg
{
    NSLog(@"msg = %@",msg);
}


-(void)endTaskActionNetwork:(NSInteger)number;
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:_user.token,@"Token",@"EndTask",@"opeType",_model.ID,@"TaskID",_user.accountName,@"AccountName",[NSString stringWithFormat:@"%d", number],@"Score",nil];
    
    
    NSURL *url = [[NSURL alloc] initWithString:TaskHandler_api];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    if (params) {
        NSArray *array = [params allKeys];
        for (int i= 0; i <[array count]; i++) {
            [request setPostValue:[params objectForKey:[array objectAtIndex:i]] forKey:[array objectAtIndex:i]];
        }
    }
    [request setDidFinishSelector:@selector(endEndTaskActionNetworkFin:)];
    [request setDidFailSelector:@selector(endEndTaskActionNetworkFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

- (void) endEndTaskActionNetworkFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endEndTaskActionNetworkString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endEndTaskActionNetworkFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endEndTaskActionNetworkString:) withObject:responsestring waitUntilDone:YES];
}

-(void)endEndTaskActionNetworkString:(NSString *)msg
{
    NSLog(@"msg = %@",msg);
}




@end
