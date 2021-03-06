//
//  ViewController.h
//  AndroidLock
//
//  Created by Purnama Santo on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYUserLoginModel.h"
#import "HYBaseViewController.h"
#import "DrawPatternLockView.h"

@interface DrawPatternLockViewController : HYBaseViewController {
  NSMutableArray* _paths;
  
  // after pattern is drawn, call this:
  id _target;
  SEL _action;
}

// get key from the pattern drawn
- (NSString*)getKey;

-(void)forgetPassword;
-(DrawPatternLockView *)getDraw;

-(void)secondPassword;

-(void)erroPassword;
-(void)firstPassword;
-(void)setSetting:(BOOL)flag;

- (void)setTarget:(id)target withAction:(SEL)action;


@end
