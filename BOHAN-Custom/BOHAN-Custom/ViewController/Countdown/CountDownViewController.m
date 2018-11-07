//
//  CountDownViewController.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/26.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "CountDownViewController.h"
#import "STLoopProgressView.h"
#import "CountdownView.h"
#import "View+MASAdditions.h"
#import "UIViewController+NavigationBar.h"
#import "NSTimer+Action.h"
#import "FileHeader.pch"
#import "WSDatePickerView.h"

@interface CountDownViewController ()<UITableViewDelegate, UITableViewDataSource> {
    __weak IBOutlet STLoopProgressView *progressView;
    __weak IBOutlet UILabel *time;
    __weak IBOutlet UILabel *status;
    __weak IBOutlet UIButton *openBtn;
    __weak IBOutlet UIButton *closeBtn;
    NSDateFormatter *formatter;
    NSDate *startDate;
    NSInteger totalSecend;//总秒数
    NSInteger lastSecend;//剩余秒数
    BOOL open;
}

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (copy, nonatomic) NSArray *datas;
@property (assign, nonatomic) NSInteger selectedItemIndex;
@property (nonatomic, weak) NSTimer *timer;//定时器
@property (nonatomic, strong) NSString * TimeUrl;
@property (nonatomic, strong) NSString * TimeStr;
@end

static NSString *countCellIdentifier = @"countCellIdentifier";

@implementation CountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"倒计时");
    self.datas = @[Localize(@"5分钟后"), Localize(@"10分钟后"), Localize(@"自定义时间")];
    formatter = [[NSDateFormatter alloc] init];
    _selectedItemIndex = NSIntegerMax;
    _mainTable.tintColor = [UIColor colorWithHexString:@"f03c4c"];
    [progressView setPersentage:0];
    [self rightBarTitle:Localize(@"取消") color:[UIColor whiteColor] action:@selector(canceOperation)];
    
//    [self getStatus];
//    [self countDownTime];
    [self loadData];
    [self PostData];
    [self UI];
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

// 启动加载Sock
- (void)PostData {
    BHSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err = nil;
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_USERNAME_PASSWORD_KEY_TitleName_IP_PORT_Name1_Name2_Name3_Name4];
    if(![BHSocket connectToHost:[usernamepasswordKVPairs objectForKey:KEY_IP] onPort:[[usernamepasswordKVPairs objectForKey:KEY_PORT] intValue] error:&err]) {
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

// 发送数据
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    ZPLog(@"%@",[NSString stringWithFormat:@"连接到:%@:%d",host,port]);
    [BHSocket readDataWithTimeout:-1 tag:0];
}

// 接收数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    ZPLog(@"%@%@",sock.connectedHost,newMessage);
    
    //    if (newMessage.length > 11) {
    //        NSString * STRid = [newMessage substringWithRange:NSMakeRange(2, 12)];
    //        self.Strid = STRid;
    //        NSString * SwitchState = [newMessage substringWithRange:NSMakeRange(14, 2)];
    //        if (![self.SwitchStr isEqualToString:SwitchState]) {
    //            self.SwitchStr = SwitchState;
    //            [self.tableview reloadData];
    //        }
    //        self.SwitchStr = SwitchState;
    //        ZPLog(@"%@---%@",STRid,SwitchState);// 动画都在下面，我不知道那个是开启动画的代码
    //    }
    //
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ // 单例方法
        [SVProgressHUD showSuccessWithStatus:(Localize(@"Connection Successful"))];
        //        //        self.tableview.hidden = NO;
                //        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 block:^{ // 列表设置15秒自动刷新
        //        [self QueryData];
        [self loadData];
//       } repeats:YES];
    });
    [BHSocket readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)error {
    ZPLog(@"%@",error);
    [SVProgressHUD showInfoWithStatus:(@"Connection Fails")];
}

