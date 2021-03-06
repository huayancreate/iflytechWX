//
//  Pull2RefreshTableView.m
//  CDPullToRefreshDemo
//
//  Created by 乐星宇 on 13-11-23.
//  Copyright (c) 2013年 cDigger. All rights reserved.
//

#import "Pull2RefreshTableView.h"
#import "HYMessageViewController.h"
#import "HYHelper.h"
#import "HYTaskModel.h"


@implementation Pull2RefreshTableView
{
    Pull2RefreshView *dragHeaderView;
    Pull2RefreshView *dragFooterView;
    
    BOOL headerRefreshing;
    BOOL footerRefreshing;
    
    
    int _lastPosition;
}

@synthesize shouldShowDragHeader, shouldShowDragFooter, dragHeaderHeight, dragFooterHeight,dic,user,pageCountFlag,flag,ishead;

- (id)initWithFrame:(CGRect)frame showDragRefreshHeader:(BOOL)showDragRefreshHeader showDragRefreshFooter:(BOOL)showDragRefreshFooter
{
    pageCountFlag = NO;
    flag = NO;
    self = [self initWithFrame:frame];
    if (self)
    {
        self.shouldShowDragHeader = showDragRefreshHeader;
        self.shouldShowDragFooter = showDragRefreshFooter;
        
        if (showDragRefreshHeader)
        {
            [self addDragHeaderView];
        }
        
        if (showDragRefreshFooter)
        {
            [self addDragFooterView];
        }
        
        self.delegate = self;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.dragHeaderHeight = 65.f;
        self.dragFooterHeight = 65.f;
    }
    
    return self;
}

- (void)addDragHeaderView
{
    if (self.shouldShowDragHeader && !dragHeaderView)
    {
        CGRect frame = CGRectMake(0, -self.dragHeaderHeight,
                                    self.bounds.size.width, self.dragHeaderHeight);
        dragHeaderView = [[Pull2RefreshView alloc]
                                    initWithFrame:frame type:kPull2RefreshViewTypeHeader];
        [self addSubview:dragHeaderView];
    }
}

- (void)addDragFooterView
{
    if (self.shouldShowDragFooter && !dragFooterView)
    {
        CGFloat height = MAX(self.contentSize.height, self.frame.size.height);
        CGRect frame = CGRectMake(0, height,
                                    self.bounds.size.width, self.dragFooterHeight);
        dragFooterView = [[Pull2RefreshView alloc]
                                    initWithFrame:frame type:kPull2RefreshViewTypeFooter];
        self.tableFooterView = dragFooterView;
    }
}

- (void)removeDragHeaderView
{
    if (dragHeaderView)
    {
        [dragHeaderView removeFromSuperview];
        self.contentInset = UIEdgeInsetsZero;
    }
}

