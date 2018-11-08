//
//  ZHeartBeatSocket.h
//  BOHAN-Custom
//
//  Created by summer on 2018/11/7.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZHSocketDelegate <NSObject>

@optional

/** 点击图片回调 */
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;

/** 图片滚动回调 */
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port;

@end

@interface ZHeartBeatSocket : NSObject
@property (nonatomic ,strong) GCDAsyncSocket *asyncSocket;


+ (instancetype)shareZheartBeatSocket;
- (void)initZheartBeatSocketWithDelegate:(id)delegate; //创建单例内部的GCDAsyncSocket
- (void)runTimerWhenAppEnterBackGround;                                 //如果需要在APP进入后台开启NStimer

@end

NS_ASSUME_NONNULL_END
