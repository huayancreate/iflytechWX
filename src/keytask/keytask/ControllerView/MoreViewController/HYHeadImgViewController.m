//
//  HYHeadImgViewController.m
//  keytask
//
//  Created by 许 玮 on 14-10-23.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYHeadImgViewController.h"
#import "HYImageFactory.h"
#import "HYConstants.h"
#import "HYControlFactory.h"
#import "HYScreenTools.h"
#import "SDImageView+SDWebCache.h"
#import "HYNetworkInterface.h"
#import "HYHelper.h"

@interface HYHeadImgViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *headImg;
    UIImagePickerController *camera;
    NSString *showMsg;
    NSTimer *connectionTimer;
}

@end

@implementation HYHeadImgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self bindAction];
    [self initControl];
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
    [[self getNavigationController] setLeftButtonImage:[HYImageFactory GetImageByName:@"leftButton" AndType:PNG]];
    [[self getNavigationController] setLeftTittle:@"头像设置"];
    [[self getNavigationController] setLeftTittleFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [[self getNavigationController] setLeftTittleColor:[UIColor whiteColor]];
    
    [[self getNavigationController] hideRightButton];
    [[self getNavigationController] showLeftButton];
    [[self getNavigationController] showLeftTittle];
    
    [self getHeadImg];
}

