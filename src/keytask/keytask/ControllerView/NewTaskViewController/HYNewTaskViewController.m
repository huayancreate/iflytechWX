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
#import "HYHelper.h"

@interface HYNewTaskViewController ()<UITextViewDelegate>
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
    NSString *paticrpantNameString;
    BOOL isPart;
    UIImageView *firstManBgView;
    UIImageView *taskPartBgView;
    UILabel *taskPartLabel;
    UIImageView *addPartPeople;
    UIImageView *delPartPeople;
 
    UIImageView *addFirstPeople;
    UIImageView *delFirstPeople;
    UIImageView *reverFirstPeople;
    UIImageView *reverPartPeople;
    UIImageView *endTimeRightView;
    UIImageView *taskCycleRightView;
    NSMutableArray *firstManList;
    NSMutableArray *excList;
    UIAlertView *backAlert;
    HYPeopleInfoView *lastFirstPeopleView;
    UITapGestureRecognizer *delPeopleViewRecognizer;
    UITapGestureRecognizer *delPartPeopleViewRecognizer;
    NSString *lastExecutorString;
    NSString *firstHeadImgUrlStr;
    NSString *startHeadImgUrlStr;
    int imgType;
    NSMutableDictionary *headImgDic;
    NSMutableArray *partHeadImgArray;
    BOOL returnFlag;
    NSString *modelPartNames;
    NSString *modelParts;
    UIImageView *endTimeBgView;
    UIImageView *taskCycleBgView;
    UIImageView *taskTargetBgView;
    UIImageView *taskResultBgView;
    BOOL isTyping;
    float targetContentHeight;
    float resultContentHeight;
    UIImageView *taskNameBgView;
    float targetBgOriY;
    float resultBgOriY;
    float taskContentOriY;
    float tartgetCurrentOriY;
    
    CGRect *targetBgSourceRect;
    CGRect *targetTextViewSourceRect;
    
    
}

@property (nonatomic, strong) UIImageView *clickView;
@property (nonatomic, strong) UILabel *clickLabel;
@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property NSMutableArray *showControlList;
@property (nonatomic, strong) UITextView *taskTargetTextField;
@property (nonatomic, strong) UITextView *taskContentText;
@property (nonatomic, strong) UITextView *taskResultTextField;
@property (nonatomic, strong) UILabel *taskCycleLabel;
@property (nonatomic, strong) UITextField *taskNameText;
@property (nonatomic, strong) HYPeopleInfoView *pepopleInfo;
@property (nonatomic, strong) HYPeopleInfoView *firstPepopleInfo;
@property (nonatomic, strong) NSMutableArray *partList;
@property (nonatomic, strong) NSMutableArray *partNameList;

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
@synthesize isForwarding;
@synthesize isEdit;
@synthesize helpModel;
@synthesize partList;
@synthesize partNameList;
@synthesize isInformation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isForwarding = NO;
        modelPartNames = @"";
        modelParts = @"";
        isEdit = YES;
        isTyping = NO;
        isInformation = NO;
        returnFlag = false;
//        isNew = YES;
        imgType = 0;
        headImgDic = [[NSMutableDictionary alloc] init];
        partHeadImgArray = [[NSMutableArray alloc] init];
        [self bindAction];
        partList = [[NSMutableArray alloc] init];
        partNameList = [[NSMutableArray alloc] init];
        isUp = YES;
        showControlList = [[NSMutableArray alloc] init];
        pickerList = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31", nil];
        days = @"0";
        pickerFlag = false;
        endTimeString = @"";
        executorString = @"";
        paticrpantString = @"";
        paticrpantNameString = @"";
        lastExecutorString = @"";
        firstHeadImgUrlStr = @"";
        startHeadImgUrlStr = @"";
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
    
    taskNameBgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, 8, ([HYScreenTools getScreenWidth] - 16), 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:YES closeKeyboard:YES isFrame:NO];
    
    [scrollView addSubview:taskNameBgView];
    
    UILabel *taskNameLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(4, 7, 90, 30) textfont:[UIFont fontWithName:FONT_BOLD size:14] text:TASK_NAME_LABEL textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    [taskNameBgView addSubview:taskNameLabel];
    
    
    taskNameText = [HYControlFactory GetTextFieldWithCGRect:CGRectMake(95, 7, (taskNameBgView.frame.size.width - 94), 30) Placeholder:nil SecureTextEntry:NO];
    [taskNameText setFont:[UIFont fontWithName:FONT size:13]];
    [taskNameText addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
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

    addFirstPeople = [HYControlFactory GetImgViewWithCGRect:CGRectMake((firstManBgView.frame.size.width) - 44 , 12.5f, 35, 35) backgroundImgName:@"newtask_add" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [addFirstPeople addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFirstPeopleAction:)]];
    
    delFirstPeople = [HYControlFactory GetImgViewWithCGRect:CGRectMake((firstManBgView.frame.size.width) - 44 , 12.5f, 35, 35) backgroundImgName:@"newtask_del" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [delFirstPeople addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delFirstPeopleAction:)]];
    
    
    reverFirstPeople = [HYControlFactory GetImgViewWithCGRect:CGRectMake((firstManBgView.frame.size.width) - 44 , 12.5f, 35, 35) backgroundImgName:@"taskrever" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [reverFirstPeople addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reverFirstPeopleAction:)]];
    
    reverPartPeople = [HYControlFactory GetImgViewWithCGRect:CGRectMake((firstManBgView.frame.size.width) - 44 , 12.5f, 35, 35) backgroundImgName:@"taskrever" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [reverPartPeople addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reverPartPeopleAction:)]];
    
    
    
    [firstManBgView addSubview:addFirstPeople];
    [firstManBgView addSubview:firstManLabel];
    
    [scrollView addSubview:firstManBgView];
    
    endTimeBgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, 196, ([HYScreenTools getScreenWidth] - 16), 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:YES closeKeyboard:YES isFrame:NO];
    
    endTimeRightView = [HYControlFactory GetImgViewWithCGRect:CGRectMake((firstManBgView.frame.size.width) - 35 , 10, 35, 25) backgroundImgName:@"newtask_right" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [endTimeBgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePickerAction:)]];
    
   [endTimeRightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePickerAction:)]];
    
    [endTimeBgView addSubview:endTimeRightView];
    
    
    UIImageView *endTimeClockView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(6, 9, 26, 26) backgroundImgName:@"newtask_time" backgroundColor:nil isCornerRadius:NO closeKeyboard:YES isFrame:NO];
    
//    [endTimeClockView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePickerAction:)]];
    [endTimeBgView addSubview:endTimeClockView];
    
    endTimeLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(46, 7, 200, 30) textfont:[UIFont fontWithName:FONT_BOLD size:14] text:END_TIME_LABEL textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
