//
//   AdapationMacro.h
//  AppKit
//
//  Created by YangLin on 2017/12/19.
//  Copyright © 2017年 YangLin. All rights reserved.
//

#ifndef AdapationMacro_h
#define AdapationMacro_h

/*获取屏幕大小*/
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

#define HeightScale            ScreenHeight/667.0
#define WidthScale             (ScreenWidth)/375.0
#define Height(height_iphone6) height_iphone6*HeightScale
#define Width(width_iphone6)   width_iphone6*WidthScale

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight (kStatusBarHeight>20?83:49)
#define kTabBarBottom (kTabBarHeight- 49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)


//版本号
#define CURRENTVERSION  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define CURRENTSHORTVERSION  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//bundleIdentifier
#define BUNDLEIDENTIFIER  [[NSBundle mainBundle] bundleIdentifier]

#define notNull(s)  (s || ![s isKindOfClass:[NSNull class]])

#define BohanID    @"1384571471"


//测试用这个
#ifdef DEBUG
#if TARGET_IPHONE_SIMULATOR//模拟器

#define ZPLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])

#elif TARGET_OS_IPHONE//真机

#define ZPLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])

#endif
#endif

////正式发布
//#else
//#ifdef zhengShiFaBu
//
//#define NSLog(...)
//
//#else
//
//#define NSLog(...) NSLog(__VA_ARGS__)
//
//#endif
//
//#endif
//
//#ifdef DEBUG // 调试状态, 打开LOG功能
//#define ZPLog(...) NSLog(__VA_ARGS__)
//#else // 发布状态, 关闭LOG功能
//#define ZPLog(...)


//国际化
#define Localize(key) NSLocalizedString(key,@"")

// 弱引用
#define MyWeakSelf __weak typeof(self) weakSelf = self;

// 强引用
#define MyStrongSelf __weak typeof(self) strongSelf = weakSelf;



#endif /* AdapationMacro_h */
