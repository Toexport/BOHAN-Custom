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
#import "NSTimer+Action.h"
#import "NsData.h"

@interface InformationController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSString * Strid;
@property (nonatomic, strong) NSString * SwitchStr;
@property (nonatomic, strong) NSString * Switch1;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) BOOL isCanSelect;
@end

@implementation InformationController
NSString * HeadStr = @"E7";
NSString * instruction = @"00130001";
NSString * instructionS = @"00130001";
NSString * queryStr = @"00320000";

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self SwitchStateS:cell];
    
    //     开关1
    cell.switch1ONButBlock = ^(id  _Nonnull Switch1OnBut) {
        [SVProgressHUD showWithStatus:@"Setting, please wait  moment..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:(Localize(@"Connection Successful"))];
        });
        [self Switch1oN];
    };
    cell.switch1OFFButBlock = ^(id  _Nonnull Switch1OFFButBlock) {
        [SVProgressHUD showWithStatus:@"Setting, please wait  moment..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:(Localize(@"Connection Successful"))];
        });
            [self Switch1Off];
    };
    //     开关2
    cell.switch2ONButBlock = ^(id  _Nonnull Switch2OnBut) {
        [SVProgressHUD showWithStatus:@"Setting, please wait  moment..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:(Localize(@"Connection Successful"))];
        });
             [self Switch2oN];
    };
    cell.switch2OFFButBlock = ^(id  _Nonnull Switch2OFFButBlock) {
        [SVProgressHUD showWithStatus:@"Setting, please wait  moment..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:(Localize(@"Connection Successful"))];
        });
             [self Switch2Off];
    };
    //     开关3
    cell.switch3ONButBlock = ^(id  _Nonnull Switch3OnBut) {
        [SVProgressHUD showWithStatus:@"Setting, please wait  moment..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:(Localize(@"Connection Successful"))];
        });
            [self Switch3oN];
    };
    cell.switch3OFFButBlock = ^(id  _Nonnull Switch3OFFButBlock) {
        [SVProgressHUD showWithStatus:@"Setting, please wait  moment..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:(Localize(@"Connection Successful"))];
        });
            [self Switch3Off];
    };
    //     开关4
    cell.switch4ONButBlock = ^(id  _Nonnull Switch4OnBut) {
        [SVProgressHUD showWithStatus:@"Setting, please wait  moment..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:(Localize(@"Connection Successful"))];
        });
            [self Switch4oN];
    };
    cell.switch4OFFButBlock = ^(id  _Nonnull Switch4OFFButBlock) {
        [SVProgressHUD showWithStatus:@"Setting, please wait  moment..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:(Localize(@"Connection Successful"))];
        });
            [self Switch4Off];
    };
    return cell;
}


// 发送数据
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    ZPLog(@"%@",[NSString stringWithFormat:@"连接到:%@:%d",host,port]);
    [BHSocket readDataWithTimeout:-1 tag:0];
}

// 接收数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    ZPLog(@"%@%@",sock.connectedHost,newMessage);
    if (newMessage.length > 11) {
        NSString * STRid = [newMessage substringWithRange:NSMakeRange(2, 12)];
        self.Strid = STRid;
        NSString * SwitchState = [newMessage substringWithRange:NSMakeRange(14, 2)];
        if (![self.SwitchStr isEqualToString:SwitchState]) {
            self.SwitchStr = SwitchState;
            [self.tableview reloadData];
        }
        self.SwitchStr = SwitchState;
        ZPLog(@"%@---%@",STRid,SwitchState);
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ // 单例方法
        [SVProgressHUD showSuccessWithStatus:(Localize(@"Connection Successful"))];
//        self.tableview.hidden = NO;
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 block:^{ // 列表设置15秒自动刷新
        [self QueryData];
        
//        } repeats:YES];
    });
    [BHSocket readDataWithTimeout:-1 tag:0];
}

