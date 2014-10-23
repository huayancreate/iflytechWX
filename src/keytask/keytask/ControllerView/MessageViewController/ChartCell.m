//
//  ChartCell.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import "ChartCell.h"
#import "ChartContentView.h"
#import "HYConstants.h"

@interface ChartCell()<ChartContentViewDelegate>
@property (nonatomic,strong) UIImageView *icon;
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
        self.backgroundColor = [UIColor clearColor];
        self.icon=[[UIImageView alloc]init];
        self.iconLabel=[[UILabel alloc]init];
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.iconLabel];
        self.chartView =[[ChartContentView alloc]initWithFrame:CGRectZero];
        self.chartView.delegate=self;
        [self.contentView addSubview:self.chartView];
    }
    return self;
}
-(void)setCellFrame:(ChartCellFrame *)cellFrame
{
   
    _cellFrame=cellFrame;
    
    ChartMessage *chartMessage=cellFrame.chartMessage;
    
    self.icon.frame= cellFrame.iconRect;
    self.iconLabel.frame = cellFrame.iconLabelRect;
    self.icon.image = [UIImage imageNamed:chartMessage.icon];
    [self.iconLabel setText:chartMessage.iconLabelText];
    [self.iconLabel setTextAlignment:NSTextAlignmentCenter];
    [self.iconLabel setFont:[UIFont fontWithName:FONT size:10]];
   
    self.chartView.chartMessage=chartMessage;
    self.chartView.frame=cellFrame.chartViewRect;
    [self setBackGroundImageViewImage:self.chartView from:@"chatto_bg_normal_from" to:@"chatto_bg_normal.png" sys:@"chatfrom_bg_normal.png"];
    self.chartView.contentLabel.text=chartMessage.content;
    
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
    chartView.backImageView.image=normal;
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
    if([self.delegate respondsToSelector:@selector(chartCell:tapContent:)]){
    
    
        [self.delegate chartCell:self tapContent:content];
    }
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
