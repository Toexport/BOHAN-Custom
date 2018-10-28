//
//  BindingController.h
//  BOHAN-Custom
//
//  Created by summer on 2018/10/27.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileHeader.pch"
NS_ASSUME_NONNULL_BEGIN

@interface BindingController : UIViewController<GCDAsyncSocketDelegate,UITextFieldDelegate> {
    GCDAsyncSocket * socket;
}
@property (strong) GCDAsyncSocket * socket;
@property (weak, nonatomic) IBOutlet UITextField *HostTextField;
@property (weak, nonatomic) IBOutlet UITextField *PortTextField;
- (IBAction)sender:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
