//
//  BindingDeviceController.m
//  BOHAN-Custom
//
//  Created by summer on 2018/10/28.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import "BindingDeviceController.h"
@interface BindingDeviceController ()


@end

@implementation BindingDeviceController
@synthesize socket;
@synthesize IPTExtField;
@synthesize PortTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"Binding Device");
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
}

- (void)viewDidUnload {
    [self setIPTExtField:nil];
    [self setIPTExtField:nil];
    [super viewDidUnload];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

// 连接
- (IBAction)ConnectBtn:(UIButton *)sender {
    if ([self.IPTExtField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:Localize(@"Please fill out the IP")];
    }else
        if ([self.PortTextField.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:Localize(@"Please fill out the Port")];
        }else {
    socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //socket.delegate = self;
    NSError *err = nil;
    if(![socket connectToHost:IPTExtField.text onPort:[PortTextField.text intValue] error:&err]) {
        [SVProgressHUD showInfoWithStatus:(@"连接失败")];
        ZPLog(@"%@%@",IPTExtField.text,PortTextField.text);
    }else {
        ZPLog(@"ok");
        ZPLog(@"%@%@",IPTExtField.text,PortTextField.text);
    }
        }
}

// 发送数据
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    ZPLog(@"%@",[NSString stringWithFormat:@"连接到:%@",host]);
    [socket readDataWithTimeout:-1 tag:0];
}

// 接收数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    ZPLog(@"%@%@",sock.connectedHost,newMessage);
    [SVProgressHUD showSuccessWithStatus:(Localize(@"连接成功"))];
    [socket readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)error {
    ZPLog(@"%@",error);
    [SVProgressHUD showInfoWithStatus:(@"连接失败")];
}

// 保存
- (IBAction)SaceBtn:(UIButton *)sender {
    if ([self.IPTExtField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:Localize(@"Please fill out the IP")];
    }else
        if ([self.PortTextField.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:Localize(@"Please fill out the Port")];
    }else
        if ([self.TitleNameTextField.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:Localize(@"Please fill equipment Name")];
    }else
        if ([self.Switch1Name.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:Localize(@"Please the name of Switch 1")];
    }else
        if ([self.Switch2Name.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:Localize(@"Please the name of Switch 2")];
    }else
        if ([self.Switch3Name.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:Localize(@"Please the name of Switch 3")];
    }else
        if ([self.Switch4Name.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:Localize(@"Please the name of Switch 4")];
    }else {
            [self SaveData];
    }
}

- (void)SaveData {
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    [usernamepasswordKVPairs setObject:self.IPTExtField.text forKey:KEY_IP];
    [usernamepasswordKVPairs setObject:self.PortTextField.text forKey:KEY_PORT];
    [usernamepasswordKVPairs setObject:self.TitleNameTextField.text forKey:KEY_TitleName];
    [usernamepasswordKVPairs setObject:self.Switch1Name.text forKey:KEY_Name1];
    [usernamepasswordKVPairs setObject:self.Switch2Name.text forKey:KEY_Name2];
    [usernamepasswordKVPairs setObject:self.Switch3Name.text forKey:KEY_Name3];
    [usernamepasswordKVPairs setObject:self.Switch4Name.text forKey:KEY_Name4];
    [CHKeychain save:KEY_USERNAME_PASSWORD_KEY_TitleName_IP_PORT_Name1_Name2_Name3_Name4 data:usernamepasswordKVPairs];
    [SVProgressHUD showSuccessWithStatus:Localize(@"保存成功")];
}

- (void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

@end
