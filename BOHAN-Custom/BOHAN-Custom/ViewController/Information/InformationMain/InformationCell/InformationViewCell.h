//
//  InformationViewCell.h
//  BOHAN-Custom
//
//  Created by summer on 2018/10/28.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InformationViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TitleNameLabel;// 标题
@property (weak, nonatomic) IBOutlet UILabel *IPLabel;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel1;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel2;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel3;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel4;
@property (weak, nonatomic) IBOutlet UISwitch *Switch1;
@property (weak, nonatomic) IBOutlet UISwitch *Switch2;
@property (weak, nonatomic) IBOutlet UISwitch *Switch3;
@property (weak, nonatomic) IBOutlet UISwitch *Switch4;
@property (weak, nonatomic) IBOutlet UIButton *Countdown1Btn;
@property (weak, nonatomic) IBOutlet UIButton *Countdown2Btn;
@property (weak, nonatomic) IBOutlet UIButton *Countdown3Btn;
@property (weak, nonatomic) IBOutlet UIButton *Countdown4Btn;

// 开关1
typedef void (^Switch1ONButBlock)(id Switch1OnBut);
@property (nonatomic , copy) Switch1ONButBlock switch1ONButBlock;
typedef void (^Switch1OFFButBlock)(id Switch1OFFButBlock);
@property (nonatomic , copy) Switch1OFFButBlock switch1OFFButBlock;
// 开关2
typedef void (^Switch2ONButBlock)(id Switch2OnBut);
@property (nonatomic , copy) Switch2ONButBlock switch2ONButBlock;
typedef void (^Switch2OFFButBlock)(id Switch2OFFButBlock);
@property (nonatomic , copy) Switch2OFFButBlock switch2OFFButBlock;
// 开关3
typedef void (^Switch3ONButBlock)(id Switch3OnBut);
@property (nonatomic , copy) Switch3ONButBlock switch3ONButBlock;
typedef void (^Switch3OFFButBlock)(id Switch3OFFButBlock);
@property (nonatomic , copy) Switch3OFFButBlock switch3OFFButBlock;
// 开关4
typedef void (^Switch4ONButBlock)(id Switch4OnBut);
@property (nonatomic , copy) Switch4ONButBlock switch4ONButBlock;
typedef void (^Switch4OFFButBlock)(id Switch4OFFButBlock);
@property (nonatomic , copy) Switch4OFFButBlock switch4OFFButBlock;

// 倒计时1
typedef void (^Countdown1BtnBlock)(id Countdown1Btn);
@property (nonatomic , copy) Countdown1BtnBlock countdown1BtnBlock;
// 倒计时2
typedef void (^Countdown2BtnBlock)(id Countdown2Btn);
@property (nonatomic , copy) Countdown2BtnBlock countdown2BtnBlock;
// 倒计时3
typedef void (^Countdown3BtnBlock)(id Countdown3Btn);
@property (nonatomic , copy) Countdown3BtnBlock countdown3BtnBlock;
// 倒计时4
typedef void (^Countdown4BtnBlock)(id Countdown4Btn);
@property (nonatomic , copy) Countdown4BtnBlock countdown4BtnBlock;

@end

NS_ASSUME_NONNULL_END
