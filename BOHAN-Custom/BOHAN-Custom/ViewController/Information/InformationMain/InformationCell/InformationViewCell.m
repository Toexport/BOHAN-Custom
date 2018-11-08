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
//    sender.on = !sender.on;
    if (self.switchBlock) {
        self.switchBlock(sender.tag);
    }
}

- (IBAction)Switch2:(UISwitch *)sender {
//    sender.on = !sender.on;
    if (self.switchBlock) {
        self.switchBlock(sender.tag);
    }
}

- (IBAction)Switch3:(UISwitch *)sender {
//    sender.on = !sender.on;
    if (self.switchBlock) {
        self.switchBlock(sender.tag);
    }
}

- (IBAction)Switch4:(UISwitch *)sender {
//    sender.on = !sender.on;
    if (self.switchBlock) {
        self.switchBlock(sender.tag);
    }
}

// 倒计时1
- (IBAction)Countdown1Btn:(UIButton *)sender {
    if (self.switchBlock) {
        self.switchBlock(sender.tag);
    }
}

// 倒计时2
- (IBAction)Countdown2Btn:(UIButton *)sender {
    if (self.switchBlock) {
        self.switchBlock(sender.tag);
    }
}

// 倒计时3
- (IBAction)Countdown3Btn:(UIButton *)sender {
    if (self.switchBlock) {
        self.switchBlock(sender.tag);
    };
}

// 倒计时4
- (IBAction)Countdown4Btn:(UIButton *)sender {
    if (self.switchBlock) {
        self.switchBlock(sender.tag);
    }
}

@end
