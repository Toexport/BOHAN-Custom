//
//  InformationController.h
//  BOHAN-Custom
//
//  Created by summer on 2018/10/28.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileHeader.pch"
NS_ASSUME_NONNULL_BEGIN

@interface InformationController : UIViewController<GCDAsyncSocketDelegate,UITextFieldDelegate> {
    GCDAsyncSocket * socket;
}
@property (strong) GCDAsyncSocket * socket;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *titleView;

@end

NS_ASSUME_NONNULL_END
