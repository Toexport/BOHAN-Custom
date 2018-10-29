//
//  BindingController.m
//  BOHAN-Custom
//
//  Created by summer on 2018/10/27.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import "BindingController.h"
#import "FileHeader.pch"
@interface BindingController ()


@end

@implementation BindingController
@synthesize socket;
@synthesize HostTextField;
@synthesize PortTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"绑定设备");
//    HostTextField.text = @"192.168.3.254";
//    PortTextField.text = @"2323";
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidUnload {
    [self setHostTextField:nil];
    [self setPortTextField:nil];
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

- (IBAction)sender:(UIButton *)sender {
    socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //socket.delegate = self;
    NSError *err = nil;
    if(![socket connectToHost:HostTextField.text onPort:[PortTextField.text intValue] error:&err]) {
        [SVProgressHUD showInfoWithStatus:(@"连接失败")];
    }else {
        NSLog(@"ok");
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



@end
