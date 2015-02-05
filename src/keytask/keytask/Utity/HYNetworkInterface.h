//
//  HYNetworkInterface.h
//  keytask
//
//  Created by 许 玮 on 14-9-29.
//  Copyright (c) 2014年 科大讯飞. All rights reserved.
//


@interface HYNetworkInterface

// 192.168.75.139
// 192.168.75.160
// in.iflytek.com

// https://192.168.58.73/KeyTask

// https://192.168.58.73

//http://in.iflytek.com/taskfile


//https://192.168.58.73/KeyTask/LoginHandler.ashx
//https://192.168.58.73/LoginHandler.ashx

//https://192.168.58.73/Keytask

#define Login_api @"https://192.168.58.73/Keytask/LoginHandler.ashx"

#define Push_api @"https://192.168.58.73/Keytask/Control/SysLoginHandler.ashx"

#define TaskHandler_api @"https://192.168.58.73/Keytask/Control/TaskHandler.ashx"

#define Proxy_api @"https://192.168.58.73/Keytask/Control/ProxyHandler.ashx"

#define SmartInput_api @"https://192.168.58.73/Keytask/Control/SmartInputHandler.ashx"

#define FileUpload_api @"https://192.168.58.73/Keytask/Control/SmartInputHandler.ashx"

#define Check_api @"https://192.168.58.73/Keytask/Control/SysLoginHandler.ashx"

#define Download_api @"https://192.168.58.73/Keytask/download.htm"

#define HeadImg_api @"http://192.168.58.73:10092/"

#define HeadUpImg_api @"http://192.168.58.73:10092/Control/HeadImgHandler.ashx"

#define FileUpImg_api @"http://192.168.58.73:10092/Control/FileHandler.ashx"

#define FileDownload_api @"http://192.168.58.73:10092/Control/Download.aspx"

#define Mp3_api @"http://192.168.58.73:10092/"

#define Suggest_api @"https://192.168.58.73/Keytask/Control/SuggestHandler.ashx"


@end
