//
//  XMLUtil.m
//  Bohan
//
//  Created by Yang Lin on 2017/12/30.
//  Copyright © 2017年 Bohan. All rights reserved.
//

#import "XMLUtil.h"
#import "FileHeader.pch"
@implementation XMLUtil


- (void)setPar:(NSXMLParser *)par
{
    _par = par;
    _par.delegate = self;
//    [_par parse];
}

//几个代理方法的实现，是按逻辑上的顺序排列的，但实际调用过程中中间三个可能因为循环等问题乱掉顺序
//开始解析
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    ZPLog(@"parserDidStartDocument...");
}
//准备节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    
//    DBLog(@"准备节点%@",elementName);
//    NSLog(@"self.methodName:%@",self.methodName);
//    NSLog(@"self:%@",self);
//    NSLog(@"解析中parse=%@, xml = %@",self.par,self);

    if ([elementName isEqualToString:[self.methodName stringByAppendingString:@"Result"]]) {
        if (!self.soapResults) {
            self.soapResults = [[NSMutableString alloc] init];
        }
        self.elementFound = YES;
    }
}
//获取节点内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{

    if (self.elementFound) {
        [self.soapResults appendString: string];
    }
}

//解析完一个节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{

//    NSLog(@"elementName:%@",elementName);
//    NSLog(@"self.methodName:%@",self.methodName);

    if ([elementName isEqualToString:[self.methodName stringByAppendingString:@"Result"]]) {
//        NSLog(@"匹配到%@",self.methodName);

        NSData *jsonData = [self.soapResults dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        self.data = dic;

        self.elementFound = FALSE;
    }

}

//解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    
//    NSLog(@"解析结束parse=%@, xml = %@",self.par,self);

    if (self.soapResults) {
        self.soapResults = nil;
    }
//    NSLog(@"self.methodName:%@,self.data:%@",self.methodName,self.data);

}

// 出错时，例如强制结束解析
- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if (self.soapResults) {
        self.soapResults = nil;
    }
}

@end
