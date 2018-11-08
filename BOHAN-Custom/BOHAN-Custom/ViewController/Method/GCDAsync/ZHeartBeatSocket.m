//
//  ZHeartBeatSocket.m
//  BOHAN-Custom
//
//  Created by summer on 2018/11/7.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import "ZHeartBeatSocket.h"
#import <UIKit/UIKit.h>

#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>

//#define SocketHOST @"192.168.3.253"         //服务器ip地址
//#define SocketonPort 6878                   //服务器端口号
#define SocketHartKey @"0026"               //心跳包的指令

@interface ZHeartBeatSocket() <GCDAsyncSocketDelegate>{
    NSString *_getStr;
    BOOL _isInContentPerform;
}

@property (nonatomic, retain) NSTimer *connectTimer; // 计时器
@property (nonatomic, weak) id<ZHSocketDelegate> delegate;
@end

@implementation ZHeartBeatSocket

//单例
+ (instancetype)shareZheartBeatSocket{
    static dispatch_once_t onceToken;
    static ZHeartBeatSocket *instance;
    dispatch_once(&onceToken, ^{
        instance = [[ZHeartBeatSocket alloc]init];
    });
    return instance;
}

//初始化 GCDAsyncSocket
- (void)initZheartBeatSocketWithDelegate:(id)delegate {
    _delegate = delegate;
    [self creatSocket];
    
    //注册APP退到后台，之后每十分钟发送的通知，与VOIP无关，由于等待时间必须大于600s，不使用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatSocket) name:@"CreatGcdSocket" object:nil];
}

//INT_MAX 最大时间链接，心跳必须!
-(void)creatSocket{
    if (_asyncSocket == nil || [_asyncSocket isDisconnected]) {
        _asyncSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_asyncSocket enableBackgroundingOnSocket];
        NSError *err = nil;
        NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_USERNAME_PASSWORD_KEY_TitleName_IP_PORT_Name1_Name2_Name3_Name4];
        if(![_asyncSocket connectToHost:[usernamepasswordKVPairs objectForKey:KEY_IP] onPort:[[usernamepasswordKVPairs objectForKey:KEY_PORT] intValue] error:&err]) {
            [SVProgressHUD showInfoWithStatus:(@"Connection Succse")];
        }else {
            [SVProgressHUD showWithStatus:@"Loading..."];
        }
    }else {
        //读取Socket通讯内容
        [_asyncSocket readDataWithTimeout:INT_MAX tag:0];
        NSLog(@"socket通讯连接成功");
        //编写Socket通讯提交服务器
        NSString *inputMsgStr = [NSString stringWithFormat:@"客户端收到%@",_getStr];
        NSString * content = [inputMsgStr stringByAppendingString:@"\r\n"];
        NSData *data = [content dataUsingEncoding:NSISOLatin1StringEncoding];
        [_asyncSocket writeData:data withTimeout:INT_MAX tag:0];
        
        [self heartbeat];
    }
}

- (void)heartbeat{
    /*
     *此处是一个心跳请求链接（自己的服务器），Timeout时间随意
     */
    [_asyncSocket writeData:[SocketHartKey dataUsingEncoding:NSISOLatin1StringEncoding] withTimeout:INT_MAX tag:0];
    NSLog(@"heart live-----------------");
}

#pragma mark - <GCDasyncSocketDelegate>
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err{
    [_asyncSocket disconnect];
    [_asyncSocket disconnectAfterReading];
    [_asyncSocket disconnectAfterWriting];
    [_asyncSocket disconnectAfterReadingAndWriting];
    // 服务器掉线，重连（不知道为什么我们的服务器没两分钟重连一次），必须添加
    if (!_isInContentPerform) {
        _isInContentPerform = YES;
        [self performSelector:@selector(perform) withObject:nil afterDelay:2];
    }
}

- (void)perform{
    _isInContentPerform = NO;
    //_asyncSocket  = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_USERNAME_PASSWORD_KEY_TitleName_IP_PORT_Name1_Name2_Name3_Name4];
    [_asyncSocket connectToHost:[usernamepasswordKVPairs objectForKey:KEY_IP] onPort:[[usernamepasswordKVPairs objectForKey:KEY_PORT] intValue] withTimeout:INT_MAX error:&error];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    [self creatSocket];
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    //接收到消息。
    if ([self.delegate respondsToSelector:@selector(socket:didReadData:withTag:)]) {
        [self.delegate socket:sock didReadData:data withTag:tag];
    }
    _getStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self creatSocket];
}

#pragma mark - <可选接入，当服务器退入后台启动timer,包括之前所有的>
- (void)runTimerWhenAppEnterBackGround{
    // 每隔30s像服务器发送心跳包
    if (self.connectTimer == nil) {
        self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(heartbeat) userInfo:nil repeats:YES];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:self.connectTimer forMode:NSDefaultRunLoopMode];
    }
    [self.connectTimer fire];
    
    //配置所有添加RunLoop后台的NSTimer可用!
    UIApplication* app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(),^{
            if(bgTask != UIBackgroundTaskInvalid){
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(bgTask != UIBackgroundTaskInvalid){
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    
}

@end
