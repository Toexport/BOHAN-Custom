//
//  UserModel.m
//  BOHAN-Custom
//
//  Created by summer on 2018/10/29.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (NSMutableArray *)arrayWithArray:(NSArray *)array{
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in array) {
        UserModel * model = [[UserModel alloc]init];
        model.UserName = dic[@"UserName"];
        model.PassWord = dic[@"PassWord"];
        [arr addObject:model];
    }
    return arr;
}
@end

//#import <Realm/Realm.h>
//// .m
//@implementation Dog
//@end  // 暂无使用
//
//@implementation Person
//@end  // 暂无使用
