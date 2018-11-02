//
//  WebSocket.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/11.
//  Copyright © 2018年 Bohan. All rights reserved.
//


//typedef void (^CompletionBlock)(id response, NSError *error);

#import <Foundation/Foundation.h>
#import "SocketRocketUtility.h"
@class CommandModel;
@interface WebSocket : NSObject

@property (nonatomic, copy)NSString *deviceIp;
@property (nonatomic,strong, readonly)SocketRocketUtility *serverSockt;
@property (nonatomic,strong, readonly)SocketRocketUtility *deviceSockt;

+ (instancetype)socketManager;

//单台设备发送命令方法
- (void)sendSingleDataWithModel:(CommandModel *)model resultBlock:(CompletionBlock)block;

//多台设备发送命令方法
- (void)sendMultiDataWithModel:(CommandModel *)model resultBlock:(CompletionBlock)block;


//- (void)sendDeviceDataWithModel:(CommandModel *)model;

@end
