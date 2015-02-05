//
//  ChartCell.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import "ChartCell.h"
#import "ChartContentView.h"
#import "HYConstants.h"#
#import "SDImageView+SDWebCache.h"
#import "HYImageFactory.h"
#import "DataProcessing.h"
#import "HYNetworkInterface.h"
#import "AudioStreamer.h"
#import "XHImageViewer.h"
#import "UIImageView+XHURLDownload.h"
#import "HYControlFactory.h"
#import "HYHelper.h"
#import "HYWebViewController.h"

@interface ChartCell()<ChartContentViewDelegate,XHImageViewerDelegate>
{
    AudioStreamer *streamer;
    UIImageView *showImg;
    NSMutableArray *_imageViews;
    NSString *startHeadImgUrlStr;
    NSTimer *mp3Timer;
    int mp3Type;
}
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *createtimeLabel;
@property (nonatomic, strong) UILabel *iconLabel;
@property (nonatomic,strong) ChartContentView *chartView;
@property (nonatomic,strong) ChartContentView *currentChartView;
@property (nonatomic,strong) NSString *contentStr;
@end

@implementation ChartCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        startHeadImgUrlStr = @"";
        self.backgroundColor = [UIColor clearColor];
        self.createtimeLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width /2) - 45, 5, 90, 10)];
//        [self.createtimeLabel setText:@"2014-09-17 12:00:00"];
        [self.createtimeLabel setFont:[UIFont fontWithName:FONT size:8]];
        [self.createtimeLabel setTextColor:[UIColor lightGrayColor]];
        [self.createtimeLabel setTextAlignment:NSTextAlignmentCenter];
        self.icon=[[UIImageView alloc]init];
        self.iconLabel=[[UILabel alloc]init];
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.iconLabel];
        self.chartView =[[ChartContentView alloc]initWithFrame:CGRectZero];
        self.chartView.delegate=self;
        [self.contentView addSubview:self.chartView];
        [self.contentView addSubview:self.createtimeLabel];
//        showImg = [[UIImageView alloc] initWithFrame:CGRectMake(160, 150, 160, 50)];
        _imageViews = [[NSMutableArray alloc] init];
        mp3Type = 0;
    }
    return self;
}

-(void)setCellFrame:(ChartCellFrame *)cellFrame
{
   
    _cellFrame=cellFrame;
    
    ChartMessage *chartMessage=cellFrame.chartMessage;
    
    self.icon.frame= cellFrame.iconRect;
    self.iconLabel.frame = cellFrame.iconLabelRect;
    if(chartMessage.messageType == messageSys)
    {
        self.icon.image = [UIImage imageNamed:chartMessage.icon];
    }else
    {
        self.icon.image = [UIImage imageNamed:chartMessage.icon];
        if(![chartMessage.iconAccountName isEqual:@""])
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self getStartHeadImg:chartMessage.iconAccountName];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSURL *urlString = [[NSURL alloc] initWithString:startHeadImgUrlStr];
                    [self.icon setImageWithURL:urlString refreshCache:NO placeholderImage:[HYImageFactory GetImageByName:@"newtask_people" AndType:PNG]];
                    
                });
            });
        }else
        {
            //NSLog(@"chartMessage.icon = %@" ,chartMessage.icon);
            NSURL *iconUrl = [[NSURL alloc] initWithString:chartMessage.icon];
            //NSLog(@"nsurl = %@" ,iconUrl);
            [self.icon setImageWithURL:iconUrl refreshCache:NO placeholderImage:[HYImageFactory GetImageByName:@"newtask_people" AndType:PNG]];
        }
    }
    [self.iconLabel setText:chartMessage.iconLabelText];
    [self.iconLabel setTextAlignment:NSTextAlignmentCenter];
    [self.iconLabel setFont:[UIFont fontWithName:FONT size:10]];
   
    self.chartView.chartMessage=chartMessage;
    self.chartView.frame=cellFrame.chartViewRect;
    [self setBackGroundImageViewImage:self.chartView from:@"chatto_bg_normal_from" to:@"chatto_bg_normal.png" sys:@"chatfrom_bg_normal.png"];
    if(![self.chartView.chartMessage.content isEqual:@""])
    {
        if(self.chartView.chartMessage.fileModel != nil)
        {
            //NSLog(@"chartMessage.fileModel.type = %@", chartMessage.fileModel.type);
            if(![chartMessage.fileModel.type isEqual:@"mp3"] && !([chartMessage.fileModel.type isEqual:@"jpg"] || [chartMessage.fileModel.type isEqual:@"bmp"] || [chartMessage.fileModel.type isEqual:@"gif"] || [chartMessage.fileModel.type isEqual:@"jpeg"] || [chartMessage.fileModel.type isEqual:@"png"]))
            {
                NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:chartMessage.content];
                NSRange contentRange = {0,[content length]};
                [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
//                self.chartView.contentLabel.numberOfLines = 3;
                self.chartView.contentLabel.attributedText = content;
                [self.chartView.contentLabel setTextColor:[UIColor blueColor]];
            }
        }else
        {
            self.chartView.contentLabel.text=chartMessage.content;
        }
    }
    [self.createtimeLabel setText:chartMessage.time];
    
}

