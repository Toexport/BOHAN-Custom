//
//  SocketRocketUtility.h
//  SUN
//
//  Created by 孙俊 on 17/2/16.
//  Copyright © 2017年 SUN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketRocket.h"
#import "NetworkRequest/NetworkRequest.h"
extern NSString * const kNeedPayOrderNote;
extern NSString * const kWebSocketDidOpenNote;
extern NSString * const kWebSocketDidCloseNote;
extern NSString * const kWebSocketdidReceiveMessageNote;

@interface SocketRocketUtility : NSObject

// 获取连接状态
@property (nonatomic,assign,readonly) SRReadyState socketReadyState;
//@property (nonatomic,copy) NSString *socketUrl;
//@property (nonatomic, copy) CompletionBlock block;
//+ (SocketRocketUtility *)instance;

- (void)webSocketClose;
- (void)webSocketOpen;
- (void)sendData:(NSString *)data  resultBlock:(CompletionBlock)block;//发送数据给服务器
- (instancetype)initWithUrl:(NSString *)socketUrl;
//- (void)deviceSendData:(id)data;//发送数据智能设备

@end
