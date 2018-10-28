//
//  UIViewController+NavigationBar.h
//  UFA
//
//  Created by YangLin on 2017/7/10.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationBar)


/**
 设置导航栏右边按钮
 
 @param title 按钮标题
 @param action 按钮标题
 */
- (void)rightBarTitle:(NSString *)title action:(SEL)action;


/**
  设置导航栏右边按钮

 @param title 按钮标题
 @param color 文字颜色
 @param action 按钮标题
 */
- (void)rightBarTitle:(NSString *)title color:(UIColor *)color action:(SEL)action;
/**
 设置导航栏右边按钮
 
 @param image 按钮图片
 @param action 事件
 */
- (void)rightBarImage:(NSString *)image action:(SEL)action;


/**
 设置导航栏左边按钮

 @param image 按钮图片
 @param action 事件
 */
- (void)leftBarImage:(NSString *)image action:(SEL)action;
@end
