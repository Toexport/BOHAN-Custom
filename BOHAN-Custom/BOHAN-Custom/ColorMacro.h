//
//  ColorMacro.h
//  AppKit
//
//  Created by YangLin on 2017/12/18.
//  Copyright © 2017年 YangLin. All rights reserved.
//

#ifndef ColorMacro_h
#define ColorMacro_h

//颜色宏定义
#define RGBColor(R,G,B,A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]
#define rgbColor(R,G,B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]

//主色调
#define kDefualtColor [UIColor getColor:@"3c94f2"]

//控制器背景色
#define kBackBackroundColor [UIColor getColor:@"fafafa"]

//主字体颜色
#define kTextColor [UIColor getColor:@"5c5c5c"]

#define kSeparatorColor rgbColor(242, 242, 242)

#endif /* ColorMacro_h */
