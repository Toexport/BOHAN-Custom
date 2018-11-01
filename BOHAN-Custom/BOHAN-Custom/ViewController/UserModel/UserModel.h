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

//
//#import <Realm/Realm.h>
//
//@class Person;
//
//// 狗狗的数据模型
//@interface Equipment : RLMObject
//@property NSString *name;// 最外层
////@property Person   *owner;
//@end
//RLM_ARRAY_TYPE(Equipment) // 定义RLMArray<Dog>
//
//// 狗狗主人的数据模型
//@interface Person : RLMObject
//@property NSString      *name; //
////@property NSDate        *birthdate;
//
//// 通过RLMArray建立关系
////@property RLMArray<Equipment> *dogs;
//
//@end


