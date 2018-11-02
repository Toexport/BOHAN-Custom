//
//  XMLUtil.h
//  Bohan
//
//  Created by Yang Lin on 2017/12/30.
//  Copyright © 2017年 Bohan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLUtil : NSObject<NSXMLParserDelegate>

@property (nonatomic, strong) NSXMLParser *par;
@property (nonatomic, strong) NSMutableString *soapResults;

@property (nonatomic, assign) BOOL elementFound;
@property (nonatomic, copy) NSString *methodName;
@property (nonatomic, strong) NSDictionary *data;

@end
