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
    [self QueryData];
}

// 启动加载Sock
- (void)PostData {
    [[ZHeartBeatSocket shareZheartBeatSocket] initZheartBeatSocketWithDelegate:self];
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
    cell.switchBlock = ^(NSInteger selectIndex) {
        if (selectIndex >= 10) { //跳转
            [self SwitchPush:selectIndex];
        } else {                 //开关
            UISwitch *swich = nil;
            switch (selectIndex) {
                case 0: swich = cell.Switch1; break;
                case 1: swich = cell.Switch2; break;
                case 2: swich = cell.Switch3; break;
                case 3: swich = cell.Switch4; break;
                default:
                    break;
            }
            [SVProgressHUD showWithStatus:@"Setting, please wait  moment..."];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
            [self changeSwichStase:swich];
        }
    };
    [self SwitchStateS:cell];
    return cell;
}

// 接收数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
        NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        ZPLog(@"%@-----%@",sock.connectedHost,newMessage);
//    E770181102000100002F001CFF000000000248FF00000000022800000000000048FF000000000148E90D
        if (newMessage.length > 14) {
            NSString * STRid = [newMessage substringWithRange:NSMakeRange(2, 12)];
            self.Strid = STRid;
            if (newMessage.length > 26) {
                SwitchState = [newMessage substringWithRange:NSMakeRange(26, 2)];
            }else {
                SwitchState = [newMessage substringWithRange:NSMakeRange(14, 2)];
            }
            if (![SwitchState isEqualToString:@"00"]) {
                self.SwitchStr = SwitchState;
                [self.tableview reloadData];
                [self.tableview.mj_header endRefreshing];
                [SVProgressHUD dismiss];
                ZPLog(@"%@---%@",STRid,SwitchState);
            }
            //结束头部刷新
            [self.tableview.mj_header endRefreshing];
            if (!self.isCanSelect) {
                self.isCanSelect = YES;
                [self addRefresh];
                [self PostData];
            }
        }
    [BHSocket readDataWithTimeout:-1 tag:0];
}

// 查询
- (void)QueryData {
    if (self.tableview) {
        return;
    }
    NSString * Str = [NSString stringWithFormat:@"%@%@",self.Strid,SwitchqueryStr];
    NSString * hexString = [Utils hexStringFromString:Str];
    NSString * CheckCode = [hexString substringFromIndex:2]; // 去掉首字符
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@",HeadStr,self.Strid,SwitchqueryStr,CheckCode,TailStr];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
}

- (void)changeSwichStase:(UISwitch *)swich {
    NSString * State = [Utils getBinaryByHex:self.SwitchStr]; // 把拿到的开关状态转16进制
    NSString *strUrl = [State stringByReplacingCharactersInRange:NSMakeRange(7-swich.tag, 1) withString:swich.on?@"0":@"1"]; // 改变开关状态
    NSString * UKTS = [Utils getHexByBinary:strUrl];
    NSString * Str = [NSString stringWithFormat:@"%@%@%@",self.Strid,SwitchinstructionStr,UKTS];
    NSString * string = [Utils hexStringFromString:Str];
    NSString * CheckCode = [string substringFromIndex:2]; // 去掉首字符
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@%@",HeadStr,self.Strid,SwitchinstructionStr,UKTS,CheckCode,TailStr];
    NSLog(@"写入数据--%@",Strr);
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
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
- (void)SwitchPush:(NSInteger )type {
    CountDownViewController * CountDown = [[CountDownViewController alloc]init];
    CountDown.deviceNo = self.Strid;
    CountDown.type = type;
    [self.navigationController pushViewController:CountDown animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
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
        [[ZHeartBeatSocket shareZheartBeatSocket] disContennct];
        NSUserDefaults *UserLoginState = [NSUserDefaults standardUserDefaults];
        [UserLoginState removeObjectForKey:LOGOUTNOTIFICATION];
        [UserLoginState synchronize];
        
    }];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

