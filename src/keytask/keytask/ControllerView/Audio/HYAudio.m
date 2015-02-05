//
//  HYAudio.m
//  keytask
//
//  Created by 许 玮 on 14-10-23.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//

#import "HYAudio.h"
#import "RecordAudio.h"

@interface HYAudio() <RecordAudioDelegate>
{
    RecordAudio *recordAudio;
    NSData *curAudio;
    BOOL isRecording;
}

@end

@implementation HYAudio

static double startRecordTime=0;
static double endRecordTime=0;

-(AVAudioRecorder *)getRecorder
{
    return [recordAudio getRecorder];
}

-(double)getRecorderPeakPower
{
    return [recordAudio getRecorderPeakPower];
}

-(void)initAudio
{
    recordAudio = nil;
    recordAudio = [[RecordAudio alloc] init];
    recordAudio.delegate = self;
}

-(void) startRecord {
//    [recordAudio stopPlay];
    [recordAudio startRecord];
    
    startRecordTime = [NSDate timeIntervalSinceReferenceDate];
    
    [curAudio release],curAudio=nil;
}


-(BOOL)stopRecord {
    endRecordTime = [NSDate timeIntervalSinceReferenceDate];
    
    NSURL *url = [recordAudio stopRecord];
    
    endRecordTime -= startRecordTime;
    if (endRecordTime<1.00f) {
        //NSLog(@"录音时间过短");
//        [self showMsg:@"录音时间过短,应大于2秒"];
        return false;
    } else if (endRecordTime>30.00f){
//        [self showMsg:@"录音时间过长,应小于30秒"];
        return false;
    }
    
    
    if (url != nil) {
        curAudio = EncodeWAVEToAMR([NSData dataWithContentsOfURL:url],1,16);
        if (curAudio) {
            [curAudio retain];
        }
    }
    
    if (curAudio.length >0) {
        [self saveAudio];
        
    } else {
        
    }
    return YES;
}

-(void)playAudio:(NSData *)data
{
    [recordAudio play:data];
}

-(void)saveAudio
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"tempUpAudio.AMR"];
    NSData *data = curAudio;
    BOOL result = [data writeToFile:uniquePath atomically:NO];
    if (result) {
        //NSLog(@"success");
    }else {
        //NSLog(@"no success");
    }
    
}

@end
