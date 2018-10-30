//
//  BindingModel.h
//  BOHAN-Custom
//
//  Created by summer on 2018/10/30.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BindingModel : NSObject
@property (nonatomic, strong) NSString * IP;
@property (nonatomic, strong) NSString * Port;
@property (nonatomic, strong) NSString * Title;
@property (nonatomic, strong) NSString * Switch1;
@property (nonatomic, strong) NSString * Switch2;
@property (nonatomic, strong) NSString * Switch3;
@property (nonatomic, strong) NSString * Switch4;

+ (NSMutableArray *)arrayWithArray:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
