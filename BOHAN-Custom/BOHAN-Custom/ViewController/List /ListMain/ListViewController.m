//
//  ListViewController.m
//  BOHAN-Custom
//
//  Created by summer on 2018/10/25.
//  Copyright © 2018 summer. All rights reserved.
//

#import "ListViewController.h"
#import "FileHeader.pch"
#import "BindingController.h"
#import "ListTableViewCell.h"
#import "SingleListController.h"
@interface ListViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSString * HTTPstr;
    NSString * PortStr;
    NSString * Str;
}

@end

@implementation ListViewController
@synthesize socket;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"设备列表");
    HTTPstr = @"61.145.190.175";
    PortStr = @"2323";
    [self rightBarTitle:Localize(@"新增") action:@selector(bindDevice)];
    [self.tableview registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"ListTableViewCell"];
     self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏tableview多余的线条
    [self DateSocket];
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

// 打开界面自动连接
- (void)DateSocket {
    socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err = nil;
    if(![socket connectToHost:HTTPstr onPort:[PortStr intValue] error:&err]) {
        [SVProgressHUD showInfoWithStatus:(@"连接失败")];
    }else {
        ZPLog(@"ok");
    }
}

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    ZPLog(@"%@",[NSString stringWithFormat:@"连接到:%@",host]);
    [socket readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    ZPLog(@"1%@%@",sock.connectedHost,newMessage);
    [socket readDataWithTimeout:-1 tag:0];
//    [SVProgressHUD showSuccessWithStatus:(Localize(@"连接成功"))];
    NSString * Minutes = [newMessage substringWithRange:NSMakeRange(15, 12)];
    Str = [NSString stringWithFormat:@"%@",Minutes];
//    ZPLog(@"%@",Minutes);
    [self.tableview reloadData];
}

// 绑定设备
- (void)bindDevice {
    BindingController * Binding = [[BindingController alloc]init];
    Binding.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:Binding animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ListTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果
    NSString * ID = [Str substringWithRange:NSMakeRange(0, 2)];
    if ([ID componentsSeparatedByString:@"66"]) {
        cell.TitleLabel.text = Localize(@"预付费");
    }
    return cell;
}

// cell的大小
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPLog(@"%ld",(long)indexPath.row);
    SingleListController * SingleList = [[SingleListController alloc]init];
    SingleList.Id = Str;
    SingleList.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:SingleList animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
    
}
@end
