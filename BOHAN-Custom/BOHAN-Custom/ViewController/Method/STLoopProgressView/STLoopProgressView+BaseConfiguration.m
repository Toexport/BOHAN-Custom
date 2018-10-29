//
//  STLoopProgressView+BaseConfiguration.m
//  STLoopProgressView
//
//  Created by TangJR on 7/1/15.
//  Copyright (c) 2015 tangjr. All rights reserved.
//

#import "STLoopProgressView+BaseConfiguration.h"
#import "FileHeader.pch"
#define DEGREES_TO_RADOANS(x) (M_PI * (x) / 180.0) // 将角度转为弧度

@implementation STLoopProgressView (BaseConfiguration)

+ (UIColor *)startColor {
    
    return [UIColor colorWithHexString:@"3ae2f3"];
}

+ (UIColor *)centerColor {
    
    return [UIColor yellowColor];
}

+ (UIColor *)endColor {
    
    return [UIColor colorWithHexString:@"44b1f4"];
}

+ (UIColor *)backgroundColor {
    
    return [UIColor colorWithRed:61.0 / 255.0 green:171.0 / 255.0 blue:255.0 / 255.0 alpha:0.4];
}

+ (CGFloat)lineWidth {
    
    return 20;
}

+ (CGFloat)startAngle {
    
    return DEGREES_TO_RADOANS(-90);
}

+ (CGFloat)endAngle {
    
    return DEGREES_TO_RADOANS(270);
}

+ (STClockWiseType)clockWiseType {
    return STClockWiseNo;
}

@end
