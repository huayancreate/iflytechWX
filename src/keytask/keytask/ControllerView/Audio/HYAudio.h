//
//  HYAudio.h
//  keytask
//
//  Created by 许 玮 on 14-10-23.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface HYAudio : NSObject

-(void) startRecord;
-(BOOL) stopRecord;
-(void)initAudio;
-(void)playAudio:(NSData *)data;
-(AVAudioRecorder *)getRecorder;
-(double)getRecorderPeakPower;

@end
