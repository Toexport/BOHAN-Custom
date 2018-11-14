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
    ZPLog(@"%@",str1);
    
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
        [self->formatters setDateFormat:@"yyyy"];// 解决问题
        [self->YearTextField setText:[self->formatters stringFromDate:selectDate]];
        self.string1 = self->YearTextField.text;
        self->YearTextField.text = [NSString stringWithString:self.string1];
        
        [self->formatters setDateFormat:@"MM"];
        [self->MonthTextField setText:[self->formatters stringFromDate:selectDate]];
        self.string2 = self->MonthTextField.text;
        self->MonthTextField.text = [NSString stringWithString:self.string2];
        
        [self->formatters setDateFormat:@"dd"];
        [self->DayTextField setText:[self->formatters stringFromDate:selectDate]];
        self.string3 = self->DayTextField.text;
        self->DayTextField.text = [NSString stringWithString:self.string3];
        
        [self->formatters setDateFormat:@"HH"];
        [self->HoursTextField setText:[self->formatters stringFromDate:selectDate]];
        self.string4 = self->HoursTextField.text;
        self->HoursTextField.text = [NSString stringWithString:self.string4];
        
        [self->formatters setDateFormat:@"mm"];
        [self->MinutesTextField setText:[self->formatters stringFromDate:selectDate]];
        self.string5 = self->MinutesTextField.text;
        self->MinutesTextField.text = [NSString stringWithString:self.string5];
        NSString * string1 = [NSString stringWithFormat:@"%@%@%@%@%@",self->YearTextField.text,self->MonthTextField.text,self->DayTextField.text,self->HoursTextField.text,self->MinutesTextField.text];
        self->str2 = [NSString stringWithFormat:@"%@",string1];
        ZPLog(@"%@",self->str2);
        if (self->str1.integerValue >= self->str2.integerValue) {
            [SVProgressHUD showInfoWithStatus:Localize(@"Set time Cannot be less than pre-order Time")];
            return ;
        }else {
        [self pleaseInsertStarTimeo:self->str1 andInsertEndTime:self->str2];
        }
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
}
@end
