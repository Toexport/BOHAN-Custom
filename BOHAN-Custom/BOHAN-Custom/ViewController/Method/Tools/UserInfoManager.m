//
//  UserInfoManager.m
//  UFA
//
//  Created by YangLin on 2017/7/24.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "UserInfoManager.h"
#import <SAMKeychain/SAMKeychain.h>
#import "FileHeader.pch"
@interface UserInfoManager ()
//@property (nonatomic, strong, readwrite)UserInfoModel *userInfo;
@end

@implementation UserInfoManager
static UserInfoManager *instance = nil;

//+ (instancetype)sharedInstance
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[UserInfoManager alloc] init];
//        [instance saveUserInfo];
//    });
//
//    return instance;
//}
//
//- (void)saveUserInfo
//{
//
//    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERINFO"];
////    self.userInfo = [UserInfoModel mj_objectWithKeyValues:userDic];
//
//}

+ (BOOL)isLogin
{
//    return [[SAMKeychain passwordForService:BUNDLEIDENTIFIER account:@"isLogin"] boolValue];
    return [[SAMKeychain passwordForService:BUNDLEIDENTIFIER account:@"isLogin"] boolValue];
}

+ (void)updateLoginState:(BOOL)isLogin
{
    [SAMKeychain setPassword:[[NSNumber numberWithBool:isLogin] stringValue] forService:BUNDLEIDENTIFIER account:@"isLogin"];
}

+ (void)saveUserName:(NSString *)userName
{
    [SAMKeychain setPassword:userName forService:BUNDLEIDENTIFIER account:@"userName"];
}

+ (void)savePassword:(NSString *)password
{
    [SAMKeychain setPassword:password forService:BUNDLEIDENTIFIER account:@"password"];
}

+ (void)saveToken:(NSString *)token
{
    [SAMKeychain setPassword:token forService:BUNDLEIDENTIFIER account:@"token"];
}

+ (void)deletAccount
{
    [SAMKeychain deletePasswordForService:BUNDLEIDENTIFIER account:@"isLogin"];
    [SAMKeychain deletePasswordForService:BUNDLEIDENTIFIER account:@"userName"];
    [SAMKeychain deletePasswordForService:BUNDLEIDENTIFIER account:@"password"];
    [SAMKeychain deletePasswordForService:BUNDLEIDENTIFIER account:@"token"];
}

+ (NSString *)userName
{
    return [SAMKeychain passwordForService:BUNDLEIDENTIFIER account:@"userName"];
}

+ (NSString *)password
{
    return [SAMKeychain passwordForService:BUNDLEIDENTIFIER account:@"password"];
}

+ (NSString *)token
{
    return [SAMKeychain passwordForService:BUNDLEIDENTIFIER account:@"token"];
}

@end
