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
//    [self ymdhms];
    [self UI];
}

- (void)CountdownS {
    self.datas = @[Localize(@"5 Minutes"), Localize(@"10 Minutes"), Localize(@"Custom Time")];
    formatter = [[NSDateFormatter alloc] init];
    _selectedItemIndex = NSIntegerMax;
    _mainTable.tintColor = [UIColor colorWithHexString:@"f03c4c"];
    [progressView setPersentage:0];
    [self rightBarTitle:Localize(@"Cancel") color:[UIColor whiteColor] action:@selector(canceOperation)];
}

//  生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    BHUpdeteDelegate;
    [self loadData];
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
        [self updateConfig];
        [self GetsTime];
    }
    
    ZPLog(@"——————所有数据---%@",newMessage);
    [SVProgressHUD dismiss];
}

- (void)updateConfig {
    NSString *content = nil;
    NSString *statusStr = nil;
    switch (self.type) {
        case 111:content = Switch1; statusStr = State1; break;
        case 222:content = Switch2; statusStr = State2; break;
        case 333:content = Switch3; statusStr = State3; break;
        case 444:content = Switch4; statusStr = State4; break;
            
        default:
            break;
    }
    if ([statusStr isEqualToString:@"FF"]) {
        [status setText:Localize(@"设备关闭")];
    }else {
        [status setText:Localize(@"设备打开")];
        [formatter setDateFormat:@"yyMMddHHmmss"];
        startDate = [formatter dateFromString:content];
        if (!startDate) {
            return ;
        }
    }
    totalSecend = MAX(0, [startDate timeIntervalSinceDate:[NSDate date]]);
    [self showConfig];
    [self setUpTimer];
}

