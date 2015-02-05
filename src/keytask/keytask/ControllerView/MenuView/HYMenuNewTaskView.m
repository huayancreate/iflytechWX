//
//  HYMenuView.m
//  keytask
//
//  Created by 许 玮 on 14-10-14.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYMenuNewTaskView.h"
#import "HYImageFactory.h"
#import "HYConstants.h"
#import "HYScreenTools.h"
#import "HYHelper.h"
#import "HYTaskModel.h"
#import "HYNewTaskViewController.h"
#import "STAlertView.h"
#import "HYNetworkInterface.h"
#import "RatingBar.h"
#import "HYAddPartViewController.h"
#import "HYMessageViewController.h"
#import "HYNewTaskViewController.h"


@interface HYMenuNewTaskView()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    BOOL show;
    NSArray *_proxys;
    UIAlertView *stAlertView;
    UIPickerView *pickerView;
    NSMutableArray *pickerList;
    NSMutableArray *pickerShowList;
    HYMyProxyModel *pickModel;
    BOOL pickerFlag;
}

@end


@implementation HYMenuNewTaskView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setShow:(BOOL)isS
{
    show = isS;
}

-(BOOL)isShow
{
    return show;
}

-(void)initWithIcons:(NSArray *)icons showNames:(NSArray *)showNames bgImgName:(NSString *)bgImgName AndProxyArray:(NSArray *)proxys
{
    assert(icons != nil && showNames != nil);
    pickerFlag = false;
    _proxys = proxys;
    int count = [showNames count];
    self.frame = CGRectMake([HYScreenTools getScreenWidth] - 140, [HYScreenTools getStatusHeight] + [[HYHelper getNavigationController] getNavigationHeight], 140, 44 * count);
    for (int i = 0; i < count; i++) {
        NSString *iconType = [icons objectAtIndex:i];
        UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, i * 44, 140, 44)];
        [bgImg setImage:[HYImageFactory GetImageByName:bgImgName AndType:PNG]];
        [bgImg setAlpha:0.9f];
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
        if([iconType isEqual:@"take_task"])
        {
            [icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newTaskAction)]];
            [iconname addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newTaskAction)]];
            [bgImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newTaskAction)]];
        }
        if([iconType isEqual:@"helppep"])
        {
            [icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(helpTaskAction)]];
            [iconname addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(helpTaskAction)]];
            [bgImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(helpTaskAction)]];
        }
    }
    
}

-(void)helpTaskAction
{
    [self removeFromSuperview];
    show = !show;
    
    if([_proxys count] == 1)
    {
        HYNewTaskViewController *createTask = [[HYNewTaskViewController alloc] init];
        
        createTask.user = [HYHelper getUser];
        createTask.user.helpModel = [_proxys objectAtIndex:0];
        createTask.user.isNew = YES;
        createTask.user.partList = nil;
        createTask.user.selectPartList = nil;
        createTask.user.excList = nil;
        createTask.user.paticrpantString = @"";
        createTask.user.executorString = @"";
        createTask.user.endTimeString = @"";
        [createTask setTitle:@""];
        [[HYHelper getNavigationController] pushController:createTask];
    }else
    {
        pickerList = [[NSMutableArray alloc] init];
        pickerShowList = [[NSMutableArray alloc] init];
        for (int i = 0; i< [_proxys count]; i++) {
            HYMyProxyModel *model = [_proxys objectAtIndex:i];
            [pickerList addObject:model];
            [pickerShowList addObject:model.proxyName];
        }
        stAlertView = [[UIAlertView alloc] initWithTitle:@"请选择提谁发起任务" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0 ,0,(stAlertView.frame.size.width - 20),80)];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        [stAlertView setValue:pickerView forKey:@"accessoryView"];
        [stAlertView show];
    }
    
    
    
}

#pragma picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [pickerShowList count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerShowList objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    pickerFlag = true;
    pickModel = [pickerList objectAtIndex:row];
}

#pragma alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView == stAlertView)
    {
        if (buttonIndex == 0) {
            //NSLog(@"点击了确定按钮");
            if(!pickerFlag)
            {
                HYNewTaskViewController *createTask = [[HYNewTaskViewController alloc] init];
                createTask.user = [HYHelper getUser];
                createTask.user.helpModel = [_proxys objectAtIndex:0];
                createTask.user.isNew = YES;
                createTask.user.selectPartList = nil;
                createTask.user.partList = nil;
                createTask.user.excList = nil;
                createTask.user.paticrpantString = @"";
                createTask.user.executorString = @"";
                createTask.user.endTimeString = @"";
                [createTask setTitle:@""];
                [[HYHelper getNavigationController] pushController:createTask];
            }else
            {
                HYNewTaskViewController *createTask = [[HYNewTaskViewController alloc] init];
                createTask.user = [HYHelper getUser];
                createTask.user.helpModel = pickModel;
                createTask.user.isNew = YES;
                createTask.user.selectPartList = nil;
                createTask.user.partList = nil;
                createTask.user.excList = nil;
                createTask.user.paticrpantString = @"";
                createTask.user.executorString = @"";
                createTask.user.endTimeString = @"";
                [createTask setTitle:@""];
                [[HYHelper getNavigationController] pushController:createTask];
            }
        }
        else {
            
        }
    }
}

-(void)newTaskAction
{
    [self removeFromSuperview];
    show = !show;
    HYNewTaskViewController *createTask = [[HYNewTaskViewController alloc] init];
    createTask.user = [HYHelper getUser];
    createTask.user.helpModel = nil;
    createTask.user.isNew = YES;
    createTask.user.partList = nil;
    createTask.user.excList = nil;
    createTask.user.selectPartList = nil;
    createTask.user.paticrpantString = @"";
    createTask.user.executorString = @"";
    createTask.user.endTimeString = @"";
    [createTask setTitle:@""];
    [[HYHelper getNavigationController] pushController:createTask];
    
}

@end
