//
//  CountDownViewController.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/26.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileHeader.pch"
@interface CountDownViewController : UIViewController<GCDAsyncSocketDelegate,UITextFieldDelegate> {
    __weak IBOutlet UIButton * DelayClosingBut;
    __weak IBOutlet UIView * PatchVIew;
    NSString * State1;    // 开关状态1
    NSString * State2;   // 开关状态2
    NSString * State3;  // 开关状态3
    NSString * State4; // 开关状态4
    
    NSString * Switch1;    // 开关数据1
    NSString * Switch2;   // 开关数据2
    NSString * Switch3;  // 开关数据3
    NSString * Switch4; // 开关数据4
    NSString * Ymdhms; 
    
    NSString * string1;
    NSString * string2;
    NSString * string3;
    NSString * string4;
    NSString * string5;
    NSString * string6;
    NSString * string7;
    
    }
@property (nonatomic, copy) NSString * deviceNo; // 设备Id
@property (nonatomic, strong) NSString * SwitchStr; // 开关数据（开，关）
@property (nonatomic, assign) NSInteger type; // 识别号
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * PatchViewLayoutConstraint;

@end
