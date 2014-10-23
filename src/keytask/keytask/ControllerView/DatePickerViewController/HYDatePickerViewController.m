//
//  HYDatePickerViewController.m
//  keytask
//
//  Created by 许 玮 on 14-10-22.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYDatePickerViewController.h"
#import "HYScreenTools.h"
#import "HYControlFactory.h"

@interface HYDatePickerViewController ()
{
    NSString *dateString;
}

@end

@implementation HYDatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initDatePicker
{
    //[self.view setFrame:CGRectMake(50, 120 , [HYScreenTools getScreenWidth] - 100, 300)];
    [self.view setFrame:CGRectMake(45, 115, [HYScreenTools getScreenWidth] - 90, 320)];
    UIImageView *imgBgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(50, 120, self.view.frame.size.width - 100 , 300) backgroundImgName:nil backgroundColor:[UIColor clearColor] isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    NSLog(@"self.view = %f" ,self.view.frame.size.width);
    [self.view addSubview:imgBgView];
    
    UIDatePicker *datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0 ,20,imgBgView.frame.size.width,imgBgView.frame.size.height - 20)];
    [imgBgView addSubview:datePicker];
    
    
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
