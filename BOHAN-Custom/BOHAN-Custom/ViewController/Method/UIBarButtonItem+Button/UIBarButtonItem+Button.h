//
//  UIBarButtonItem+Button.h
//  Bohan
//
//  Created by summer on 2018/9/12.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Button)
+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image higlImage:(UIImage *)highImage target:target action:(SEL)action;

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image selImage:(UIImage *)selImage target:target action:(SEL)action;

+ (UIBarButtonItem *)backItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:target action:(SEL)action;

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title  target:target action:(SEL)action;
@end
