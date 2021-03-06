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
#import "NSTimer+Action.h"

@interface ZHeartBeatSocket() <GCDAsyncSocketDelegate>{
    NSString *_getStr;
    BOOL _isInContentPerform;
}

typedef NS_ENUM (NSInteger, BHSocketLinkStyle) {
    HBSocketNoHartbeat,
    HBSocketNoQueryData,
    HBSocketDidQueryData,
};

@property (nonatomic, retain) NSTimer *connectTimer; // 计时器
@property (nonatomic, weak) id<ZHSocketDelegate> delegate;
@property (nonatomic, strong) BHStrFinishBlock block;
@property (nonatomic, assign) BHSocketLinkStyle linkStyle;
@property (nonatomic, strong) NSTimer *timer;

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

- (void)updateDelegate:(id)delegate {
    _delegate = delegate;
}

- (void)disContennct {
    _isInContentPerform = YES;
    [self.asyncSocket disconnect];
}

- (void)stopBeatHart {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
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
        //        [self heartbeat];
    }
}
- (void)IDdata:(BHStrFinishBlock)block {
    _block = block;
    NSString * RadioStr = @"E7AAAAAAAAAAAA00000000FC0D";
    [BHSocket writeData:[RadioStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
}

- (void)heartbeat {
    //    self.linkStyle = HBSocketDidQueryData;
    /*
     *此处是一个心跳请求链接（自己的服务器），Timeout时间随意
     */
//    NSString * strrrr = @"E770181102000100260000C20D";
    if (IdStrS) {
        NSString * str = [NSString stringWithFormat:@"%@%@",IdStrS,SwitchqueryStr];
        NSString * string = [Utils hexStringFromString:str];
        NSString * CheckCode = [string substringFromIndex:2]; // 去掉首字符
        NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@",HeadStr,IdStrS,SwitchqueryStr,CheckCode,TailStr];
        [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
        [BHSocket readDataWithTimeout:-1 tag:0];
        NSLog(@"heart live-----------------");
        NSLog(@"%@",_asyncSocket);
    }
}

#pragma mark - <GCDasyncSocketDelegate>
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err{
    [_asyncSocket disconnect];
    [_asyncSocket disconnectAfterReading];
    [_asyncSocket disconnectAfterWriting];
    [_asyncSocket disconnectAfterReadingAndWriting];
    // 服务器掉线，重连，必须添加
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
    [self IDdata:^(NSString *string) {
        if (!IdStrS) {
            IdStrS = string;
            [self heartbeat];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^{
                [self heartbeat];
            } repeats:YES];
        }
    }];
    
    [self creatSocket];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    if ([self.delegate respondsToSelector:@selector(socket:didReadData:withTag:)]) {
        [self.delegate socket:sock didReadData:data withTag:tag];
    }
    _getStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (_getStr.length > 14) {
        self.block([_getStr substringWithRange:NSMakeRange(2, 12)]);
    }
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
