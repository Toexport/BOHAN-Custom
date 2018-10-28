//
//  ManagementViewController.m
//  BOHAN-Custom
//
//  Created by summer on 2018/10/25.
//  Copyright © 2018 summer. All rights reserved.
//

#import "ManagementViewController.h"
#import "ManagementCell.h"
#import "FileHeader.pch"
@interface ManagementViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"设备管理");
    [self.Tableview registerNib:[UINib nibWithNibName:@"ManagementCell" bundle:nil] forCellReuseIdentifier:@"ManagementCell"];
    self.Tableview.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏tableview多余的线条
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ManagementCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ManagementCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变
    if ([cell.IDLabel.text hasPrefix:@"67"]) {
        cell.NameLabel.text = Localize(@"移动16A");
        cell.TypeLabel.text = Localize(@"墙壁插座");
    }else
        if ([cell.IDLabel.text hasPrefix:@"68"]) {
            cell.NameLabel.text = Localize(@"移动插座10A");
            cell.TypeLabel.text = Localize(@"移动插座");
        }else
            if ([cell.IDLabel.text hasPrefix:@"60"]) {
                cell.NameLabel.text = Localize(@"预付费");
                cell.TypeLabel.text = Localize(@"GPRS预付费");
            }else
                if ([cell.IDLabel.text hasPrefix:@"61"]) {
                    cell.NameLabel.text = Localize(@"开关");
                    cell.TypeLabel.text = Localize(@"一位开关");
                }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}
@end
