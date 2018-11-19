//
//  CountdownView.h
//  Bohan
//
//  Created by summer on 2018/8/2.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountdownView : UIView
{
    __weak IBOutlet UIButton *SettingBut; // 设置按钮
    __weak IBOutlet UITextField *YearTextField; // 年
    __weak IBOutlet UITextField *MonthTextField; // 月
    __weak IBOutlet UITextField *DayTextField; // 日
    __weak IBOutlet UITextField *HoursTextField; // 时
    __weak IBOutlet UITextField *MinutesTextField; // 分
}
typedef void(^doneBlock)(NSString *selectDate);
@property (nonatomic,strong)doneBlock doneBlock  ;
typedef void(^ButtonClick)(UIButton * sender);
@property (nonatomic,copy) ButtonClick buttonAction;

@property (nonatomic, strong) NSString * GetYearStr;
@property (nonatomic, strong) NSString * GetMonthStr;
@property (nonatomic, strong) NSString * GetDayStr;
@property (nonatomic, strong) NSString * GetHoursStr;
@property (nonatomic, strong) NSString * GetMinutesStr;

@property (nonatomic, strong) NSString * TakeYearStr;
@property (nonatomic, strong) NSString * TakeMonthStr;
@property (nonatomic, strong) NSString * TakeDayStr;
@property (nonatomic, strong) NSString * TakeHoursStr;
@property (nonatomic, strong) NSString * TakeMinutesStr;

@end
