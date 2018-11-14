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

@property (weak, nonatomic) IBOutlet UITableView * mainTable;
@property (copy, nonatomic) NSArray * datas;
@property (assign, nonatomic) NSInteger selectedItemIndex;
@property (nonatomic, weak) NSTimer * timer;//定时器
@property (nonatomic, strong) NSString * TimeUrl;
@property (nonatomic, strong) NSString * TimeStr;
@property (nonatomic, strong) NSString * SwitchState; // 开关状态
@end

static NSString *countCellIdentifier = @"countCellIdentifier";

@implementation CountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"Countdown");
    [self CountdownS];
    [self ShiftData];
    [self UI];
    [self PostData];
}

- (void)CountdownS {
    self.datas = @[Localize(@"5 Minutes"), Localize(@"10 Minutes"), Localize(@"Custom Time")];
    formatter = [[NSDateFormatter alloc] init];
    _selectedItemIndex = NSIntegerMax;
    _mainTable.tintColor = [UIColor colorWithHexString:@"f03c4c"];
    [progressView setPersentage:0];
    [self rightBarTitle:Localize(@"Cancel") color:[UIColor whiteColor] action:@selector(canceOperation)];
}

// 启动加载Sock
- (void)PostData {
    [[ZHeartBeatSocket shareZheartBeatSocket] initZheartBeatSocketWithDelegate:self];
}

//  生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
    [self ShiftData];
    [self UI];
}

// 查询(倒计时)
- (void)loadData {
    NSString * Str = [NSString stringWithFormat:@"%@%@",self.deviceNo,CountdownqQueryStr];
    NSString * hexString = [Utils hexStringFromString:Str];
    NSString * CheckCode = [hexString substringFromIndex:2]; // 去掉首字符
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@",HeadStr,self.deviceNo,CountdownqQueryStr,CheckCode,TailStr];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
    ZPLog(@"查询(倒计时)%@",Strr);
}

// 接收数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString * newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (newMessage.length > 56) {
    NSString * AllStr = [newMessage substringWithRange:NSMakeRange(24, 56)];
    ZPLog(@"所有开关数据---%@",AllStr);
        
/**************1**************/
    State1 = [AllStr substringWithRange:NSMakeRange(0, 2)]; // 开关状态1
    ZPLog(@"开关1状态---%@",State1);
    Switch1 =  [AllStr substringWithRange:NSMakeRange(2, 12)]; // 开关数据1
    ZPLog(@"开关1数据---%@",Switch1);
    YMDHMS2 = [NSString stringWithFormat:@"%@",Switch1];
    
        
/**************2**************/
    State2 = [AllStr substringWithRange:NSMakeRange(14, 2)]; // 开关状态1
    ZPLog(@"开关2状态---%@",State2);
    Switch2 =  [AllStr substringWithRange:NSMakeRange(16, 12)]; // 开关数据1
    ZPLog(@"开关2数据---%@",Switch2);
    
/**************3**************/
    State3 = [AllStr substringWithRange:NSMakeRange(28, 2)]; // 开关状态1
    ZPLog(@"开关3状态---%@",State3);
    Switch3 =  [AllStr substringWithRange:NSMakeRange(30, 12)]; // 开关数据1
    ZPLog(@"开关3数据---%@",Switch3);
        
/**************4**************/
    State4 = [AllStr substringWithRange:NSMakeRange(42, 2)]; // 开关状态1
    ZPLog(@"开关4状态---%@",State4);
    Switch4 =  [AllStr substringWithRange:NSMakeRange(44, 12)]; // 开关数据1
    ZPLog(@"开关4数据---%@",Switch4);
        
    }
    ZPLog(@"——————所有数据---%@",newMessage);
    [SVProgressHUD dismiss];
}

