//
//  NSError+Message.h
//  AppKit
//
//  Created by YangLin on 2017/12/19.
//  Copyright © 2017年 YangLin. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "FileHeader.pch"
static NSString *const NSYLErrorDomain = @"NSYLErrorDomain";

NS_ERROR_ENUM(NSYLErrorDomain)
{
    YLErrorUnknown = 0,//未知错误
    YLErrorBadURL = 1,//请求地址无效
    YLErrorTimedOut = 2,//请求超时
    YLErrorNoNetwork = 3,//无网络
    YLErrorHostLost = 4,//连接不上服务器
    YLErrorServer = 5,//服务器故障
    YLErrorSocketClose = 6,//socket连接关闭
    YLErrorSocketConnectFailed = 7,//socket连接失败
//    UFAErrorAccount,//账号或密码错误
    YLErrorOther = 8,//其他错误
//
//
//    NSURLErrorUnknown =             -1,
//    NSURLErrorCancelled =             -999,
//    NSURLErrorBadURL =                 -1000,
//    NSURLErrorTimedOut =             -1001,
//    NSURLErrorUnsupportedURL =             -1002,
//    NSURLErrorCannotFindHost =             -1003,
//    NSURLErrorCannotConnectToHost =         -1004,
//    NSURLErrorNetworkConnectionLost =         -1005,
//    NSURLErrorDNSLookupFailed =         -1006,
//    NSURLErrorHTTPTooManyRedirects =         -1007,
//    NSURLErrorResourceUnavailable =         -1008,
//    NSURLErrorNotConnectedToInternet =         -1009,
//    NSURLErrorRedirectToNonExistentLocation =     -1010,
//    NSURLErrorBadServerResponse =         -1011,
//    NSURLErrorUserCancelledAuthentication =     -1012,
//    NSURLErrorUserAuthenticationRequired =     -1013,
//    NSURLErrorZeroByteResource =         -1014,
//    NSURLErrorCannotDecodeRawData =             -1015,
//    NSURLErrorCannotDecodeContentData =         -1016,
//    NSURLErrorCannotParseResponse =             -1017,
//    NSURLErrorAppTransportSecurityRequiresSecureConnection API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0)) = -1022,
//    NSURLErrorFileDoesNotExist =         -1100,
//    NSURLErrorFileIsDirectory =         -1101,
//    NSURLErrorNoPermissionsToReadFile =     -1102,
//    NSURLErrorDataLengthExceedsMaximum API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0)) =    -1103,
//    NSURLErrorFileOutsideSafeArea API_AVAILABLE(macos(10.12.4), ios(10.3), watchos(3.2), tvos(10.2)) = -1104,
//
//    // SSL errors
//    NSURLErrorSecureConnectionFailed =         -1200,
//    NSURLErrorServerCertificateHasBadDate =     -1201,
//    NSURLErrorServerCertificateUntrusted =     -1202,
//    NSURLErrorServerCertificateHasUnknownRoot = -1203,
//    NSURLErrorServerCertificateNotYetValid =     -1204,
//    NSURLErrorClientCertificateRejected =     -1205,
//    NSURLErrorClientCertificateRequired =    -1206,
//    NSURLErrorCannotLoadFromNetwork =         -2000,
    
    
};


@interface NSError (Message)

/**
 错误转换方法

 @return 自定义的错误
 */
- (NSError *)errorConvert;
@end