//    [endTimeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePickerAction:)]];
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
    
    taskContentText = [HYControlFactory GetTextViewWithCGRect:CGRectMake(8, (taskContentLabel.frame.origin.y + taskContentLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 120) isCornerRaidus:YES font:[UIFont fontWithName:FONT_BOLD size:13] textColor:[UIColor blackColor]];
    taskContentText.delegate = self;
    
    taskContentOriY = taskContentText.frame.origin.y;
    
    [showControlList addObject:taskContentText];
    
    taskTargetBgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, (taskContentText.frame.origin.y + taskContentText.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:YES closeKeyboard:YES isFrame:NO];
    
    
    targetBgOriY = taskTargetBgView.frame.origin.y + taskTargetBgView.frame.size.height;
    resultBgOriY = taskResultBgView.frame.origin.y + taskResultBgView.frame.size.height;
    
    UILabel *taskTargetLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(4, 7, 50, 30) textfont:[UIFont fontWithName:FONT_BOLD size:14] text:TASK_TARGET textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    
//    taskTargetTextField = [HYControlFactory GetTextFieldWithCGRect:CGRectMake(60, 7, 200, 30) Placeholder:@"" SecureTextEntry:NO];
    taskTargetTextField = [HYControlFactory GetTextViewWithCGRect:CGRectMake(60, 7, taskTargetBgView.frame.size.width - 64, 30) isCornerRaidus:NO font:[UIFont fontWithName:FONT_BOLD size:14] textColor:[UIColor blackColor]];
    
    
    
//    [taskTargetTextField setFont:[UIFont fontWithName:FONT size:13]];
    taskTargetTextField.delegate = self;
    
    
    [taskTargetBgView addSubview:taskTargetTextField];
    
    [taskTargetBgView addSubview:taskTargetLabel];
    
    [showControlList addObject:taskTargetBgView];
    
    taskResultBgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, (taskTargetBgView.frame.origin.y + taskTargetBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:YES closeKeyboard:YES isFrame:NO];
    
    UILabel *taskResultLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(4, 7, 50, 30) textfont:[UIFont fontWithName:FONT_BOLD size:14] text:TASK_RESULT textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    [taskResultBgView addSubview:taskResultLabel];
    
//    taskResultTextField = [HYControlFactory GetTextFieldWithCGRect:CGRectMake(60, 7, 200, 30) Placeholder:@"" SecureTextEntry:NO];
    
    taskResultTextField = [HYControlFactory GetTextViewWithCGRect:CGRectMake(60, 7, 200, 30) isCornerRaidus:NO font:[UIFont fontWithName:FONT_BOLD size:13] textColor:[UIColor blackColor]];
    taskResultTextField.delegate = self;
    
    
//    [taskResultTextField setFont:[UIFont fontWithName:FONT size:13]];
    [taskResultBgView addSubview:taskResultTextField];
    
    [showControlList addObject:taskResultBgView];
    
    taskCycleBgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, (taskResultBgView.frame.origin.y + taskResultBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:YES closeKeyboard:YES isFrame:NO];
    
    
    taskCycleRightView = [HYControlFactory GetImgViewWithCGRect:CGRectMake((taskCycleBgView.frame.size.width) - 35 , 10, 35, 25) backgroundImgName:@"newtask_right" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    
    [taskCycleRightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerAction:)]];
    [taskCycleBgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerAction:)]];
    
    [taskCycleBgView addSubview:taskCycleRightView];
    
    
    
    UIImageView *taskCycleImgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(6, 9, 26, 26) backgroundImgName:@"newtask_date" backgroundColor:nil isCornerRadius:NO closeKeyboard:YES isFrame:NO];
    [taskCycleBgView addSubview:taskCycleImgView];
    
    taskCycleLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(46, 7, 200, 30) textfont:[UIFont fontWithName:FONT_BOLD size:14] text:[TASK_CYCLE stringByAppendingString:@"       0    天"] textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    [taskCycleBgView addSubview:taskCycleLabel];
    
    
    
    [showControlList addObject:taskCycleBgView];
    
    taskPartLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(10, (taskCycleBgView.frame.origin.y + taskCycleBgView.frame.size.height + 10), ([HYScreenTools getScreenWidth] - 16), 30) textfont:[UIFont fontWithName:FONT_BOLD size:14] text:TASK_PART_LABEL textColor:[UIColor blackColor] TextAlignment:NSTextAlignmentLeft];
    
    [showControlList addObject:taskPartLabel];
    
    taskPartBgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, (taskPartLabel.frame.origin.y + taskPartLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 60) backgroundImgName:nil backgroundColor:[UIColor whiteColor] isCornerRadius:YES closeKeyboard:YES isFrame:NO];
    
    addPartPeople = [HYControlFactory GetImgViewWithCGRect:CGRectMake((taskPartBgView.frame.size.width) - 44 , 12.5f, 35, 35) backgroundImgName:@"newtask_add" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [addPartPeople addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPartPeopleAction:)]];
    
    delPartPeople = [HYControlFactory GetImgViewWithCGRect:CGRectMake((taskPartBgView.frame.size.width) - 44 , 56.5f, 35, 35) backgroundImgName:@"newtask_del" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [delPartPeople addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delPartPeopleAction:)]];
    
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
    
    if(model == nil || isForwarding == YES || isEdit == YES)
    {
        pepopleInfo.name = self.user.username;
    }
    if(self.user.helpModel != nil)
    {
        pepopleInfo.name = self.user.helpModel.proxyName;
    }
    
    if(model != nil)
    {
        modelParts = model.paticrpant;
        modelPartNames = model.paticrpantName;
        [taskNameText setText:model.name];
        if(isForwarding == YES)
        {
            pepopleInfo.name = self.user.username;
        }else
        {
            firstPepopleInfo = [[HYPeopleInfoView alloc] initWithFrame:CGRectMake(taskNameText.frame.origin.x, 5, 35, 50)];
            pepopleInfo.name = model.initiatorName;
            firstPepopleInfo.icon = [HYImageFactory GetImageByName:@"newtask_people" AndType:PNG];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self getFirstHeadImg:model.executor];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if(firstHeadImgUrlStr != nil && ![firstHeadImgUrlStr isEqual:@""])
                    {
                        [firstPepopleInfo setHeadImgUrlStr:firstHeadImgUrlStr];
                    }
                });
            });
            
            firstPepopleInfo.name = model.executorName;
            HYSmartInputModel *tempSmartModel = [[HYSmartInputModel alloc] init];
            tempSmartModel.accountName = model.executor;
            tempSmartModel.name = model.executorName;
            if(excList == nil)
            {
                excList = [[NSMutableArray alloc] init];
                [excList addObject:tempSmartModel];
            }
        }
        
        [taskContentText setText:model.description];
        [taskTargetTextField setText:model.goal];
        
        CGRect textTargetFrame = [[taskTargetTextField layoutManager]usedRectForTextContainer:[taskTargetTextField textContainer]];
        
        CGSize setTarSize = CGSizeMake(taskTargetTextField.frame.size.width, textTargetFrame.size.height + 10);
        [taskTargetTextField setContentSize:setTarSize];
//        
//        
        [self setTaskTargetTextFieldContentSize];
//        taskTargetTextField setContentSize:<#(CGSize)#>
        
        [taskTargetTextField setContentSize:CGSizeMake(taskTargetTextField.frame.size.width,textTargetFrame.size.height + 50 )];
        
        [taskResultTextField setText:model.product];
        CGRect textResultFrame = [[taskResultTextField layoutManager]usedRectForTextContainer:[taskResultTextField textContainer]];
//        //NSLog(@"看看数据多说 = %f", textResultFrame.size.height);
//        //NSLog(@"看看数据多说 = %f", taskResultTextField.contentSize.height);
//        
        CGSize setSize = CGSizeMake(taskTargetTextField.frame.size.width, textResultFrame.size.height + 10);
        [taskResultTextField setContentSize:setSize];
//        //NSLog(@"看看数据多说 = %f", taskResultTextField.contentSize.height);
//        
        [self setTaskResultTextFieldContentSize];
        NSString *cycleString = TASK_CYCLE;
        cycleString = [cycleString stringByAppendingString:@"       "];
        cycleString = [cycleString stringByAppendingString:model.days];
        cycleString = [cycleString stringByAppendingString:@"    天"];
        [taskCycleLabel setText:cycleString];
//
        [endTimeLabel setText:[END_TIME_LABEL stringByAppendingString:model.endTime]];
        
//        [self addPartPeopleView];
        if(firstPepopleInfo != nil)
        {
            [firstManBgView addSubview:[firstPepopleInfo getViewWithWidth:35 iconHeight:35 nameWidth:35 nameHeight:15]];
        }
    }
    
    [startNameBgView addSubview:[pepopleInfo getViewWithWidth:35 iconHeight:35 nameWidth:35 nameHeight:15]];
}

//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    //NSLog(@"12312321");
//}

