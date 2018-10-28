//
//  UIBarButtonItem+Button.m
//  Bohan
//
//  Created by summer on 2018/9/12.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "UIBarButtonItem+Button.h"
#import "UIView+Frame.h"
@implementation UIBarButtonItem (Button)
+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image higlImage:(UIImage *)highImage target:target action:(SEL)action {
    //导航栏的左右两边  若是自定义的按钮  系统会自动扩充可点击面积  包装一个view就没事了
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highImage forState:UIControlStateHighlighted];
    [btn sizeToFit];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    UIView *buttonView = [[UIView alloc] initWithFrame:btn.bounds];
    //    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectInset(btn.bounds, -5, 0)];
    
    
    [buttonView addSubview:btn];
    return [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    
    
}
+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image selImage:(UIImage *)selImage target:target action:(SEL)action{
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selImage forState:UIControlStateSelected];
    [btn sizeToFit];
    
    //监听
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    
    UIView *buttonView = [[UIView alloc] initWithFrame:btn.bounds];
    [buttonView addSubview:btn];
    return [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    
}
+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title  target:target action:(SEL)action {
    //导航栏的左右两边  若是自定义的按钮  系统会自动扩充可点击面积  包装一个view就没事了
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //    [btn sizeToFit];
    btn.lq_width = 70;
    btn.lq_height = 30;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    UIView *buttonView = [[UIView alloc] initWithFrame:btn.bounds];
    [buttonView addSubview:btn];
    return [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    
    
}

//导航栏返回按钮
+ (UIBarButtonItem *)backItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:target action:(SEL)action {
    UIButton *backBtn = [[UIButton alloc] init];
    
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn setImage:highImage forState:UIControlStateHighlighted];
    //    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    //设置按钮字体颜色  <设置字体大小 一定要在normal状态下设置字体大小 >
    //    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //        backBtn.backgroundColor = [UIColor blueColor];
    backBtn.frame = CGRectMake(0, 0, 35, 35);
    //    [backBtn sizeToFit];
    
    //设置按钮内边距 调整位置  按道理超出父控件的 会不显示  但是因为在导航栏 系统内部做了处理，左边右边是按钮的 系统会自动扩充按钮的面积
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    
    
    //覆盖了系统做法 就没有系统的默认返回 也没有了点击屏幕侧边返回的功能
    //监听点击 返回
    [backBtn addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    
    return [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}
@end