- (void)removeDragFooterView
{
    if (dragFooterView)
    {
        [dragFooterView removeFromSuperview];
        self.contentInset = UIEdgeInsetsZero;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYMessageViewController *messageView = [[HYMessageViewController alloc] init];
    HYTaskModel *model = [dic objectAtIndex:indexPath.row];
    [messageView setTitle:@""];
    messageView.taskModel = model;
    self.user.isLogin = true;
    messageView.user = self.user;
    [[HYHelper getNavigationController] pushController:messageView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //added 2013.11.28 动态修改headerView的位置
    if (headerRefreshing)
    {
        if (scrollView.contentOffset.y >= -scrollView.contentInset.top
            && scrollView.contentOffset.y < 0)
        {
            //注意:修改scrollView.contentInset时，若使当前界面显示位置发生变化，会触发scrollViewDidScroll:，从而导致死循环。
            //因此此处scrollView.contentInset.top必须为-scrollView.contentOffset.y
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        else if (scrollView.contentOffset.y == 0)//到0说明headerView已经在tableView最上方，不需要再修改了
        {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
    
    //other code here...
    
    //拉动足够距离，状态变更为“松开....”
    if (self.shouldShowDragHeader && dragHeaderView)
    {
        if (dragHeaderView.state == kPull2RefreshViewStateDragToRefresh
            && scrollView.contentOffset.y < -self.dragHeaderHeight - 10.f
            && !headerRefreshing
            && !footerRefreshing)
        {
            [dragHeaderView flipImageAnimated:YES];
            [dragHeaderView setState:kPull2RefreshViewStateLooseToRefresh];
        }
    }
    
    if (self.shouldShowDragFooter && dragFooterView && !pageCountFlag)
    {
        CGFloat scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y;
        if(scrollView.contentSize.height > scrollView.frame.size.height)
        {
            if (dragFooterView.state == kPull2RefreshViewStateDragToRefresh
                && scrollPosition <= self.dragFooterHeight
                && (scrollView.contentOffset.y + self.frame.size.height) > scrollView.contentSize.height + self.dragFooterHeight
                && !headerRefreshing
                && !footerRefreshing)
            {
                [dragFooterView setState:kPull2RefreshViewStateLooseToRefresh];
            }
        }else
        {
            if (dragFooterView.state == kPull2RefreshViewStateDragToRefresh
                && scrollPosition <= self.dragFooterHeight
                && scrollView.contentOffset.y > 30
                && !headerRefreshing
                && !footerRefreshing)
            {
                [dragFooterView setState:kPull2RefreshViewStateLooseToRefresh];
            }
        }
    }
//    if(pageCountFlag)
//    {
//        Pull2RefreshView *dragView = nil;
//        if (headerRefreshing)
//        {
//            dragView = dragHeaderView;
//        }
//        else if (footerRefreshing)
//        {
//            dragView.pageCountflag = pageCountFlag;
//            dragView = dragFooterView;
//        }
//        
//        if(dragView == dragFooterView)
//        {
//            dragView.pageCountflag = pageCountFlag;
//            [dragView setState:kPull2RefreshViewStateDragToRefresh];
//        }
//    }
//    [self completeDragRefresh];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //拉动足够距离，松开后，状态变更为“加载中...”
    if (self.shouldShowDragHeader && dragHeaderView)
    {
        //NSLog(@"scrollView.contentOffset.y = %f",scrollView.contentOffset.y);
        //NSLog(@"self.dragHeaderHeight = %f",self.dragHeaderHeight);
        //NSLog(@"headerRefreshing = %d", headerRefreshing);
        if (dragHeaderView.state == kPull2RefreshViewStateLooseToRefresh
            && scrollView.contentOffset.y < -self.dragHeaderHeight - 10.0f
            && !headerRefreshing
            && !footerRefreshing)//每次只允许上拉或者下拉其中一个执行
        {
            headerRefreshing = YES;
            //使refresh panel保持显示
            self.contentInset = UIEdgeInsetsMake(self.dragHeaderHeight, 0, 0, 0);
            [dragHeaderView setState:kPull2RefreshViewStateRefreshing];
        }
    }
    
    if(self.shouldShowDragFooter && dragFooterView && dragFooterView.state == kPull2RefreshViewStateLooseToRefresh && !footerRefreshing && !pageCountFlag)
    {
        footerRefreshing = YES;
        [dragFooterView setState:kPull2RefreshViewStateRefreshing];
        //执行数据加载操作
    }
    
    if(footerRefreshing)
    {
        self.dragEndBlock(kPull2RefreshViewTypeFooter);
    }
    
    //执行加载数据操作
    if (headerRefreshing)
    {
        self.dragEndBlock(kPull2RefreshViewTypeHeader);
    }
}

-(void)setSatues
{
    dragFooterView.pageCountflag = pageCountFlag;
    dragFooterView.flag = flag;
    [dragFooterView setState:kPull2RefreshViewStateDragToRefresh];
    [self completeDragRefresh];
}

#pragma mark - Other
- (void)completeDragRefresh
{
    Pull2RefreshView *dragView = nil;
    if (headerRefreshing)
    {
        dragView = dragHeaderView;
    }
    else if (footerRefreshing)
    {
        dragView.pageCountflag = pageCountFlag;
        dragView.flag = flag;
        dragView = dragFooterView;
    }
    
    if(dragView == dragFooterView)
    {
        dragView.pageCountflag = pageCountFlag;
        dragView.flag = flag;
        [dragView setState:kPull2RefreshViewStateDragToRefresh];
    }
    
    if (dragView == dragHeaderView)
    {
        //恢复箭头为原始指向，不需要动画效果
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        self.contentInset = UIEdgeInsetsZero;
        [UIView commitAnimations];
        
        [dragView flipImageAnimated:NO];
        [dragView setState:kPull2RefreshViewStateDragToRefresh];
    }
    
    headerRefreshing = NO;
    footerRefreshing = NO;
}


@end
