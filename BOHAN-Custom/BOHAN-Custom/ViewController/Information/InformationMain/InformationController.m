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
#import <Foundation/Foundation.h>
#import "NSTimer+Action.h"
#import "NsData.h"
#import "Masonry.h"
#import "MJRefreshComponent.h"
#import "MJRefresh.h"
//#define KPacketHeaderLength 7
@interface InformationController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSString * Strid;
@property (nonatomic, strong) NSString * SwitchStr;
@property (nonatomic, strong) NSString * StateSStr;
@property (nonatomic, strong) NSString * Switch1;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) BOOL isCanSelect;

@end

@implementation InformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"Device List");
    [self rightBarTitle:Localize(@"Exit") action:@selector(LogOut)];
    [self.tableview registerNib:[UINib nibWithNibName:@"InformationViewCell" bundle:nil] forCellReuseIdentifier:@"InformationViewCell"];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏tableview多余的线条
    [self PostData];
}

// 刷新
- (void)addRefresh {
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(QueryData)];
    [self.tableview reloadData];
    //自动更改透明度
    self.tableview.mj_header.automaticallyChangeAlpha = YES;
}

- (IBAction)GetData:(UIButton *)sender {
    [self PostData];
    [self QueryData];
}

//  生命周期
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
//
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_timer pauseTimer];
}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}

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
    [self SwitchStateS:cell];
    [self SwitcBtn:cell]; // 开关点击事件
    [self SwitchPush:cell]; // 开关点击跳转事件
    return cell;
}

//// 发送数据
//- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
//    ZPLog(@"%@",[NSString stringWithFormat:@"连接到:%@:%d服务器",host,port]);
////    typedef NS_ENUM(NSInteger ,KReadDataType){
////        TAG_FIXED_LENGTH_HEADER = 10,//消息头部tag
////        TAG_RESPONSE_BODY = 11//消息体tag
////    };
//    [BHSocket readDataWithTimeout:-1 tag:0];
////    [BHSocket readDataToLength:KPacketHeaderLength withTimeout:-1 tag:TAG_FIXED_LENGTH_HEADER];
//}

// 接收数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
        NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        ZPLog(@"%@-----%@",sock.connectedHost,newMessage);
        if (newMessage.length > 14) {
            NSString * STRid = [newMessage substringWithRange:NSMakeRange(2, 12)];
            self.Strid = STRid;
            if (newMessage.length > 26) {
                SwitchState = [newMessage substringWithRange:NSMakeRange(26, 2)];
            }else {
                SwitchState = [newMessage substringWithRange:NSMakeRange(14, 2)];
            }
            if (![self.SwitchStr isEqualToString:SwitchState] && ![SwitchState isEqualToString:@"00"]) {
                self.SwitchStr = SwitchState;
                [self.tableview reloadData];
                [self.tableview.mj_header endRefreshing];
                [SVProgressHUD dismiss];
            }
            self.SwitchStr = SwitchState;
            ZPLog(@"%@---%@",STRid,SwitchState);
            //结束头部刷新
            [self.tableview.mj_header endRefreshing];
        }
        if (!self.isCanSelect) {
            self.isCanSelect = YES;
            [self addRefresh];
        }
        [SVProgressHUD dismiss];
    

//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{ // 单例方法
//        [SVProgressHUD showSuccessWithStatus:(Localize(@"Connection Successful"))];
//        MyWeakSelf
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:5 block:^{ // 列表设置8秒自动刷新
//            __strong typeof(self) strongSelf = weakSelf;
//            [strongSelf PostData];
//        } repeats:YES];
//    });
    
    [BHSocket readDataWithTimeout:-1 tag:0];
}
// 查询
- (void)QueryData {
    NSString * Str = [NSString stringWithFormat:@"%@%@",self.Strid,SwitchqueryStr];
    NSString * hexString = [Utils hexStringFromString:Str];
    NSString * CheckCode = [hexString substringFromIndex:2]; // 去掉首字符
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@",HeadStr,self.Strid,SwitchqueryStr,CheckCode,TailStr];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
}