// 查询
- (void)QueryData {
    NSString * Str = [NSString stringWithFormat:@"%@%@",self.Strid,queryStr];
    NSString * hexString = [Utils hexStringFromString:Str];
    NSString * CheckCode = [hexString substringWithRange:NSMakeRange(2, 2)];
    NSString * string = [NSString stringWithFormat:@"%@0D",CheckCode];
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@",self.Strid,queryStr,string];
        NSString * UFT = @" E7701811020001002E0001CB0D";
    [BHSocket writeData:[UFT dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
}




- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)error {
    ZPLog(@"%@",error);
    [SVProgressHUD showInfoWithStatus:(@"Connection Fails")];
    self.tableview.hidden = YES;
}

// 开关1开启
- (void)Switch1oN {
    NSString * State = [Utils getBinaryByHex:self.SwitchStr]; // 把拿到的开关状态转16进制
    NSString * Stats = [State substringWithRange:NSMakeRange(7, 1)]; // 获取1位
    NSString *strUrl = [Stats stringByReplacingOccurrencesOfString:@"1" withString:@"0"];// 把获取到的1h换成0
    NSString * SRT = [State substringWithRange:NSMakeRange(0, 7)];
    NSString * STRURL = [NSString stringWithFormat:@"%@%@",SRT,strUrl];
    NSString * UKTS = [Utils getHexByBinary:STRURL];
    
    
    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,instruction,UKTS];
    NSString * string = [Utils hexStringFromString:Str];
    
    NSString * CheckCode = [string substringWithRange:NSMakeRange(2, 2)];
    NSString * stRR = [NSString stringWithFormat:@"%@0D",CheckCode];
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@",HeadStr,self.Strid,instruction,UKTS,stRR];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
    ZPLog(@"%@",Strr);
}

// 开关1关闭
- (void)Switch1Off {
    NSString * State = [Utils getBinaryByHex:self.SwitchStr]; // 把拿到的开关状态转16进制
    NSString * Stats = [State substringWithRange:NSMakeRange(7, 1)]; // 获取1位
    NSString *strUrl = [Stats stringByReplacingOccurrencesOfString:@"0" withString:@"1"];// 把获取到的1换成0
    NSString * SRT = [State substringWithRange:NSMakeRange(0, 7)];
    NSString * STRURL = [NSString stringWithFormat:@"%@%@",SRT,strUrl];
    NSString * UKTS = [Utils getHexByBinary:STRURL];
    
    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,instruction,UKTS];
    NSString * string = [Utils hexStringFromString:Str];
    
    NSString * CheckCode = [string substringWithRange:NSMakeRange(2, 2)];
    NSString * stRR = [NSString stringWithFormat:@"%@0D",CheckCode];
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@",HeadStr,self.Strid,instruction,UKTS,stRR];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
    
    NSString *string22 = @"10001000";
    NSString *string222 = [string22 stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@"9"];
    ZPLog(@"replace---%@",string222);
    
////    NSString * Instruction = @"10000001";
////    NSString * State = [Utils getHexByBinary:Instruction];
//    NSString * State = @"81";
//    ZPLog(@"%@",State);
//    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,instructionS,State];
//    NSString * string = [Utils hexStringFromString:Str];
//    NSString * CheckCode = [string substringWithRange:NSMakeRange(2, 2)];
//    NSString * stRR = [NSString stringWithFormat:@"%@0D",CheckCode];
//    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@",HeadStr,self.Strid,instructionS,State,stRR];
//    [socket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
//    [socket readDataWithTimeout:-1 tag:0];
//    ZPLog(@"%@",Strr);
}

// 开关2开启
- (void)Switch2oN {
    NSString * State = [Utils getBinaryByHex:self.SwitchStr]; // 把拿到的开关状态转16进制
//
    NSString * Stats = [State substringWithRange:NSMakeRange(6, 1)]; // 获取2位

    NSString * sKU = [Stats substringWithRange:NSMakeRange(0, 1)];
//
    NSString *strUrl = [sKU stringByReplacingOccurrencesOfString:@"1" withString:@"0"];// 把获取到的1换成0
    NSString * KLKK = [State substringWithRange:NSMakeRange(7, 1)];
    NSString * SRT = [State substringWithRange:NSMakeRange(0, 6)];
    
    NSString * STRURL = [NSString stringWithFormat:@"%@%@%@",SRT,strUrl,KLKK];
    
    
    NSString * UKTS = [Utils getHexByBinary:STRURL];
    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,instruction,UKTS];
    NSString * string = [Utils hexStringFromString:Str];
    NSString * CheckCode = [string substringWithRange:NSMakeRange(2, 2)];
    NSString * stRR = [NSString stringWithFormat:@"%@0D",CheckCode];
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@",HeadStr,self.Strid,instruction,UKTS,stRR];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
    ZPLog(@"%@",Strr);
    
    
    
//    NSString * State = @"8D";
//    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,instruction,State];
//    NSString * string = [Utils hexStringFromString:Str];
//    NSString * CheckCode = [string substringWithRange:NSMakeRange(2, 2)];
//    NSString * stRR = [NSString stringWithFormat:@"%@0D",CheckCode];
//    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@",HeadStr,self.Strid,instruction,State,stRR];
//    [socket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
//    [socket readDataWithTimeout:-1 tag:0];
//    ZPLog(@"%@",Strr);
}

