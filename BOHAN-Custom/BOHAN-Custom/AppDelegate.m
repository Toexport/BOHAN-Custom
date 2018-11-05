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
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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


@end
