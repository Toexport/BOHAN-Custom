//
//  LoginViewController.m
//  Bohan
//
//  Created by Yang Lin on 2017/12/24.
//  Copyright © 2017年 Bohan. All rights reserved.
//

#import "LoginViewController.h"
//#import "VerificationCodeViewController.h"
#import "RegistrationAgreementController.h"
#import "RegisterViewController.h"
#import "InformationController.h"
#import "UserModel.h"
#import "RLMRealm.h"
#import "FileHeader.pch"
@interface LoginViewController ()<UITextFieldDelegate> {
    __weak IBOutlet EdgetTextField *accountTF;
    __weak IBOutlet EdgetTextField *passwordTF;
    __weak IBOutlet UIImageView *accountLeft;
    __weak IBOutlet UIImageView *passwordLeft;
    __weak IBOutlet UIButton *passwordRight;
    __weak IBOutlet UIButton *moreInfoBtn;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"3d8df1"];
    self.navigationController.navigationBarHidden = YES;
    if (@available(iOS 11.0, *)){
        [(UIScrollView *)self.view setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    accountTF.keyboardType = UIKeyboardTypeASCIICapable;
    accountTF.clearButtonMode = UITextFieldViewModeWhileEditing;  // 一键删除文字
    passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;  // 一键删除文字
    accountTF.leftViewSpacing = 8;
    accountTF.textSpacing = 8;
    accountTF.editSpacing = 8;
    
    passwordTF.leftViewSpacing = 8;
    passwordTF.textSpacing = 8;
    passwordTF.editSpacing = 8;

    [accountTF setLeftView:accountLeft];
    [passwordTF setLeftView:passwordLeft];
    [passwordTF setRightView:passwordRight];
    
    accountTF.leftViewMode = UITextFieldViewModeAlways;
    passwordTF.leftViewMode = UITextFieldViewModeAlways;

    accountTF.rightViewMode = UITextFieldViewModeWhileEditing;
    passwordTF.rightViewMode = UITextFieldViewModeAlways;
    
//    if (USERNAME) {
//        accountTF.text = USERNAME;
//    }
//    if (PASSWORD) {
//        passwordTF.text = PASSWORD;
//    }
    
    NSString *moreStr = Localize(@"了解更多伯瀚:");
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:moreInfoBtn.titleLabel.text];
    [attr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(moreStr.length, attr.length-moreStr.length)];
    moreInfoBtn.titleLabel.attributedText = attr;
    moreInfoBtn.titleLabel.numberOfLines = 2;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//}

#pragma mark - action
- (BOOL)autoLogin {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loginAccount"]) {
        return YES;
    }
    return NO;
}

- (IBAction)loginAction {
    if ([self cheakError]) {
        //        NSDictionary *dict = [CHKeychain load:accountTF.text];
        // 获取
        RLMRealm *realm = [RLMRealm defaultRealm];
        //    删除所有数据 [realm beginWriteTransaction]; [realm deleteAllObjects];[realm commitWriteTransaction];
        RLMResults *results = [UserModel allObjectsInRealm:realm];
        NSArray * arr = [NSArray arrayWithObject:results];
        for (NSDictionary * dict in arr) {
            
            for (UserModel * model in dict) {
                
                if ([accountTF.text isEqualToString:model[@"UserName"]] &&
                    [[self md5:passwordTF.text] isEqualToString:model[@"PassWord"]]) {
                    
//            记录上次的登录账号,下载可自动登录,退出登录需要删除此信息
                    [[NSUserDefaults standardUserDefaults] setObject:accountTF.text forKey:LOGOUTNOTIFICATION];
                    [UIApplication sharedApplication].delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[InformationController new]];
                    [SVProgressHUD showSuccessWithStatus:@"登陆成功"];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"账号或密码错误"];
                }
            }
        }
        
    }
}

- (BOOL)cheakError {
    if (!accountTF.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入账号"];
        return NO;
    }
    if (!passwordTF.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
        return NO;
    }
    return YES;
}

- (IBAction)showAction:(UIButton *)sender {
    passwordTF.secureTextEntry = sender.selected;
    sender.selected = !sender.selected;
}

- (IBAction)registAction {
    RegisterViewController * Register = [[RegisterViewController alloc] init];
    Register.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:Register animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
}

- (IBAction)moreInfoAction {
    RegistrationAgreementController * RegistrationAgreement = [[RegistrationAgreementController alloc]init];
    RegistrationAgreement.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:RegistrationAgreement animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
}

- (void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

//
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
