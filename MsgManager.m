//
//  MsgManager.m
//  YLHTools
//
//  Created by 张丽 on 2018/10/31.
//  Copyright © 2018年 ZL. All rights reserved.
//

#import "MsgManager.h"
static MsgManager *manager = nil;
@implementation MsgManager
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}
- (instancetype)copyWithZone:(NSZone *)zone {
    return manager;
}
@end
