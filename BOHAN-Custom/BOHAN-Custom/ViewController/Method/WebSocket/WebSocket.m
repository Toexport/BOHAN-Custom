//
//  WebSocket.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/11.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "WebSocket.h"
#import "CommandModel.h"
#import "WebSocket+Utils.h"
#import "SocketRocketUtility.h"
#import "NSError+Message.h"
#import "FileHeader.pch"
@interface WebSocket ()

@property (nonatomic,strong, readwrite)SocketRocketUtility *serverSockt;
@property (nonatomic,strong, readwrite)SocketRocketUtility *deviceSockt;

@end

@implementation WebSocket

+ (instancetype)socketManager {
    static WebSocket *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[WebSocket alloc] init];
    });
    return instance;
}
//n
- (SocketRocketUtility *)serverSockt {
    if (!_serverSockt) {

//               _serverSockt = [[SocketRocketUtility alloc] initWithUrl:@"ws://www.bohanserver.top:8888"]; // 原始地址
//               _serverSockt = [[SocketRocketUtility alloc] initWithUrl:@"ws://122.10.97.35:8888"]; // 香港地址
        _serverSockt = [[SocketRocketUtility alloc]initWithUrl:@"ws://192.168.3.222:2323"];
    }// 这个是地址192.168.3.254:2323
    return _serverSockt;
}

//- (SocketRocketUtility *)deviceSockt
//{
//    if (!_deviceSockt) {
//        _deviceSockt = [[SocketRocketUtility alloc] init];
//    }
//    if (self.deviceIp) {
//        _deviceSockt.socketUrl = [NSString stringWithFormat:@"%@:6868",self.deviceIp];
//    }168
//
//    return _deviceSockt;
//}

- (void)sendSingleDataWithModel:(CommandModel *)model resultBlock:(CompletionBlock)block {
    NSString *dataStr = [self singleDataStringWithModel:model];
    if (!dataStr || dataStr.length == 0) {
        return;
    }
    [self.serverSockt sendData:dataStr resultBlock:block];
}

- (void)sendMultiDataWithModel:(CommandModel *)model resultBlock:(CompletionBlock)block {
    NSString *dataStr = [self multiDataStringWithModel:model];
    if (!dataStr || dataStr.length == 0) {
        return;
    }
    [self.serverSockt sendData:dataStr resultBlock:block];
}


//- (void)sendDeviceDataWithModel:(CommandModel *)model
//{
//    NSString *dataStr = [self singleDataStringWithModel:model];
//    [self.deviceSockt sendData:dataStr resultBlock:block];
//
//}

@end