-(void)getStartHeadImg:(NSString *)accountName
{
    HYUserLoginModel *userModel = [HYHelper getUser];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:userModel.accountName,@"AccountName",userModel.token,@"Token",@"GetHeadImg",@"opeType",accountName,@"UserAccount",nil];
    
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
//    request setCompletionBlock:<#^(void)aCompletionBlock#>
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


-(void)setBackGroundImageViewImage:(ChartContentView *)chartView from:(NSString *)from to:(NSString *)to sys:(NSString *)sys
{
    UIImage *normal=nil ;
    
    if(chartView.chartMessage.messageType == messageSys)
    {
        normal = [UIImage imageNamed:sys];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
    }else if(chartView.chartMessage.messageType == messageFrom){
        
        normal = [UIImage imageNamed:from];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        
    }else if(chartView.chartMessage.messageType==messageTo){
        
        normal = [UIImage imageNamed:to];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
    }
    if(chartView.chartMessage.messageType == messageSys)
    {
        chartView.backImageView.image=normal;
    }else
    {
        if(chartView.chartMessage.fileModel == nil)
        {
            chartView.backImageView.image=normal;
        }else
        {
            //NSLog(@"chartMessage.fileModel.type = %@", chartView.chartMessage.fileModel.type);
            if([chartView.chartMessage.fileModel.type isEqual:@"mp3"])
            {
                if(chartView.chartMessage.messageType == messageFrom)
                {
                    normal = [UIImage imageNamed:@"chatto_yuyin_left"];
                    normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 1.0 topCapHeight:normal.size.height * 0.7];
                }
                if(chartView.chartMessage.messageType == messageTo)
                {
                    normal = [UIImage imageNamed:@"chatto_yuyin_right"];
                    normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 1.0 topCapHeight:normal.size.height * 0.7];
                }
            }
            if([chartView.chartMessage.fileModel.type isEqual:@"jpg"] || [chartView.chartMessage.fileModel.type isEqual:@"bmp"] || [chartView.chartMessage.fileModel.type isEqual:@"gif"] || [chartView.chartMessage.fileModel.type isEqual:@"jpeg"] || [chartView.chartMessage.fileModel.type isEqual:@"png"])
            {
                if(chartView.chartMessage.messageType == messageFrom)
                {
                    normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 1.0 topCapHeight:normal.size.height * 0.7];
                    
                    chartView.backImageView.image=normal;
                    UIImageView *jpgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(16, 2, chartView.frame.size.width - 25, chartView.frame.size.height - 10) backgroundImgName:nil backgroundColor:[UIColor clearColor] isCornerRadius:NO closeKeyboard:NO isFrame:NO];
                    NSString *imgString = @"";
                    NSArray *imgArr = nil;
                    imgArr = [chartView.chartMessage.fileModel.path componentsSeparatedByString:@"\\"];
                    if([imgArr count] != 2)
                    {
                        imgArr = [chartView.chartMessage.fileModel.path componentsSeparatedByString:@"//"];
                    }
                    if(imgArr != nil)
                    {
                        imgString = [imgString stringByAppendingString:Mp3_api];
                        imgString = [imgString stringByAppendingString:[imgArr objectAtIndex:0]];
                        imgString = [imgString stringByAppendingString:@"/"];
                        imgString = [imgString stringByAppendingString:[imgArr objectAtIndex:1]];
                    }
                    NSURL *imgURL = [[NSURL alloc] initWithString:imgString];
                    [jpgView loadWithURL:imgURL placeholer:[UIImage imageNamed:@"newtask_people"] showActivityIndicatorView:YES];
                    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
                    [jpgView addGestureRecognizer:gesture];
                    [_imageViews addObject:jpgView];
                    [chartView addSubview:jpgView];
                }
                if(chartView.chartMessage.messageType == messageTo)
                {
                    normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 1.0 topCapHeight:normal.size.height * 0.7];
                    
                    chartView.backImageView.image=normal;
                    UIImageView *jpgView = [HYControlFactory GetImgViewWithCGRect:CGRectMake(8, 2, chartView.frame.size.width - 25, chartView.frame.size.height - 10) backgroundImgName:nil backgroundColor:[UIColor clearColor] isCornerRadius:NO closeKeyboard:NO isFrame:NO];
                    NSString *imgString = @"";
                    NSArray *imgArr = nil;
                    imgArr = [chartView.chartMessage.fileModel.path componentsSeparatedByString:@"\\"];
                    if([imgArr count] != 2)
                    {
                        imgArr = [chartView.chartMessage.fileModel.path componentsSeparatedByString:@"//"];
                    }
                    if(imgArr != nil)
                    {
                        imgString = [imgString stringByAppendingString:Mp3_api];
                        imgString = [imgString stringByAppendingString:[imgArr objectAtIndex:0]];
                        imgString = [imgString stringByAppendingString:@"/"];
                        imgString = [imgString stringByAppendingString:[imgArr objectAtIndex:1]];
                    }
                    NSURL *imgURL = [[NSURL alloc] initWithString:imgString];
                    [jpgView loadWithURL:imgURL placeholer:[UIImage imageNamed:@"newtask_people"] showActivityIndicatorView:YES];
                    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
                    [jpgView addGestureRecognizer:gesture];
                    [_imageViews addObject:jpgView];
                    [chartView addSubview:jpgView];
                }
            }
        }
    }
    chartView.backImageView.image=normal;
}

