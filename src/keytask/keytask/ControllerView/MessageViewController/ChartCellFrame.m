//
//  ChartCellFrame.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
#define kIconMarginX 5
#define kIconMarginY 20

#import "ChartCellFrame.h"

@implementation ChartCellFrame

-(void)setChartMessage:(ChartMessage *)chartMessage
{
    _chartMessage=chartMessage;
    
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    CGFloat iconX = kIconMarginX;
    CGFloat iconY = kIconMarginY;
    CGFloat iconWidth = 35;
    CGFloat iconHeight = 35;
    //NSLog(@"ChartCellFrame type = %d ", chartMessage.messageType);
    if(chartMessage.messageType == messageSys)
    {
        
    }else if (chartMessage.messageType == messageFrom)
    {
    
    }else if(chartMessage.messageType == messageTo)
    {
        iconX = winSize.width - kIconMarginX - iconWidth;
    }
    self.iconRect = CGRectMake(iconX, iconY, iconWidth, iconHeight);
    self.iconLabelRect = CGRectMake(iconX, iconY + iconHeight, iconWidth, 15);
    
    CGFloat contentX=CGRectGetMaxX(self.iconRect)+kIconMarginX;
    CGFloat contentY = iconY;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:13]};
    if(chartMessage.fileModel != nil)
    {
        chartMessage.content = @"填充";
    }
    CGSize contentSize=[chartMessage.content boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    if(chartMessage.fileModel != nil)
    {
        //NSLog(@"chartView.chartMessage.fileModel.type = %@", chartMessage.fileModel.type);
        if(![chartMessage.fileModel.type isEqual:@"mp3"] && !([chartMessage.fileModel.type isEqual:@"jpg"] || [chartMessage.fileModel.type isEqual:@"bmp"] || [chartMessage.fileModel.type isEqual:@"gif"] || [chartMessage.fileModel.type isEqual:@"jpeg"] || [chartMessage.fileModel.type isEqual:@"png"]))
        {
            chartMessage.content = chartMessage.fileModel.name;
            contentSize=[chartMessage.content boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
        }else
        {
            chartMessage.content = @"";
        }
    }
    if(chartMessage.messageType == messageTo){
    
        contentX=iconX-kIconMarginX-contentSize.width-iconWidth;
    }
    
    self.chartViewRect=CGRectMake(contentX, contentY, contentSize.width+35, contentSize.height+30);
    
    self.cellHeight=MAX(CGRectGetMaxY(self.iconRect), CGRectGetMaxY(self.chartViewRect))+kIconMarginX + 20;
}
@end
