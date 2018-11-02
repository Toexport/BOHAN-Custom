//
//  WebSocket+Utils.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/12.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "WebSocket+Utils.h"
#import "CommandModel.h"
#import "Utils.h"
#import "SocketRocketUtility.h"
#import "NSError+Message.h"
#import "FileHeader.pch"
@implementation WebSocket (Utils)


- (NSString *)singleDataStringWithModel:(CommandModel *)model
{
    
    NSString *stringLengh = @"0000";
    NSString *conent = @"";
    if (model.content && model.content.length >0) {
        stringLengh = [Utils getHexByDecimal:model.content.length/2];
        conent = model.content;
    }
    
    NSString *string = [NSString stringWithFormat:@"%@%@%@%@",model.deviceNo, model.command, stringLengh, conent];
    
    if (string.length%2 != 0) {
        string = [string stringByAppendingString:@"0"];
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    
    int result = 0;
    for (NSUInteger i = 0; i + 2 <= string.length; i += 2) {
        NSString *subString = [string substringWithRange:NSMakeRange(i, 2)];
        
        [arr addObject:subString];
        int intResult;
        [[NSScanner scannerWithString:subString] scanHexInt:&intResult];
        result += intResult;
    }
    
    NSString *amountStr = [Utils getHexByDecimal:result];
    amountStr = [amountStr substringFromIndex:amountStr.length - 2];

    [arr addObject:amountStr];

    return [NSString stringWithFormat:@"E7%@0D",[arr componentsJoinedByString:@""]];
    
}



- (NSString *)multiDataStringWithModel:(CommandModel *)model
{
    NSString *conent = @"";
    if (model.content && model.content.length >0) {
        conent = model.content;
    }
    NSString *string = [NSString stringWithFormat:@"%@%04lu%@", model.command, conent.length, conent];
    
    return [NSString stringWithFormat:@"3A%@0D",string];

}


@end
