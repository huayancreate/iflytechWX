//
//  HYNewTaskViewController.m
//  keytask
//
//  Created by 许 玮 on 14-10-9.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYNewTaskViewController.h"
#import "HYImageFactory.h"
#import "HYConstants.h"
#import "HYMainViewController.h"
#import "HYScreenTools.h"
#import "HYControlFactory.h"
#import "HYPeopleInfoView.h"
#import "HYNetworkInterface.h"
#import "HYSmartInputViewController.h"
#import "CXAlertView.h"
#import "HYSmartInputModel.h"

@interface HYNewTaskViewController ()
{
    BOOL isUp;
    UIDatePicker *datePicker;
    UILabel *endTimeLabel;
    NSMutableArray *pickerList;
    UIAlertView *alertViewDatePicker;
    UIAlertView *alertViewpicker;
    UIPickerView *pickerView;
    NSString *days;
    BOOL pickerFlag;
    NSString *endTimeString;
    NSString *executorString;
    NSString *paticrpantString;
    BOOL isPart;
    UIImageView *firstManBgView;
}
@property (nonatomic, strong) UIImageView *clickView;
@property (nonatomic, strong) UILabel *clickLabel;
@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property NSMutableArray *showControlList;
@property (nonatomic, strong) UITextField *taskTargetTextField;
@property (nonatomic, strong) UITextView *taskContentText;
@property (nonatomic, strong) UITextField *taskResultTextField;
@property (nonatomic, strong) UILabel *taskCycleLabel;
@property (nonatomic, strong) UITextField *taskNameText;
@property (nonatomic, strong) HYPeopleInfoView *pepopleInfo;
@property (nonatomic, strong) HYPeopleInfoView *firstPepopleInfo;

@end

@implementation HYNewTaskViewController
@synthesize clickView;
@synthesize clickLabel;
@synthesize okButton;
@synthesize scrollView;
@synthesize showControlList;
@synthesize model;
@synthesize taskTargetTextField;
@synthesize taskContentText;
@synthesize taskResultTextField;
@synthesize taskCycleLabel;
@synthesize taskNameText;
@synthesize pepopleInfo;
@synthesize firstPepopleInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self bindAction];
        isUp = YES;
        showControlList = [[NSMutableArray alloc] init];
        pickerList = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31", nil];
        days = @"0";
        pickerFlag = false;
        endTimeString = @"";
        executorString = @"";
        paticrpantString = @"";
        isPart = true;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControl];
}

-(void)initControl
{
    scrollView = [HYControlFactory GetScrollViewWithCGRect:CGRectMake(0,([HYScreenTools getStatusHeight] +  [[self getNavigationController] getNavigationHeight]), [HYScreenTools getScreenWidth], ([HYScreenTools getScreenHeight] - [HYScreenTools getStatusHeight] -[[self getNavigationController] getNavigationHeight])) backgroundColor:[UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f] backImgName:nil delegate:self];
    
    
    [self.view addSubview:scrollView];
    
    UIImageView *taskNameBgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, 8, ([HYScreenTools getScreenWidth] - 16), 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:YES closeKeyboard:YES isFrame:NO];
    
    [scrollView addSubview:taskNameBgView];
    
    UILabel *taskNameLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(4, 7, 90, 30) textfont:[UIFont fontWithName:FONT_BOLD size:14] text:TASK_NAME_LABEL textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    [taskNameBgView addSubview:taskNameLabel];
    
    
    taskNameText = [HYControlFactory GetTextFieldWithCGRect:CGRectMake(95, 7, (taskNameBgView.frame.size.width - 94), 30) Placeholder:nil SecureTextEntry:NO];
    [taskNameText setFont:[UIFont fontWithName:FONT size:13]];
