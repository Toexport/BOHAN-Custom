//
//  InformationController.m
//  BOHAN-Custom
//
//  Created by summer on 2018/10/28.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import "InformationController.h"
#import "FileHeader.pch"
#import "InformationViewCell.h"
#import "BindingDeviceController.h"
#import "LoginViewController.h"
#import "CountDownViewController.h"
#import "CommandModel.h"
#import "WebSocket.h"
#import <Foundation/Foundation.h>
@interface InformationController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSString * Strid;
@property (nonatomic, strong) NSString * Switch1;
@end

@implementation InformationController
@synthesize socket;
NSString * HeadStr = @"+RECV:0,E7";
NSString * instruction = @"0013000100";
NSString * instructionS = @"0013000101";
NSString * queryStr = @"00020000";


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableview.hidden = YES;
    self.title = Localize(@"Device List");
    [self rightBarTitle:Localize(@"Exit") action:@selector(LogOut)];
    [self.tableview registerNib:[UINib nibWithNibName:@"InformationViewCell" bundle:nil] forCellReuseIdentifier:@"InformationViewCell"];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏tableview多余的线条
    [self PostData];
}

- (IBAction)GetData:(UIButton *)sender {
    [self PostData];
    [self QueryData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableview reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// 新增设备
- (IBAction)BindingDevice:(UIButton *)sender {
    BindingDeviceController * BindingDevice = [[BindingDeviceController alloc]init];
    BindingDevice.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:BindingDevice animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

// cell的大小
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 242;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InformationViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"InformationViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果
     NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_USERNAME_PASSWORD_KEY_TitleName_IP_PORT_Name1_Name2_Name3_Name4];
    cell.TitleNameLabel.text = [usernamepasswordKVPairs objectForKey:KEY_TitleName];
    cell.IPLabel.text = [usernamepasswordKVPairs objectForKey:KEY_IP];
    cell.NameLabel1.text = [usernamepasswordKVPairs objectForKey:KEY_Name1];
    cell.NameLabel2.text = [usernamepasswordKVPairs objectForKey:KEY_Name2];
    cell.NameLabel3.text = [usernamepasswordKVPairs objectForKey:KEY_Name3];
    cell.NameLabel4.text = [usernamepasswordKVPairs objectForKey:KEY_Name4];
    cell.countdownBtnBlock = ^(id  _Nonnull CountdownBtn) {
        CountDownViewController * CountDown = [[CountDownViewController alloc]init];
        CountDown.deviceNo = self.Strid;
        [self.navigationController pushViewController:CountDown animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
    };
    cell.extractButBlock = ^(id  _Nonnull ExtractBut) {
        [self Switch1oN];
    };
    cell.sxtractButBlock = ^(id  _Nonnull SxtractBut) {
        [self Switch1Off];
    };
    return cell;
}

// 发送数据
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    ZPLog(@"%@",[NSString stringWithFormat:@"连接到:%@",host]);
    [socket readDataWithTimeout:-1 tag:0];
}

// 接收数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString * String = [newMessage substringWithRange:NSMakeRange(15, 12)];
    ZPLog(@"%@%@",sock.connectedHost,newMessage);
    ZPLog(@"%@",String);
    self.Strid = String;
//     开关状态
    NSString * Switch1 = [newMessage substringWithRange:NSMakeRange(37, 2)];
    ZPLog(@"%@",Switch1);
    self.Switch1 = Switch1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ // 单例方法
        [SVProgressHUD showSuccessWithStatus:(Localize(@"Connection Successful"))];
    });
    [socket readDataWithTimeout:-1 tag:0];
    [self socketS]; //设置开关状态
    [self QueryData]; // 查询开关状态
}

// 查询
- (void)QueryData {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ // 单例方法
        NSString * Str = [NSString stringWithFormat:@"%@%@",self.Strid,queryStr];
        NSString * hexString = [Utils hexStringFromString:Str];
        NSString * CheckCode = [hexString substringWithRange:NSMakeRange(2, 2)];
        NSString * string = [NSString stringWithFormat:@"%@0D",CheckCode];
        NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@",HeadStr,self.Strid,queryStr,string];
        [self->socket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
        [self->socket readDataWithTimeout:-1 tag:0];
    });
}

// 获取开关状态
- (void)socketS {
    InformationViewCell * cell = [[InformationViewCell alloc]init];
    if ([self.Switch1 containsString:@"00"]) {
        cell.Switch1.on = YES;
    }else
        if ([self.Switch1 containsString:@"01"]) {
            cell.Switch1.on = NO;
        }
    ZPLog(@"%@",self.Switch1);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)error {
    ZPLog(@"%@",error);
    [SVProgressHUD showInfoWithStatus:(@"Connection Fails")];
    self.tableview.hidden = YES;
}

// 开关1开启
- (void)Switch1oN {
    NSString * Str = [NSString stringWithFormat:@"%@%@",self.Strid,instruction];
    NSString * string = [Utils hexStringFromString:Str];
    NSString * CheckCode = [string substringWithRange:NSMakeRange(2, 2)];
    NSString * stRR = [NSString stringWithFormat:@"%@0D",CheckCode];
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@",HeadStr,self.Strid,instruction,stRR];
    [self->socket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [self->socket readDataWithTimeout:-1 tag:0];
    ZPLog(@"%@",Strr);
}

// 开关1关闭
- (void)Switch1Off {
    NSString * Str = [NSString stringWithFormat:@"%@%@",self.Strid,instructionS];
    NSString * string = [Utils hexStringFromString:Str];
    NSString * CheckCode = [string substringWithRange:NSMakeRange(2, 2)];
    NSString * stRR = [NSString stringWithFormat:@"%@0D",CheckCode];
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@",HeadStr,self.Strid,instructionS,stRR];
    [self->socket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [self->socket readDataWithTimeout:-1 tag:0];
    ZPLog(@"%@",Strr);
}

// 启动加载Sock
- (void)PostData {
    socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err = nil;
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_USERNAME_PASSWORD_KEY_TitleName_IP_PORT_Name1_Name2_Name3_Name4];
    if(![socket connectToHost:[usernamepasswordKVPairs objectForKey:KEY_IP] onPort:[[usernamepasswordKVPairs objectForKey:KEY_PORT] intValue] error:&err]) {
        [SVProgressHUD showInfoWithStatus:(@"Connection Fails")];
    }else {
        [SVProgressHUD showWithStatus:@"Loading..."];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
//        1.view的背景颜色
        [SVProgressHUD setBackgroundColor:[UIColor orangeColor]];
//        2.view上面的旋转小图标的 颜色
        [SVProgressHUD setForegroundColor:[UIColor blueColor]];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        NSLog(@"ok");
        NSLog(@"%@:%@",KEY_PORT,KEY_IP);
    }
}


// 注销登录
- (void)LogOut {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:Localize(@"Prompt") message:Localize(@"Are you sure you want to log out?") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:Localize(@"Cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"action = %@", action);
        }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:Localize(@"Determine") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//        清除所有的数据
    [UIApplication sharedApplication].delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
    NSUserDefaults *UserLoginState = [NSUserDefaults standardUserDefaults];
            [UserLoginState removeObjectForKey:LOGOUTNOTIFICATION];
            [UserLoginState synchronize];
        }];
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
}

@end
