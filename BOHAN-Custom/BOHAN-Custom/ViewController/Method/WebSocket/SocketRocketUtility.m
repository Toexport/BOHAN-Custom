//
//  SocketRocketUtility.m
//  SUN
//
//  Created by 孙俊 on 17/2/16.
//  Copyright © 2017年 SUN. All rights reserved.
//

#import "SocketRocketUtility.h"
#import "NSError+Message.h"
#import "FileHeader.pch"
#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}
@interface SocketRocketUtility()<SRWebSocketDelegate>
{
    NSTimeInterval reConnectTime;
    dispatch_semaphore_t sendSemaphore;
    dispatch_queue_t socketSendQueue;
    BOOL isWaiting;
    BOOL isFirst;
    
}

@property (nonatomic,strong) SRWebSocket *socket;
@property (nonatomic,strong) NSString *socketUrl;
@property (nonatomic,copy) CompletionBlock resultBlock;

@end

@implementation SocketRocketUtility


- (instancetype)initWithUrl:(NSString *)socketUrl
{
    if (self = [super init]) {
        
        self.socketUrl = socketUrl;
        sendSemaphore = dispatch_semaphore_create(0);
        [self webSocketOpen];     //开始连接;
    }
    
    return self;
}

- (SRWebSocket *)socket
{
    if (!_socket) {
        _socket = [[SRWebSocket alloc] initWithURLRequest:
                       [NSURLRequest requestWithURL:[NSURL URLWithString:self.socketUrl]]];//这里填写你服务器的地址
        
        _socket.delegate = self;   //SRWebSocketDelegate 协议
        socketSendQueue = dispatch_queue_create("com.bohan.socket.queue", NULL);
    }
    
    return _socket;
}

#pragma mark - **************** public methods


-(void)webSocketClose{
    [self.socket close];
    _socket = nil;
}

- (void)webSocketOpen{
    [self.socket open];
}

#define WeakSelf(ws) __weak __typeof(&*self)weakSelf = self
- (void)sendData:(NSString *)data resultBlock:(CompletionBlock)block{
    
//    if (isFirst) {
//        self.resultBlock = [block copy];
//    }
//    isFirst = NO;
    dispatch_async(socketSendQueue, ^{
        //一直等待，直到开启socket连接后，发送信号，才会继续执行，发送数据，收到发送的数据后再次发送信号，继续发送，保证同时只有一个线程发送数据。
        
        reConnectTime = 0;
        if (self.socket.readyState == SR_CLOSED) {
//            [self reConnect];
        }
        
        dispatch_semaphore_wait(sendSemaphore, DISPATCH_TIME_FOREVER);
//        long result = dispatch_semaphore_wait(sendSemaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)));
//        
//        if (result != 0) {
//            //超时
//            if (self.resultBlock) {
//
//                NSError *error = [NSError errorWithDomain:NSYLErrorDomain code:YLErrorTimedOut userInfo:@{NSLocalizedDescriptionKey:@"请求超时"}];
//
//                dispatch_main_async_safe( ^{
//                    self.resultBlock(nil, error.errorConvert);
//                    self.resultBlock = nil;
//                });
//
//            }
////
////            if (isWaiting) {
////                dispatch_semaphore_signal(sendSemaphore);
////                isWaiting = NO;
////                DBLog(@"发送信号");
////
////            }
//
//        }
//
        isWaiting = YES;
        self.resultBlock = [block copy];//copy后修改将self.resultBlock设置为nil不影响回调，并且能将未调用的回调重新调用
        ZPLog(@"socketSendData --------------- %@",data);
        
        if (self.socket.readyState == SR_OPEN) {
            [self.socket send:data];    // 发送数据
//            NSString * str = [NSString stringWithFormat:@"%@",data];
//            NSString  * string =[str substringWithRange:NSMakeRange(2, 34)];
//            [self.socket send:string];    // 发送数据
//             ZPLog(@"socketSendData --------------- %@",data);
        }
        
    });
}