//    taskNameText.clearButtonMode = UITextFieldViewModeAlways;
    [taskNameBgView addSubview:taskNameText];
    

    
    
    UIImageView *startNameBgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, 60, ([HYScreenTools getScreenWidth] - 16), 60) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:YES closeKeyboard:YES isFrame:NO];
    
    UILabel *startNameLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(4, 15, 90, 30) textfont:[UIFont fontWithName:FONT_BOLD size:14] text:START_NAME_LABEL textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    [startNameBgView addSubview:startNameLabel];
    
    //add StartNameView
    //test xuwei

    
    [scrollView addSubview:startNameBgView];
    
    firstManBgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, 128, ([HYScreenTools getScreenWidth] - 16), 60) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:YES closeKeyboard:YES isFrame:NO];
    
    UILabel *firstManLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(4, 15, 90, 30) textfont:[UIFont fontWithName:FONT_BOLD size:14] text:FIRST_MAN_LABEL textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    
    //test xuwei

    UIImageView *addFirstPeople = [HYControlFactory GetImgViewWithCGRect:CGRectMake((firstManBgView.frame.size.width) - 44 , 12.5f, 35, 35) backgroundImgName:@"newtask_add" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [addFirstPeople addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFirstPeopleAction:)]];
    
    [firstManBgView addSubview:addFirstPeople];
    [firstManBgView addSubview:firstManLabel];
    
    [scrollView addSubview:firstManBgView];
    
    UIImageView *endTimeBgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, 196, ([HYScreenTools getScreenWidth] - 16), 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:YES closeKeyboard:YES isFrame:NO];
    
    UIImageView *endTimeRightView = [HYControlFactory GetImgViewWithCGRect:CGRectMake((firstManBgView.frame.size.width) - 35 , 10, 35, 25) backgroundImgName:@"newtask_right" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    
   [endTimeRightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePickerAction:)]];
    
    [endTimeBgView addSubview:endTimeRightView];
    
    
    UIImageView *endTimeClockView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(6, 9, 26, 26) backgroundImgName:@"newtask_time" backgroundColor:nil isCornerRadius:NO closeKeyboard:YES isFrame:NO];
    [endTimeBgView addSubview:endTimeClockView];
    
    endTimeLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(46, 7, 200, 30) textfont:[UIFont fontWithName:FONT_BOLD size:14] text:END_TIME_LABEL textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    [endTimeBgView addSubview:endTimeLabel];
    
    [scrollView addSubview:endTimeBgView];
    
    clickLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(([HYScreenTools getScreenWidth]/3 + 2), (endTimeBgView.frame.origin.y + endTimeBgView.frame.size.height + 14), 60, 30) textfont:[UIFont fontWithName:FONT_BOLD size:12] text:CLICK_ON_LABEL textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    
    clickView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(([HYScreenTools getScreenWidth]/3 + clickLabel.frame.size.width + 3), (endTimeBgView.frame.origin.y + endTimeBgView.frame.size.height + 15), 25, 25) backgroundImgName:@"newtask_down" backgroundColor:nil isCornerRadius:NO closeKeyboard:YES isFrame:NO];
    
    [scrollView addSubview:clickView];
    [scrollView addSubview:clickLabel];
    

    
    [clickView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickShowAndHide:)]];
    
    
    // click show
    
    UILabel *taskContentLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(10, (clickLabel.frame.origin.y + clickLabel.frame.size.height + 14), ([HYScreenTools getScreenWidth] - 16), 30) textfont:[UIFont fontWithName:FONT_BOLD size:14] text:TASK_CONTENT_LABEL textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];

    [showControlList addObject:taskContentLabel];
    
    taskContentText = [HYControlFactory GetTextViewWithCGRect:CGRectMake(8, (taskContentLabel.frame.origin.y + taskContentLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 120) isCornerRaidus:YES font:[UIFont fontWithName:FONT size:13] textColor:[UIColor blackColor]];
    
    [showControlList addObject:taskContentText];
    
    UIImageView *taskTargetBgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, (taskContentText.frame.origin.y + taskContentText.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:YES closeKeyboard:YES isFrame:NO];
    
    UILabel *taskTargetLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(4, 7, 50, 30) textfont:[UIFont fontWithName:FONT_BOLD size:14] text:TASK_TARGET textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    
    taskTargetTextField = [HYControlFactory GetTextFieldWithCGRect:CGRectMake(60, 7, 200, 30) Placeholder:@"" SecureTextEntry:NO];
    [taskTargetTextField setFont:[UIFont fontWithName:FONT size:13]];
    [taskTargetBgView addSubview:taskTargetTextField];
    
    [taskTargetBgView addSubview:taskTargetLabel];
    
    [showControlList addObject:taskTargetBgView];
    
    UIImageView *taskResultBgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, (taskTargetBgView.frame.origin.y + taskTargetBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:YES closeKeyboard:YES isFrame:NO];
    
    UILabel *taskResultLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(4, 7, 50, 30) textfont:[UIFont fontWithName:FONT_BOLD size:14] text:TASK_RESULT textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    [taskResultBgView addSubview:taskResultLabel];
    
    taskResultTextField = [HYControlFactory GetTextFieldWithCGRect:CGRectMake(60, 7, 200, 30) Placeholder:@"" SecureTextEntry:NO];
    [taskResultTextField setFont:[UIFont fontWithName:FONT size:13]];
    [taskResultBgView addSubview:taskResultTextField];
    
    [showControlList addObject:taskResultBgView];
    
    UIImageView *taskCycleBgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, (taskResultBgView.frame.origin.y + taskResultBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:YES closeKeyboard:YES isFrame:NO];
    
    
    UIImageView *taskCycleRightView = [HYControlFactory GetImgViewWithCGRect:CGRectMake((taskCycleBgView.frame.size.width) - 35 , 10, 35, 25) backgroundImgName:@"newtask_right" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    
    [taskCycleRightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerAction:)]];
    
    [taskCycleBgView addSubview:taskCycleRightView];
    
    
    
    UIImageView *taskCycleImgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(6, 9, 26, 26) backgroundImgName:@"newtask_date" backgroundColor:nil isCornerRadius:NO closeKeyboard:YES isFrame:NO];
    [taskCycleBgView addSubview:taskCycleImgView];
    
    taskCycleLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(46, 7, 200, 30) textfont:[UIFont fontWithName:FONT_BOLD size:14] text:[TASK_CYCLE stringByAppendingString:@"       天"] textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    [taskCycleBgView addSubview:taskCycleLabel];
    
    
    
    [showControlList addObject:taskCycleBgView];
    
    UILabel *taskPartLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(10, (taskCycleBgView.frame.origin.y + taskCycleBgView.frame.size.height + 10), ([HYScreenTools getScreenWidth] - 16), 30) textfont:[UIFont fontWithName:FONT_BOLD size:14] text:TASK_PART_LABEL textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    
    [showControlList addObject:taskPartLabel];
    
    UIImageView *taskPartBgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, (taskPartLabel.frame.origin.y + taskPartLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 60) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:YES closeKeyboard:YES isFrame:NO];
    
    UIImageView *addPartPeople = [HYControlFactory GetImgViewWithCGRect:CGRectMake((taskPartBgView.frame.size.width) - 44 , 12.5f, 35, 35) backgroundImgName:@"newtask_add" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [addPartPeople addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPartPeopleAction:)]];
    
    [taskPartBgView addSubview:addPartPeople];
    
    
    
    [showControlList addObject:taskPartBgView];
    
    okButton = [HYControlFactory GetButtonWithCGRect:CGRectMake(8, (clickView.frame.origin.y + clickView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44) backgroundImg:@"newtask_ok" selectBackgroundImgName:@"newtask_ok_hover" addTarget:self action:@selector(_submitAction) forControlEvents:UIControlEventTouchUpInside];
    [okButton setTitle:OK_BUTTON_TEXT forState:UIControlStateNormal];
    [okButton.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:20]];
    [okButton.titleLabel setTextColor:[UIColor whiteColor]];
    [okButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [scrollView addSubview:okButton];
    
    pepopleInfo = [[HYPeopleInfoView alloc] initWithFrame:CGRectMake(taskNameText.frame.origin.x, 5, 35, 50)];
    pepopleInfo.icon = [HYImageFactory GetImageByName:@"newtask_people" AndType:PNG];
    
    if(model == nil)
    {
        pepopleInfo.name = self.user.username;
    }
    
    if(model != nil)
    {
        
        firstPepopleInfo = [[HYPeopleInfoView alloc] initWithFrame:CGRectMake(taskNameText.frame.origin.x, 5, 35, 50)];
        [taskNameText setText:model.name];
        taskNameText.userInteractionEnabled = NO;
        pepopleInfo.name = model.initiatorName;

        firstPepopleInfo.icon = [HYImageFactory GetImageByName:@"newtask_people" AndType:PNG];
        firstPepopleInfo.name = model.executorName;
        
        [taskContentText setText:model.description];
        taskContentText.userInteractionEnabled = NO;
        [taskTargetTextField setText:model.goal];
        taskTargetTextField.userInteractionEnabled = NO;
        [taskResultTextField setText:model.product];
        taskResultTextField.userInteractionEnabled = NO;
        NSString *cycleString = TASK_CYCLE;
        cycleString = [cycleString stringByAppendingString:@"       "];
        cycleString = [cycleString stringByAppendingString:model.days];
        cycleString = [cycleString stringByAppendingString:@"天"];
        [taskCycleLabel setText:cycleString];
        [addFirstPeople removeFromSuperview];
        [endTimeLabel setText:[END_TIME_LABEL stringByAppendingString:model.endTime]];
        
        
        
        [endTimeRightView removeFromSuperview];
        [taskCycleRightView removeFromSuperview];
        [okButton removeFromSuperview];
        [firstManBgView addSubview:[firstPepopleInfo getView]];
    }
    
    [startNameBgView addSubview:[pepopleInfo getView]];
    
    
}

