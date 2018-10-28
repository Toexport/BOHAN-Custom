//
//  BCTabBarController.m
//  BOHAN-Custom
//
//  Created by 赵宁 on 2018/10/25.
//  Copyright © 2018年 张鹏. All rights reserved.
//

#import "BCTabBarController.h"
#import "ListViewController.h"
#import "BCNavigationController.h"
#import "FileHeader.pch"
#import "ManagementViewController.h"

@interface BCTabBarController ()

@end

@implementation BCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChildViewController];
    self.view.backgroundColor = [UIColor redColor];
}

- (void)setupChildViewController{
    [self addTabbarChildController:@"ListViewController" andImage:@"List" andLabel:@"设备列表"];
    [self addTabbarChildController:@"ManagementViewController" andImage:@"Management" andLabel:@"设备管理"];
}

- (void)addTabbarChildController: (NSString *)controllerName andImage: (NSString *)imageName andLabel: (NSString *)labelText{
    Class controller = NSClassFromString(controllerName);
    UIViewController *vc = [[controller alloc] init];
    BCNavigationController *nav = [[BCNavigationController alloc] initWithRootViewController:vc];
    //5c8cf0
    nav.navigationBar.barTintColor = [UIColor whiteColor];
//    nav.navigationBar.tintColor = [UIColor ck_colorWithHex:0x92c8fa];
//    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor ck_colorWithHex:0x92c8fa]}];
    [self addChildViewController:nav];
    vc.title = labelText;
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]} forState:(UIControlStateSelected)];
    
    //设置无渲染的图片
    vc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_select",imageName]] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    //设置文字颜色
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"3c94f2"]} forState:UIControlStateSelected];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
