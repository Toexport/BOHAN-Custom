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
@interface InformationController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation InformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"Device List");
    [self.tableview registerNib:[UINib nibWithNibName:@"InformationViewCell" bundle:nil] forCellReuseIdentifier:@"InformationViewCell"];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏tableview多余的线条
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
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InformationViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"InformationViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
