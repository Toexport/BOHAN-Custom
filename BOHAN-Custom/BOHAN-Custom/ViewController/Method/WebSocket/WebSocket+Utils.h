//
//  WebSocket+Utils.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/12.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "WebSocket.h"
@class CommandModel;
@interface WebSocket (Utils)

- (NSString *)singleDataStringWithModel:(CommandModel *)model;


- (NSString *)multiDataStringWithModel:(CommandModel *)model;

@end
