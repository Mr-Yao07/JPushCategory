//
//  AppDelegate+Jpush.h
//  YLHTools
//
//  Created by 张丽 on 2018/10/31.
//  Copyright © 2018年 ZL. All rights reserved.
//

#import "AppDelegate.h"


#ifdef DEBUG
static BOOL isProduction = NO;
#else
static BOOL isProduction = YES;
#endif

static NSString *appKey = @"e493d7f8cc7499575abaa8d2";
static NSString *channel = @"Publish channel";

@interface AppDelegate (Jpush)
- (BOOL)Jpush_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
@end
