//
//  EdgetTextField.m
//  UFA
//
//  Created by YangLin on 2017/7/17.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "EdgetTextField.h"
//#import "DebuggingANDPublishing.pch"
@implementation EdgetTextField



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += _leftViewSpacing;
    return iconRect;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super rightViewRectForBounds:bounds];
    iconRect.origin.x += _rightViewSpacing;
    return iconRect;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super placeholderRectForBounds:bounds];
    iconRect.origin.x += _placeHolderSpacing;
    return iconRect;

}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super textRectForBounds:bounds];
    iconRect.origin.x += _textSpacing;
    return iconRect;
}


- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super textRectForBounds:bounds];
    iconRect.origin.x += _editSpacing;
    return iconRect;

}

@end
