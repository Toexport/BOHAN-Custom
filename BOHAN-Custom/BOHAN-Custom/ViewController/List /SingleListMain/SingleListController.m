//
//  SingleListController.m
//  BOHAN-Custom
//
//  Created by summer on 2018/10/27.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import "SingleListController.h"
#import "FileHeader.pch"
#import "SingleListCell/SingleListViewCell.h"
@interface SingleListController ()<UITableViewDelegate, UITableViewDataSource>{
    NSString * Instruction;
}

@end

@implementation SingleListController
@synthesize socket;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"单项列表");
    [self.tableview registerNib:[UINib nibWithNibName:@"SingleListViewCell" bundle:nil] forCellReuseIdentifier:@"SingleListViewCell"];
    Instruction = @"000100008F0D";
    [self GetData];
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

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"%@",[NSString stringWithFormat:@"连接到:%@",host]);
    [socket readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
}

// 查询当前设备信息
- (void)GetData {
    NSString * string = @"+RECV:0,E7";
    NSString * Str = [NSString stringWithFormat:@"%@%@%@",string,self.Id,Instruction];
    [socket writeData:[Str dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [socket readDataWithTimeout:-1 tag:0];
    NSLog(@"1%@%@%@",string,self.Id,Instruction);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"1%@%@",sock.connectedHost,newMessage);
    [socket readDataWithTimeout:-1 tag:0];
    //    [SVProgressHUD showSuccessWithStatus:(Localize(@"连接成功"))];
//    NSString * Minutes = [newMessage substringWithRange:NSMakeRange(15, 12)];
//    Str = [NSString stringWithFormat:@"%@",Minutes];
//        NSLog(@"%@",Minutes);
    [self.tableview reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SingleListViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SingleListViewCell"];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果、
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