// 开关2关闭
- (void)Switch2Off {
    NSString * State = [Utils getBinaryByHex:self.SwitchStr]; // 把拿到的开关状态转16进制
    //
    NSString * Stats = [State substringWithRange:NSMakeRange(6, 1)]; // 获取2位
    NSString * sKU = [Stats substringWithRange:NSMakeRange(0, 1)];
    //
    NSString *strUrl = [sKU stringByReplacingOccurrencesOfString:@"0" withString:@"1"];// 把获取到的0换成1
    NSString * KLKK = [State substringWithRange:NSMakeRange(7, 1)];
    NSString * SRT = [State substringWithRange:NSMakeRange(0, 6)];
    
    NSString * STRURL = [NSString stringWithFormat:@"%@%@%@",SRT,strUrl,KLKK];
    
    NSString * UKTS = [Utils getHexByBinary:STRURL];
    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,instruction,UKTS];
    NSString * string = [Utils hexStringFromString:Str];
    NSString * CheckCode = [string substringWithRange:NSMakeRange(2, 2)];
    NSString * stRR = [NSString stringWithFormat:@"%@0D",CheckCode];
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@",HeadStr,self.Strid,instruction,UKTS,stRR];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
    ZPLog(@"%@",Strr);
    
//    NSString * State = @"8B";
//    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,instructionS,State];
//    NSString * string = [Utils hexStringFromString:Str];
//    NSString * CheckCode = [string substringWithRange:NSMakeRange(2, 2)];
//    NSString * stRR = [NSString stringWithFormat:@"%@0D",CheckCode];
//    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@",HeadStr,self.Strid,instructionS,State,stRR];
//    [socket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
//    [socket readDataWithTimeout:-1 tag:0];
//    ZPLog(@"%@",Strr);
}

// 开关3开启
- (void)Switch3oN {
    NSString * State = [Utils getBinaryByHex:self.SwitchStr];
    //
    NSString * Stats = [State substringWithRange:NSMakeRange(5, 1)]; // 获取1位
    
    NSString * sKU = [Stats substringWithRange:NSMakeRange(0, 1)];
    //
    NSString *strUrl = [sKU stringByReplacingOccurrencesOfString:@"1" withString:@"0"];// 把获取到的0换成1
    
    NSString * KLKK = [State substringWithRange:NSMakeRange(6, 2)];
    
    NSString * SRT = [State substringWithRange:NSMakeRange(0, 5)];
    
    NSString * STRURL = [NSString stringWithFormat:@"%@%@%@",SRT,strUrl,KLKK];
    
    NSString * UKTS = [Utils getHexByBinary:STRURL];
    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,instruction,UKTS];
    NSString * string = [Utils hexStringFromString:Str];
    NSString * CheckCode = [string substringWithRange:NSMakeRange(2, 2)];
    NSString * stRR = [NSString stringWithFormat:@"%@0D",CheckCode];
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@",HeadStr,self.Strid,instruction,UKTS,stRR];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
    
    
    
//    NSString * State = @"80";
//    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,instruction,State];
//    NSString * string = [Utils hexStringFromString:Str];
//    NSString * CheckCode = [string substringWithRange:NSMakeRange(2, 2)];
//    NSString * stRR = [NSString stringWithFormat:@"%@0D",CheckCode];
//    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@",HeadStr,self.Strid,instruction,State,stRR];
//    [socket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
//    [socket readDataWithTimeout:-1 tag:0];
//    ZPLog(@"%@",Strr);
}

// 开关3关闭
- (void)Switch3Off {
    NSString * State = [Utils getBinaryByHex:self.SwitchStr]; // 把拿到的开关状态转16进制
    //
    NSString * Stats = [State substringWithRange:NSMakeRange(5, 1)]; // 获取1位
    
    NSString * sKU = [Stats substringWithRange:NSMakeRange(0, 1)];
    //
    NSString *strUrl = [sKU stringByReplacingOccurrencesOfString:@"0" withString:@"1"];// 把获取到的0换成1
    
    NSString * KLKK = [State substringWithRange:NSMakeRange(6, 2)];
    
    NSString * SRT = [State substringWithRange:NSMakeRange(0, 5)];
    
    NSString * STRURL = [NSString stringWithFormat:@"%@%@%@",SRT,strUrl,KLKK];
    
    NSString * UKTS = [Utils getHexByBinary:STRURL];
    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,instruction,UKTS];
    NSString * string = [Utils hexStringFromString:Str];
    NSString * CheckCode = [string substringWithRange:NSMakeRange(2, 2)];
    NSString * stRR = [NSString stringWithFormat:@"%@0D",CheckCode];
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@",HeadStr,self.Strid,instruction,UKTS,stRR];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
    ZPLog(@"%@",Strr);
    