// 加载失败
//- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)error {
//    ZPLog(@"断线重连");
//     [self BoltData];
////    self.isCanSelect = NO;
////    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_USERNAME_PASSWORD_KEY_TitleName_IP_PORT_Name1_Name2_Name3_Name4];
////    [BHSocket connectToHost:[usernamepasswordKVPairs objectForKey:KEY_IP] onPort:[[usernamepasswordKVPairs objectForKey:KEY_PORT] intValue] withTimeout:5 error:nil];
////    self.timer = [NSTimer scheduledTimerWithTimeInterval:15 block:^{ // 列表设置5秒自
////        [BHSocket disconnect];
////    //结束头部刷新
////        [self.tableview.mj_header endRefreshing];
////    } repeats:YES];
////    static dispatch_once_t onceToken;
////    dispatch_once(&onceToken, ^{ // 单例方法
////        [SVProgressHUD showSuccessWithStatus:(Localize(@"Connection Successful"))];
////        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 block:^{ // 列表设置5秒自动刷新
////        [BHSocket disconnect];
//////    //结束头部刷新
////         [self.tableview.mj_header endRefreshing];
////        } repeats:YES];
////    });
////    [BHSocket readDataWithTimeout:-1 tag:0];
////    [BHSocket disconnect];
////    [SVProgressHUD dismiss];
//}
//
//// 断线加载Sock
//- (void)BoltData {
//    BHSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//    NSError *err = nil;
//    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_USERNAME_PASSWORD_KEY_TitleName_IP_PORT_Name1_Name2_Name3_Name4];
//    if(![BHSocket connectToHost:[usernamepasswordKVPairs objectForKey:KEY_IP] onPort:[[usernamepasswordKVPairs objectForKey:KEY_PORT] intValue] error:&err]) {
//        [SVProgressHUD showInfoWithStatus:(@"Connection Fails")];
//    }else {
//        [SVProgressHUD showWithStatus:@"Reconnect..."];
//
//    }
//}


// 开关1开启
- (void)Switch1oN {
    NSString * State = [Utils getBinaryByHex:self.SwitchStr]; // 把拿到的开关状态转16进制
    NSString *strUrl = [State stringByReplacingCharactersInRange:NSMakeRange(7, 1) withString:@"0"]; // 改变开关状态
    NSString * UKTS = [Utils getHexByBinary:strUrl];
    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,SwitchinstructionStr,UKTS];
    NSString * string = [Utils hexStringFromString:Str];
    NSString * CheckCode = [string substringFromIndex:2]; // 去掉首字符
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@%@",HeadStr,self.Strid,SwitchinstructionStr,UKTS,CheckCode,TailStr];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
    
//    NSString * State = [Utils getBinaryByHex:self.SwitchStr]; // 把拿到的开关状态转16进制
//    NSString * Stats = [State substringWithRange:NSMakeRange(7, 1)]; // 获取1位
//    NSString *strUrl = [Stats stringByReplacingOccurrencesOfString:@"1" withString:@"0"];// 把获取到的1h换成0
//    NSString * SRT = [State substringWithRange:NSMakeRange(0, 7)];
//    NSString * STRURL = [NSString stringWithFormat:@"%@%@",SRT,strUrl];
//    NSString * UKTS = [Utils getHexByBinary:STRURL];
//
//    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,instruction,UKTS];
//    NSString * string = [Utils hexStringFromString:Str];
//
//    NSString * CheckCode = [string substringWithRange:NSMakeRange(2, 2)];
//    NSString * stRR = [NSString stringWithFormat:@"%@0D",CheckCode];
//    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@",HeadStr,self.Strid,instruction,UKTS,stRR];
//    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
//    [BHSocket readDataWithTimeout:-1 tag:0];
     ZPLog(@"开关1开启%@",Strr);
}

// 开关1关闭
- (void)Switch1Off {
    NSString * State = [Utils getBinaryByHex:self.SwitchStr]; // 把拿到的开关状态转16进制
    NSString *strUrl = [State stringByReplacingCharactersInRange:NSMakeRange(7, 1) withString:@"1"]; // 改变开关状态
    NSString * UKTS = [Utils getHexByBinary:strUrl];
    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,SwitchinstructionStr,UKTS];
    NSString * string = [Utils hexStringFromString:Str];
    NSString * CheckCode = [string substringFromIndex:2]; // 去掉首字符
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@%@",HeadStr,self.Strid,SwitchinstructionStr,UKTS,CheckCode,TailStr];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
    ZPLog(@"开关1关闭%@",Strr);
//    NSString *string22 = @"10001000";
//    NSString *string222 = [string22 stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@"9"];
//    ZPLog(@"replace---%@",string222);
}

// 开关2开启
- (void)Switch2oN {
    NSString * State = [Utils getBinaryByHex:self.SwitchStr]; // 把拿到的开关状态转16进制
    NSString *strUrl = [State stringByReplacingCharactersInRange:NSMakeRange(6, 1) withString:@"0"]; // 改变开关状态
    NSString * UKTS = [Utils getHexByBinary:strUrl];
    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,SwitchinstructionStr,UKTS];
    NSString * string = [Utils hexStringFromString:Str];
    NSString * CheckCode = [string substringFromIndex:2]; // 去掉首字符
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@%@",HeadStr,self.Strid,SwitchinstructionStr,UKTS,CheckCode,TailStr];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
    ZPLog(@"开关2开启%@",Strr);
}

