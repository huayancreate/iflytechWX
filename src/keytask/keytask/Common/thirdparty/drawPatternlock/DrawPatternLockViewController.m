//
//  ViewController.m
//  AndroidLock
//
//  Created by Purnama Santo on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DrawPatternLockViewController.h"
#import "DrawPatternLockView.h"
#import "HYImageFactory.h"
#import "HYConstants.h"
#import "HYHelper.h"
#import "HYScreenTools.h"
#import "HYControlFactory.h"
#import "HYLoginViewController.h"
#import "HYHelper.h"

#define MATRIX_SIZE 3

@interface DrawPatternLockViewController()
{
    DrawPatternLockView *drawView;
    UILabel *tipsLabel;
    UILabel *downTipsLabel;
    BOOL setting;
}

@end

@implementation DrawPatternLockViewController


-(DrawPatternLockView *)getDraw
{
    return drawView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)forgetPassword
{
    [tipsLabel removeFromSuperview];
    [tipsLabel setText:@"忘记密码?"];
    [drawView addSubview:tipsLabel];
}

-(void)setSetting:(BOOL)flag
{
    setting = flag;
}


-(void)erroPassword
{
    [downTipsLabel removeFromSuperview];
    [downTipsLabel setText:@"再次确认密码错误!"];
    [drawView addSubview:downTipsLabel];
}

-(void)firstPassword
{
    [downTipsLabel removeFromSuperview];
    [downTipsLabel setText:@"请输入手势密码!"];
    [drawView addSubview:downTipsLabel];
}

-(void)secondPassword
{
    [downTipsLabel removeFromSuperview];
    [downTipsLabel setText:@"请再次确认密码!"];
    [drawView addSubview:downTipsLabel];
}

- (void)loadView {
  [super loadView];
//    setting = NO;
    [self.view setFrame:CGRectMake(0, [HYScreenTools getStatusHeight], [HYScreenTools getScreenWidth], [HYScreenTools getScreenHeight] - [HYScreenTools getStatusHeight])];
    drawView = [[DrawPatternLockView alloc] initWithFrame:CGRectMake(0, [HYScreenTools getStatusHeight], [HYScreenTools getScreenWidth], [HYScreenTools getScreenHeight] - [HYScreenTools getStatusHeight])];
    [self.view addSubview:drawView];
    
    tipsLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(([HYScreenTools getScreenWidth] - 150) /2, [HYScreenTools getScreenHeight] - 60, 150, 30) textfont:[UIFont fontWithName:FONT size:17] text:@"" textColor:[UIColor whiteColor] TextAlignment:NSTextAlignmentCenter];
    tipsLabel.userInteractionEnabled = YES;
    [tipsLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetPasswordAction)]];
    [tipsLabel setText:@"忘记密码?"];
    
    
    downTipsLabel = [HYControlFactory GetLableWithCGRect:CGRectMake(([HYScreenTools getScreenWidth] - 150) /2, 15, 150, 30) textfont:[UIFont fontWithName:FONT size:17] text:@"" textColor:[UIColor whiteColor] TextAlignment:NSTextAlignmentCenter];
    [downTipsLabel setText:@"请输入手势密码"];
    [drawView addSubview:downTipsLabel];
    //    [drawView addSubview:tipsLabel];
}

-(void)forgetPasswordAction
{
    [[[self getNavigationController] getModel] removeAll];
    HYLoginViewController *loginView = [[HYLoginViewController alloc] init];
    [[self getNavigationController] pushController:loginView];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
    drawView.backgroundColor = [UIColor colorWithPatternImage:[HYImageFactory GetImageByName:@"lock_bg" AndType:PNG]];

  for (int i=0; i<MATRIX_SIZE; i++) {
    for (int j=0; j<MATRIX_SIZE; j++) {
      UIImage *dotImage = [UIImage imageNamed:@"dot_off.png"];
      UIImageView *imageView = [[UIImageView alloc] initWithImage:dotImage
                                                 highlightedImage:[UIImage imageNamed:@"dot_on.png"]];
      imageView.frame = CGRectMake(0, 0, dotImage.size.width, dotImage.size.height);
      imageView.userInteractionEnabled = YES;
      imageView.tag = j*MATRIX_SIZE + i + 1;
      [drawView addSubview:imageView];
    }
  }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[[self getNavigationController] getView] setHidden:YES];
    [[[self getTabbarController] getView] setHidden:YES];
    
    if(!setting)
    {
        [drawView addSubview:tipsLabel];
    }else
    {
        [tipsLabel removeFromSuperview];
    }
}


- (void)viewWillLayoutSubviews {
    int w = drawView.frame.size.width/MATRIX_SIZE;
    int h = (drawView.frame.size.height - 140)/MATRIX_SIZE;
    
    int i=0;
    for (UIImageView *view in drawView.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]])
        {
            int x = w*(i/MATRIX_SIZE) + w/2;
            int y = h*(i%MATRIX_SIZE) + h/2;
            y = y + 70;
            view.center = CGPointMake(x, y);
            i++;
        }
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
      return YES;
  }
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  _paths = [[NSMutableArray alloc] init];
}



- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  CGPoint pt = [[touches anyObject] locationInView:drawView];
  UIView *touched = [drawView hitTest:pt withEvent:event];
  
  if(touched == nil)
  {
      return;
  }
  DrawPatternLockView *v = (DrawPatternLockView*)drawView;
  [v drawLineFromLastDotTo:pt];

  if (touched!=drawView) {
    if(drawView.flag)
    {
        return;
    }
    //NSLog(@"touched view tag: %d ", touched.tag);
    
    BOOL found = NO;
    for (NSNumber *tag in _paths) {
      found = tag.integerValue==touched.tag;
      if (found)
        break;
    }
    
    if (found)
      return;

    [_paths addObject:[NSNumber numberWithInt:touched.tag]];
    [v addDotView:touched];

    UIImageView* iv = (UIImageView*)touched;
    iv.highlighted = YES;
  }

}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  // clear up hilite
  DrawPatternLockView *v = (DrawPatternLockView*)drawView;
  [v clearDotViews];

  for (UIView *view in drawView.subviews)
    if ([view isKindOfClass:[UIImageView class]])
      [(UIImageView*)view setHighlighted:NO];
  
  [drawView setNeedsDisplay];
  
  // pass the output to target action...
  if (_target && _action)
    [_target performSelector:_action withObject:[self getKey]];
}


// get key from the pattern drawn
// replace this method with your own key-generation algorithm
- (NSString*)getKey {
  NSMutableString *key;
  key = [NSMutableString string];

  // simple way to generate a key
  for (NSNumber *tag in _paths) {
    [key appendFormat:@"%02d", tag.integerValue];
  }
  
  return key;
}


- (void)setTarget:(id)target withAction:(SEL)action {
  _target = target;
  _action = action;
}

@end
