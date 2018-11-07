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
    self.Switch1.transform = CGAffineTransformMakeScale( 1.1, 1.1);//缩放
    self.Switch2.transform = CGAffineTransformMakeScale( 1.1, 1.1);//缩放
    self.Switch3.transform = CGAffineTransformMakeScale( 1.1, 1.1);//缩放
    self.Switch4.transform = CGAffineTransformMakeScale( 1.1, 1.1);//缩放
}

- (IBAction)Switch1:(UISwitch *)sender {
    if (sender.isOn) {
        self.switch1ONButBlock(self.Switch1);
        ZPLog(@"开");
    }else {
        self.switch1OFFButBlock(self.Switch1);
        ZPLog(@"关");
    }
}

- (IBAction)Switch2:(UISwitch *)sender {
    if (sender.isOn) {
        self.switch2ONButBlock(self.Switch2);
        ZPLog(@"开");
    }else {
        self.switch2OFFButBlock(self.Switch2);
        ZPLog(@"关");
    }
}

- (IBAction)Switch3:(UISwitch *)sender {
    if (sender.isOn) {
        self.switch3ONButBlock(self.Switch3);
        ZPLog(@"开");
    }else {
        self.switch3OFFButBlock(self.Switch3);
        ZPLog(@"关");
    }
}

- (IBAction)Switch4:(UISwitch *)sender {
    if (sender.isOn) {
        self.switch4ONButBlock(self.Switch4);
        ZPLog(@"开");
    }else {
        self.switch4OFFButBlock(self.Switch4);
        ZPLog(@"关");
    }
}

// 倒计时1
- (IBAction)Countdown1Btn:(UIButton *)sender {
    self.countdown1BtnBlock(self.Countdown1Btn);
}

// 倒计时2
- (IBAction)Countdown2Btn:(UIButton *)sender {
    self.countdown2BtnBlock(self.Countdown2Btn);
}

// 倒计时3
- (IBAction)Countdown3Btn:(UIButton *)sender {
    self.countdown3BtnBlock(self.Countdown3Btn);
}

// 倒计时4
- (IBAction)Countdown4Btn:(UIButton *)sender {
    self.countdown4BtnBlock(self.Countdown4Btn);
}

@end
