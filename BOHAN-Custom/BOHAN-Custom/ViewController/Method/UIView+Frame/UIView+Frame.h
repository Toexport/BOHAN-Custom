//
//  UIView+Frame.h
//  Bohan
//
//  Created by summer on 2018/9/12.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property CGFloat lq_x;
@property CGFloat lq_y;
@property CGFloat lq_width;
@property CGFloat lq_height;
@property CGFloat lq_centerX;
@property CGFloat lq_centerY;
@property CGFloat lq_bottom;
@property CGFloat lq_right;

@end


@interface UIView (cornerRadius)

-(void)setMyCornerRadius:(CGFloat)cornerRadius;

@end
