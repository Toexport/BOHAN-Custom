//
//  ListViewController.h
//  BOHAN-Custom
//
//  Created by summer on 2018/10/25.
//  Copyright © 2018 summer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileHeader.pch"
NS_ASSUME_NONNULL_BEGIN

@interface ListViewController : UIViewController<GCDAsyncSocketDelegate,UITextFieldDelegate> {
    GCDAsyncSocket * socket;
}
@property (strong) GCDAsyncSocket * socket;
//@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

NS_ASSUME_NONNULL_END