// 开关2关闭
- (void)Switch2Off {
    NSString * State = [Utils getBinaryByHex:self.SwitchStr]; // 把拿到的开关状态转16进制
    NSString *strUrl = [State stringByReplacingCharactersInRange:NSMakeRange(6, 1) withString:@"1"]; // 改变开关状态
    NSString * UKTS = [Utils getHexByBinary:strUrl];
    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,SwitchinstructionStr,UKTS];
    NSString * string = [Utils hexStringFromString:Str];
    NSString * CheckCode = [string substringFromIndex:2]; // 去掉首字符
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@%@",HeadStr,self.Strid,SwitchinstructionStr,UKTS,CheckCode,TailStr];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
     ZPLog(@"开关2关闭%@",Strr);
}

// 开关3开启
- (void)Switch3oN {
    NSString * State = [Utils getBinaryByHex:self.SwitchStr]; // 把拿到的开关状态转16进制
    NSString *strUrl = [State stringByReplacingCharactersInRange:NSMakeRange(5, 1) withString:@"0"]; // 改变开关状态
    NSString * UKTS = [Utils getHexByBinary:strUrl];
    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,SwitchinstructionStr,UKTS];
    NSString * string = [Utils hexStringFromString:Str];
    NSString * CheckCode = [string substringFromIndex:2]; // 去掉首字符
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@%@",HeadStr,self.Strid,SwitchinstructionStr,UKTS,CheckCode,TailStr];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
}

// 开关3关闭
- (void)Switch3Off {
    NSString * State = [Utils getBinaryByHex:self.SwitchStr]; // 把拿到的开关状态转16进制
    NSString *strUrl = [State stringByReplacingCharactersInRange:NSMakeRange(5, 1) withString:@"1"]; // 改变开关状态
    NSString * UKTS = [Utils getHexByBinary:strUrl];
    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,SwitchinstructionStr,UKTS];
    NSString * string = [Utils hexStringFromString:Str];
    NSString * CheckCode = [string substringFromIndex:2]; // 去掉首字符
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@%@",HeadStr,self.Strid,SwitchinstructionStr,UKTS,CheckCode,TailStr];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
    ZPLog(@"开关3关闭%@",Strr);
}

// 开关4开启
- (void)Switch4oN {
    NSString * State = [Utils getBinaryByHex:self.SwitchStr]; // 把拿到的开关状态转16进制
    NSString *strUrl = [State stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@"0"]; // 改变开关状态
    NSString * UKTS = [Utils getHexByBinary:strUrl];
    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,SwitchinstructionStr,UKTS];
    NSString * string = [Utils hexStringFromString:Str];
    NSString * CheckCode = [string substringFromIndex:2]; // 去掉首字符
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@%@",HeadStr,self.Strid,SwitchinstructionStr,UKTS,CheckCode,TailStr];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
}

// 开关4关闭
- (void)Switch4Off {
    NSString * State = [Utils getBinaryByHex:self.SwitchStr]; // 把拿到的开关状态转16进制
    NSString *strUrl = [State stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@"1"]; // 改变开关状态
    NSString * UKTS = [Utils getHexByBinary:strUrl];
    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,SwitchinstructionStr,UKTS];
    NSString * string = [Utils hexStringFromString:Str];
    NSString * CheckCode = [string substringFromIndex:2]; // 去掉首字符
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@%@",HeadStr,self.Strid,SwitchinstructionStr,UKTS,CheckCode,TailStr];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
    ZPLog(@"开关4关闭%@",Strr);
}

// 启动加载Sock
- (void)PostData {
    [[ZHeartBeatSocket shareZheartBeatSocket] initZheartBeatSocketWithDelegate:self];
}

// 开关点击事件
- (void)SwitcBtn:(InformationViewCell *)cell {
    cell.switch1ONButBlock = ^(id  _Nonnull Switch1OnBut) {
        [SVProgressHUD showWithStatus:@"Setting, please wait  moment..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.StateSStr = [Utils getBinaryByHex:self.SwitchStr];
        });
        [self Switch1oN];
    };
    cell.switch1OFFButBlock = ^(id  _Nonnull Switch1OFFButBlock) {
        [SVProgressHUD showWithStatus:@"Setting, please wait  moment..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.StateSStr = [Utils getBinaryByHex:self.SwitchStr];
        });
        [self Switch1Off];
    };