-(void)setTaskResultTextFieldContentSize
{
    if(taskResultTextField.contentSize.height >= 100)
    {
        
        [taskResultBgView setFrame:CGRectMake(8, (taskTargetBgView.frame.origin.y + taskTargetBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 114)];
        
        [taskResultTextField setFrame:CGRectMake(60, 7, taskResultBgView.frame.size.width - 64, 100)];
        
        [taskCycleBgView setFrame:CGRectMake(8, (taskResultBgView.frame.origin.y + taskResultBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)];
        
        [taskPartLabel setFrame:CGRectMake(10, (taskCycleBgView.frame.origin.y + taskCycleBgView.frame.size.height + 10), ([HYScreenTools getScreenWidth] - 16), 30)];
        
        [taskPartBgView setFrame:CGRectMake(8, (taskPartLabel.frame.origin.y + taskPartLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), taskPartBgView.frame.size.height)];
        
        
        [okButton setFrame:CGRectMake(8, (taskPartBgView.frame.origin.y + taskPartBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)];
        
        [scrollView setContentSize:CGSizeMake([HYScreenTools getScreenWidth],okButton.frame.origin.y + okButton.frame.size.height + 10 )];
        
        //        = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, (taskResultBgView.frame.origin.y + taskResultBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)
    }else
    {
        
        //NSLog(@"ceshi %f = ", taskResultTextField.contentSize.height);
        [taskResultBgView setFrame:CGRectMake(8, (taskTargetBgView.frame.origin.y + taskTargetBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 14 + taskResultTextField.contentSize.height)];
        
        [taskCycleBgView setFrame:CGRectMake(8, (taskResultBgView.frame.origin.y + taskResultBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)];
        
        [taskPartLabel setFrame:CGRectMake(10, (taskCycleBgView.frame.origin.y + taskCycleBgView.frame.size.height + 10), ([HYScreenTools getScreenWidth] - 16), 30)];
        
        [taskPartBgView setFrame:CGRectMake(8, (taskPartLabel.frame.origin.y + taskPartLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), taskPartBgView.frame.size.height)];
        
        
        [okButton setFrame:CGRectMake(8, (taskPartBgView.frame.origin.y + taskPartBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)];
        
        //        = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, (taskResultBgView.frame.origin.y + taskResultBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)
        
        [taskResultTextField setFrame:CGRectMake(60, 7, taskResultBgView.frame.size.width - 64, taskResultTextField.contentSize.height)];
        [scrollView setContentSize:CGSizeMake([HYScreenTools getScreenWidth],okButton.frame.origin.y + okButton.frame.size.height + 10 )];
    }

}

-(void)setTaskTargetTextFieldContentSize
{
    if(taskTargetTextField.contentSize.height >= 100)
    {
        [taskTargetBgView setFrame:CGRectMake(8, (taskContentText.frame.origin.y + taskContentText.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 114)];
        
        if(taskResultTextField.contentSize.height >= 100)
        {
            [taskResultBgView setFrame:CGRectMake(8, (taskTargetBgView.frame.origin.y + taskTargetBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 114)];
        }else
        {
            [taskResultBgView setFrame:CGRectMake(8, (taskTargetBgView.frame.origin.y + taskTargetBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16),
                                                  14 + taskResultTextField.contentSize.height)];
        }
        
        [taskCycleBgView setFrame:CGRectMake(8, (taskResultBgView.frame.origin.y + taskResultBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)];
        
        [taskPartLabel setFrame:CGRectMake(10, (taskCycleBgView.frame.origin.y + taskCycleBgView.frame.size.height + 10), ([HYScreenTools getScreenWidth] - 16), 30)];
        
        [taskPartBgView setFrame:CGRectMake(8, (taskPartLabel.frame.origin.y + taskPartLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), taskPartBgView.frame.size.height)];
        
        
        [okButton setFrame:CGRectMake(8, (taskPartBgView.frame.origin.y + taskPartBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)];
        
        //        = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, (taskResultBgView.frame.origin.y + taskResultBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)
        [scrollView setContentSize:CGSizeMake([HYScreenTools getScreenWidth],okButton.frame.origin.y + okButton.frame.size.height + 10 )];
        
        [taskTargetTextField setFrame:CGRectMake(60, 7, taskTargetBgView.frame.size.width - 64, 100)];
    }else
    {
        if(taskResultTextField.contentSize.height >= 100)
        {
            [taskResultBgView setFrame:CGRectMake(8, (taskTargetBgView.frame.origin.y + taskTargetBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 114)];
        }else
        {
            [taskResultBgView setFrame:CGRectMake(8, (taskTargetBgView.frame.origin.y + taskTargetBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16),
                                                  14 + taskResultTextField.contentSize.height)];
        }
        [taskTargetBgView setFrame:CGRectMake(8, (taskContentText.frame.origin.y + taskContentText.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), taskTargetTextField.contentSize.height + 14)];
        
        [taskCycleBgView setFrame:CGRectMake(8, (taskResultBgView.frame.origin.y + taskResultBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)];
        
        [taskPartLabel setFrame:CGRectMake(10, (taskCycleBgView.frame.origin.y + taskCycleBgView.frame.size.height + 10), ([HYScreenTools getScreenWidth] - 16), 30)];
        
        [taskPartBgView setFrame:CGRectMake(8, (taskPartLabel.frame.origin.y + taskPartLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), taskPartBgView.frame.size.height)];
        
        
        [okButton setFrame:CGRectMake(8, (taskPartBgView.frame.origin.y + taskPartBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)];
        
        //        = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, (taskResultBgView.frame.origin.y + taskResultBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)
        
        //NSLog(@"jaskdjksaljdklsajd %f= ", taskResultTextField.contentSize.height);
        [taskTargetTextField setFrame:CGRectMake(60, 7,  taskTargetBgView.frame.size.width - 64, taskTargetTextField.contentSize.height)];
        [scrollView setContentSize:CGSizeMake([HYScreenTools getScreenWidth],okButton.frame.origin.y + okButton.frame.size.height + 10 )];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView == taskTargetTextField)
    {
        
//        [HYControlFactory GetTextViewWithCGRect:CGRectMake(60, 7, 200, 30)
        NSString *tempString = taskTargetTextField.text;
        //NSLog(@"%@", taskTargetTextField.text);
        if(!isTyping)
        {
            targetBgOriY = taskTargetBgView.frame.origin.y + taskTargetBgView.frame.size.height;
            return;
        }
        if(targetContentHeight == 0)
        {
            return;
        }
        
        [taskTargetBgView setFrame:CGRectMake(8, (taskContentText.frame.origin.y + taskContentText.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), taskTargetBgView.frame.size.height)];
        
        [taskTargetTextField removeFromSuperview];
        taskTargetTextField = nil;
        if(targetContentHeight >= 100)
        {
            [taskContentText setFrame:CGRectMake(taskContentText.frame.origin.x, taskContentOriY, taskContentText.frame.size.width, taskContentText.frame.size.height)];
            [taskTargetBgView setFrame:CGRectMake(8, (taskContentText.frame.origin.y + taskContentText.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), taskTargetBgView.frame.size.height)];
            
            taskTargetTextField = [HYControlFactory GetTextViewWithCGRect:CGRectMake(60, 7, taskTargetBgView.frame.size.width - 64, 100) isCornerRaidus:NO font:[UIFont fontWithName:FONT_BOLD size:14] textColor:[UIColor blackColor]];
            taskTargetTextField.text = tempString;
            [taskTargetBgView addSubview:taskTargetTextField];
            
            taskTargetTextField.delegate = self;
//            [taskTargetTextField setFrame:CGRectMake(60, 7, 200, 100)];
            
            
            
            //还原其他控件
            if(resultContentHeight >= 100)
            {
                [taskResultBgView setFrame:CGRectMake(8, (taskTargetBgView.frame.origin.y + taskTargetBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 114)];
            }else
            {
                if(resultContentHeight == 0)
                {
                    [taskResultBgView setFrame:CGRectMake(8, (taskTargetBgView.frame.origin.y + taskTargetBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)];
                }else
                {
                    [taskResultBgView setFrame:CGRectMake(8, (taskTargetBgView.frame.origin.y + taskTargetBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), resultContentHeight + 14)];
                
                }
            }
            
            [taskCycleBgView setFrame:CGRectMake(8, (taskResultBgView.frame.origin.y + taskResultBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)];
            
            [taskPartLabel setFrame:CGRectMake(10, (taskCycleBgView.frame.origin.y + taskCycleBgView.frame.size.height + 10), ([HYScreenTools getScreenWidth] - 16), 30)];
            
            [taskPartBgView setFrame:CGRectMake(8, (taskPartLabel.frame.origin.y + taskPartLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), taskPartBgView.frame.size.height)];
            
            
            [okButton setFrame:CGRectMake(8, (taskPartBgView.frame.origin.y + taskPartBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)];
            
            //        = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, (taskResultBgView.frame.origin.y + taskResultBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)
            [scrollView setContentSize:CGSizeMake([HYScreenTools getScreenWidth],okButton.frame.origin.y + okButton.frame.size.height + 10 )];
            
            
            
        }else
        {
            [taskContentText setFrame:CGRectMake(taskContentText.frame.origin.x, taskContentOriY, taskContentText.frame.size.width, taskContentText.frame.size.height)];
            
            [taskTargetBgView setFrame:CGRectMake(8, (taskContentText.frame.origin.y + taskContentText.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), taskTargetBgView.frame.size.height)];
            
            taskTargetTextField = [HYControlFactory GetTextViewWithCGRect:CGRectMake(60, 7, taskTargetBgView.frame.size.width - 64, targetContentHeight) isCornerRaidus:NO font:[UIFont fontWithName:FONT_BOLD size:14] textColor:[UIColor blackColor]];
            [taskTargetBgView addSubview:taskTargetTextField];
            
            taskTargetTextField.delegate = self;
            
            taskTargetTextField.text = tempString;
            
            //还原其他控件
            if(resultContentHeight >= 100)
            {
                [taskResultBgView setFrame:CGRectMake(8, (taskTargetBgView.frame.origin.y + taskTargetBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 114)];
            }else
            {
                if(resultContentHeight == 0)
                {
                    [taskResultBgView setFrame:CGRectMake(8, (taskTargetBgView.frame.origin.y + taskTargetBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)];
                }else
                {
                    [taskResultBgView setFrame:CGRectMake(8, (taskTargetBgView.frame.origin.y + taskTargetBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), resultContentHeight + 14)];
                    
                }
            }
            
            [taskCycleBgView setFrame:CGRectMake(8, (taskResultBgView.frame.origin.y + taskResultBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)];
            
            [taskPartLabel setFrame:CGRectMake(10, (taskCycleBgView.frame.origin.y + taskCycleBgView.frame.size.height + 10), ([HYScreenTools getScreenWidth] - 16), 30)];
            
            [taskPartBgView setFrame:CGRectMake(8, (taskPartLabel.frame.origin.y + taskPartLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), taskPartBgView.frame.size.height)];
            
            
            [okButton setFrame:CGRectMake(8, (taskPartBgView.frame.origin.y + taskPartBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)];
            
            //        = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, (taskResultBgView.frame.origin.y + taskResultBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)
            [scrollView setContentSize:CGSizeMake([HYScreenTools getScreenWidth],okButton.frame.origin.y + okButton.frame.size.height + 10 )];
        }
        
        isTyping = NO;
    }
    
    
    
    
    if(textView == taskResultTextField)
    {
        //        [HYControlFactory GetTextViewWithCGRect:CGRectMake(60, 7, 200, 30)
        NSString *tempString = taskResultTextField.text;
        //NSLog(@"%@", taskResultTextField.text);
        if(!isTyping)
        {
            resultBgOriY = taskResultBgView.frame.origin.y + taskResultBgView.frame.size.height;
            tartgetCurrentOriY = taskTargetBgView.frame.origin.y;
            return;
        }
        if(resultContentHeight == 0)
        {
            return;
        }
        
        [taskResultTextField removeFromSuperview];
        taskResultTextField = nil;
        NSString *tempTargetString = taskTargetTextField.text;
        [taskTargetTextField removeFromSuperview];
        taskTargetTextField = nil;
        if(resultContentHeight >= 100)
        {
            [taskContentText setFrame:CGRectMake(taskContentText.frame.origin.x, taskContentOriY, taskContentText.frame.size.width, taskContentText.frame.size.height)];
            [taskTargetBgView setFrame:CGRectMake(8, (taskContentText.frame.origin.y + taskContentText.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), taskTargetBgView.frame.size.height)];
            
            taskTargetTextField = [HYControlFactory GetTextViewWithCGRect:CGRectMake(60, 7, taskTargetBgView.frame.size.width - 64, 100) isCornerRaidus:NO font:[UIFont fontWithName:FONT_BOLD size:14] textColor:[UIColor blackColor]];
            taskTargetTextField.text = tempTargetString;
            [taskTargetBgView addSubview:taskTargetTextField];
            
            taskTargetTextField.delegate = self;
            
            
            taskResultTextField = [HYControlFactory GetTextViewWithCGRect:CGRectMake(60, 7, taskResultBgView.frame.size.width - 64, 100) isCornerRaidus:NO font:[UIFont fontWithName:FONT_BOLD size:14] textColor:[UIColor blackColor]];
            taskResultTextField.text = tempString;
            [taskResultBgView addSubview:taskResultTextField];
            
            taskResultTextField.delegate = self;
            
            //还原其他控件
            if(resultContentHeight >= 100)
            {
                [taskResultBgView setFrame:CGRectMake(8, (taskTargetBgView.frame.origin.y + taskTargetBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 114)];
            }else
            {
                if(resultContentHeight == 0)
                {
                    [taskResultBgView setFrame:CGRectMake(8, (taskTargetBgView.frame.origin.y + taskTargetBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)];
                }else
                {
                    [taskResultBgView setFrame:CGRectMake(8, (taskTargetBgView.frame.origin.y + taskTargetBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), resultContentHeight + 14)];
                    
                }
            }
            
            [taskCycleBgView setFrame:CGRectMake(8, (taskResultBgView.frame.origin.y + taskResultBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)];
            
            [taskPartLabel setFrame:CGRectMake(10, (taskCycleBgView.frame.origin.y + taskCycleBgView.frame.size.height + 10), ([HYScreenTools getScreenWidth] - 16), 30)];
            
            [taskPartBgView setFrame:CGRectMake(8, (taskPartLabel.frame.origin.y + taskPartLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), taskPartBgView.frame.size.height)];
            
            
            [okButton setFrame:CGRectMake(8, (taskPartBgView.frame.origin.y + taskPartBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)];
            
            //        = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, (taskResultBgView.frame.origin.y + taskResultBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)
            [scrollView setContentSize:CGSizeMake([HYScreenTools getScreenWidth],okButton.frame.origin.y + okButton.frame.size.height + 10 )];
            
            
        }else
        {
            [taskContentText setFrame:CGRectMake(taskContentText.frame.origin.x, taskContentOriY, taskContentText.frame.size.width, taskContentText.frame.size.height)];
            
            [taskTargetBgView setFrame:CGRectMake(8, (taskContentText.frame.origin.y + taskContentText.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), taskTargetBgView.frame.size.height)];
            
            taskTargetTextField = [HYControlFactory GetTextViewWithCGRect:CGRectMake(60, 7, taskTargetBgView.frame.size.width - 64, targetContentHeight) isCornerRaidus:NO font:[UIFont fontWithName:FONT_BOLD size:14] textColor:[UIColor blackColor]];
            [taskTargetBgView addSubview:taskTargetTextField];
            
            taskTargetTextField.delegate = self;
            
            taskTargetTextField.text = tempTargetString;
            
            taskResultTextField = [HYControlFactory GetTextViewWithCGRect:CGRectMake(60, 7, taskResultBgView.frame.size.width - 64, resultContentHeight) isCornerRaidus:NO font:[UIFont fontWithName:FONT_BOLD size:14] textColor:[UIColor blackColor]];
            [taskResultBgView addSubview:taskResultTextField];
            
            taskResultTextField.delegate = self;
            
            taskResultTextField.text = tempString;
            
            //还原其他控件
            if(resultContentHeight >= 100)
            {
                [taskResultBgView setFrame:CGRectMake(8, (taskTargetBgView.frame.origin.y + taskTargetBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 114)];
            }else
            {
                if(resultContentHeight == 0)
                {
                    [taskResultBgView setFrame:CGRectMake(8, (taskTargetBgView.frame.origin.y + taskTargetBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)];
                }else
                {
                    [taskResultBgView setFrame:CGRectMake(8, (taskTargetBgView.frame.origin.y + taskTargetBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), resultContentHeight + 14)];
                    
                }
            }
            
            [taskCycleBgView setFrame:CGRectMake(8, (taskResultBgView.frame.origin.y + taskResultBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)];
            
            [taskPartLabel setFrame:CGRectMake(10, (taskCycleBgView.frame.origin.y + taskCycleBgView.frame.size.height + 10), ([HYScreenTools getScreenWidth] - 16), 30)];
            
            [taskPartBgView setFrame:CGRectMake(8, (taskPartLabel.frame.origin.y + taskPartLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), taskPartBgView.frame.size.height)];
            
            
            [okButton setFrame:CGRectMake(8, (taskPartBgView.frame.origin.y + taskPartBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)];
            
            //        = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, (taskResultBgView.frame.origin.y + taskResultBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44)
            [scrollView setContentSize:CGSizeMake([HYScreenTools getScreenWidth],okButton.frame.origin.y + okButton.frame.size.height + 10 )];
            
            
        }
        
        isTyping = NO;
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    returnFlag = YES;
    isTyping = YES;
    
    if(textView == taskTargetTextField)
    {
        //NSLog(@"taskTargetTextField.contentSize.height = %f", taskTargetTextField.contentSize.height);
        targetContentHeight = taskTargetTextField.contentSize.height;
        if(taskTargetTextField.contentSize.height >= 100)
        {
            [taskContentText setFrame:CGRectMake(taskContentText.frame.origin.x, taskContentOriY - 70, taskContentText.frame.size.width, taskContentText.frame.size.height)];
            [taskTargetBgView setFrame:CGRectMake(8, targetBgOriY - 114, ([HYScreenTools getScreenWidth] - 16), 114)];
            [taskTargetTextField setFrame:CGRectMake(60, 7, taskTargetBgView.frame.size.width - 64, 100)];
        }else
        {
            [taskContentText setFrame:CGRectMake(taskContentText.frame.origin.x, taskContentOriY - taskTargetTextField.contentSize.height, taskContentText.frame.size.width, taskContentText.frame.size.height)];
            [taskTargetBgView setFrame:CGRectMake(8, targetBgOriY - taskTargetTextField.contentSize.height - 14, ([HYScreenTools getScreenWidth] - 16), taskTargetTextField.contentSize.height + 14)];
            [taskTargetTextField setFrame:CGRectMake(60, 7, taskTargetBgView.frame.size.width - 64, taskTargetTextField.contentSize.height)];
        }
    }
    
    if(textView == taskResultTextField)
    {
        [taskContentText setFrame:CGRectMake(taskContentText.frame.origin.x, taskContentOriY - 70, taskContentText.frame.size.width, taskContentText.frame.size.height)];
        [taskTargetBgView setFrame:CGRectMake(taskTargetBgView.frame.origin.x, tartgetCurrentOriY - 70, taskTargetBgView.frame.size.width, taskTargetBgView.frame.size.height)];
        //NSLog(@"taskTargetTextField.contentSize.height = %f", taskTargetTextField.contentSize.height);
        resultContentHeight = taskResultTextField.contentSize.height;
        if(taskResultTextField.contentSize.height >= 100)
        {
             [taskTargetBgView setFrame:CGRectMake(taskTargetBgView.frame.origin.x, tartgetCurrentOriY - 100, taskTargetBgView.frame.size.width, taskTargetBgView.frame.size.height)];
            [taskResultBgView setFrame:CGRectMake(8, resultBgOriY - 114, ([HYScreenTools getScreenWidth] - 16), 114)];
            [taskResultTextField setFrame:CGRectMake(60, 7, taskResultBgView.frame.size.width - 64, 100)];
        }else
        {
            [taskTargetBgView setFrame:CGRectMake(taskTargetBgView.frame.origin.x, tartgetCurrentOriY - taskResultTextField.contentSize.height, taskTargetBgView.frame.size.width, taskTargetBgView.frame.size.height)];
           
            [taskResultBgView setFrame:CGRectMake(8, resultBgOriY - taskResultTextField.contentSize.height - 14, ([HYScreenTools getScreenWidth] - 16), taskResultTextField.contentSize.height + 14)];
            [taskResultTextField setFrame:CGRectMake(60, 7, taskResultBgView.frame.size.width - 64, taskResultTextField.contentSize.height)];
        }
    }
}

-(void)getPartHeadImg:(NSString *)accountName
{
    if(self.user == nil)
    {
        self.user = [HYHelper getUser];
    }
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.accountName,@"AccountName",self.user.token,@"Token",@"GetHeadImg",@"opeType",accountName,@"UserAccount",nil];
    
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
    [request setDidFinishSelector:@selector(endGetPartHeadImgFin:)];
    [request setDidFailSelector:@selector(endGetPartHeadImgFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startSynchronous];
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    returnFlag = YES;
}

- (void) endGetPartHeadImgFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetPartHeadImgString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endGetPartHeadImgFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetPartHeadImgStringFail:) withObject:responsestring waitUntilDone:YES];
}

-(void)endGetPartHeadImgStringFail:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"服务器连接失败,请检查网络!"];
    //    [self logoutAction];
}

-(void)endGetPartHeadImgString:(NSString *)msg
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
        NSDictionary *content = [contents objectAtIndex:0];
        NSString *headImgUrl = @"";
        NSArray *headArr = nil;
        NSString *accountNameString = [content objectForKey:@"AccountName"];
        if(![[content objectForKey:@"Img"] isEqualToString:@""])
        {
            headArr = [[content objectForKey:@"Img"] componentsSeparatedByString:@"\\"];
        }
        if([headArr count] != 2 && headArr != nil)
        {
            headArr = [[content objectForKey:@"Img"] componentsSeparatedByString:@"//"];
        }
        if(headArr != nil)
        {
            headImgUrl = [headImgUrl stringByAppendingString:HeadImg_api];
            headImgUrl = [headImgUrl stringByAppendingString:[headArr objectAtIndex:0]];
            headImgUrl = [headImgUrl stringByAppendingString:@"/"];
            headImgUrl = [headImgUrl stringByAppendingString:[headArr objectAtIndex:1]];
        }
        //firstHeadImgUrlStr = headImgUrl;
        [headImgDic setObject:headImgUrl forKey:accountNameString];
//        [headImgArray addObject:headImgUrl];
    }else
    {
        //        [self logoutAction];
    }
}



-(void)getStartHeadImg:(NSString *)accountName
{
    if(self.user == nil)
    {
        self.user = [HYHelper getUser];
    }
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.accountName,@"AccountName",self.user.token,@"Token",@"GetHeadImg",@"opeType",accountName,@"UserAccount",nil];
    
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
    [request setDidFinishSelector:@selector(endGetStartHeadImgFin:)];
    [request setDidFailSelector:@selector(endGetStartHeadImgFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startSynchronous];
}

- (void) endGetStartHeadImgFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetStartHeadImgString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endGetStartHeadImgFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetStartHeadImgStringFail:) withObject:responsestring waitUntilDone:YES];
}

-(void)endGetStartHeadImgStringFail:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"服务器连接失败,请检查网络!"];
    //    [self logoutAction];
}

-(void)endGetStartHeadImgString:(NSString *)msg
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
        NSDictionary *content = [contents objectAtIndex:0];
        NSString *headImgUrl = @"";
        NSArray *headArr = nil;
        if(![[content objectForKey:@"Img"] isEqualToString:@""])
        {
            headArr = [[content objectForKey:@"Img"] componentsSeparatedByString:@"\\"];
        }
        if([headArr count] != 2 && headArr != nil)
        {
            headArr = [[content objectForKey:@"Img"] componentsSeparatedByString:@"//"];
        }
        if(headArr != nil)
        {
            headImgUrl = [headImgUrl stringByAppendingString:HeadImg_api];
            headImgUrl = [headImgUrl stringByAppendingString:[headArr objectAtIndex:0]];
            headImgUrl = [headImgUrl stringByAppendingString:@"/"];
            headImgUrl = [headImgUrl stringByAppendingString:[headArr objectAtIndex:1]];
        }
        //firstHeadImgUrlStr = headImgUrl;
        startHeadImgUrlStr = headImgUrl;
    }else
    {
        //        [self logoutAction];
    }
}

-(void)getFirstHeadImg:(NSString *)accountName
{
    if(self.user == nil)
    {
        self.user = [HYHelper getUser];
    }
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.accountName,@"AccountName",self.user.token,@"Token",@"GetHeadImg",@"opeType",accountName,@"UserAccount",nil];
    
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
    [request setDidFinishSelector:@selector(endGetFirstHeadImgFin:)];
    [request setDidFailSelector:@selector(endGetFirstHeadImgFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startSynchronous];
}

- (void) endGetFirstHeadImgFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetFirstHeadImgString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endGetFirstHeadImgFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetFirstHeadImgStringFail:) withObject:responsestring waitUntilDone:YES];
}

-(void)endGetFirstHeadImgStringFail:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"服务器连接失败,请检查网络!"];
    //    [self logoutAction];
}

-(void)endGetFirstHeadImgString:(NSString *)msg
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
        NSDictionary *content = [contents objectAtIndex:0];
        NSString *headImgUrl = @"";
        NSArray *headArr = nil;
        if(![[content objectForKey:@"Img"] isEqualToString:@""])
        {
            headArr = [[content objectForKey:@"Img"] componentsSeparatedByString:@"\\"];
        }
        if([headArr count] != 2 && headArr != nil)
        {
            headArr = [[content objectForKey:@"Img"] componentsSeparatedByString:@"//"];
        }
        if(headArr != nil)
        {
            headImgUrl = [headImgUrl stringByAppendingString:HeadImg_api];
            headImgUrl = [headImgUrl stringByAppendingString:[headArr objectAtIndex:0]];
            headImgUrl = [headImgUrl stringByAppendingString:@"/"];
            headImgUrl = [headImgUrl stringByAppendingString:[headArr objectAtIndex:1]];
        }
        firstHeadImgUrlStr = headImgUrl;
//        startHeadImgUrlStr = headImgUrl;
    }else
    {
//        [self logoutAction];
    }
}


-(void)addPartPeopleView
{
    [taskPartBgView setFrame:CGRectMake(8, (taskPartLabel.frame.origin.y + taskPartLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 70)];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    [headImgDic removeAllObjects];
    [partHeadImgArray removeAllObjects];
    if(self.user.partList != nil || self.user.selectPartList != nil)
    {
        if(self.user.partList != nil && isPart)
        {
            self.user.selectPartList = [self.user.partList mutableCopy];
        }
        paticrpantString = @"";
        paticrpantNameString = @"";
        for (UIImageView *oneView in taskPartBgView.subviews ) {
            if ([oneView isKindOfClass:[UIView class]]) {
                [oneView removeFromSuperview];
            }
        }
        [taskPartBgView addSubview:addPartPeople];
        int line = 0;
        for (int i = 0; i < [self.user.partList count]; i++) {
            HYSmartInputModel *smartModel = [self.user.partList objectAtIndex:i];
            line = i / 4;
            int modeline = i % 4;
            dispatch_group_async(group, queue, ^{
                [self getPartHeadImg:smartModel.accountName];
            });
            HYPeopleInfoView *partPeople = [[HYPeopleInfoView alloc] initWithFrame:CGRectMake(10 + modeline * 50, 5 + line * 65, 45, 60)];
            partPeople.accountName = smartModel.accountName;
            [partHeadImgArray addObject:partPeople];
            partPeople.name = smartModel.name;
            partPeople.icon = [HYImageFactory GetImageByName:@"newtask_people" AndType:PNG];
            [taskPartBgView addSubview:[partPeople getViewWithWidth:45 iconHeight:45 nameWidth:45 nameHeight:15]];
            paticrpantString = [paticrpantString stringByAppendingString:smartModel.accountName];
            
            paticrpantNameString = [paticrpantNameString stringByAppendingString:smartModel.name];
            if(i != ([self.user.partList count] -1))
            {
                paticrpantString = [paticrpantString stringByAppendingString:@","];
                paticrpantNameString = [paticrpantNameString stringByAppendingString:@","];
            }
        }
        self.user.paticrpantString = paticrpantString;
        if(self.user.partList == nil)
        {
            for (int i = 0; i < [self.user.selectPartList count]; i++) {
                HYSmartInputModel *smartModel = [self.user.selectPartList objectAtIndex:i];
                line = i / 4;
                int modeline = i % 4;
                dispatch_group_async(group, queue, ^{
                    [self getPartHeadImg:smartModel.accountName];
                });
                HYPeopleInfoView *partPeople = [[HYPeopleInfoView alloc] initWithFrame:CGRectMake(10 + modeline * 50, 5 + line * 65, 45, 60)];
                partPeople.accountName = smartModel.accountName;
                [partHeadImgArray addObject:partPeople];
                partPeople.name = smartModel.name;
                partPeople.icon = [HYImageFactory GetImageByName:@"newtask_people" AndType:PNG];
                [taskPartBgView addSubview:[partPeople getViewWithWidth:45 iconHeight:45 nameWidth:45 nameHeight:15]];
                paticrpantString = [paticrpantString stringByAppendingString:smartModel.accountName];
                
                paticrpantNameString = [paticrpantNameString stringByAppendingString:smartModel.name];
                if(i != ([self.user.selectPartList count] -1))
                {
                    paticrpantString = [paticrpantString stringByAppendingString:@","];
                    paticrpantNameString = [paticrpantNameString stringByAppendingString:@","];
                }
            }
            self.user.paticrpantString = paticrpantString;
        }
        if(line < 1)
        {
            [taskPartBgView setFrame:CGRectMake(8, (taskPartLabel.frame.origin.y + taskPartLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 120)];
        }else
        {
            [taskPartBgView setFrame:CGRectMake(8, (taskPartLabel.frame.origin.y + taskPartLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), (70 * line + 70))];
        }
        self.user.paticrpantString = paticrpantString;
        model.paticrpantName = paticrpantNameString;
        model.paticrpant = paticrpantString;
        [taskPartBgView addSubview:delPartPeople];
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            for (int j = 0; j < [partHeadImgArray count]; j++) {
                HYPeopleInfoView *partPeopleView = [partHeadImgArray objectAtIndex:j];
                [partPeopleView setHeadImgUrlStr:[headImgDic objectForKey:partPeopleView.accountName]];
            }
        });
    }
    
//    if(self.user.excList != nil)
//    {
//        if(excList == nil)
//        {
//            excList = [[NSMutableArray alloc] init];
//        }
//        excList = self.user.excList;
//        paticrpantString = @"";
//        paticrpantNameString = @"";
//        for (UIImageView *oneView in taskPartBgView.subviews ) {
//            if ([oneView isKindOfClass:[UIView class]]) {
//                [oneView removeFromSuperview];
//            }
//        }
//        [taskPartBgView addSubview:addPartPeople];
//        int line = 0;
//        for (int i = 0; i < [self.user.partList count]; i++) {
//            HYSmartInputModel *smartModel = [self.user.partList objectAtIndex:i];
//            line = i / 4;
//            int modeline = i % 4;
//            HYPeopleInfoView *partPeople = [[HYPeopleInfoView alloc] initWithFrame:CGRectMake(10 + modeline * 50, 5 + line * 65, 45, 60)];
//            partPeople.name = smartModel.name;
//            partPeople.icon = [HYImageFactory GetImageByName:@"newtask_people" AndType:PNG];
//            [taskPartBgView addSubview:[partPeople getViewWithWidth:45 iconHeight:45 nameWidth:45 nameHeight:15]];
//            
//            
//            
//            paticrpantString = [paticrpantString stringByAppendingString:smartModel.accountName];
//            
//            paticrpantNameString = [paticrpantNameString stringByAppendingString:smartModel.name];
//            if(i != ([self.user.partList count] -1))
//            {
//                paticrpantString = [paticrpantString stringByAppendingString:@","];
//                paticrpantNameString = [paticrpantNameString stringByAppendingString:@","];
//            }
//        }
//        self.user.paticrpantString = paticrpantString;
//        [taskPartBgView setFrame:CGRectMake(8, (taskPartLabel.frame.origin.y + taskPartLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), (70 * line + 70))];
//        model.paticrpantName = paticrpantNameString;
//        model.paticrpant = paticrpantString;
//        return;
//    }
    

    
    
    //添加参与人
    if(model != nil)
    {
        if(![model.paticrpant isEqual:@""] && (self.user.partList == nil && self.user.selectPartList == nil))
        {
            for (UIImageView *oneView in taskPartBgView.subviews ) {
                if ([oneView isKindOfClass:[UIView class]]) {
                    [oneView removeFromSuperview];
                }
            }
            if(isEdit)
            {
                [taskPartBgView addSubview:addPartPeople];
            }
            partList = [model.paticrpant componentsSeparatedByString:@","];
            partNameList = [model.paticrpantName componentsSeparatedByString:@","];
            
            int partCount = 0;
            if([partList count] < [partNameList count])
            {
                partCount = [partList count];
            }else
            {
                partCount = [partNameList count];
            }
            int line = 0;
            for (int i = 0; i < partCount; i++) {
                line = i / 4;
                int modeline = i % 4;
                HYPeopleInfoView *partPeople = [[HYPeopleInfoView alloc] initWithFrame:CGRectMake(10 + modeline * 50, 5 + line * 65, 45, 60)];
                [partHeadImgArray addObject:partPeople];
                partPeople.accountName = [partList objectAtIndex:i];
                partPeople.name = [partNameList objectAtIndex:i];
                partPeople.icon = [HYImageFactory GetImageByName:@"newtask_people" AndType:PNG];
                dispatch_group_async(group, queue, ^{
                    [self getPartHeadImg:[partList objectAtIndex:i]];
                });
                [taskPartBgView addSubview:[partPeople getViewWithWidth:45 iconHeight:45 nameWidth:45 nameHeight:15]];
            }
            if(line < 1)
            {
                [taskPartBgView setFrame:CGRectMake(8, (taskPartLabel.frame.origin.y + taskPartLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 120)];
            }else
            {
                [taskPartBgView setFrame:CGRectMake(8, (taskPartLabel.frame.origin.y + taskPartLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), (70 * line + 70))];
            }
            if(!isEdit)
            {
                [taskPartBgView setFrame:CGRectMake(8, (taskPartLabel.frame.origin.y + taskPartLabel.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), (70 * line + 70))];
            }
            if(partCount != 0)
            {
                
                if(isEdit)
                {
                    [taskPartBgView addSubview:delPartPeople];
                }
            }
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                for (int j = 0; j < [partHeadImgArray count]; j++) {
                    HYPeopleInfoView *partPeopleView = [partHeadImgArray objectAtIndex:j];
                    [partPeopleView setHeadImgUrlStr:[headImgDic objectForKey:partPeopleView.accountName]];
                }
            });
            
        }
    }
    if(isEdit)
    {
        if(!self.user.isNew)
        {
            if(!isInformation)
            {
                [okButton removeFromSuperview];
                okButton = [HYControlFactory GetButtonWithCGRect:CGRectMake(8, (taskPartBgView.frame.origin.y + taskPartBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44) backgroundImg:@"newtask_ok" selectBackgroundImgName:@"newtask_ok_hover" addTarget:self action:@selector(_submitAction) forControlEvents:UIControlEventTouchUpInside];
                [okButton setTitle:OK_BUTTON_TEXT forState:UIControlStateNormal];
                [okButton.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:20]];
                [okButton.titleLabel setTextColor:[UIColor whiteColor]];
                [okButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
                [scrollView addSubview:okButton];
                [scrollView setContentSize:CGSizeMake([HYScreenTools getScreenWidth],okButton.frame.origin.y + okButton.frame.size.height + 10 )];
            }
        }
    }else
    {
        [scrollView setContentSize:CGSizeMake([HYScreenTools getScreenWidth],taskPartBgView.frame.origin.y + taskPartBgView.frame.size.height + 10 )];
    }
}

-(void)addPartPeopleAction:(UIGestureRecognizer *)gestureRecognizer
{
    returnFlag = YES;
    isPart = true;
    HYSmartInputViewController *smartInput = [[HYSmartInputViewController alloc] init];
    smartInput.isFirstManInput = NO;
    smartInput.isAddPartViewInput = NO;
    smartInput.isProxyInput = NO;
    smartInput.partList = nil;
    smartInput.excList = nil;
    smartInput.partList = [[NSMutableArray alloc] init];
    NSString *temppaticrpant = @"";
    NSString *temppaticrpantName = @"";
    temppaticrpant = paticrpantString;
    temppaticrpantName = paticrpantNameString;
    if(![temppaticrpant isEqual:@""])
    {
        NSArray *temppatArr = [temppaticrpant componentsSeparatedByString:@","];
        NSArray *temppatnameArr = [temppaticrpantName componentsSeparatedByString:@","];
        int partCount = 0;
        if([temppatArr count] < [temppatnameArr count])
        {
            partCount = [temppatArr count];
        }else
        {
            partCount = [temppatnameArr count];
        }
        for (int i = 0; i < partCount; i++) {
            HYSmartInputModel *tempSmartModel = [[HYSmartInputModel alloc] init];
            tempSmartModel.accountName = [temppatArr objectAtIndex:i];
            tempSmartModel.name = [temppatnameArr objectAtIndex:i];
            [smartInput.partList addObject:tempSmartModel];
        }
    }
    
    if(self.user == nil)
    {
        smartInput.user = [HYHelper getUser];
    }else
    {
        smartInput.user = self.user;
    }
    self.user.isAddPartViewList = nil;
    smartInput.title = @"智能输入";
    [[self getNavigationController] pushController:smartInput];
}

-(void)reverPartPeopleAction:(UIGestureRecognizer *)gestureRecognizer
{
    returnFlag = YES;
    for (int i = 0; i < [partHeadImgArray count]; i++) {
        HYPeopleInfoView *pepView = [partHeadImgArray objectAtIndex:i];
        [pepView removeDelView];
        [pepView getView].userInteractionEnabled = NO;
//        [[pepView getView] removeGestureRecognizer:delPartPeopleViewRecognizer];
    }
    [reverPartPeople removeFromSuperview];
    [taskPartBgView addSubview:addPartPeople];
    [taskPartBgView addSubview:delPartPeople];
}

-(void)reverFirstPeopleAction:(UIGestureRecognizer *)gestureRecognizer
{
    returnFlag = YES;
    [firstPepopleInfo removeDelView];
    [[firstPepopleInfo getView] removeGestureRecognizer:delPeopleViewRecognizer];
    [firstManBgView addSubview:[firstPepopleInfo getView]];
    [reverFirstPeople removeFromSuperview];
    [firstManBgView addSubview:delFirstPeople];
}

-(void)delPartPeopleAction:(UIGestureRecognizer *)gestureRecognizer
{
    returnFlag = YES;
//    [firstPepopleInfo addDelView];
    for (int i = 0; i < [partHeadImgArray count]; i++) {
        HYPeopleInfoView *pepView = [partHeadImgArray objectAtIndex:i];
        [pepView addDelView];
        [pepView getView].userInteractionEnabled = YES;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delPartPeopleActionView:)];
        [[pepView getView] addGestureRecognizer:tapRecognizer];
    }
    [delPartPeople removeFromSuperview];
    [taskPartBgView addSubview:reverPartPeople];
    [addPartPeople removeFromSuperview];
//    [firstManBgView addSubview:reverFirstPeople];
//    [[firstPepopleInfo getView] addGestureRecognizer:delPeopleViewRecognizer];
}



-(void)delFirstPeopleAction:(UIGestureRecognizer *)gestureRecognizer
{
    returnFlag = YES;
    [firstPepopleInfo addDelView];
    [delFirstPeople removeFromSuperview];
    [firstManBgView addSubview:reverFirstPeople];
    [[firstPepopleInfo getView] addGestureRecognizer:delPeopleViewRecognizer];
}

-(void)delPartPeopleActionView:(UIGestureRecognizer *)gestureRecognizer
{
    returnFlag = YES;
    HYPeopleInfoView *delCurrentPartView = (HYPeopleInfoView *)gestureRecognizer.view;
    [delCurrentPartView removeFromSuperview];
    for (int i = 0 ; i < [self.user.partList count]; i++) {
        HYSmartInputModel *smartModel = [self.user.partList objectAtIndex:i];
        if([smartModel.accountName isEqual:delCurrentPartView.accountName])
        {
            [self.user.partList removeObjectAtIndex:i];
            break;
        }
    }
    if(self.user.partList == nil)
    {
        int partCount = 0;
        if([partList count] < [partNameList count])
        {
            partCount = [partList count];
        }else
        {
            partCount = [partNameList count];
        }
        if(partCount > 1)
        {
            for (int i = 0; i < partCount; i++) {
                if([delCurrentPartView.accountName isEqual:[partList objectAtIndex:i]])
                {
                    [partList removeObjectAtIndex:i];
                    //                [partNameList removeObjectAtIndex:i];
                    break;
                }
            }
            for (int i = 0; i < partCount; i++) {
                if([delCurrentPartView.name isEqual:[partNameList objectAtIndex:i]])
                {
                    [partNameList removeObjectAtIndex:i];
                    //                [partNameList removeObjectAtIndex:i];
                    partCount = partCount - 1;
                    break;
                }
            }
        }else
        {
            partCount = 0;
        }
//        for (int i = 0; i < partCount; i++) {
//            if([delCurrentPartView.name isEqual:[partNameList objectAtIndex:i]])
//            {
//                [partNameList removeObjectAtIndex:i];
//                break;
//            }
//        }
        paticrpantString = @"";
        paticrpantNameString = @"";
        for (int i = 0; i < partCount; i++) {
            paticrpantString = [paticrpantString stringByAppendingString:[partList objectAtIndex:i]];
            
            paticrpantNameString = [paticrpantNameString stringByAppendingString:[partNameList objectAtIndex:i]];
            if(i != (partCount -1))
            {
                paticrpantString = [paticrpantString stringByAppendingString:@","];
                paticrpantNameString = [paticrpantNameString stringByAppendingString:@","];
            }
        }
        self.user.paticrpantString = paticrpantString;
        model.paticrpant = paticrpantString;
        model.paticrpantName = paticrpantNameString;
    }else
    {
        paticrpantString = @"";
        paticrpantNameString = @"";
        int count = [self.user.partList count];
        for (int i = 0; i < count; i++) {
            HYSmartInputModel *tempmodel = [self.user.partList objectAtIndex:i];
            paticrpantString = [paticrpantString stringByAppendingString:tempmodel.accountName];
            
            paticrpantNameString = [paticrpantNameString stringByAppendingString:tempmodel.name];
            if(i != (count -1))
            {
                paticrpantString = [paticrpantString stringByAppendingString:@","];
                paticrpantNameString = [paticrpantNameString stringByAppendingString:@","];
            }
        }
        self.user.paticrpantString = paticrpantString;
    }
    for (int i = 0; i < [partHeadImgArray count]; i++) {
        HYPeopleInfoView *pepView = [partHeadImgArray objectAtIndex:i];
        [pepView addDelView];
        [pepView getView].userInteractionEnabled = YES;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delPartPeopleActionView:)];
        [[pepView getView] addGestureRecognizer:tapRecognizer];
    }
    [delPartPeople removeFromSuperview];
    [taskPartBgView addSubview:reverPartPeople];
    [addPartPeople removeFromSuperview];
//    [self addPartPeopleView];
}

-(void)delFirstPeopleActionView:(UIGestureRecognizer *)gestureRecognizer
{
    executorString = @"";
    self.user.executorString = nil;
    [excList removeAllObjects];
    excList = nil;
    [[firstPepopleInfo getView] removeGestureRecognizer:delPeopleViewRecognizer];
    [[firstPepopleInfo getView] removeFromSuperview];
    [reverFirstPeople removeFromSuperview];
    firstPepopleInfo = nil;
    [firstManBgView addSubview:addFirstPeople];
}

-(void)addFirstPeopleAction:(UIGestureRecognizer *)gestureRecognizer
{
    returnFlag = YES;
    isPart = false;
    HYSmartInputViewController *smartInput = [[HYSmartInputViewController alloc] init];
//    smartInput.user = self.user;
    smartInput.partList = nil;
    smartInput.excList = nil;
    smartInput.isFirstManInput = YES;
    smartInput.isAddPartViewInput = NO;
    smartInput.excList = [[NSMutableArray alloc] init];
    for (int i = 0; i < [excList count]; i++) {
        [smartInput.excList addObject:[excList objectAtIndex:i]];
    }
//    smartInput.excList = excList;
    if(self.user == nil)
    {
        self.user = [HYHelper getUser];
    }else
    {
        smartInput.user = self.user;
    }
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
    returnFlag = YES;
    alertViewpicker = [[UIAlertView alloc] initWithTitle:@"请选择汇报周期" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(10 ,0,200,80)];
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
    returnFlag = YES;
    alertViewDatePicker = [[UIAlertView alloc] initWithTitle:@"请选择时间" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
     datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(10 ,0,200 ,80)];
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
            //NSLog(@"点击了确定按钮");
            NSDate *selectDate = [datePicker date];
            NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
            selectDateFormatter.dateFormat = @"yyyy-MM-dd";
            NSString *dateString = [selectDateFormatter stringFromDate:selectDate];
            [endTimeLabel setText:[END_TIME_LABEL stringByAppendingString:dateString]];
            self.user.endTimeString = dateString;
            endTimeString = dateString;
        }
        else {
            //NSLog(@"点击了取消按钮");
        }
    }
    if(alertView == alertViewpicker)
    {
        if (buttonIndex == 0) {
            //NSLog(@"点击了确定按钮");
            if(!pickerFlag)
            {
                days = @"1";
            }
            NSString *cycleString = TASK_CYCLE;
            cycleString = [cycleString stringByAppendingString:@"       "];
            cycleString = [cycleString stringByAppendingString:days];
            cycleString = [cycleString stringByAppendingString:@"    天"];
            [taskCycleLabel setText:cycleString];
        }
        else {
            if(!pickerFlag)
            {
                days = @"0";
            }
        }
    }
    if(alertView == backAlert)
    {
        if (buttonIndex == 0) {
            //NSLog(@"点击了确定按钮");
            model.paticrpantName = modelPartNames;
            model.paticrpant = modelParts;
            [[self getNavigationController] popController:self];
        }
        else {
            //NSLog(@"点击了取消按钮");
        }
    }
}



-(void)clickShowAndHide:(UIGestureRecognizer *)gestureRecognizer
{
    if(isUp)
    {
        self.user.isNew = NO;
        [self clickShow];
        
    }else
    {
        self.user.isNew = YES;
        [self clickHide];
    }
}

-(void)_submitAction
{
    NSString *opetype = @"";
    if(model == nil)
    {
//        endTimeString = model.endTime;
        if(self.user.endTimeString == nil)
        {
            endTimeString = @"";
        }else
        {
            endTimeString = self.user.endTimeString;
        }
        if(self.user.executorString == nil)
        {
            executorString = @"";
        }else
        {
            executorString = self.user.executorString;
        }
        if(self.user.paticrpantString == nil)
        {
            paticrpantString = @"";
        }else
        {
            paticrpantString = self.user.paticrpantString;
        }
        opetype = @"AddTask";
        [SVProgressHUD showWithStatus:@"正在提交任务..." maskType:SVProgressHUDMaskTypeGradient];
    }else
    {
        if(self.user.endTimeString == nil)
        {
            endTimeString = model.endTime;
        }else
        {
            endTimeString = self.user.endTimeString;
        }
        if(self.user.executorString == nil)
        {
            executorString = @"";
        }else
        {
            executorString = self.user.executorString;
        }
        if(self.user.paticrpantString == nil)
        {
            paticrpantString = model.paticrpant;
        }else
        {
            paticrpantString = self.user.paticrpantString;
        }
        
        
        if(isForwarding == YES)
        {
            opetype = @"AddTask";
            [SVProgressHUD showWithStatus:@"正在提交任务..." maskType:SVProgressHUDMaskTypeGradient];
        }else
        {
            opetype = @"EditTask";
            [SVProgressHUD showWithStatus:@"正在更新任务..." maskType:SVProgressHUDMaskTypeGradient];
        }
    }
    
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
    NSString *initiatorName = @"";
    if(self.user.helpModel != nil)
    {
        initiatorName = self.user.helpModel.proxy;
    }else
    {
        initiatorName = self.user.accountName;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.user.token,@"Token",opetype,@"opeType",taskNameText.text,@"Name",initiatorName,@"Initiator",taskContentText.text,@"Description",taskTargetTextField.text,@"Goal",taskResultTextField.text,@"Product",endTimeString,@"EndTime",executorString,@"Executor",paticrpantString,@"Paticrpant",self.user.accountName,@"AccountName",@"200",@"TaskStatus",days,@"Days",nil];
    
    if([opetype isEqual:@"EditTask"])
    {
        //NSLog(@"EditTask HYNewTaskViewController Initiator = %@ Paticrpant = %@ executorString = %@", [params objectForKey:@"Initiator"],[params objectForKey:@"Paticrpant"], [params objectForKey:@"executorString"]);
    }
    if(model != nil && isForwarding == NO)
    {
        [params setObject:model.ID forKey:@"TaskID"];
    }else
    {
    }
    
    NSURL *url = [[NSURL alloc] initWithString:TaskHandler_api];
    [[[DataProcessing alloc] init] sentRequest:url Parem:params Target:self];
    
}

#pragma mark -
#pragma mark DataProcesse
-(void) endFailedRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    //NSLog(@"msg = %@", msg);
    [SVProgressHUD showErrorWithStatus:msg];
    return;
}

-(void) endRequest:(NSString *)msg
{
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
            
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"提交失败!"];
            return;
        }
        NSDictionary *content = [contents objectAtIndex:0];
        result = [content objectForKey:@"result"];
        if([result boolValue])
        {
            
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"提交成功!"];
            [[self getNavigationController] popController:self];
        }else
        {
            
            [SVProgressHUD dismiss];
            NSString *erroMsg = [content objectForKey:@"message"];
            [SVProgressHUD showErrorWithStatus:erroMsg];
        }
    }else
    {
        
        [SVProgressHUD dismiss];
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
    taskPartBgView = [showControlList lastObject];
    okButton = [HYControlFactory GetButtonWithCGRect:CGRectMake(8, (taskPartBgView.frame.origin.y + taskPartBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44) backgroundImg:@"newtask_ok" selectBackgroundImgName:@"newtask_ok_hover" addTarget:self action:@selector(_submitAction) forControlEvents:UIControlEventTouchUpInside];
    [okButton setTitle:OK_BUTTON_TEXT forState:UIControlStateNormal];
    [okButton.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:20]];
    [okButton.titleLabel setTextColor:[UIColor whiteColor]];
    [okButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    scrollView.bounces = NO;
    scrollView.userInteractionEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    if(model == nil || isForwarding == YES || isEdit == YES)
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
    if(model == nil || isForwarding == YES)
    {
        [scrollView addSubview:okButton];
    }else
    {
        if(isEdit == YES)
        {
            [scrollView addSubview:okButton];
        }
    }
    [scrollView setContentSize:CGSizeMake([HYScreenTools getScreenWidth],[HYScreenTools getScreenHeight] - [HYScreenTools getStatusHeight] - [[self getNavigationController] getNavigationHeight])];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    delPeopleViewRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delFirstPeopleActionView:)];
    
    delPartPeopleViewRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delPartPeopleActionView:)];
    
    [super viewWillAppear:animated];
    [[[self getNavigationController] getView] setHidden:NO];
    [[[self getTabbarController] getView] setHidden:YES];
    [[self getNavigationController] setCenterTittle:[self title]];
    [[self getNavigationController] setLeftButtonImage:[HYImageFactory GetImageByName:@"leftButton" AndType:PNG]];
    
    if(model != nil && isForwarding == NO && (isEdit == NO || isEdit == YES))
    {
        self.user.endTimeString = model.endTime;
        endTimeString = model.endTime;
        executorString  = model.executor;
        days = model.days;
        paticrpantString = model.paticrpant;
        paticrpantNameString = model.paticrpantName;
        [[self getNavigationController] setLeftTittle:model.name];
    }else
    {
        endTimeString = model.endTime;
        executorString  = model.executor;
        if(isForwarding)
        {
            executorString = @"";
        }
        days = model.days;
        paticrpantString = model.paticrpant;
        paticrpantNameString = model.paticrpantName;
        if(isForwarding == YES)
        {
            [[self getNavigationController] setLeftTittle:@"复制任务"];
        }else
        {
            [[self getNavigationController] setLeftTittle:NEW_TASK];
        }
    }
    [[self getNavigationController] setLeftTittleFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [[self getNavigationController] setLeftTittleColor:[UIColor whiteColor]];
    
    [[self getNavigationController] hideRightButton];
    [[self getNavigationController] showLeftButton];
    [[self getNavigationController] showLeftTittle];
    
    if([self.user.partList count] != 0)
    {
        if(isPart)
        {
            [okButton removeFromSuperview];
            okButton = [HYControlFactory GetButtonWithCGRect:CGRectMake(8, (taskPartBgView.frame.origin.y + taskPartBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44) backgroundImg:@"newtask_ok" selectBackgroundImgName:@"newtask_ok_hover" addTarget:self action:@selector(_submitAction) forControlEvents:UIControlEventTouchUpInside];
            [okButton setTitle:OK_BUTTON_TEXT forState:UIControlStateNormal];
            [okButton.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:20]];
            [okButton.titleLabel setTextColor:[UIColor whiteColor]];
            [okButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
            
            [scrollView setContentSize:CGSizeMake([HYScreenTools getScreenWidth],okButton.frame.origin.y + okButton.frame.size.height + 10 )];
            [scrollView addSubview:okButton];
        }
    }
    
    if([self.user.excList count] != 0 && !isPart)
    {
        HYSmartInputModel *smartModel = [self.user.excList objectAtIndex:0];
        if(firstPepopleInfo == nil)
        {
            firstPepopleInfo = [[HYPeopleInfoView alloc] initWithFrame:CGRectMake(taskNameText.frame.origin.x, 5, 35, 50)];
            firstPepopleInfo.icon = [HYImageFactory GetImageByName:@"newtask_people" AndType:PNG];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self getFirstHeadImg:smartModel.accountName];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if(firstHeadImgUrlStr != nil)
                    {
                        [firstPepopleInfo setHeadImgUrlStr:firstHeadImgUrlStr];
                    }
                });
            });
            firstPepopleInfo.name = smartModel.name;
            [firstManBgView addSubview:[firstPepopleInfo getViewWithWidth:35 iconHeight:35 nameWidth:35 nameHeight:15]];
        }
        self.user.executorString = smartModel.accountName;
        executorString = smartModel.accountName;
        if(excList == nil)
        {
            excList = [[NSMutableArray alloc] init];
            excList = self.user.excList;
        }
    }
    
    if(model != nil)
    {
        if(isPart)
        {
            
            [okButton removeFromSuperview];
            okButton = [HYControlFactory GetButtonWithCGRect:CGRectMake(8, (taskPartBgView.frame.origin.y + taskPartBgView.frame.size.height + 8), ([HYScreenTools getScreenWidth] - 16), 44) backgroundImg:@"newtask_ok" selectBackgroundImgName:@"newtask_ok_hover" addTarget:self action:@selector(_submitAction) forControlEvents:UIControlEventTouchUpInside];
            [okButton setTitle:OK_BUTTON_TEXT forState:UIControlStateNormal];
            [okButton.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:20]];
            [okButton.titleLabel setTextColor:[UIColor whiteColor]];
            [okButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
            
            [scrollView setContentSize:CGSizeMake([HYScreenTools getScreenWidth],okButton.frame.origin.y + okButton.frame.size.height + 10 )];
            [scrollView addSubview:okButton];
        }
//        [self addPartPeopleView];
        if(isEdit == NO)
        {
            taskNameText.userInteractionEnabled = NO;
            taskTargetTextField.editable = NO;
//            taskTargetTextField.userInteractionEnabled = NO;
            taskContentText.editable = NO;
            taskResultTextField.editable = NO;
            endTimeLabel.userInteractionEnabled = NO;
            endTimeRightView.userInteractionEnabled = NO;
            endTimeBgView.userInteractionEnabled = NO;
            
            taskCycleLabel.userInteractionEnabled = NO;
            taskCycleRightView.userInteractionEnabled = NO;
            taskCycleBgView.userInteractionEnabled = NO;
            
            [addPartPeople removeFromSuperview];
            [endTimeRightView removeFromSuperview];
            [taskCycleRightView removeFromSuperview];
            [okButton removeFromSuperview];
            [addFirstPeople removeFromSuperview];
//            [endTimeRightView addGestureRecognizer:nil];
//            [addFirstPeople removeFromSuperview];
        }else
        {
            
            if (firstPepopleInfo != nil)
            {
                [addFirstPeople removeFromSuperview];
                [firstManBgView addSubview:delFirstPeople];
            }
        }
    }else
    {
        if (firstPepopleInfo != nil)
        {
            [addFirstPeople removeFromSuperview];
            [firstManBgView addSubview:delFirstPeople];
        }
    }
    
    if((self.user.isNew || self.isInformation) && self.user.partList == nil)
    {
        [self clickHide];
        isUp = YES;
    }else
    {
        [self clickShow];
        isUp = NO;
    }
    [self addPartPeopleView];
    [self loadHeadImgs];
    
    if(!isForwarding && model != nil)
    {
        if(self.user.executorString == nil)
        {
            self.user.executorString = model.executor;
        }
    }
    
}

