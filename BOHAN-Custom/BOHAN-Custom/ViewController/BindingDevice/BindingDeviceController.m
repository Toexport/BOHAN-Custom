//
//  BindingDeviceController.m
//  BOHAN-Custom
//
//  Created by summer on 2018/10/28.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import "BindingDeviceController.h"

@interface BindingDeviceController ()

@end

@implementation BindingDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"Binding Device");
}

- (IBAction)ConnectBtn:(UIButton *)sender {
}

- (IBAction)SaceBtn:(UIButton *)sender {
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