-(void)addPartPeopleAction:(UIGestureRecognizer *)gestureRecognizer
{
    isPart = true;
    HYSmartInputViewController *smartInput = [[HYSmartInputViewController alloc] init];
    smartInput.user = self.user;
    smartInput.title = @"智能输入";
    [[self getNavigationController] pushController:smartInput];
}

-(void)addFirstPeopleAction:(UIGestureRecognizer *)gestureRecognizer
{
    isPart = false;
    HYSmartInputViewController *smartInput = [[HYSmartInputViewController alloc] init];
    smartInput.user = self.user;
    smartInput.title = @"智能输入";
    [[self getNavigationController] pushController:smartInput];
}

#pragma picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [pickerList count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerList objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    pickerFlag = true;
    days = [pickerList objectAtIndex:row];
}



-(void)pickerAction:(UIGestureRecognizer *)gestureRecognizer
{
    alertViewpicker = [[UIAlertView alloc] initWithTitle:@"请选择汇报周期" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0 ,0,alertViewpicker.frame.size.width,0)];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [alertViewpicker setValue:pickerView forKey:@"accessoryView"];
    [alertViewpicker show];
}

-(void)datePickerAction:(UIGestureRecognizer *)gestureRecognizer
{
//    HYDatePickerViewController *datePickerView = [[HYDatePickerViewController alloc] init];
//    [datePickerView initDatePicker];
//    [datePickerView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//    [datePickerView setModalPresentationStyle:UIModalPresentationFormSheet];
//    [self presentViewController:datePickerView animated:YES completion:nil];
    alertViewDatePicker = [[UIAlertView alloc] initWithTitle:@"请选择时间" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
     datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0 ,0,alertViewDatePicker.frame.size.width,0)];
    datePicker.date = [NSDate date];
    datePicker.datePickerMode = UIDatePickerModeDate;