-(void)initControl
{
    UIImageView *bgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(0, ([HYScreenTools getStatusHeight] + [[self getNavigationController] getNavigationHeight]), [HYScreenTools getScreenWidth], ([HYScreenTools getScreenHeight] - [HYScreenTools getStatusHeight]- [[self getNavigationController] getNavigationHeight])) backgroundImgName:nil backgroundColor:[UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1.0f] isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    [self.view addSubview:bgView];
    
    headImg = [HYControlFactory GetImgViewWithCGRect:CGRectMake(40, 10, [HYScreenTools getScreenWidth] - 80, [HYScreenTools getScreenWidth] - 80) backgroundImgName:@"newtask_people" backgroundColor:nil isCornerRadius:NO closeKeyboard:NO isFrame:NO];
    
    NSURL *url = nil;
    if(self.user.headImg != nil)
    {
        url = [[NSURL alloc] initWithString:self.user.headImg];
    }
    
    [headImg setImageWithURL:url refreshCache:NO placeholderImage:[HYImageFactory GetImageByName:@"newtask_people" AndType:PNG]];
    
    [bgView addSubview:headImg];
    
    
    //按钮
    UIButton *photoBtn = [HYControlFactory GetButtonWithCGRect:CGRectMake(40, headImg.frame.origin.y + headImg.frame.size.height + 10, 100, 44) backgroundImg:@"newtask_ok" selectBackgroundImgName:@"newtask_ok_hover" addTarget:self action:@selector(photoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [photoBtn setTitle:@"图   库" forState:UIControlStateNormal];
    [photoBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [photoBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [photoBtn.titleLabel setFont:[UIFont fontWithName:FONT size:18]];
    UIButton *cameraBtn = [HYControlFactory GetButtonWithCGRect:CGRectMake([HYScreenTools getScreenWidth] - 140 , headImg.frame.origin.y + headImg.frame.size.height + 10, 100, 44) backgroundImg:@"newtask_ok" selectBackgroundImgName:@"newtask_ok_hover" addTarget:self action:@selector(cameraBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cameraBtn setTitle:@"拍   照" forState:UIControlStateNormal];
    [cameraBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [cameraBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [cameraBtn.titleLabel setFont:[UIFont fontWithName:FONT size:18]];
    [bgView addSubview:photoBtn];
    [bgView addSubview:cameraBtn];
    
    
}

- (void)photoBtnAction:(id)sender {
    [connectionTimer invalidate];
    connectionTimer = nil;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)cameraBtnAction:(id)sender {
    [connectionTimer invalidate];
    connectionTimer = nil;
    camera = [[UIImagePickerController alloc] init];
    camera.delegate = self;
    camera.allowsEditing = NO;
    
    //检查摄像头是否支持摄像机模式
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        camera.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        //NSLog(@"Camera not exist");
        return;
    }
    [self presentViewController:camera animated:YES completion:nil];
    
}


- (void) imagePickerController: (UIImagePickerController*) picker
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    
    //获得编辑过的图片
    UIImage* image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    
    //NSLog(@"ASKJDKASDJK %.2f,%.2f",image.size.width,image.size.height);
    [headImg setImage:image];
    
    float width = 540.00;
    float height = 960.00;
    if(image.size.width > image.size.height)
    {
        width = 960.00;
        height = ((image.size.height) / (image.size.width) * 960);
    }else
    {
        height = 960.00;
        //NSLog(@"asdjas %.2f,%.2f",image.size.width,image.size.height);
        width = ((image.size.width) / (image.size.height) * 960);
    }
    
    
    
    UIImage *bigImage = [self imageWithImage:image scaledToSize:CGSizeMake(width, height)];
    
    [self saveImage:bigImage WithName:@"big_headImg.jpg"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendImgFile:(NSString *)fullPathfile
{
    [SVProgressHUD showWithStatus:@"正在上传头像..." maskType:SVProgressHUDMaskTypeGradient];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.token,@"Token",self.user.accountName,@"AccountName",nil];
    
    NSURL *url = [[NSURL alloc] initWithString:HeadUpImg_api];
    NSMutableDictionary *files = [[NSMutableDictionary alloc] init];
    [files setValue:fullPathfile forKey:@"file"];
    
    [[[DataProcessing alloc] init] sentRequest:url Parem:params Files:files Target:self];
    
//    [[[DataProcessing alloc] init] sentRequest:url Parem:params Target:self];
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
    //NSLog(@"msg = %@", msg);
    NSError *error;
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSString *result = [json objectForKey:@"Success"];
    if([result boolValue])
    {
        NSArray *contents = [json objectForKey:@"Content"];
        if([contents count] <= 0)
        {
            [SVProgressHUD dismiss];
            return;
        }
        NSDictionary *content = [contents objectAtIndex:0];
        showMsg = [content objectForKey:@"message"];
        if([[content objectForKey:@"result"] boolValue])
        {
            [self getHeadImg];
        }else
        {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:showMsg];
        }
//        [SVProgressHUD showSuccessWithStatus:];
    }
}

-(void)getHeadImg
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.accountName,@"AccountName",self.user.token,@"Token",@"GetHeadImg",@"opeType",nil];
    
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
    [request setDidFinishSelector:@selector(endGetHeadImgFin:)];
    [request setDidFailSelector:@selector(endGetHeadImgFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [connectionTimer invalidate];
    connectionTimer = nil;
}

- (void) endGetHeadImgFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetHeadImgString:) withObject:responsestring waitUntilDone:YES];
}

- (void) endGetHeadImgFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器链接失败";
    ////NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGetHeadImgStringFail:) withObject:responsestring waitUntilDone:YES];
}

-(void)endGetHeadImgStringFail:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"服务器连接失败,请检查网络!"];
    //    [self logoutAction];
}

-(void)endGetHeadImgString:(NSString *)msg
{
    [SVProgressHUD dismiss];
    NSError *error;
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [json objectForKey:@"Success"];
    if([result boolValue])
    {
        NSArray *contents = [json objectForKey:@"Content"];
        if([contents count] <= 0)
        {
//            [self checkVersion];
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
        NSURL *headu = [[NSURL alloc] initWithString:headImgUrl];
        [headImg setImageWithURL:headu refreshCache:NO placeholderImage:[HYImageFactory GetImageByName:@"newtask_people" AndType:PNG]];
        self.user = [HYHelper getUser];
        self.user.headImg = headImgUrl;
        self.user.lastTimeHeadImg = [content objectForKey:@"LastTime"];
        
//        [SVProgressHUD showSuccessWithStatus:showMsg];
//        [self checkVersion];
    }else
    {
        [super logoutAction];
    }
}



//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage, 0.5f);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    
    
    [self sendImgFile:fullPathToFile];
}

- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
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