// 定时开关
- (void)SetCountdown {
    NSString *content = [time.text stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString * SwitchS = [Utils getBinaryByHex:self.SwitchStr]; // 把拿到的开关状态转16进制
    NSString * But1Str = [SwitchS substringWithRange:NSMakeRange(7, 1)];
    NSString * But2Str = [SwitchS substringWithRange:NSMakeRange(6, 1)];
    NSString * But3Str = [SwitchS substringWithRange:NSMakeRange(5, 1)];
    NSString * But4Str = [SwitchS substringWithRange:NSMakeRange(4, 1)];
    if ([content isEqualToString:@"000000"]) {
        [SVProgressHUD showInfoWithStatus:Localize(@"Please choose countdown time")];
        return;
    }
    if (time.text.length >= 7) {
        _TimeUrl = [time.text substringToIndex:5];
    }else
        if (time.text.length >= 5) {
            _TimeUrl = [time.text substringToIndex:5];
        }
    
    if (self.type == 111) { // 开关1
        if ([But1Str isEqualToString:@"1"]) {
            _TimeStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",_TimeUrl,SetOpen,AllStr,State2,Switch,State3,Switch,State4];
        }else
            if ([But1Str isEqualToString:@"0"]) {
                _TimeStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",_TimeUrl,SetOff,Switch,State2,Switch,State3,Switch,State4];
            }
        [self TimingSet];
    }else
        
        if (self.type == 222) { // 开关2
            if ([But2Str isEqualToString:@"1"]) {
                _TimeStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",Switch,State1,_TimeUrl,SetOpen,Switch,State3,Switch,State4];
            }else
                if ([But2Str isEqualToString:@"0"]) {
                    _TimeStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",Switch,State1,_TimeUrl,SetOff,Switch,State3,Switch,State4];
                }
            [self TimingSet];
        }else
            
            if (self.type == 333) {
                if ([But3Str isEqualToString:@"1"]) {
                    _TimeStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",Switch,State1,Switch,State2,_TimeUrl,SetOpen,Switch,State4];
                }else
                    if ([But3Str isEqualToString:@"0"]) {
                        _TimeStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",Switch,State1,Switch,State2,_TimeUrl,SetOff,Switch,State4];
                    }
                [self TimingSet];
            }else
                
                if (self.type == 444) {
                    if ([But4Str isEqualToString:@"1"]) {
                        _TimeStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",Switch,State1,Switch,State2,Switch,State3,_TimeUrl,SetOpen];
                    }else
                        if ([But4Str isEqualToString:@"0"]) {
                            _TimeStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",Switch,State1,Switch,State2,Switch,State3,_TimeUrl,SetOff];
                        }
                    [self TimingSet];
                }
}

// 定时器设置
- (void)TimingSet {
    MyWeakSelf
    NSString * strUrl = [_TimeStr stringByReplacingOccurrencesOfString:@":" withString:@""];  //去掉:
    NSString * str = [NSString stringWithFormat:@"%@%@%@",self.deviceNo,countdownStr,strUrl];
    NSString * hexString = [Utils hexStringFromString:str];
    NSString * CheckCode = [hexString substringFromIndex:2];
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@%@",HeadStr,self.deviceNo,countdownStr,strUrl,CheckCode,TailStr];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
    ZPLog(@"%@",time.text);
    NSString * TimeStr = [NSString stringWithFormat:@"%@:00",time.text];
    int minutes = [[TimeStr substringToIndex:4] intValue]*60+[[TimeStr substringWithRange:NSMakeRange(3, 5)] intValue];
    startDate = [NSDate dateWithMinutesFromNow:minutes];
    [formatter setDateFormat:@"yyMMddHHmmss"];
    startDate = [formatter dateFromString:[formatter stringFromDate:startDate]];
    totalSecend = MAX(0, [startDate timeIntervalSinceDate:[NSDate date]]);
    [weakSelf showConfig];
    [self setUpTimer];
    [SVProgressHUD showSuccessWithStatus:(Localize(@"Set Success"))];
    ZPLog(@"%@",Strr);
}

// 隐藏与显示
- (void)showConfig {
    if (startDate) {
        _mainTable.hidden = YES;
        PatchVIew.hidden = YES;
        openBtn.hidden = YES;
        closeBtn.hidden = YES;
    }else {
        _mainTable.hidden = NO;
        openBtn.hidden = NO;
        closeBtn.hidden = NO;
        PatchVIew.hidden = NO;
    }
}

// 取消
- (void)canceOperation {
    NSString * SwitchNo = [NSString stringWithFormat:@"%@%@%@%@",Switch,Switch,Switch,Switch];
    NSString * strUrl = [SwitchNo stringByReplacingOccurrencesOfString:@":" withString:@""];  //去掉:
    NSString * str = [NSString stringWithFormat:@"%@%@%@",self.deviceNo,countdownStr,strUrl];
    NSString * hexString = [Utils hexStringFromString:str];
    NSString * CheckCode = [hexString substringFromIndex:2];
    NSString * Strr = [NSString stringWithFormat:@"%@%@%@%@%@%@",HeadStr,self.deviceNo,countdownStr,strUrl,CheckCode,TailStr];
    [BHSocket writeData:[Strr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
    [self stopTimer];
    _selectedItemIndex = NSIntegerMax;
    [_mainTable reloadData];
    [SVProgressHUD showSuccessWithStatus:Localize(@"Cancel Success")];
}

//新增UI
- (void)UI {
    CountdownView * view = [[[NSBundle mainBundle] loadNibNamed:@"CountdownView" owner:nil options:nil] firstObject];
    view.doneBlock = ^(NSString *selectDate) {
        self->time.text = selectDate;
    };
    view.buttonAction = ^(UIButton *sender) {
        [self SetCountdown];
    };
    _mainTable.tableFooterView = view;
}

// 延时开关
- (IBAction)DelayClosingBut:(UIButton *)sender {
    [self SetCountdown];
}

- (void)setUpTimer {
    //说明已经过了时间,不再开启定时器
    NSComparisonResult result =[startDate compare:[NSDate date]];
    if (result != NSOrderedDescending) {//是不是上面没有写这个StartDate进去啊
        [self stopTimer];
        return;
    }
    MyWeakSelf
    _timer = [NSTimer scheduledTimerWithTimeInterval:1  block:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf timeAction];
    }repeats:YES];
}

- (void)timeAction {
    lastSecend = MAX(0, [startDate timeIntervalSinceDate:[NSDate date]]);
    NSComparisonResult result =[startDate compare:[NSDate date]];
    if (lastSecend <= 0 || result != NSOrderedDescending) {
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
    [self showConfig];
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

/*设置cell 的宽度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:countCellIdentifier];
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
        WSDatePickerView * datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowHourMinute scrollToDate:[formatter dateFromString:[time.text substringToIndex:5]] CompleteBlock:^(NSDate *selectDate) {
            if (self.selectedItemIndex != indexPath.row) {
                self.selectedItemIndex = indexPath.row;
                [tableView reloadData];
            }
            [self->formatter setDateFormat:@"HH:mm:ss"];
            NSString * string = [self->formatter stringFromDate:selectDate];
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

- (void)ShiftData {
//         开关1
    if (self.type == 111) {
        if ([self.SwitchStr isEqualToString:@"80"] || [self.SwitchStr isEqualToString:@"82"] || [self.SwitchStr isEqualToString:@"84"] || [self.SwitchStr isEqualToString:@"86"] || [self.SwitchStr isEqualToString:@"88"] || [self.SwitchStr isEqualToString:@"8A"] || [self.SwitchStr isEqualToString:@"8C"] || [self.SwitchStr isEqualToString:@"8E"]) {
            open = NO;
        }else{
            open = YES;
        }
    }
//        开关2
    if (self.type == 222) {
        if ([self.SwitchStr isEqualToString:@"80"] || [self.SwitchStr isEqualToString:@"81"] || [self.SwitchStr isEqualToString:@"84"] || [self.SwitchStr isEqualToString:@"85"] || [self.SwitchStr isEqualToString:@"88"] || [self.SwitchStr isEqualToString:@"89"] || [self.SwitchStr isEqualToString:@"8D"] || [self.SwitchStr isEqualToString:@"8C"]) {
            open = NO;
        }else{
            open = YES;
        }
    }
//        开关3
    if (self.type == 333) {
        if ([self.SwitchStr isEqualToString:@"80"] || [self.SwitchStr isEqualToString:@"81"] || [self.SwitchStr isEqualToString:@"82"] || [self.SwitchStr isEqualToString:@"83"] || [self.SwitchStr isEqualToString:@"88"] || [self.SwitchStr isEqualToString:@"89"] || [self.SwitchStr isEqualToString:@"8A"] || [self.SwitchStr isEqualToString:@"8B"]) {
            open = NO;
        }else{
            open = YES;
        }
    }
//        开关4
    if (self.type == 444) {
        if ([self.SwitchStr isEqualToString:@"80"] || [self.SwitchStr isEqualToString:@"81"] || [self.SwitchStr isEqualToString:@"82"] || [self.SwitchStr isEqualToString:@"83"] || [self.SwitchStr isEqualToString:@"84"] || [self.SwitchStr isEqualToString:@"85"] || [self.SwitchStr isEqualToString:@"86"] || [self.SwitchStr isEqualToString:@"87"]) {
            open = NO;
        }else {
            open = YES;
        }
    }
    
    if (!open) {
//        开启
        closeBtn.layer.borderColor = [UIColor colorWithHexString:@"39B3FF"].CGColor;
        closeBtn.layer.borderWidth = 1;
        closeBtn.backgroundColor = [UIColor whiteColor];
        [closeBtn setTitleColor:[UIColor colorWithHexString:@"39B3FF"] forState:UIControlStateNormal];
        
        openBtn.backgroundColor = [UIColor colorWithHexString:@"BBBBBB"];
        [openBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        openBtn.layer.borderColor = [UIColor colorWithHexString:@"BBBBBB"].CGColor;
    }else {
        openBtn.layer.borderColor = [UIColor colorWithHexString:@"39B3FF"].CGColor;
        openBtn.layer.borderWidth = 1;
        openBtn.backgroundColor = [UIColor whiteColor];
        [openBtn setTitleColor:[UIColor colorWithHexString:@"39B3FF"] forState:UIControlStateNormal];
        
        closeBtn.backgroundColor = [UIColor colorWithHexString:@"BBBBBB"];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        closeBtn.layer.borderColor = [UIColor colorWithHexString:@"BBBBBB"].CGColor;
    }
}

//// 获取当前年月日时间
//- (void)yyyyMMddHHmm {
//    NSDate *currentDate = [NSDate date];
//    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
//    //IOS 8 之后
//    NSUInteger integer = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//    NSDateComponents *dataCom = [currentCalendar components:integer fromDate:currentDate];
//    NSInteger year = [dataCom year]; // 年
//    NSInteger month = [dataCom month]; // 月
//    NSInteger day = [dataCom day]; // 日
//    NSInteger hour = [dataCom hour]; // 时
//    NSInteger minute = [dataCom minute]; // 分
//    NSInteger second = [dataCom second]; // 秒
//    YEAR = [[NSNumber numberWithInteger:year] stringValue];
//    if (month >= 10) {
//        MONTH = [[NSNumber numberWithInteger:month] stringValue];
//    }else {
//        MONTH = [NSString stringWithFormat:@"0%ld",(long)month];
//    }
//    if (day >= 10) {
//        DAY = [[NSNumber numberWithInteger:day] stringValue];
//    }else {
//        DAY = [NSString stringWithFormat:@"0%ld",(long)day];
//    }
//    if (hour >= 10) {
//        HOUR = [[NSNumber numberWithInteger:hour] stringValue];
//    }else {
//        HOUR = [NSString stringWithFormat:@"0%ld",(long)hour];
//    }
//    if (minute >= 10) {
//        MINUTE = [[NSNumber numberWithInteger:minute] stringValue];
//    }else {
//        MINUTE = [NSString stringWithFormat:@"0%ld",(long)minute];
//    }
//    if (second >= 10) {
//        SECOND = [[NSNumber numberWithInteger:second] stringValue];
//    }else {
//        SECOND = [NSString stringWithFormat:@"0%ld",(long)second];
//    }
//    NSString * Ymdhms = [NSString stringWithFormat:@"%@%@%@%@%@%@",YEAR,MONTH,DAY,HOUR,MINUTE,SECOND];
//    NSString * YMDHMS = [Ymdhms substringFromIndex:2];
//    YMDHMS1 = [NSString stringWithFormat:@"%@",YMDHMS];
//}
//
//// 将字符串转换成时间差
//- (void)pleaseInsertStarTimeo:(NSString *)time1 andInsertEndTime:(NSString *)time2{
//    // 1.将时间转换为date
//    NSString * createdAtString = YMDHMS1;
//    NSString * createdAtString1 = YMDHMS2;
//    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyyMMddHHmmss";
//    NSDate * date2 = [formatter dateFromString:createdAtString1];
//    NSDate * date1 = [formatter dateFromString:createdAtString];
//    NSDate * date3 = [NSDate dateWithTimeIntervalSinceNow:ABS(date2.timeIntervalSinceNow-date1.timeIntervalSinceNow)];
//    NSInteger count = ABS(date2.timeIntervalSinceNow-date1.timeIntervalSinceNow);
//    NSInteger hours = count /3600;
//    NSInteger mnitues = count %3600/60;
//    NSInteger second = count %3600/600;
//    NSString * string = [NSString stringWithFormat:@"%.02ld:%.02ld:%.02ld",(long)hours,(long)mnitues,(long)second];
//    ZPLog(@"%@",string);
//    AllStr = [NSString stringWithFormat:@"%@",string];
//    }

@end