- (void)tapHandle:(UITapGestureRecognizer *)tap {
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:_imageViews selectedView:(UIImageView *)tap.view];
}

-(void)chartContentViewLongPress:(ChartContentView *)chartView content:(NSString *)content
{
    [self becomeFirstResponder];
    UIMenuController *menu=[UIMenuController sharedMenuController];
    [menu setTargetRect:self.bounds inView:self];
    [menu setMenuVisible:YES animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuShow:) name:UIMenuControllerWillShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuHide:) name:UIMenuControllerWillHideMenuNotification object:nil];
    self.contentStr=content;
    self.currentChartView=chartView;
}

-(void)chartContentViewTapPress:(ChartContentView *)chartView content:(NSString *)content
{
//    [self.delegate chartCell:self tapContent:content];
    if(chartView.chartMessage.fileModel != nil)
    {
        //NSLog(@"chartView.chartMessage.fileModel.type = %@", chartView.chartMessage.fileModel.type);
        if([chartView.chartMessage.fileModel.type isEqual:@"mp3"])
        {
            [self startOnlineMp3:chartView.chartMessage.fileModel.path];
        }else if([chartView.chartMessage.fileModel.type isEqual:@"jpg"] || [chartView.chartMessage.fileModel.type isEqual:@"bmp"] || [chartView.chartMessage.fileModel.type isEqual:@"gif"] || [chartView.chartMessage.fileModel.type isEqual:@"jpeg"] || [chartView.chartMessage.fileModel.type isEqual:@"png"])
        {
            
        }else
        {
            HYWebViewController *webView = [[HYWebViewController alloc] init];
            webView.title = chartView.chartMessage.content;
            NSString *streamerURL = @"";
            NSArray *pathArr = nil;
            pathArr = [chartView.chartMessage.fileModel.path componentsSeparatedByString:@"\\"];
            if([pathArr count] != 2)
            {
                pathArr = [chartView.chartMessage.fileModel.path componentsSeparatedByString:@"//"];
            }
            if(pathArr != nil)
            {
                streamerURL = [streamerURL stringByAppendingString:Mp3_api];
                streamerURL = [streamerURL stringByAppendingString:[pathArr objectAtIndex:0]];
                streamerURL = [streamerURL stringByAppendingString:@"/"];
                streamerURL = [streamerURL stringByAppendingString:[pathArr objectAtIndex:1]];
            }
            webView.link_url = streamerURL;
            [[HYHelper getNavigationController] pushController:webView];
        }
        
    }
//    if([self.delegate respondsToSelector:@selector(chartCell:tapContent:)]){
//
//    }
}

