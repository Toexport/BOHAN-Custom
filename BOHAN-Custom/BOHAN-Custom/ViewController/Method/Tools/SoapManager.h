//
//  SoapManager.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/5.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, SoapType){
    SoapType_soap = 0,
    SoapType_soap12
};

@interface SoapManager : NSObject

/**
 *  请求URL
 */
@property(nonatomic,readonly) NSURL *webURL;
@property(nonatomic,readonly) NSString *defaultSoapMesage;

@property(nonatomic,assign)     SoapType soapType;


@property(nonatomic,copy)     NSString *serviceNameSpace;
/**
 *  调用的方法名
 */
@property(nonatomic,copy)     NSString *methodName;
/**
 *  请求字符串
 */
@property(nonatomic,copy,getter=requestBodyMessage)     NSString *bodyMessage;

/**
 *  请求参数
 */
@property(nonatomic,copy)     NSDictionary *parameters;

/**
 *  有认证的请求头设置
 */
@property(nonatomic,copy)     NSString *soapHeader;
/**
 *  请求头
 */
@property(nonatomic,copy)   NSDictionary *headers;
/**
 *  参数设置
 */
@property(nonatomic,copy)   NSArray *soapParams;

+ (instancetype)manager;
- (NSString*)soapBodyMessage;
- (void)soapWithMethodName:(NSString*)methodName soapHeader:(NSString *)soapHeader headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters;
@end
