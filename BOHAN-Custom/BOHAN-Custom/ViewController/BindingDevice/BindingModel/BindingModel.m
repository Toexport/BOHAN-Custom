//
//  BindingModel.m
//  BOHAN-Custom
//
//  Created by summer on 2018/10/30.
//  Copyright © 2018 张鹏. All rights reserved.
//

#import "BindingModel.h"

@implementation BindingModel

+ (NSMutableArray *)arrayWithArray:(NSArray *)array {
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in array) {
        BindingModel * model = [[BindingModel alloc]init];
        model.IP = dic[@"ip"];
        model.Port = dic[@"port"];
        model.Title = dic[@"title"];
        model.Switch1 = dic[@"switch1"];
        model.Switch2 = dic[@"switch2"];
        model.Switch3 = dic[@"switch3"];
        model.Switch4 = dic[@"switch4"];
        [arr addObject:model];
    }
    return arr;
}

@end
