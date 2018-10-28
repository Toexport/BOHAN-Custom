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


#ifdef DEBUG
# define DBLog(format,...) NSLog((@"[%s][%s][%d]" format), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DBLog(...);
#endif

//国际化
#define Localize(key) NSLocalizedString(key,@"")

// 弱引用
#define MyWeakSelf __weak typeof(self) weakSelf = self;

// 强引用
#define MyStrongSelf __weak typeof(self) strongSelf = weakSelf;



#endif /* AdapationMacro_h */
