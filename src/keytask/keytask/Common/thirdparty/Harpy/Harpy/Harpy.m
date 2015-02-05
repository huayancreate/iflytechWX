//
//  Harpy.m
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import "Harpy.h"
#import "HarpyConstants.h"
#import "HYNetworkInterface.h"
#import "HYHelper.h"

#define kHarpyCurrentVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey]

@interface Harpy ()

+ (void)showAlertWithAppStoreVersion:(NSString*)appStoreVersion;


@end

@implementation Harpy

#pragma mark - Public Methods
+ (void)checkVersion
{
}

#pragma mark - Private Methods
+ (void)showAlertWithAppStoreVersion:(NSString *)currentAppStoreVersion
{
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    if ( harpyForceUpdate ) { // Force user to update app
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                            message:[NSString stringWithFormat:@"%@ 有新版本。 请现在更新到新版本%@。", appName, currentAppStoreVersion]
                                                           delegate:self
                                                  cancelButtonTitle:kHarpyUpdateButtonTitle
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
        
    } else { // Allow user option to update next time user launches your app
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                            message:[NSString stringWithFormat:@"%@ 有新版本。 请现在更新到新版本%@。", appName, currentAppStoreVersion]
                                                           delegate:self
                                                  cancelButtonTitle:kHarpyCancelButtonTitle
                                                  otherButtonTitles:kHarpyUpdateButtonTitle, nil];
        
        [alertView show];
        
    }
    
}

#pragma mark - Private Methods
+ (void)showAlertWithVersion:(NSString *)currentAppStoreVersion info:(NSString *)info download:(NSString *)url
{
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    if([info isEqual:@""])
    {
        if ( harpyForceUpdate ) { // Force user to update app
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                                message:[NSString stringWithFormat:@"[%@] 有新版本。 请现在更新到新版本%@。", appName, currentAppStoreVersion]
                                                               delegate:self
                                                      cancelButtonTitle:kHarpyUpdateButtonTitle
                                                      otherButtonTitles:nil, nil];
            
            [alertView show];
            
        } else { // Allow user option to update next time user launches your app
            
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                                message:[NSString stringWithFormat:@"[%@] 有新版本。 请现在更新到新版本%@。", appName, currentAppStoreVersion]
                                                               delegate:self
                                                      cancelButtonTitle:kHarpyCancelButtonTitle
                                                      otherButtonTitles:kHarpyUpdateButtonTitle, nil];
            
            [alertView show];
            
        }
    }
    else
    {
        if ( harpyForceUpdate ) { // Force user to update app
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                                message:[NSString stringWithFormat:@"[%@] 有新版本。 请现在更新到新版本%@。版本更新内容:%@", appName, currentAppStoreVersion,info]
                                                               delegate:self
                                                      cancelButtonTitle:kHarpyUpdateButtonTitle
                                                      otherButtonTitles:nil, nil];
            
            [alertView show];
            
        } else { // Allow user option to update next time user launches your app
            
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                                message:[NSString stringWithFormat:@"[%@] 有新版本。 请现在更新到新版本%@。版本更新内容:%@", appName, currentAppStoreVersion,info]
                                                               delegate:self
                                                      cancelButtonTitle:kHarpyCancelButtonTitle
                                                      otherButtonTitles:kHarpyUpdateButtonTitle, nil];
            
            [alertView show];
            
        }
    }
    
    
    
}

#pragma mark - UIAlertViewDelegate Methods
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSURL *url = [[NSURL alloc] initWithString:[HYHelper getDownloadURL]];
    if ( harpyForceUpdate ) {
        
        //NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
        //NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
        [[UIApplication sharedApplication] openURL:url];
        
    } else {
        
        switch ( buttonIndex ) {
                
            case 0:{ // Cancel / Not now
                
                // Do nothing
                
            } break;
                
            case 1:{ // Update
                
                //NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
                //NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
                [[UIApplication sharedApplication] openURL:url];
                
            } break;
                
            default:
                break;
        }
        
    }
    
    
}

@end
