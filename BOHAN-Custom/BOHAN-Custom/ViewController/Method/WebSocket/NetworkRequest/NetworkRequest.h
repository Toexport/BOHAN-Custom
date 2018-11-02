//
//  NetworkRequest.h
//  AppKit
//
//  Created by YangLin on 2017/12/18.
//  Copyright © 2017年 YangLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^CompletionBlock)(id response, NSError *error);

@interface NetworkRequest : NSObject

@property (nonatomic, strong, readonly) AFHTTPSessionManager *session;

+ (instancetype)sharedInstance;

- (void)requestWithUrl:(NSString *)urlStr parameter:(NSDictionary *)paramater completion:(CompletionBlock)block;


//- (void)requestSignWithUrl:(NSString *)urlStr parameter:(NSDictionary *)paramater completion:(CompletionBlock)block;
@end
