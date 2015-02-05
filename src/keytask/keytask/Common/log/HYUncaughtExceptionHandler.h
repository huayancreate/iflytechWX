//
//  HYUncaughtExceptionHandler.h
//  keytask
//
//  Created by 许 玮 on 14-12-4.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYUncaughtExceptionHandler : NSObject{
    BOOL dismissed;
}

@end

void HandleException(NSException *exception);
void SignalHandler(int signal);


void InstallUncaughtExceptionHandler(void);