#pragma mark - **************** private mothodes
//重连机制
- (void)reConnect
{
    
    //超过一分钟就不再重连 所以只会重连5次 2^5 = 64
    if (reConnectTime > 64) {
        //您的网络状况不是很好，请检查网络后重试
        return;
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reConnectTime * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        if (self.socket.readyState == SR_CLOSED) {
//            [self.socket open];     //开始连接;
            [self webSocketClose];
            [self webSocketOpen];
        }
        ZPLog(@"重连");
//        [HintView showHint:@"账号在其他设备上登录，非本人操作请尽快修改密码"];

    });
    
    //重连时间2的指数级增长
    if (reConnectTime == 0) {
        reConnectTime = 2;
    }else{
        reConnectTime *= 2;
    }
}


#pragma mark - socket delegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    //每次正常连接的时候清零重连时间
    reConnectTime = 0;
    ZPLog(@"************************** socket 连接成功************************** ");
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        isFirst = YES;
        dispatch_semaphore_signal(sendSemaphore);
        isWaiting = NO;
        ZPLog(@"发送信号1");
    });
    
    if (isWaiting) {
        dispatch_semaphore_signal(sendSemaphore);
        isWaiting = NO;
        ZPLog(@"发送信号2");
    }
    
    //
//    if (!self.resultBlock) {
//        isFirst = YES;
//    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    
    ZPLog(@"************************** socket 连接失败************************** ");
    
    if (self.resultBlock) {
        
        dispatch_main_async_safe( ^{
            
            NSError *error = [NSError errorWithDomain:NSYLErrorDomain code:YLErrorSocketConnectFailed userInfo:@{NSLocalizedDescriptionKey:Localize(@"设备连接失败,正在重新连接")}];

            self.resultBlock(nil, error.errorConvert);
            self.resultBlock = nil;
        });
        
    }
    
//    if (isWaiting) {
//        dispatch_semaphore_signal(sendSemaphore);
//        isWaiting = NO;
//        DBLog(@"发送信号");
//
//    }
    
    //连接失败就重连
    [self reConnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    
    ZPLog(@"************************** socket连接关闭************************** ");
    ZPLog(@"被关闭连接，code:%ld,reason:%@,wasClean:%d",(long)code,reason,wasClean);
//    [HintView showHint:@"账号在其他设备上登录，非本人操作请尽快修改密码"];
    if (self.resultBlock) {
        
        NSError *error = [NSError errorWithDomain:NSYLErrorDomain code:YLErrorSocketClose userInfo:@{NSLocalizedDescriptionKey:Localize(@"设备连接关闭,正在重新连接")}];
        
        dispatch_main_async_safe( ^{
            self.resultBlock(nil, error.errorConvert);
            self.resultBlock = nil;
        });
    }
    
//    if (isWaiting) {
//        dispatch_semaphore_signal(sendSemaphore);
//        isWaiting = NO;
//        DBLog(@"发送信号");
//    }

    [self reConnect];

}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message  {
    
    ZPLog(@"************************** socket收到数据了************************** ");
    ZPLog(@"message:%@",message);

    if (webSocket == self.socket) {
        
        NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        NSString *content = dic[@"content"];
        
        ZPLog(@"回调block=%@",self.resultBlock);

        if (!err && [[dic[@"statusCode"] stringValue] isEqualToString:@"0"]) {
            
            if (self.resultBlock) {
                
                dispatch_main_async_safe( ^{
                    self.resultBlock(content, nil);
                    self.resultBlock = nil;
                });
            }
        }else
        {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:[dic[@"statusCode"] integerValue] userInfo:@{NSLocalizedDescriptionKey:dic[@"message"]}];
            if (self.resultBlock) {
                
                dispatch_main_async_safe( ^{
                    self.resultBlock(nil, error);
                    self.resultBlock = nil;
                });
            }
        }
    }
    
    if (isWaiting) {
        dispatch_semaphore_signal(sendSemaphore);
        isWaiting = NO;
        ZPLog(@"发送信号");
        
    }
}

#pragma mark - **************** setter getter
- (SRReadyState)socketReadyState{
    return self.socket.readyState;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