//    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertView.frame.size.width,alertView.frame.size.height)];
//    [v addSubview:datePicker];
    [alertViewDatePicker setValue:datePicker forKey:@"accessoryView"];
    [alertViewDatePicker show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView == alertViewDatePicker)
    {
        if (buttonIndex == 0) {
            NSLog(@"点击了确定按钮");
            NSDate *selectDate = [datePicker date];
            NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
            selectDateFormatter.dateFormat = @"yyyy-MM-dd";
            NSString *dateString = [selectDateFormatter stringFromDate:selectDate];
            [endTimeLabel setText:[END_TIME_LABEL stringByAppendingString:dateString]];
            endTimeString = dateString;
        }
        else {
            NSLog(@"点击了取消按钮");
        }
    }
    if(alertView == alertViewpicker)
    {
        if (buttonIndex == 0) {
            NSLog(@"点击了确定按钮");
            if(!pickerFlag)
            {
                days = @"1";
            }
            NSString *cycleString = TASK_CYCLE;
            cycleString = [cycleString stringByAppendingString:@"       "];
            cycleString = [cycleString stringByAppendingString:days];
            cycleString = [cycleString stringByAppendingString:@"天"];
            [taskCycleLabel setText:cycleString];
        }
        else {
            if(!pickerFlag)
            {
                days = @"0";
            }
        }
    }
}



