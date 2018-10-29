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
// 连接
- (IBAction)ConnectBtn:(UIButton *)sender {
    
}

// 保存
- (IBAction)SaceBtn:(UIButton *)sender {
    
    if ([self.IPTExtField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:Localize(@"请填写IP")];
    }else
        if ([self.PortTextField.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:Localize(@"请填写端口")];
        }else
            if ([self.TitleNameTextField.text isEqualToString:@""]) {
                [SVProgressHUD showErrorWithStatus:Localize(@"请填写设备名称")];
            }else
                if ([self.Switch1Name.text isEqualToString:@""]) {
                    [SVProgressHUD showErrorWithStatus:Localize(@"请填写开关1名称")];
                }else
                    if ([self.Switch2Name.text isEqualToString:@""]) {
                        [SVProgressHUD showErrorWithStatus:Localize(@"请填写开关2名称")];
                    }else
                        if ([self.Switch3Name.text isEqualToString:@""]) {
                            [SVProgressHUD showErrorWithStatus:Localize(@"请填写开关3名称")];
                        }else
                            if ([self.Switch4Name.text isEqualToString:@""]) {
                                [SVProgressHUD showErrorWithStatus:Localize(@"请填写开关4名称")];
                            }else {
                                [self SaveData];
                            }
}

- (void)SaveData {
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    [usernamepasswordKVPairs setObject:self.IPTExtField.text forKey:KEY_IP];
    [CHKeychain save:self.IPTExtField.text data:usernamepasswordKVPairs];
    
    [usernamepasswordKVPairs setObject:self.PortTextField.text forKey:KEY_PORT];
    [CHKeychain save:self.PortTextField.text data:usernamepasswordKVPairs];
    
    [usernamepasswordKVPairs setObject:self.TitleNameTextField.text forKey:KEY_TitleName];
    [CHKeychain save:self.TitleNameTextField.text data:usernamepasswordKVPairs];
    
    [usernamepasswordKVPairs setObject:self.Switch1Name.text forKey:KEY_Name1];
    [CHKeychain save:self.Switch1Name.text data:usernamepasswordKVPairs];
    
    [usernamepasswordKVPairs setObject:self.Switch2Name.text forKey:KEY_Name2];
    [CHKeychain save:self.Switch2Name.text data:usernamepasswordKVPairs];
    
    [usernamepasswordKVPairs setObject:self.Switch3Name.text forKey:KEY_Name3];
    [CHKeychain save:self.Switch3Name.text data:usernamepasswordKVPairs];
    
    [usernamepasswordKVPairs setObject:self.Switch4Name.text forKey:KEY_Name4];
    [CHKeychain save:self.Switch4Name.text data:usernamepasswordKVPairs];
    
    [SVProgressHUD showSuccessWithStatus:Localize(@"保存成功")];
}

@end
