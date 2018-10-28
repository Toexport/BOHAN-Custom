//
//  BindingDeviceController.h
//  BOHAN-Custom
//
//  Created by summer on 2018/10/28.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileHeader.pch"
NS_ASSUME_NONNULL_BEGIN

@interface BindingDeviceController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *IPTExtField;
@property (weak, nonatomic) IBOutlet UITextField *PortTextField;
@property (weak, nonatomic) IBOutlet UITextField *TitleNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *Switch1Name;
@property (weak, nonatomic) IBOutlet UITextField *Switch2Name;
@property (weak, nonatomic) IBOutlet UITextField *Switch3Name;
@property (weak, nonatomic) IBOutlet UITextField *Switch4Name;
@property (weak, nonatomic) IBOutlet UIButton *ConnectBtn;
@property (weak, nonatomic) IBOutlet UIButton *SaveBtn;

@end

NS_ASSUME_NONNULL_END