// 查询
- (void)loadData {
    NSString * Str = [NSString stringWithFormat:@"%@%@",self.deviceNo,CountdownqQueryStr];
    NSString * hexString = [Utils hexStringFromString:Str];
    NSString * CheckCode = [hexString substringFromIndex:2]; // 去掉首字符
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@",HeadStr,self.deviceNo,CountdownqQueryStr,CheckCode,TailStr];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
    ZPLog(@"%@",Strr);
}

// 定时开关
- (void)SetCountdown {
    if (time.text.length >= 7) {
        _TimeUrl = [time.text substringToIndex:5];
    }else
        if (time.text.length >= 5) {
            _TimeUrl = [time.text substringToIndex:5];
        }
    _TimeStr = [NSString stringWithFormat:@"%@%@%@%@%@",_TimeUrl,SetOpen,Switch,Switch,Switch];
    [self TimingSet];
}

// 定时器
- (void)TimingSet {
    NSString * strUrl = [_TimeStr stringByReplacingOccurrencesOfString:@":" withString:@""];  //去掉:
    NSString * str = [NSString stringWithFormat:@"%@%@%@",self.deviceNo,countdownStr,strUrl];
    NSString * hexString = [Utils hexStringFromString:str];
    NSString * CheckCode = [hexString substringFromIndex:2];
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@%@",HeadStr,self.deviceNo,countdownStr,strUrl,CheckCode,TailStr];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
    ZPLog(@"%@",time.text);
    [self setUpTimer];
    ZPLog(@"%@",Strr);
}

//- (void)countDownTime {
//    WebSocket *socket = [WebSocket socketManager];
//    CommandModel *model = [[CommandModel alloc] init];
//    model.command = @"0012";
//    model.deviceNo = self.deviceNo;
//    //    [self.view startLoading];
//
//    MyWeakSelf
//    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
//        //        [weakSelf.view stopLoading];
//        if (!error) {
//            NSString *statusStr = [response substringWithRange:NSMakeRange(((NSString *)response).length - 18, 2)];
//
//            NSString *content = [response substringWithRange:NSMakeRange(((NSString *)response).length - 16, 12)];
//            if ([content hasPrefix:@"00"]) {
//                return ;
//            }
//            [self->formatter setDateFormat:@"yyMMddHHmmss"];
//            self->startDate = [self->formatter dateFromString:content];
//            if (!self->startDate) {
//                return ;
//            }
//            if ([statusStr isEqualToString:@"00"]) {
//                [self->status setText:Localize(@"设备关闭")];
//
//            }else {
//                [self->status setText:Localize(@"设备打开")];
//            }
//
//            self->totalSecend = MAX(0, [self->startDate timeIntervalSinceDate:[NSDate date]]);
//            [weakSelf showConfig];
//            [self setUpTimer];
//        }
//
//        ZPLog(@"--------%@",response);
//    }];
//}
//
- (void)getStatus {
//    WebSocket *socket = [WebSocket socketManager];
//    CommandModel *model = [[CommandModel alloc] init];
//    model.command = @"0002";
//    model.deviceNo = self.deviceNo;
//    //    [self.view startLoading];
//    MyWeakSelf
//    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
////        [weakSelf.view stopLoading];
//        if (!error) {
//            if (((NSString *)response).length>26) {
//                NSString *status = [response substringWithRange:NSMakeRange(24, 2)];
//                NSString *binary = [Utils getBinaryByHex:status];
//                NSString *left = [binary substringWithRange:NSMakeRange(binary.length - 3, 1)];
//                NSString *center = [binary substringWithRange:NSMakeRange(binary.length - 2, 1)];
//                NSString *right = [binary substringFromIndex:binary.length - 1];
//                //一位插座
//                if ([self.deviceNo hasPrefix:@"61"]) {
//                    if ([center isEqualToString:@"0"]) {
//                        self->open = NO;
//                    }else {
//                        self->open = YES;
//                    }
//                    //二位插座
//                }else if ([self.deviceNo hasPrefix:@"62"]) {
//                    if ([left isEqualToString:@"0"] || [right isEqualToString:@"0"]) {
//                        self->open = NO;
//                    }else {
//                        self->open = YES;
//                    }
//                    //三位插座
//                }else if ([self.deviceNo hasPrefix:@"63"]) {
//                    if ([left isEqualToString:@"0"] || [right isEqualToString:@"0"] || [center isEqualToString:@"0"]) {
//                        self->open = NO;
//                    }else {
//                        self->open = YES;
//                    }
//                }else {
//                    if ([status isEqualToString:@"00"]) {
//                        self->open = NO;
//                    }else {
//                        self->open = YES;
//                    }
//                }
//                if (!self->open) {
//                    //开启
//                    self->closeBtn.layer.borderColor = [UIColor colorWithHexString:@"39B3FF"].CGColor;
//                    self->closeBtn.layer.borderWidth = 1;
//                    self->closeBtn.backgroundColor = [UIColor whiteColor];
//                    [self->closeBtn setTitleColor:[UIColor colorWithHexString:@"39B3FF"] forState:UIControlStateNormal];
//
//                    self->openBtn.backgroundColor = [UIColor colorWithHexString:@"BBBBBB"];
//                    [self->openBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                    self->openBtn.layer.borderColor = [UIColor colorWithHexString:@"BBBBBB"].CGColor;
//                }else {
//                    self->openBtn.layer.borderColor = [UIColor colorWithHexString:@"39B3FF"].CGColor;
//                    self->openBtn.layer.borderWidth = 1;
//                    self->openBtn.backgroundColor = [UIColor whiteColor];
//                    [self->openBtn setTitleColor:[UIColor colorWithHexString:@"39B3FF"] forState:UIControlStateNormal];
//
//                    self->closeBtn.backgroundColor = [UIColor colorWithHexString:@"BBBBBB"];
//                    [self->closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                    self->closeBtn.layer.borderColor = [UIColor colorWithHexString:@"BBBBBB"].CGColor;
//
//                }
//
//            }
//
//        }
//
//    }];
//
}

