//
//  DataProcessing.m
//  KONKA
//
//  Created by archon on 12-10-20.
//  Copyright (c) 2012年 HY. All rights reserved.
//

#import "DataProcessing.h"

static DataProcessing *instance;
@implementation DataProcessing

+ (DataProcessing *)sharedDataProcessing
{
    if (instance == nil) {
		instance = [[DataProcessing alloc] init];
	}
	return instance;

}

#pragma mark -
#pragma mark HttpRequest

-(BOOL) sentRequest:(NSURL *)url Target:(id)target
{
    @try {
        if (url) {
            ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL:url];
            [request setDelegate:target];
            [request startAsynchronous];
            return YES;
        }
    }
    @catch (NSException *exception) {
        //NSLog(@"exception:%@",exception);
    }
    return NO;

}

-(ASIFormDataRequest *)getRequest:(NSURL *)url Parem:(NSDictionary*)parem  Target:(id)target
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    return request;
}

-(BOOL) sentByRequest:(ASIFormDataRequest *)request Parem:(NSDictionary*)parem  Target:(id)target
{
    @try {
        if (request) {
            [request setDelegate:target];
            if (parem) {
                NSArray *array = [parem allKeys];
                for (int i= 0; i <[array count]; i++) {
                    //NSLog(@"parem %@",[parem objectForKey:[array objectAtIndex:i]]);
                    [request setPostValue:[parem objectForKey:[array objectAtIndex:i]] forKey:[array objectAtIndex:i]];
                }
                
            }
            [request setPersistentConnectionTimeoutSeconds:15];
            [request setNumberOfTimesToRetryOnTimeout:1];
            [request startAsynchronous];
            return YES;
        }
    }
    @catch (NSException *exception) {
        //NSLog(@"exception:%@",exception);
    }
    return NO;
    
}


-(BOOL) sentRequest:(NSURL *)url Parem:(NSDictionary*)parem  Target:(id)target
{
    @try {
        if (url) {
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            [request setDelegate:target];
            if (parem) {
                NSArray *array = [parem allKeys];
                for (int i= 0; i <[array count]; i++) {
                    //NSLog(@"parem %@",[parem objectForKey:[array objectAtIndex:i]]);
                    [request setPostValue:[parem objectForKey:[array objectAtIndex:i]] forKey:[array objectAtIndex:i]];
                }
                
            }
            [request setAuthenticationScheme:@"https"];
            [request setValidatesSecureCertificate:NO];
            [request setShouldAttemptPersistentConnection:NO];
            [request setPersistentConnectionTimeoutSeconds:15];
            [request setNumberOfTimesToRetryOnTimeout:1];
            [request startAsynchronous];
            return YES;
        }
    }
    @catch (NSException *exception) {
        //NSLog(@"exception:%@",exception);
    }
    return NO;

}
-(BOOL) sentSynRequest:(NSURL *)url Parem:(NSDictionary*)parem  Target:(id)target
{
    @try {
        if (url) {
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            [request setDelegate:target];
            if (parem) {
                NSArray *array = [parem allKeys];
                for (int i= 0; i <[array count]; i++) {
                    //NSLog(@"parem %@",[parem objectForKey:[array objectAtIndex:i]]);
                    [request setPostValue:[parem objectForKey:[array objectAtIndex:i]] forKey:[array objectAtIndex:i]];
                }
                
            }
            
            [request setPersistentConnectionTimeoutSeconds:15];
            [request setNumberOfTimesToRetryOnTimeout:1];
            [request startSynchronous];
            return YES;
        }
    }
    @catch (NSException *exception) {
        //NSLog(@"exception:%@",exception);
    }
    return NO;
    
}

