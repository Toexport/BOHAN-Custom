//
//  NSError+Message.m
//  AppKit
//
//  Created by YangLin on 2017/12/19.
//  Copyright © 2017年 YangLin. All rights reserved.
//

#import "NSError+Message.h"
#import "FileHeader.pch"
@implementation NSError (Message)

- (NSError *)errorConvert{
    
    NSInteger code = self.code;
    NSString *string = self.localizedDescription;
    if (self.domain == NSYLErrorDomain) {
        
        return self;
    }else
    {
        switch (code) {
            case NSURLErrorUnknown:
                code = YLErrorUnknown;
                string = Localize(@"发送未知错误，请稍后再试");
                break;
            case NSURLErrorBadURL:
            case NSURLErrorUnsupportedURL:
                code = YLErrorBadURL;
                string = Localize(@"请求地址无效");
                break;
            case NSURLErrorTimedOut:
                code = YLErrorTimedOut;
                string = Localize(@"请求超时，请稍后再试");
                break;
            case NSURLErrorNotConnectedToInternet:
                code = YLErrorNoNetwork;
                string = Localize(@"当前无网络，请检查网络");
                break;
            case NSURLErrorCannotConnectToHost:
            case NSURLErrorCannotFindHost:
            case NSURLErrorNetworkConnectionLost:
            case NSURLErrorDNSLookupFailed:
                code = YLErrorHostLost;
                string = Localize(@"连接不上服务器，请稍后再试");
                break;
            default:
                code = YLErrorOther;
                string = self.localizedDescription;
                break;
        }
    }
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:string};

    NSError *newError = [NSError errorWithDomain:NSYLErrorDomain code:code userInfo:userInfo];
    
    return newError;
}

@end
