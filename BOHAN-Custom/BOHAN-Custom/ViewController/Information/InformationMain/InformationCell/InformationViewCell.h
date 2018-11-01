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
@property (weak, nonatomic) IBOutlet UIButton *CountdownBtn;

typedef void (^CountdownBtnBlock)(id CountdownBtn);
@property (nonatomic , copy) CountdownBtnBlock countdownBtnBlock;

typedef void (^ExtractButBlock)(id ExtractBut);
@property (nonatomic , copy) ExtractButBlock extractButBlock;

typedef void (^SxtractButBlock)(id SxtractBut);
@property (nonatomic , copy) SxtractButBlock sxtractButBlock;
@end

NS_ASSUME_NONNULL_END