-(void)clickShowAndHide:(UIGestureRecognizer *)gestureRecognizer
{
    if(isUp)
    {
        [self clickShow];
        
    }else
    {
        [self clickHide];
    }
}

-(void)_submitAction
{
    
    [SVProgressHUD showWithStatus:@"正在提交任务..." maskType:SVProgressHUDMaskTypeGradient];
    if(taskNameText.text == nil)
    {
        taskNameText.text = @"";
    }
    if(taskContentText.text == nil)
    {
        taskContentText.text = @"";
    }
    if(taskTargetTextField.text == nil)
    {
        taskTargetTextField.text = @"";
    }
    if(taskResultTextField.text == nil)
    {
        taskResultTextField.text = @"";
    }
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.token,@"Token",@"AddTask",@"opeType",taskNameText.text,@"Name",self.user.accountName,@"Initiator",taskContentText.text,@"Description",taskTargetTextField.text,@"Goal",taskResultTextField.text,@"Product",endTimeString,@"EndTime",executorString,@"Executor",paticrpantString,@"Paticrpant",self.user.accountName,@"AccountName",@"200",@"TaskStatus",days,@"Days",nil];
    
    NSURL *url = [[NSURL alloc] initWithString:TaskHandler_api];
    
    [[[DataProcessing alloc] init] sentRequest:url Parem:params Target:self];
    
}

#pragma mark -
#pragma mark DataProcesse
-(void) endFailedRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    NSLog(@"msg = %@", msg);
}

-(void) endRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    NSError *error;
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [json objectForKey:@"Success"];
    NSArray *contents = nil;
    if([result boolValue])
    {
        contents = [json objectForKey:@"Content"];
        if([contents count] <= 0)
        {
            [SVProgressHUD showSuccessWithStatus:@"提交失败!"];
            return;
        }
        NSDictionary *content = [contents objectAtIndex:0];
        result = [content objectForKey:@"result"];
        if([result boolValue])
        {
            [SVProgressHUD showSuccessWithStatus:@"提交成功!"];
            [[self getNavigationController] popController:self];
        }else
        {
            NSString *erroMsg = [content objectForKey:@"message"];
            [SVProgressHUD showErrorWithStatus:erroMsg];
        }
    }else
    {
        [super logoutAction];
    }
}