-(void)loadHeadImgs
{
    if(self.user.isNew)
    {
        if(self.user.helpModel != nil)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self getStartHeadImg:self.user.helpModel.proxy];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if(startHeadImgUrlStr != nil)
                    {
                        [pepopleInfo setHeadImgUrlStr:startHeadImgUrlStr];
                    }
                });
            });
        }else
        {
            [pepopleInfo setHeadImgUrlStr:self.user.headImg];
        }
    }else
    {
        if(model != nil)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if(isForwarding)
                {
                    [self getStartHeadImg:self.user.accountName];
                }else
                {
                    [self getStartHeadImg:model.initiator];
                }
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if(startHeadImgUrlStr != nil)
                    {
                        [pepopleInfo setHeadImgUrlStr:startHeadImgUrlStr];
                    }
                });
            });
        }
    }
}


-(void)bindAction
{
    [[self getNavigationController] setLeftButtonTarget:nil action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)backAction:(id)sender
{
//    if(model == nil && isEdit == YES && isForwarding == NO)
//    {
//        backAlert = [[UIAlertView alloc] initWithTitle:@"你是否要确认退出新建任务" message:@"退出新建任务会造成当前任务数据丢失" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
//    }
    if(isEdit)
    {
        if(returnFlag)
        {
            backAlert = [[UIAlertView alloc] initWithTitle:@"你是否要确认退出此任务" message:@"当前任务修改数据还未保存" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
            [backAlert show];
        }else
        {
            [[self getNavigationController] popController:self];
        }
    }else
    {
        [[self getNavigationController] popController:self];
    }
}


#pragma alert


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
    //NSLog(@"");
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