//    NSString * State = @"82";
//    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,instructionS,State];
//    NSString * string = [Utils hexStringFromString:Str];
//    NSString * CheckCode = [string substringWithRange:NSMakeRange(2, 2)];
//    NSString * stRR = [NSString stringWithFormat:@"%@0D",CheckCode];
//    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@",HeadStr,self.Strid,instructionS,State,stRR];
//    [socket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
//    [socket readDataWithTimeout:-1 tag:0];
//    ZPLog(@"%@",Strr);
}

// 开关4开启
- (void)Switch4oN {
    NSString * State = [Utils getBinaryByHex:self.SwitchStr];
    //
    NSString * Stats = [State substringWithRange:NSMakeRange(4, 1)]; // 获取1位
    
    NSString * sKU = [Stats substringWithRange:NSMakeRange(0, 1)];
    //
    NSString *strUrl = [sKU stringByReplacingOccurrencesOfString:@"1" withString:@"0"];// 把获取到的0换成1
    
    NSString * KLKK = [State substringWithRange:NSMakeRange(5, 3)];
    
    NSString * SRT = [State substringWithRange:NSMakeRange(0, 4)];
    
    NSString * STRURL = [NSString stringWithFormat:@"%@%@%@",SRT,strUrl,KLKK];
    
    NSString * UKTS = [Utils getHexByBinary:STRURL];
    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,instruction,UKTS];
    NSString * string = [Utils hexStringFromString:Str];
    NSString * CheckCode = [string substringWithRange:NSMakeRange(2, 2)];
    NSString * stRR = [NSString stringWithFormat:@"%@0D",CheckCode];
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@",HeadStr,self.Strid,instruction,UKTS,stRR];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
    ZPLog(@"%@",Strr);
//    NSString * State = @"80";
//    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,instruction,State];
//    NSString * string = [Utils hexStringFromString:Str];
//    NSString * CheckCode = [string substringWithRange:NSMakeRange(2, 2)];
//    NSString * stRR = [NSString stringWithFormat:@"%@0D",CheckCode];
//    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@",HeadStr,self.Strid,instruction,State,stRR];
//    [socket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
//    [socket readDataWithTimeout:-1 tag:0];
////    [socket readDataWithTimeout:-1 tag:100];
//    ZPLog(@"%@",Strr);
}

// 开关4关闭
- (void)Switch4Off {
    NSString * State = [Utils getBinaryByHex:self.SwitchStr];
    //
    NSString * Stats = [State substringWithRange:NSMakeRange(4, 1)]; // 获取1位
    
    NSString * sKU = [Stats substringWithRange:NSMakeRange(0, 1)];
    //
    NSString *strUrl = [sKU stringByReplacingOccurrencesOfString:@"0" withString:@"1"];// 把获取到的0换成1
    
    NSString * KLKK = [State substringWithRange:NSMakeRange(5, 3)];
    
    NSString * SRT = [State substringWithRange:NSMakeRange(0, 4)];
    
    NSString * STRURL = [NSString stringWithFormat:@"%@%@%@",SRT,strUrl,KLKK];
    
    NSString * UKTS = [Utils getHexByBinary:STRURL];
    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,instruction,UKTS];
    NSString * string = [Utils hexStringFromString:Str];
    NSString * CheckCode = [string substringWithRange:NSMakeRange(2, 2)];
    NSString * stRR = [NSString stringWithFormat:@"%@0D",CheckCode];
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@",HeadStr,self.Strid,instruction,UKTS,stRR];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
    ZPLog(@"%@",Strr);
    
    
//    NSString * State = @"82";
//    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,instructionS,State];
//    NSString * string = [Utils hexStringFromString:Str];
//    NSString * CheckCode = [string substringWithRange:NSMakeRange(2, 2)];
//    NSString * stRR = [NSString stringWithFormat:@"%@0D",CheckCode];
//    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@",HeadStr,self.Strid,instructionS,State,stRR];
//    [socket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
//    [socket readDataWithTimeout:-1 tag:0];
////    [socket readDataWithTimeout:-1 tag:100];
//    ZPLog(@"%@",Strr);
}

