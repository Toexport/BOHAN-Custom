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

@end

NS_ASSUME_NONNULL_END
