//
//  CommonlyInstruction.h
//  BOHAN-Custom
//
//  Created by summer on 2018/11/6.
//  Copyright © 2018 张鹏. All rights reserved.
//

#ifndef CommonlyInstruction_h
#define CommonlyInstruction_h

/********头&&尾**********/
static NSString * HeadStr = @"E7";
static NSString * IdStrS;
static NSString * TailStr = @"0D"; // 尾部
/********开关查询以及指令**********/
static NSString * SwitchState;
static NSString * SwitchinstructionStr = @"00130001"; // 定时开关指令
static NSString * SwitchqueryStr = @"00260000";// 查询开关状态指令
static NSString * newMessage;
//static NSString * Strr; // 指令参数，全局
/********倒计时查询&&定时指令**********/
static NSString * CountdownqQueryStr = @"002F0000"; // 查询(倒计时)
//static NSString * SwitchShiftStr = @"00020000"; // 查询(开关状态)
static NSString * countdownStr = @"002E000C"; // 设置定时
static NSString * SetOpen = @"00"; // 开
static NSString * SetOff = @"01"; // 关闭
static NSString * Switch = @"0000FF"; // 空字符（设置开关为不动作状态）


#endif /* CommonlyInstruction_h */