// 启动加载Sock
- (void)PostData {
    BHSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err = nil;
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_USERNAME_PASSWORD_KEY_TitleName_IP_PORT_Name1_Name2_Name3_Name4];
    if(![BHSocket connectToHost:[usernamepasswordKVPairs objectForKey:KEY_IP] onPort:[[usernamepasswordKVPairs objectForKey:KEY_PORT] intValue] error:&err]) {
        self.tableview.hidden = YES;
        [SVProgressHUD showInfoWithStatus:(@"Connection Fails")];
    }else {
        [SVProgressHUD showWithStatus:@"Loading..."];
        //        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
        //        1.view的背景颜色
        //        [SVProgressHUD setBackgroundColor:[UIColor orangeColor]];
        //        2.view上面的旋转小图标的 颜色
        //        [SVProgressHUD setForegroundColor:[UIColor blueColor]];
        //        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        ZPLog(@"ok");
        ZPLog(@"%@:%@",KEY_PORT,KEY_IP);
    }
}

    // 查询开关状态
    - (void)SwitchStateS:(InformationViewCell *)cell { // 不显示出来。。。你来,keyilema
        if ([self.SwitchStr isEqualToString:@"80"]) {
            cell.Switch1.on = YES;
            cell.Switch2.on = YES;
            cell.Switch3.on = YES;
            cell.Switch4.on = YES;
        }else
            if ([self.SwitchStr isEqualToString:@"81"]) {
                cell.Switch1.on = NO;
                cell.Switch2.on = YES;
                cell.Switch3.on = YES;
                cell.Switch4.on = YES;
            }else
                if ([self.SwitchStr isEqualToString:@"82"]) {
                    cell.Switch1.on = YES;
                    cell.Switch2.on = YES;
                    cell.Switch3.on = NO;
                    cell.Switch4.on = YES;
                }else
                    if ([self.SwitchStr isEqualToString:@"83"]) {
                        cell.Switch1.on = NO;
                        cell.Switch2.on = NO;
                        cell.Switch3.on = YES;
                        cell.Switch4.on = YES;
                    }else
                        if ([self.SwitchStr isEqualToString:@"84"]) {
                            cell.Switch1.on = YES;
                            cell.Switch2.on = YES;
                            cell.Switch3.on = NO;
                            cell.Switch4.on = YES;
                        }else
                            if ([self.SwitchStr isEqualToString:@"85"]) {
                                cell.Switch1.on = NO;
                                cell.Switch2.on = YES;
                                cell.Switch3.on = NO;
                                cell.Switch4.on = YES;
                            }else
                                if ([self.SwitchStr isEqualToString:@"86"]) {
                                    cell.Switch1.on = YES;
                                    cell.Switch2.on = NO;
                                    cell.Switch3.on = NO;
                                    cell.Switch4.on = YES;
                                }else
                                  if ([self.SwitchStr isEqualToString:@"88"]) {
                                            cell.Switch1.on = YES;
                                            cell.Switch2.on = YES;
                                            cell.Switch3.on = YES;
                                            cell.Switch4.on = NO;
                                }else
                                    if ([self.SwitchStr isEqualToString:@"8B"]) {
                                        cell.Switch1.on = NO;
                                        cell.Switch2.on = NO;
                                        cell.Switch3.on = YES;
                                        cell.Switch4.on = NO;
                                    }else
                                if ([self.SwitchStr isEqualToString:@"8D"]) {
                                    cell.Switch1.on = YES;
                                    cell.Switch2.on = NO;
                                    cell.Switch3.on = YES;
                                    cell.Switch4.on = YES;
                                }else
                                    if ([self.SwitchStr isEqualToString:@"8C"]) {
                                        cell.Switch1.on = YES;
                                        cell.Switch2.on = YES;
                                        cell.Switch3.on = NO;
                                        cell.Switch4.on = NO;
                                    }else
                                        if ([self.SwitchStr isEqualToString:@"8F"]) {
                                            cell.Switch1.on = NO;
                                            cell.Switch2.on = NO;
                                            cell.Switch3.on = NO;
                                            cell.Switch4.on = NO;
                                        }else
                                            if ([self.SwitchStr isEqualToString:@"89"]) {
                                                cell.Switch1.on = NO;
                                                cell.Switch2.on = YES;
                                                cell.Switch3.on = YES;
                                                cell.Switch4.on = NO;
                                            }else
                                                if ([self.SwitchStr isEqualToString:@"8E"]) {
                                                    cell.Switch1.on = YES;
                                                    cell.Switch2.on = NO;
                                                    cell.Switch3.on = NO;
                                                    cell.Switch4.on = NO;
                                                }
    }


// 注销登录
- (void)LogOut {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:Localize(@"Prompt") message:Localize(@"Are you sure you want to log out?") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:Localize(@"Cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        ZPLog(@"action = %@", action);
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
