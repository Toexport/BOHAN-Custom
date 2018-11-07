//
//  CountDownViewController.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/26.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileHeader.pch"
@interface CountDownViewController : UIViewController<GCDAsyncSocketDelegate,UITextFieldDelegate> {

    __weak IBOutlet UIButton *DelayClosingBut;
    __weak IBOutlet UIView *PatchVIew;
    
}
@property (nonatomic, copy) NSString *deviceNo;
//@property (nonatomic, assign) BOOL *isCountDownModel;
//- (IBAction)cancelAction;
@property (nonatomic, assign) NSInteger type; // 识别号
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PatchViewLayoutConstraint;

@end
