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
    self.Switch1.backgroundColor = [UIColor redColor];
    self.Switch2.backgroundColor = [UIColor redColor];
    self.Switch3.backgroundColor = [UIColor redColor];
    self.Switch4.backgroundColor = [UIColor redColor];
}

- (IBAction)Switch1:(UISwitch *)sender {
//     self.Switch1.backgroundColor = [UIColor colorWithHexString:@"e4e4e4"];
    
    if (sender.isOn) {
        self.Switch1.backgroundColor = [UIColor colorWithHexString:@"54d76a"];
//        self.ExtractButBlock(self.Switch1);
        self.extractButBlock(self.Switch1);
        
        
        ZPLog(@"开");
    }else {
        self.Switch1.backgroundColor = [UIColor redColor];
        self.sxtractButBlock(self.Switch1);
        ZPLog(@"关");
    }
    
    
}

- (IBAction)Switch2:(UISwitch *)sender {
    
}

- (IBAction)Switch3:(UISwitch *)sender {
    
}

- (IBAction)Switch4:(UISwitch *)sender {
    
}

- (IBAction)CountdownBtn:(UIButton *)sender {
    self.countdownBtnBlock(self.CountdownBtn);
}

@end