// 隐藏与显示
- (void)showConfig {
    if (startDate) {
        _mainTable.hidden = YES;
        PatchVIew.hidden = YES;
        openBtn.hidden = YES;
        closeBtn.hidden = YES;
        //        cancelBtn.hidden = NO;
    }else {
        _mainTable.hidden = NO;
        openBtn.hidden = NO;
        closeBtn.hidden = NO;
        PatchVIew.hidden = NO;
        [self getStatus];
        //        cancelBtn.hidden = YES;
    }
}
// 取消
- (void)canceOperation {
//    //    [CommonOperation cancelDeviceRunModel:self.deviceNo result:^(id response, NSError *error) {
//    //        if (!error) {
//    //            [self stopTimer];
//    //            _selectedItemIndex = NSIntegerMax;
//    //            [_mainTable reloadData];
//    //            [HintView showHint:Localize(@"取消成功")];
//    //        }else {
//    //            [HintView showHint:error.localizedDescription];
//    //        }
//    //
//    //    }];
}

//新增

// UI
- (void)UI {
    CountdownView * view = [[[NSBundle mainBundle] loadNibNamed:@"CountdownView" owner:nil options:nil] firstObject];
    view.doneBlock = ^(NSString *selectDate) {
        self->time.text = selectDate;
    };
    view.buttonAction = ^(UIButton *sender) {
        [self startAction];
        [self SetCountdown];
    };
    _mainTable.tableFooterView = view;

}