-(BOOL) sentGetRequest:(NSString *)url Parem:(NSDictionary*)parem  Target:(id)target
{
    @try {
        if (url) {
           
            NSMutableString *strUrl = [[NSMutableString alloc] init];
            [strUrl appendString:url];
            
            if (parem) {
                NSArray *array = [parem allKeys];
                for (int i= 0; i <[array count]; i++) {
                    if ([parem objectForKey:[array objectAtIndex:i]]) {
                        [strUrl appendFormat:@"&%@=%@",[array objectAtIndex:i],[parem objectForKey:[array objectAtIndex:i]] ];
                    }
                }
                
            }
           ////NSLog(@"strUrl:%@",strUrl);
            NSURL *temurl = [NSURL URLWithString:strUrl];
            if (temurl) {
                
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:temurl];
                [request setRequestMethod:@"GET"];
                [request setDelegate:target];
                
                [request setPersistentConnectionTimeoutSeconds:15];
                [request setNumberOfTimesToRetryOnTimeout:1];
                [request startAsynchronous];
                
                /*
                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:temurl];
                [request setDelegate:target];
                [request setPersistentConnectionTimeoutSeconds:15];
                [request setNumberOfTimesToRetryOnTimeout:1];
                [request startAsynchronous];*/
                
                return YES;
            }
            [strUrl release];
            strUrl =  nil;
            
        }
    }
    @catch (NSException *exception) {
         //NSLog(@"exception:%@",exception);
    }
    return NO;
    
}


-(BOOL) sentPostRequest:(NSURL *)url Parem:(NSDictionary*)parem  Target:(id)target
{
    @try {
        if (url) {
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                [request setRequestMethod:@"POST"];
                [request setDelegate:target];
            
                [request setPersistentConnectionTimeoutSeconds:15];
                [request setNumberOfTimesToRetryOnTimeout:1];
                [request startAsynchronous];
                
                /*
                 ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:temurl];
                 [request setDelegate:target];
                 [request setPersistentConnectionTimeoutSeconds:15];
                 [request setNumberOfTimesToRetryOnTimeout:1];
                 [request startAsynchronous];*/
                
                return YES;
            }
    }
    @catch (NSException *exception) {
        //NSLog(@"exception:%@",exception);
    }
    return NO;
    
}

-(BOOL) sentRequest:(NSURL *)url Parem:(NSDictionary*)parem Files:(NSDictionary*)files Target:(id)target
{
    @try {
        if (url) {
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            
            [request setDelegate:target];
            if (parem) {
                NSArray *array = [parem allKeys];
                for (int i= 0; i <[array count]; i++) {
                    [request setPostValue:[parem objectForKey:[array objectAtIndex:i]] forKey:[array objectAtIndex:i]];
                }
            }
            
            if (files) {
                NSArray *arrays = [files allKeys];
                for (int i= 0; i <[arrays count]; i++) {
                    [request addFile:[files objectForKey:[arrays objectAtIndex:i]] forKey:[arrays objectAtIndex:i]];
                }
            }
            [request setRequestMethod:@"POST"];
            [request buildPostBody];
            [request setPersistentConnectionTimeoutSeconds:15];
            [request setNumberOfTimesToRetryOnTimeout:1];
            [request startAsynchronous];
            return YES;
        }

    }
    @catch (NSException *exception) {
         //NSLog(@"exception:%@",exception);
    }
    return NO;
}

-(NSString *) sentSynchronousRequest:(NSURL *)url Parem:(NSDictionary*)parem Files:(NSDictionary*)files Target:(id)target
{
    @try {
        if (url) {
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            
            [request setDelegate:target];
            if (parem) {
                NSArray *array = [parem allKeys];
                for (int i= 0; i <[array count]; i++) {
                    [request setPostValue:[parem objectForKey:[array objectAtIndex:i]] forKey:[array objectAtIndex:i]];
                }
            }
            
            if (files) {
                NSArray *arrays = [files allKeys];
                for (int i= 0; i <[arrays count]; i++) {
                    
                    [request addFile:[files objectForKey:[arrays objectAtIndex:i]] forKey:[arrays objectAtIndex:i]];
                    
                }
            }
            [request setPersistentConnectionTimeoutSeconds:15];
            [request setNumberOfTimesToRetryOnTimeout:1];
            [request startSynchronous];
            
            NSError *error = [request error];
            if (!error) {
                NSString *response = [request responseString];
                return response;
            }

        }
        
    }
    @catch (NSException *exception) {
        //NSLog(@"exception:%@",exception);
    }
    return nil;
}
@end