// 定时开关
- (void)SetCountdown {
    NSString * content = [time.text stringByReplacingOccurrencesOfString:@":" withString:@""];
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
        _TimeStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",_TimeUrl,SetOpen,Switch,State2,Switch,State3,Switch,State4];
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

//  取消
- (void)canceOperation {
    NSString * SwitchNo = [NSString stringWithFormat:@"%@FF%@FF%@FF%@FF",Switch,Switch,Switch,Switch];
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

//  新增UI
- (void)UI {
    CountdownView * view = [[[NSBundle mainBundle] loadNibNamed:@"CountdownView" owner:nil options:nil] firstObject];
    view.doneBlock = ^(NSString *selectDate) {
        self->time.text = selectDate;
        ZPLog(@"%@",selectDate);
    };
    view.buttonAction = ^(UIButton *sender) {
        [self SetCountdown];
    };
    _mainTable.tableFooterView = view;
}

//  延时开关
- (IBAction)DelayClosingBut:(UIButton *)sender {
    [self SetCountdown];
}

- (void)setUpTimer {
//    说明已经过了时间,不再开启定时器
    NSComparisonResult result =[startDate compare:[NSDate date]];
    if (result != NSOrderedDescending) {
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
    [_timer pauseTimer];
    [_timer invalidate];
    _timer = nil;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
//       开关1
    if (self.type == 111) {
        if ([self.SwitchStr isEqualToString:@"80"] || [self.SwitchStr isEqualToString:@"82"] || [self.SwitchStr isEqualToString:@"84"] || [self.SwitchStr isEqualToString:@"86"] || [self.SwitchStr isEqualToString:@"88"] || [self.SwitchStr isEqualToString:@"8A"] || [self.SwitchStr isEqualToString:@"8C"] || [self.SwitchStr isEqualToString:@"8E"]) {
            open = NO;
        }else{
            open = YES;
        }
    }
    
//      开关2
    if (self.type == 222) {
        if ([self.SwitchStr isEqualToString:@"80"] || [self.SwitchStr isEqualToString:@"81"] || [self.SwitchStr isEqualToString:@"84"] || [self.SwitchStr isEqualToString:@"85"] || [self.SwitchStr isEqualToString:@"88"] || [self.SwitchStr isEqualToString:@"89"] || [self.SwitchStr isEqualToString:@"8D"] || [self.SwitchStr isEqualToString:@"8C"]) {
            open = NO;
        }else{
            open = YES;
        }
    }
    
//      开关3
    if (self.type == 333) {
        if ([self.SwitchStr isEqualToString:@"80"] || [self.SwitchStr isEqualToString:@"81"] || [self.SwitchStr isEqualToString:@"82"] || [self.SwitchStr isEqualToString:@"83"] || [self.SwitchStr isEqualToString:@"88"] || [self.SwitchStr isEqualToString:@"89"] || [self.SwitchStr isEqualToString:@"8A"] || [self.SwitchStr isEqualToString:@"8B"]) {
            open = NO;
        }else{
            open = YES;
        }
    }
    
//      开关4
    if (self.type == 444) {
        if ([self.SwitchStr isEqualToString:@"80"] || [self.SwitchStr isEqualToString:@"81"] || [self.SwitchStr isEqualToString:@"82"] || [self.SwitchStr isEqualToString:@"83"] || [self.SwitchStr isEqualToString:@"84"] || [self.SwitchStr isEqualToString:@"85"] || [self.SwitchStr isEqualToString:@"86"] || [self.SwitchStr isEqualToString:@"87"]) {
            open = NO;
        }else {
            open = YES;
        }
    }
    
    if (!open) {
//      开启
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

- (void)GetsTime {
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
//  IOS 8 之后
    NSUInteger integer = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents * dataCom = [currentCalendar components:integer fromDate:currentDate];
    NSInteger year = [dataCom year]; // 年
    NSInteger month = [dataCom month]; // 月
    NSInteger day = [dataCom day]; // 日
    NSInteger week = [dataCom weekday]; // 星期
    NSInteger hour = [dataCom hour]; // 时
    NSInteger minute = [dataCom minute]; // 分
    NSInteger second = [dataCom second]; // 秒
    NSString * Year = [[NSNumber numberWithInteger:year] stringValue];
    string1 = [Year substringFromIndex:2]; // 去掉首字符
    if (month >= 10) {
        string2 = [[NSNumber numberWithInteger:month] stringValue];
    }else {
        string2 = [NSString stringWithFormat:@"0%ld",(long)month];
    }
    if (day >= 10) {
        string3 = [[NSNumber numberWithInteger:day] stringValue];
    }else {
        string3 = [NSString stringWithFormat:@"0%ld",(long)day];
    }
    if (hour >= 10) {
        string5 = [[NSNumber numberWithInteger:hour] stringValue];
    }else{
        string5 = [NSString stringWithFormat:@"0%ld",(long)hour];
    }
    if (minute >= 10) {
        string6 = [[NSNumber numberWithInteger:minute] stringValue];
    }else {
        string6 = [NSString stringWithFormat:@"0%ld",(long)minute];
    }
    if (second >= 10) {
        string7 = [[NSNumber numberWithInteger:second] stringValue];
    }else {
        string7 = [NSString stringWithFormat:@"0%ld",(long)second];
    }
    
//   星期
    NSString * WeekStr = [NSString stringWithFormat:@"%ld",(long)week];
    ZPLog(@"%@",WeekStr);
    if ([WeekStr containsString:@"1"]) {
        week = 0;
        if (week >= 10) {
            string4 = [[NSNumber numberWithInteger:week] stringValue];
        }else {
            string4 = [NSString stringWithFormat:@"0%ld",(long)week];
        }
    }
    if ([WeekStr containsString:@"2"]) {
        week = 1;
        if (week >= 10) {
            string4 = [[NSNumber numberWithInteger:week] stringValue];
        }else {
            string4 = [NSString stringWithFormat:@"0%ld",(long)week];
        }
    }
    if ([WeekStr containsString:@"3"]) {
        week = 2;
        if (week >= 10) {
            string4 = [[NSNumber numberWithInteger:week] stringValue];
        }else {
            string4 = [NSString stringWithFormat:@"0%ld",(long)week];
        }
    }
    if ([WeekStr containsString:@"4"]) {
        week = 3;
        if (week >= 10) {
            string4 = [[NSNumber numberWithInteger:week] stringValue];
        }else {
            string4 = [NSString stringWithFormat:@"0%ld",(long)week];
        }
    }
    if ([WeekStr containsString:@"5"]) {
        week = 4;
        if (week >= 10) {
            string4 = [[NSNumber numberWithInteger:week] stringValue];
        }else {
            string4 = [NSString stringWithFormat:@"0%ld",(long)week];
        }
    }
    if ([WeekStr containsString:@"6"]) {
        week = 5;
        if (week >= 10) {
            string4 = [[NSNumber numberWithInteger:week] stringValue];
        }else {
            string4 = [NSString stringWithFormat:@"0%ld",(long)week];
        }
    }
    if ([WeekStr containsString:@"7"]) {
        week = 6;
        if (week >= 10) {
            string4 = [[NSNumber numberWithInteger:week] stringValue];
        }else {
            string4 = [NSString stringWithFormat:@"0%ld",(long)week];
        }
    }
    Ymdhms = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",string1,string2,string3,string4,string5,string6,string7];
    ZPLog(@"%@",Ymdhms);
    [self CheckTime];
}

// 校验时间
- (void)CheckTime {
    NSString * str = [NSString stringWithFormat:@"%@%@%@",self.deviceNo,CheckTimeStr,Ymdhms];
    NSString * string = [Utils hexStringFromString:str];
    NSString * CheckCode = [string substringFromIndex:2]; // 去掉首字符
    NSString * CollectionStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",HeadStr,self.deviceNo,CheckTimeStr,Ymdhms,CheckCode,TailStr];
    [BHSocket writeData:[CollectionStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [BHSocket readDataWithTimeout:-1 tag:0];
    ZPLog(@"%@",CollectionStr);
}

@end