// 延时开关
- (IBAction)DelayClosingBut:(UIButton *)sender {
//    [self startAction];
    [self SetCountdown];
    
}
//
// 延时数据
- (void)startAction {
//    NSString *content = [time.text stringByReplacingOccurrencesOfString:@":" withString:@""];
//    if ([content isEqualToString:@"000000"]) {
//        //        [HintView showHint:Localize(@"请选择倒计时时间")];
//        ZPLog(@"请选择倒计时时间");
//        return;
//    }
//    WebSocket *socket = [WebSocket socketManager];
//    CommandModel *model = [[CommandModel alloc] init];
//    model.command = open?@"000B":@"000A";
//    model.deviceNo = self.deviceNo;
//    model.content = [content substringToIndex:4];
//    //    [self.view startLoading];
//
//    __weak typeof(NSString *) weakContent = model.content;
//    MyWeakSelf
//    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
//        //        [weakSelf.view stopLoading];
//        if (!error) {
//            int minutes = [[self->time.text substringToIndex:4] intValue]*60+[[self->time.text substringWithRange:NSMakeRange(3, 5)] intValue];
//            self->startDate = [NSDate dateWithMinutesFromNow:minutes];
//            [self->formatter setDateFormat:@"yyMMddHHmmss"];
//            self->startDate = [self->formatter dateFromString:[self->formatter stringFromDate:self->startDate]];
//            self->totalSecend = MAX(0, [self->startDate timeIntervalSinceDate:[NSDate date]]);
//            [weakSelf showConfig];
//            [self setUpTimer];
//            //            [HintView showHint:Localize(@"设置成功")];
//            [SVProgressHUD showInfoWithStatus:@"设置成功"];
//            ZPLog(@"设置成功");
//        }else {
//            //            [HintView showHint:error.localizedDescription];
//            [SVProgressHUD showErrorWithStatus:@"l设置失败"];
//        }
//    }];
}

- (void)setUpTimer {
    //说明已经过了时间,不再开启定时器
    NSComparisonResult result =[startDate compare:[NSDate date]];
    if (result != NSOrderedDescending) {//是不是上面没有写这个StartDate进去啊
        [self stopTimer];
        return;
    }
    MyWeakSelf
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                               block:^{
                                                   __strong typeof(self) strongSelf = weakSelf;
                                                   [strongSelf timeAction];
                                               }
                                             repeats:YES];

}

- (void)timeAction {
    lastSecend = MAX(0, [startDate timeIntervalSinceDate:[NSDate date]]);
    NSComparisonResult result =[startDate compare:[NSDate date]];
    if (lastSecend <=0 || result != NSOrderedDescending) {
        open = !open;
        [self stopTimer];
    }
    [progressView setPersentage:lastSecend/(totalSecend*1.0)];
    [time setText:[Utils gapDateFrom:[NSDate date] toDate:startDate]] ;

}

- (void)stopTimer {
    [time setText:@"00:00:00"] ;
    [progressView setPersentage:0];
    [status setText:Localize(@"设备打开/关闭")];
    startDate = nil;
//    [self getStatus];
    [self showConfig];
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

/*设置cell 的宽度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:countCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:countCellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.datas[indexPath.row];
    if (self.selectedItemIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"f03c4c"];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"5c5c5c"];
    }
    return cell;
}

#pragma mark 按钮的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        [formatter setDateFormat:@"HH:mm"];
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowHourMinute scrollToDate:[formatter dateFromString:[time.text substringToIndex:5]] CompleteBlock:^(NSDate *selectDate) {
            if (self.selectedItemIndex != indexPath.row) {
                self.selectedItemIndex = indexPath.row;
                [tableView reloadData];
            }
            [self->formatter setDateFormat:@"HH:mm:ss"];
            NSString *string = [self->formatter stringFromDate:selectDate];
            [self->time setText:string];

        }];
        datepicker.hideBackgroundYearLabel = YES;
        datepicker.dateLabelColor = [UIColor colorWithHexString: @"3c94f2"];
        datepicker.doneButtonColor = [UIColor colorWithHexString: @"3c94f2"];
        [datepicker show];

    }else {
        if (indexPath.row == 0) {
            [time setText:@"00:05"];
        }else {
            [time setText:@"00:10"];
        }
        if (self.selectedItemIndex != indexPath.row) {
            self.selectedItemIndex = indexPath.row;
            [tableView reloadData];
        }

    }
}


@end
