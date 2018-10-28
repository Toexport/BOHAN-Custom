//
//  ManagementCell.h
//  BOHAN-Custom
//
//  Created by summer on 2018/10/27.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ManagementCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UILabel *TypeLabel;

@end

NS_ASSUME_NONNULL_END
