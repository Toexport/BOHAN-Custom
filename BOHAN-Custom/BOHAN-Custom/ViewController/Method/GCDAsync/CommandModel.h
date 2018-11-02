//
//  CommandModel.h
//  BOHAN-Custom
//
//  Created by summer on 2018/11/1.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommandModel : NSObject
@property (nonatomic, copy)NSString *deviceNo;
@property (nonatomic, copy)NSString *command;
@property (nonatomic, copy)NSString *content;
@end

NS_ASSUME_NONNULL_END