//     开关2
    cell.switch2ONButBlock = ^(id  _Nonnull Switch2OnBut) {
        [SVProgressHUD showWithStatus:@"Setting, please wait  moment..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.StateSStr = [Utils getBinaryByHex:self.SwitchStr];
        });
        [self Switch2oN];
    };
    cell.switch2OFFButBlock = ^(id  _Nonnull Switch2OFFButBlock) {
        [SVProgressHUD showWithStatus:@"Setting, please wait  moment..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.StateSStr = [Utils getBinaryByHex:self.SwitchStr];
        });
        [self Switch2Off];
    };
//     开关3
    cell.switch3ONButBlock = ^(id  _Nonnull Switch3OnBut) {
        [SVProgressHUD showWithStatus:@"Setting, please wait  moment..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.StateSStr = [Utils getBinaryByHex:self.SwitchStr];
        });
        [self Switch3oN];
    };
    cell.switch3OFFButBlock = ^(id  _Nonnull Switch3OFFButBlock) {
        [SVProgressHUD showWithStatus:@"Setting, please wait  moment..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.StateSStr = [Utils getBinaryByHex:self.SwitchStr];
        });
        [self Switch3Off];
    };
//     开关4
    cell.switch4ONButBlock = ^(id  _Nonnull Switch4OnBut) {
        [SVProgressHUD showWithStatus:@"Setting, please wait  moment..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.StateSStr = [Utils getBinaryByHex:self.SwitchStr];
        });
        [self Switch4oN];
    };
    cell.switch4OFFButBlock = ^(id  _Nonnull Switch4OFFButBlock) {
        [SVProgressHUD showWithStatus:@"Setting, please wait  moment..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.StateSStr = [Utils getBinaryByHex:self.SwitchStr];
        });
        [self Switch4Off];
    };
}

// 查询开关状态
- (void)SwitchStateS:(InformationViewCell *)cell {
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
                cell.Switch2.on = NO;
                cell.Switch3.on = YES;
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
                                if ([self.SwitchStr isEqualToString:@"87"]) {
                                    cell.Switch1.on = NO;
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
                                        if ([self.SwitchStr isEqualToString:@"89"]) {
                                            cell.Switch1.on = NO;
                                            cell.Switch2.on = YES;
                                            cell.Switch3.on = YES;
                                            cell.Switch4.on = NO;
                                        }else
                                            if ([self.SwitchStr isEqualToString:@"8A"]) {
                                                cell.Switch1.on = YES;
                                                cell.Switch2.on = NO;
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
                                                        cell.Switch1.on = NO;
                                                        cell.Switch2.on = YES;
                                                        cell.Switch3.on = NO;
                                                        cell.Switch4.on = NO;
                                                    }else
                                                        if ([self.SwitchStr isEqualToString:@"8C"]) {
                                                            cell.Switch1.on = YES;
                                                            cell.Switch2.on = YES;
                                                            cell.Switch3.on = NO;
                                                            cell.Switch4.on = NO;
                                                        }else
                                                            if ([self.SwitchStr isEqualToString:@"8E"]) {
                                                                cell.Switch1.on = YES;
                                                                cell.Switch2.on = NO;
                                                                cell.Switch3.on = NO;
                                                                cell.Switch4.on = NO;
                                                            }else
                                                                if ([self.SwitchStr isEqualToString:@"8F"]) {
                                                                    cell.Switch1.on = NO;
                                                                    cell.Switch2.on = NO;
                                                                    cell.Switch3.on = NO;
                                                                    cell.Switch4.on = NO;
                                                                }
}

// 点击开关跳转事件
- (void)SwitchPush:(InformationViewCell *)cell {
    cell.countdown1BtnBlock = ^(id  _Nonnull Countdown1Btn) {
        CountDownViewController * CountDown = [[CountDownViewController alloc]init];
        CountDown.deviceNo = self.Strid;
        CountDown.type = 111;
        [self.navigationController pushViewController:CountDown animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
    };
    cell.countdown2BtnBlock = ^(id  _Nonnull Countdown2Btn) {
        CountDownViewController * CountDown = [[CountDownViewController alloc]init];
        CountDown.deviceNo = self.Strid;
        CountDown.type = 222;
        [self.navigationController pushViewController:CountDown animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
    };
    cell.countdown3BtnBlock = ^(id  _Nonnull Countdown3Btn) {
        CountDownViewController * CountDown = [[CountDownViewController alloc]init];
        CountDown.deviceNo = self.Strid;
        CountDown.type = 333;
        [self.navigationController pushViewController:CountDown animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
    };
    cell.countdown4BtnBlock = ^(id  _Nonnull Countdown4Btn) {
        CountDownViewController * CountDown = [[CountDownViewController alloc]init];
        CountDown.deviceNo = self.Strid;
        CountDown.type = 444;
        [self.navigationController pushViewController:CountDown animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
    };
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

