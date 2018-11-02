//
//  SoapManager.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/5.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "SoapManager.h"
#import "AdapationMacro.h"
//static NSString *const defaultWebServiceNameSpace = @"http://bohansever.top/";

//static NSString *const httpServer=@"http://www.bohanserver.top:8088/webservice.asmx/wsdl"; // 原始地址接口
//static NSString *const httpServer=@"http://122.10.97.35/webservice.asmx?wsdl"; // 香港地址接口
static NSString *const httpServer=@"192.168.3.254:2323"; // 测试
static NSString *const nameSpace=@"http://bohansever.top/";
//static NSString *const nameSpace=@"http://192.168.3.254:23/";// 测试

//static NSString *const serviceURL=@"http://www.bohanserver.top:8088/"; // 原始接口
//static NSString *const serviceURL=@"http://122.10.97.35:8088/"; // 香港接口
static NSString *const serviceURL=@"http://192.168.3.254:2323"; // 测试接口

//soap 1.1请求方式
static NSString *const defaultSoap1Message = @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">%@<soap:Body>%@</soap:Body></soap:Envelope>";

//soap 1.2请求方式
static NSString *const defaultSoap12Message = @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">%@<soap12:Body>%@</soap12:Body></soap12:Envelope>";

@implementation SoapManager

+ (instancetype)manager {
    static SoapManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SoapManager alloc] init];
        instance.soapType = SoapType_soap;
    });
    return instance;
}

- (void)soapWithMethodName:(NSString*)methodName soapHeader:(NSString *)soapHeader headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters {
    self.methodName = methodName;
    self.soapHeader = soapHeader;
    self.headers = headers;
    self.parameters = parameters;
}

-(NSString*)defaultSoapMesage{
    if (self.soapType==SoapType_soap) {
        return defaultSoap1Message;
    }
    return defaultSoap12Message;
}

-(NSDictionary*)headers{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    if (_headers&&[_headers count]>0) {
        
        dic = [_headers mutableCopy];
        //        return dic;
        //        return _headers;
    }
    
//    [dic setValue:serviceURL forKey:@"Host"];
    
    if (self.soapType==SoapType_soap) {
        [dic setValue:@"text/xml; charset=utf-8" forKey:@"Content-Type"];
        
        NSString *soapAction=[NSString stringWithFormat:@"%@%@",nameSpace,self.methodName]; //httpServer
        if ([soapAction length]>0) {
            [dic setValue:soapAction forKey:@"SOAPAction"];
        }
    }
    if (self.soapType==SoapType_soap12) {
        [dic setValue:@"application/soap+xml; charset=utf-8" forKey:@"Content-Type"];
    }
    [dic setValue:[NSString stringWithFormat:@"%d",(int)[[self soapBodyMessage] length]] forKey:@"Content-Length"];
    ZPLog(@"请求头为:%@",dic);
    
    //    if (self.httpWay==ASIServiceHttpGet) {
    //        return [NSMutableDictionary dictionaryWithObjectsAndKeys:[self hostName],@"Host", nil];
    //    }
    return dic;
    
}

#pragma mark -
#pragma mark 公有方法
- (NSString*)stringSoapMessage:(NSArray*)params{
    
    NSString *soap = self.soapType==SoapType_soap?@"soap":@"soap12";
    
    NSString *startNode=[NSString stringWithFormat:@"<%@:Header>",soap];
    NSString *endNode=[NSString stringWithFormat:@"</%@:Header>",soap];
    
    NSString *xmlnsStr=[nameSpace length]>0?[NSString stringWithFormat:@" xmlns=\"%@\"",nameSpace]:@"";
    
    NSString *header = @"";
    if ([_headers count]>0) {
        if (_soapHeader&&[_soapHeader length]>0) {
            header = [self soapName:_soapHeader xmlnStr:xmlnsStr params:_headers];
        }else {
            header=[self soapName:nil xmlnStr:xmlnsStr params:_headers];
        }
        header=[NSString stringWithFormat:@"%@%@%@",startNode,header,endNode];;
    }
    
    if ([self.parameters count]>0) {
        NSString *soap=[self soapName:self.methodName xmlnStr:xmlnsStr params:self.parameters];
        return [NSString stringWithFormat:[self defaultSoapMesage],header,soap];
    }
    NSString *body=[NSString stringWithFormat:@"<%@%@ />",[self methodName],xmlnsStr];
    return [NSString stringWithFormat:[self defaultSoapMesage],header,body];
}

- (NSString *)soapName:(NSString *)name xmlnStr:(NSString *)xmlnStr params:(NSDictionary *)params {
    if ([params count]>0) {
        NSMutableString *soap = [@"" mutableCopy];
        if (name && name.length>0) {
            soap=[NSMutableString stringWithFormat:@"<%@%@>",name,xmlnStr];
        }
        for (NSString *key in params) {
            [soap appendFormat:@"<%@>",key];
            [soap appendString:[params objectForKey:key]];
            [soap appendFormat:@"</%@>",key];
        }
        //可有可无
//        [soap appendString:[self paramsFormatString:self.soapParams]];
        
        if (name && name.length>0) {
            [soap appendFormat:@"</%@>",name];
        }
        return soap;
    }
    
    return @"";
}

-(NSString*)paramsFormatString:(NSArray*)params {
    NSMutableString *xml=[NSMutableString stringWithFormat:@""];
    for (NSDictionary *item in params) {
        NSString *key=[[item allKeys] objectAtIndex:0];
        [xml appendFormat:@"<%@>",key];
        [xml appendString:[item objectForKey:key]];
        [xml appendFormat:@"</%@>",key];
    }
    return xml;
}

- (NSString*)soapBodyMessage{
    if (_bodyMessage&&[_bodyMessage length]>0) {
        return _bodyMessage;
    }
    return [self stringSoapMessage:[self soapParams]];
}

@end
