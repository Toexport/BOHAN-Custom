//
//  NetworkRequest+Utils.h
//  AppKit
//
//  Created by YangLin on 2017/12/18.
//  Copyright © 2017年 YangLin. All rights reserved.
//

#import "NetworkRequest.h"

@interface NetworkRequest (Utils)

- (NSString *)urlStrHandle:(NSString *)urlSt;

- (NSDictionary *)paramaterHandle:(NSDictionary *)paramater sign:(BOOL)sign;

- (NSString *)soapWithMethodName:(NSString *)method parameters:(NSDictionary *)parameters;

- (void)resultHandleWithResponse:(id)responseObject complationBlock:(CompletionBlock)block;

- (NSDictionary *)xmlParse:(NSXMLParser *)parse methodName:(NSString *)method;

@end