-(void)clickShow
{
    [clickLabel setText:CLICK_OFF_LABEL];
    isUp = !isUp;
    [clickView setImage:[HYImageFactory GetImageByName:@"newtask_up" AndType:PNG]];
    [okButton removeFromSuperview];
    for (int i = 0; i < [showControlList count]; i++) {
        [scrollView addSubview:[showControlList objectAtIndex:i]];
    }
    UIImageView *taskPartBgView = [showControlList lastObject];
    okButton = [HYControlFactory GetButtonWithCGRect:CGRectMake(8, (taskPartBgView.frame.origin.y + taskPartBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44) backgroundImg:@"newtask_ok" selectBackgroundImgName:@"newtask_ok_hover" addTarget:self action:@selector(_submitAction) forControlEvents:UIControlEventTouchUpInside];
    [okButton setTitle:OK_BUTTON_TEXT forState:UIControlStateNormal];
    [okButton.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:20]];
    [okButton.titleLabel setTextColor:[UIColor whiteColor]];
    [okButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    scrollView.bounces = NO;
    scrollView.userInteractionEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    if(model == nil)
    {
        [scrollView addSubview:okButton];
        [scrollView setContentSize:CGSizeMake([HYScreenTools getScreenWidth],okButton.frame.origin.y + okButton.frame.size.height + 10 )];
    }else
    {
        [scrollView setContentSize:CGSizeMake([HYScreenTools getScreenWidth],taskPartBgView.frame.origin.y + taskPartBgView.frame.size.height + 10 )];
    }
}

-(void)clickHide
{
    [clickLabel setText:CLICK_ON_LABEL];
    isUp = !isUp;
    [clickView setImage:[HYImageFactory GetImageByName:@"newtask_down" AndType:PNG]];
    [okButton removeFromSuperview];
    for (int i = 0 ; i < [showControlList count]; i++) {
        [[showControlList objectAtIndex:i] removeFromSuperview];
    }
    okButton = [HYControlFactory GetButtonWithCGRect:CGRectMake(8, (clickView.frame.origin.y + clickView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44) backgroundImg:@"newtask_ok" selectBackgroundImgName:@"newtask_ok_hover" addTarget:self action:@selector(_submitAction) forControlEvents:UIControlEventTouchUpInside];
    [okButton setTitle:OK_BUTTON_TEXT forState:UIControlStateNormal];
    [okButton.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:20]];
    [okButton.titleLabel setTextColor:[UIColor whiteColor]];
    [okButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    scrollView.bounces = NO;
    scrollView.userInteractionEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    if(model == nil)
    {
        [scrollView addSubview:okButton];
    }
    [scrollView setContentSize:CGSizeMake([HYScreenTools getScreenWidth],[HYScreenTools getScreenHeight] - [HYScreenTools getStatusHeight] - [[self getNavigationController] getNavigationHeight])];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[[self getNavigationController] getView] setHidden:NO];
    [[[self getTabbarController] getView] setHidden:YES];
    [[self getNavigationController] setCenterTittle:[self title]];
    [[self getNavigationController] setLeftButtonImage:[HYImageFactory GetImageByName:@"leftButton" AndType:PNG]];
    if(model != nil)
    {
        [[self getNavigationController] setLeftTittle:model.name];
    }else
    {
        [[self getNavigationController] setLeftTittle:NEW_TASK];
    }
    [[self getNavigationController] setLeftTittleFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [[self getNavigationController] setLeftTittleColor:[UIColor whiteColor]];
    
    [[self getNavigationController] hideRightButton];
    [[self getNavigationController] showLeftButton];
    [[self getNavigationController] showLeftTittle];
    
    if([self.user.selectList count] != 0)
    {
        if(isPart)
        {
            
        }else
        {
            HYSmartInputModel *smartModel = [self.user.selectList objectAtIndex:[self.user.selectList count] - 1];
            if(firstPepopleInfo == nil)
            {
                firstPepopleInfo = [[HYPeopleInfoView alloc] initWithFrame:CGRectMake(taskNameText.frame.origin.x, 5, 35, 50)];
                firstPepopleInfo.icon = [HYImageFactory GetImageByName:@"newtask_people" AndType:PNG];
                firstPepopleInfo.name = smartModel.name;
                [firstManBgView addSubview:[firstPepopleInfo getView]];
            }else
            {
                [firstPepopleInfo setViewName:smartModel.name];
            }
            executorString = smartModel.accountName;
            
        }
    }
    
}

-(void)bindAction
{
    [[self getNavigationController] setLeftButtonTarget:nil action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)backAction:(id)sender
{
    [[self getNavigationController] popController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)datePickerController:(HYDatePickerViewController *)controller
{
    
}

#pragma HYSmartInputViewControllerDelegate
-(void)returnSmartInputViewController:(HYSmartInputViewController *)controller
{
    NSLog(@"");
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
