//
//  RegisterViewController.h
//  BOHAN-Custom
//
//  Created by summer on 2018/10/28.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *UserNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *PassWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *DetermineBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ViewTopLayoutConstraint;

@end

NS_ASSUME_NONNULL_END
