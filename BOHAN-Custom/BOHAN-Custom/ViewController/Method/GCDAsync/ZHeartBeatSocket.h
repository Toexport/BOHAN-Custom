//
//  ZHeartBeatSocket.h
//  BOHAN-Custom
//
//  Created by summer on 2018/11/7.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHeartBeatSocket : NSObject

+ (instancetype)shareZheartBeatSocket;
- (void)initZheartBeatSocket;               //创建单例内部的GCDAsyncSocket
- (void)runTimerWhenAppEnterBackGround;     //如果需要在APP进入后台开启NStimer

@end

NS_ASSUME_NONNULL_END
