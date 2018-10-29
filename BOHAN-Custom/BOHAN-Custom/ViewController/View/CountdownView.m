//
//  CountdownView.m
//  Bohan
//
//  Created by summer on 2018/8/2.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "CountdownView.h"
#import "WSDatePickerView.h"
#import "FileHeader.pch"

@interface CountdownView () {
    NSDateFormatter *formatters;
    NSString * str1;
    NSString * str2;
}

@end

@implementation CountdownView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self yyyyMMddHHmm];
    
}
// 设置按钮
- (IBAction)SettingBut:(UIButton *)sender {

    if (self.buttonAction) {
        self.buttonAction(sender);
    }
    
}

// 获取当前年月日时间
- (void)yyyyMMddHHmm {
    
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    //IOS 8 之后
    NSUInteger integer = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dataCom = [currentCalendar components:integer fromDate:currentDate];
    NSInteger year = [dataCom year]; // 年
    NSInteger month = [dataCom month]; // 月
    NSInteger day = [dataCom day]; // 日
    NSInteger hour = [dataCom hour]; // 时
    NSInteger minute = [dataCom minute]; // 分
    
    self.string1 = [[NSNumber numberWithInteger:year] stringValue];
    self.string11 = [[NSNumber numberWithInteger:year] stringValue];
//    YYYYTextField.text = [NSString stringWithString:self.string1];
    YearTextField.text = [NSString stringWithString:self.string11];
    if(month >= 10) {
        self.string2 = [[NSNumber numberWithInteger:month] stringValue];
        self.string22 = [[NSNumber numberWithInteger:month] stringValue];
    }else {
        self.string2 = [NSString stringWithFormat:@"0%ld",(long)month];
        self.string22 = [NSString stringWithFormat:@"0%ld",(long)month];
    }
//    mmTextField.text = [NSString stringWithString:self.string2];
    MonthTextField.text = [NSString stringWithString:self.string22];
    
    if (day >= 10) {
        self.string3 = [[NSNumber numberWithInteger:day] stringValue];
        self.string33 = [[NSNumber numberWithInteger:day] stringValue];
    }else {
        self.string3 = [NSString stringWithFormat:@"0%ld",(long)day];
        self.string33 = [NSString stringWithFormat:@"0%ld",(long)day];
    }
//    DDTextField.text = [NSString stringWithString:self.string3];
    DayTextField.text = [NSString stringWithString:self.string3];
    
    if (hour >= 10) {
        self.string4 = [[NSNumber numberWithInteger:hour] stringValue];
        self.string44 = [[NSNumber numberWithInteger:hour] stringValue];
    }else{
        self.string4 = [NSString stringWithFormat:@"0%ld",(long)hour];
        self.string44 = [NSString stringWithFormat:@"0%ld",(long)hour];
    }
//    HHTextField.text = [NSString stringWithString:self.string4];
    HoursTextField.text = [NSString stringWithString:self.string44];
    if (minute >= 10) {
        self.string5 = [[NSNumber numberWithInteger:minute] stringValue];
        self.string55 = [[NSNumber numberWithInteger:minute] stringValue];
    }else {
        self.string5 = [NSString stringWithFormat:@"0%ld",(long)minute];
        self.string55 = [NSString stringWithFormat:@"0%ld",(long)minute];
    }
//    MMTextField.text = [NSString stringWithString:self.string5];
    MinutesTextField.text = [NSString stringWithString:self.string55];
    NSString * string = [NSString stringWithFormat:@"%@%@%@%@%@",YearTextField.text,MonthTextField.text,DayTextField.text,HoursTextField.text,MinutesTextField.text];
    str1 = [NSString stringWithFormat:@"%@",string];
    NSLog(@"%@",str1);
    
}


// 选中时间按钮
- (IBAction)SelectediTemBut:(UIButton *)sender {
    NSString *string;
    if (!formatters) {
        formatters = [[NSDateFormatter alloc] init];
        formatters.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    [formatters setDateFormat:@"yyyy-MM-dd HH:mm"];
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute scrollToDate:[formatters dateFromString:string] CompleteBlock:^(NSDate *selectDate) {
        [self yyyyMMddHHmm];
        [formatters setDateFormat:@"yyyy"];// 解决问题
        [YearTextField setText:[formatters stringFromDate:selectDate]];
        self.string1 = YearTextField.text;
        YearTextField.text = [NSString stringWithString:self.string1];
        
        [formatters setDateFormat:@"MM"];
        [MonthTextField setText:[formatters stringFromDate:selectDate]];
        self.string2 = MonthTextField.text;
        MonthTextField.text = [NSString stringWithString:self.string2];
        
        [formatters setDateFormat:@"dd"];
        [DayTextField setText:[formatters stringFromDate:selectDate]];
        self.string3 = DayTextField.text;
        DayTextField.text = [NSString stringWithString:self.string3];
        
        [formatters setDateFormat:@"HH"];
        [HoursTextField setText:[formatters stringFromDate:selectDate]];
        self.string4 = HoursTextField.text;
        HoursTextField.text = [NSString stringWithString:self.string4];
        
        [formatters setDateFormat:@"mm"];
        [MinutesTextField setText:[formatters stringFromDate:selectDate]];
        self.string5 = MinutesTextField.text;
        MinutesTextField.text = [NSString stringWithString:self.string5];
        NSString * string1 = [NSString stringWithFormat:@"%@%@%@%@%@",YearTextField.text,MonthTextField.text,DayTextField.text,HoursTextField.text,MinutesTextField.text];
        str2 = [NSString stringWithFormat:@"%@",string1];
        NSLog(@"%@",str2);
        [self pleaseInsertStarTimeo:str1 andInsertEndTime:str2];
        
    }];
    datepicker.hideBackgroundYearLabel = YES;
    datepicker.dateLabelColor = [UIColor colorWithHexString:@"3c94f2"];
    datepicker.doneButtonColor = [UIColor colorWithHexString:@"3c94f2"];
    [datepicker show];
}

// 将字符串转换成时间差
- (void)pleaseInsertStarTimeo:(NSString *)time1 andInsertEndTime:(NSString *)time2{
    // 1.将时间转换为date
    NSString * createdAtString = str2;
    NSString * createdAtString1 = str1;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmm";
    NSDate *date2 = [formatter dateFromString:createdAtString1];
    NSDate *date1 = [formatter dateFromString:createdAtString];
    NSDate *date3 = [NSDate dateWithTimeIntervalSinceNow:ABS(date2.timeIntervalSinceNow-date1.timeIntervalSinceNow)];
    NSInteger count = ABS(date2.timeIntervalSinceNow-date1.timeIntervalSinceNow);
    NSInteger hours = count /3600;
    NSInteger mnitues = count %3600/60;
    NSString *string = [NSString stringWithFormat:@"%.02ld:%.02ld:00",(long)hours,(long)mnitues];
    if (self.doneBlock) {
        self.doneBlock(string);
        
    }
//    
//    // 2.创建日历
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
//    // 3.利用日历对象比较两个时间的差值
//    NSDateComponents *cmps = [calendar components:type fromDate:date2 toDate:date1 options:0];
////    NSString * string = [NSString stringWithFormat:@"%ld%ld%ld%ld", (long)cmps.year, (long)cmps.month, (long)cmps.day, (long)cmps.hour, (long)cmps.minute];
////    ZPLog(@"%@",string);
//    // 4.输出结果
//    NSLog(@"两个时间相差%ld年%ld月%ld日%ld小时%ld分钟", (long)cmps.year, (long)cmps.month, (long)cmps.day, (long)cmps.hour, (long)cmps.minute);
}
@end
