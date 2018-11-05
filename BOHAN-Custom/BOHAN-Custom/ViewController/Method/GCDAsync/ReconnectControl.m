//
//  ReconnectControl.m
//  BOHAN-Custom
//
//  Created by summer on 2018/11/5.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import "ReconnectControl.h"

@interface ReconnectControl ()

@end

@implementation ReconnectControl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
+(ReconnectControl *)shareControl
{
    static ReconnectControl *control;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        control = [ReconnectControl new];
    });
    return control;
}

//
//-(void)startReconnectBlock:(VoidBlock)noticeUI success:(VoidBlock)success
//{
//    _UIBlock = noticeUI;
//    _successBlock = success;
//    _reconnectCount = 0;
//    [_reconnectTimer invalidate];
//    _reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(reconnect) userInfo:nil repeats:true];
//    _status = Reconnecting;
//}
//
//-(void)reconnect
//{
//    //当连续5次没有连接成功时通知UI显示断网提示
//    if (_reconnectCount == 5) {
//        _UIBlock();
//    }
//    _reconnectCount += 1;
//    [self connectHost];
//}
//
////连接服务器
//-(void)connectHost
//{
//    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//    NSError *error = nil;
//    [_socket connectToHost:[Socket sharedInstance].socketHost onPort:[Socket sharedInstance].socketPort withTimeout:3 error:&error];
//}
//
///**
// 连接成功后，断开Socket，通知正在等待连接的socket和UI
// */
//-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
//{
//    _successBlock();
//    _status = ReconnecNone;
//    _reconnectCount = 0;
//    [_reconnectTimer invalidate];
//    [_socket disconnect];
//    _socket.delegate = nil;
//    NSLog(@"连接成功");
//}



@end
