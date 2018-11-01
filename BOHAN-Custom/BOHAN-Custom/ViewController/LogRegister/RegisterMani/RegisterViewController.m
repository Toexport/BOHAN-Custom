//
//  RegisterViewController.m
//  BOHAN-Custom
//
//  Created by summer on 2018/10/28.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import "RegisterViewController.h"
#import "FileHeader.pch"
#import "RLMRealm.h"
#import "UserModel.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"注册");
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
}

- (IBAction)DetermineBtn:(UIButton *)sender {
    if ([self cheakError]) {
        // 获取
        RLMRealm *realm = [RLMRealm defaultRealm];
        //    删除所有数据[realm beginWriteTransaction]; [realm deleteAllObjects];[realm commitWriteTransaction];
        RLMResults *results = [UserModel allObjectsInRealm:realm];
        
        NSArray * arr = [NSArray arrayWithObject:results];
        
        for (NSDictionary * dict in arr) {
            
            for (UserModel * model in dict) {
            
                if ([self.UserNameTextField.text isEqualToString:model[@"UserName"]]) {

                    NSLog(@"111");
                    [SVProgressHUD showErrorWithStatus:(Localize(@"账号已注册"))];

                }else
                    if ([self.UserNameTextField.text isEqualToString:model[@"nil"]]) {
                        NSLog(@"222");
                        RLMRealm *realm = [RLMRealm defaultRealm];
                        UserModel *model = [[UserModel alloc]init];
                        model.UserName = self.UserNameTextField.text;
                        model.PassWord = [self md5:self.PassWordTextField.text];
                        //        存储单个数据
                        [realm beginWriteTransaction];
                        [realm addObject:model];
                        [realm commitWriteTransaction];
                        [SVProgressHUD showSuccessWithStatus:(Localize(@"注册成功"))];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
            }
        }
    }
}

- (BOOL)cheakError {
    if (!self.UserNameTextField.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入账号"];
        return NO;
    }
    if (!self.PassWordTextField.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
        return NO;
    }
    return YES;
}

- (void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

//  MD5加密方法
- (NSString *)md5:(NSString *)input {
    const char * cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    //    CC_MD5(cStr, strlen(cStr),digest); // This is the md5 call
    CC_MD5(cStr, (CC_LONG)strlen(cStr),digest); // This is the md5 call
    NSMutableString * output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH *2];
    for (int i = 0; i<CC_MD5_DIGEST_LENGTH; i ++) {
        [output appendFormat:@"%02x",digest[i]];
    }
    return output;
}
@end
