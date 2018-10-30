//
//  UserModel.h
//  BOHAN-Custom
//
//  Created by summer on 2018/10/29.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLMObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserModel : RLMObject
@property (nonatomic, strong) NSString * UserName;
@property (nonatomic, strong) NSString * PassWord;

+ (NSMutableArray *)arrayWithArray:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
