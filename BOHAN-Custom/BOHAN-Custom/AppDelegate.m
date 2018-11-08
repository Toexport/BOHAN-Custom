//
//  AppDelegate.m
//  BOHAN-Custom
//
//  Created by 赵宁 on 2018/10/25.
//  Copyright © 2018年 张鹏. All rights reserved.
//

#import "AppDelegate.h"
#import "BCTabBarController.h"
#import "LoginViewController.h"
#import "InformationController.h"
#import "ListViewController.h"
#import "FileHeader.pch"
#import "AFNetworking.h"
#import "ZHeartBeatSocket.h"
@interface AppDelegate ()<UITabBarControllerDelegate,GCDAsyncSocketDelegate>{
    ZHeartBeatSocket *_socket;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[AFNetworkReachabilityManager sharedManager]  startMonitoring];
    LoginViewController *login = [[LoginViewController alloc] init];
    UINavigationController *nav;
    if ([login autoLogin]) {
        nav = [[UINavigationController alloc] initWithRootViewController:[InformationController new]];
    } else {
        nav = [[UINavigationController alloc] initWithRootViewController:login];
    }
    self.window.rootViewController = nav;
    self.window.rootViewController.view.backgroundColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"3c94f2"]];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor], nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, nil]]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexString:@"3c94f2"]];
    _socket  =  [ZHeartBeatSocket shareZheartBeatSocket];
    [_socket initZheartBeatSocketWithDelegate:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{ [[NSNotificationCenter defaultCenter]postNotificationName:@"CreatGcdSocket" object:nil userInfo:nil];}];
    //如果需要添加NSTimer
    [_socket runTimerWhenAppEnterBackGround];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
/**
 实时检查当前网络状态
 */
- (void)addReachabilityManager {
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"网络不通：%@",@(status) );
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"网络通过WIFI连接：%@",@(status));
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"网络通过无线连接：%@",@(status) );
                break;
            }
            default:
                break;
        }
        
        NSLog(@"网络状态数字返回：%@",@(status));
        NSLog(@"网络状态返回: %@", AFStringFromNetworkReachabilityStatus(status));
        
        NSLog(@"isReachable: %@",@([AFNetworkReachabilityManager sharedManager].isReachable));
        NSLog(@"isReachableViaWWAN: %@",@([AFNetworkReachabilityManager sharedManager].isReachableViaWWAN));
        NSLog(@"isReachableViaWiFi: %@",@([AFNetworkReachabilityManager sharedManager].isReachableViaWiFi));
    }];
    
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器
}

@end
