//
//  RegisterViewController.m
//  BOHAN-Custom
//
//  Created by summer on 2018/10/28.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import "RegisterViewController.h"
#import "FileHeader.pch"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"注册");
}

- (IBAction)DetermineBtn:(UIButton *)sender {
    if ([CHKeychain load:self.UserNameTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"用户已注册"];
    } else {
        NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
        [usernamepasswordKVPairs setObject:self.UserNameTextField.text forKey:KEY_USERNAME];
        [usernamepasswordKVPairs setObject:self.PassWordTextField.text forKey:KEY_PASSWORD];
        [CHKeychain save:self.UserNameTextField.text data:usernamepasswordKVPairs];
        [SVProgressHUD showSuccessWithStatus:(Localize(@"注册成功"))];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
