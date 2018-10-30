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
@interface InformationController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation InformationController
@synthesize socket;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"Device List");
    [self rightBarTitle:Localize(@"登出") action:@selector(LogOut)];
    [self.tableview registerNib:[UINib nibWithNibName:@"InformationViewCell" bundle:nil] forCellReuseIdentifier:@"InformationViewCell"];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏tableview多余的线条
    [self PostData];
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

- (void)PostData {
    socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //socket.delegate = self;
    NSError *err = nil;
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_TitleName_IP_PORT_Name1_Name2_Name3_Name4];
    if(![socket connectToHost:[usernamepasswordKVPairs objectForKey:KEY_IP] onPort:[[usernamepasswordKVPairs objectForKey:KEY_PORT] intValue] error:&err]) {
        [SVProgressHUD showInfoWithStatus:(@"连接失败")];
    }else {
        NSLog(@"ok");
        NSLog(@"%@:%@",KEY_PORT,KEY_IP);
    }
}

// 发送数据
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"%@",[NSString stringWithFormat:@"连接到:%@",host]);
    [socket readDataWithTimeout:-1 tag:0];
}

// 接收数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@%@",sock.connectedHost,newMessage);
    [SVProgressHUD showSuccessWithStatus:(Localize(@"连接成功"))];
    [socket readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)error {
    NSLog(@"%@",error);
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
        [self.navigationController pushViewController:CountDown animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
    };
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}

// 注销登录
- (void)LogOut {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:Localize(@"提示") message:Localize(@"确定要注销登录吗？") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:Localize(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"action = %@", action);
            
        }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:Localize(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            //            清除所有的数据
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