-(void)startOnlineMp3:(NSString *)path
{
    mp3Timer = [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(mp3Img) userInfo:nil repeats:YES];
    [self createStreamer:path];
    [streamer start];
}

-(void)mp3Img
{
    //NSLog(@"mp3Type = %d", mp3Type);
    //NSLog(@"state = %d", [streamer state]);
    
    if([streamer state] == AS_INITIALIZED)
    {
        [mp3Timer invalidate];
        mp3Timer = nil;
        mp3Type = 2;
    }
    
    if(mp3Type == 3)
    {
        mp3Type = 0;
    }
    if(self.chartView.chartMessage.messageType == messageFrom)
    {
        switch (mp3Type) {
            case 0:
                self.chartView.backImageView.image = [HYImageFactory GetImageByName:@"chatto_yuyin_left1" AndType:PNG];
                break;
            case 1:
                self.chartView.backImageView.image = [HYImageFactory GetImageByName:@"chatto_yuyin_left2" AndType:PNG];
                break;
            case 2:
                self.chartView.backImageView.image = [HYImageFactory GetImageByName:@"chatto_yuyin_left" AndType:PNG];
                break;
        }
    }
    if(self.chartView.chartMessage.messageType == messageTo)
    {
        switch (mp3Type) {
            case 0:
                self.chartView.backImageView.image = [HYImageFactory GetImageByName:@"chatto_yuyin_right1" AndType:PNG];
                break;
            case 1:
                self.chartView.backImageView.image = [HYImageFactory GetImageByName:@"chatto_yuyin_right2" AndType:PNG];
                break;
            case 2:
                self.chartView.backImageView.image = [HYImageFactory GetImageByName:@"chatto_yuyin_right" AndType:PNG];
                break;
        }
    }
    mp3Type = mp3Type + 1;
}

- (void)destroyStreamer
{
    if (streamer)
    {
        [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:streamer];
        
        [streamer stop];
        streamer = nil;
    }
}

- (void)createStreamer:(NSString *)path
{
//    if (streamer)
//    {
//        return;
//    }
    
    [self destroyStreamer];
    
    NSString *streamerURL = @"";
    NSArray *pathArr = nil;
    pathArr = [path componentsSeparatedByString:@"\\"];
    if([pathArr count] != 2)
    {
        pathArr = [path componentsSeparatedByString:@"//"];
    }
    if(pathArr != nil)
    {
        streamerURL = [streamerURL stringByAppendingString:Mp3_api];
        streamerURL = [streamerURL stringByAppendingString:[pathArr objectAtIndex:0]];
        streamerURL = [streamerURL stringByAppendingString:@"/"];
        streamerURL = [streamerURL stringByAppendingString:[pathArr objectAtIndex:1]];
    }
    
    NSURL *url = [NSURL URLWithString:streamerURL];
    streamer = [[AudioStreamer alloc] initWithURL:url];
}

-(void)menuShow:(UIMenuController *)menu
{
//    [self setBackGroundImageViewImage:self.currentChartView from:@"chatfrom_bg_focused.png" to:@"chatto_bg_focused.png"];
}
-(void)menuHide:(UIMenuController *)menu
{
//    [self setBackGroundImageViewImage:self.currentChartView from:@"chatfrom_bg_normal.png" to:@"chatto_bg_normal.png"];
//    self.currentChartView=nil;
//    [self resignFirstResponder];
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(action ==@selector(copy:)){

        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

-(void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard]setString:self.contentStr];
}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
