//
//  InformationViewCell.m
//  BOHAN-Custom
//
//  Created by summer on 2018/10/28.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import "InformationViewCell.h"
#import "FileHeader.pch"

@implementation InformationViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.Switch1.backgroundColor = [UIColor redColor];
//    self.Switch2.backgroundColor = [UIColor redColor];
//    self.Switch3.backgroundColor = [UIColor redColor];
//    self.Switch4.backgroundColor = [UIColor redColor];
    self.Switch1.transform = CGAffineTransformMakeScale( 1.1, 1.1);//缩放
    self.Switch2.transform = CGAffineTransformMakeScale( 1.1, 1.1);//缩放
    self.Switch3.transform = CGAffineTransformMakeScale( 1.1, 1.1);//缩放
    self.Switch4.transform = CGAffineTransformMakeScale( 1.1, 1.1);//缩放
}

- (IBAction)Switch1:(UISwitch *)sender {
    if (sender.isOn) {
//        self.Switch1.backgroundColor = [UIColor colorWithHexString:@"54d76a"];
        self.switch1ONButBlock(self.Switch1);
        ZPLog(@"开");
    }else {
//        self.Switch1.backgroundColor = [UIColor redColor];
        self.switch1OFFButBlock(self.Switch1);
        ZPLog(@"关");
    }
}

- (IBAction)Switch2:(UISwitch *)sender {
    if (sender.isOn) {
//        self.Switch2.backgroundColor = [UIColor colorWithHexString:@"54d76a"];
        self.switch2ONButBlock(self.Switch2);
        ZPLog(@"开");
    }else {
//        self.Switch2.backgroundColor = [UIColor redColor];
        self.switch2OFFButBlock(self.Switch2);
        ZPLog(@"关");
    }
}

- (IBAction)Switch3:(UISwitch *)sender {
    if (sender.isOn) {
        self.switch3ONButBlock(self.Switch3);
//         self.Switch3.backgroundColor = [UIColor colorWithHexString:@"54d76a"];
        ZPLog(@"开");
    }else {
        self.switch3OFFButBlock(self.Switch3);
//         self.Switch3.backgroundColor = [UIColor redColor];
        ZPLog(@"关");
    }
}

- (IBAction)Switch4:(UISwitch *)sender {
    if (sender.isOn) {
        self.switch4ONButBlock(self.Switch4);
//         self.Switch4.backgroundColor = [UIColor colorWithHexString:@"54d76a"];
        ZPLog(@"开");
    }else {
        self.switch4OFFButBlock(self.Switch4);
//        self.Switch4.backgroundColor = [UIColor redColor];
        ZPLog(@"关");
    }
}

// 倒计时
- (IBAction)CountdownBtn:(UIButton *)sender {
    self.countdownBtnBlock(self.CountdownBtn);
}

@end
