//
//  UserInfoManager.h
//  UFA
//
//  Created by YangLin on 2017/7/24.
//  Copyright © 2017年 UFA. All rights reserved.
//

#define ISLOGIN  [UserInfoManager isLogin]//是否已登录
#define TOKEN  [UserInfoManager token]//用户token
#define USERNAME  [UserInfoManager userName]//用户名
#define PASSWORD  [UserInfoManager password]//密码


#import <Foundation/Foundation.h>
//#import "UserInfoModel.h"
@interface UserInfoManager : NSObject

//@property (nonatomic, strong, readonly)UserInfoModel *userInfo;

/**
 *  @brief  获取单例对象
 *
 *  @return 返回单例对象
 */
//+ (instancetype)sharedInstance;

//
///**
// 保存用户数据
// */
//- (void)saveUserInfo;


+ (BOOL)isLogin;
+ (void)updateLoginState:(BOOL)isLogin;
+ (void)saveUserName:(NSString *)userName;
+ (void)savePassword:(NSString *)password;
+ (void)saveToken:(NSString *)token;
+ (NSString *)userName;
+ (NSString *)password;
+ (NSString *)token;
+ (void)deletAccount;


@end
