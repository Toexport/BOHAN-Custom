//
//  Utils.h
//  UFA
//
//  Created by YangLin on 2017/7/19.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
CGRect CGRectChangeWidth(CGRect frame, CGFloat width);
CGRect CGRectChangeHeight(CGRect frame, CGFloat height);
CGRect CGRectChangeX(CGRect frame, CGFloat x);
CGRect CGRectChangeY(CGRect frame, CGFloat y);
CGRect CGRectChangeOrigin(CGRect frame, CGFloat x, CGFloat y);
CGRect CGRectChangeSize(CGRect frame, CGFloat width, CGFloat height);

CGSize getTextSize(UIFont *font,NSString *text, CGFloat maxWidth);
CGSize getTextSizeWithAttributes(UIFont *font,NSString *text, CGFloat maxWidth, NSMutableParagraphStyle * paragraphStyle);
@interface Utils : NSObject

//+ (NSString *)HTMLWithData:(NSDictionary *)data usingTemplate:(NSString *)templateName;
//+ (NSString *)htmlFormat:(NSString *)html
//            articleTitle:(NSString *)title
//                  author:(NSString *)authorName
//            timeInterval:(NSString *)time;

/**
 *  @brief  过滤HTML标签
 *
 *  @param html HTML字符串
 *
 *  @return 返回过滤后的字符串
 */
+ (NSString *)filterHTML:(NSString *)html;


+ (NSString *)htmlEntityDecode:(NSString *)string;

/**
 *  @brief  url utf8编码
 *
 *  @param string 需编码的URL字符串
 *
 *  @return 编码后的字符串
 */

+ (NSString*)encodeURL:(NSString *)string;


+ (NSString *)md5:(NSString *)input;


/**
 *  @brief  验证手机号码
 *
 *  @param mobileNum 手机号
 *
 *  @return 返回是否验证通过
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 *  @brief  验证手固话
 *
 *  @param mobileNum 固话号码
 *
 *  @return 返回是否验证通过
 */
+ (BOOL)isCTNumber:(NSString *)mobileNum;

/**
 *  @brief 验证邮箱
 *
 *  @param email 邮箱
 *
 *  @return 返回是否验证通过
 */
+ (BOOL)validateEmail:(NSString *)email;

/**
 *  @return 验证是否是url
 */

+(BOOL)isUrl:(NSString *)URL;

/**
 *  @return 验证是否是身份证
 */

+ (BOOL)CheckIsIdentityCard: (NSString *)identityCard;

/**
 *  @brief 验证账号
 *
 *  @param account 注册账号
 *
 *  @return 验证是否验证通过
 */
+(BOOL)vertifyTheAccount:(NSString *)account;

/**
 *  @brief 验证密码
 *
 *  @param password 密码
 *
 *  @return 返回是否验证通过
 */
+(BOOL)vertifyThePassword:(NSString *)password;

/**
 *  @brief 验证是否是数字
 *
 *  @param string 被验证数字
 *
 *  @return 返回是否验证通过
 */
+(BOOL)isPureInt:(NSString*)string;

///**
// *  @brief 获取状态码对应的错误信息
// *
// *  @param code 状态码
// *
// *  @return 返回错误信息
// */
//+ (NSString *)messageWithCode:(int)code;


//判断中英混合的的字符串长度
+ (int)convertToInt:(NSString*)strtemp;

//数字每三位逗号分隔
+(NSString *)countNumAndChangeformat:(NSString *)num;

/**
 *  @brief 添加3D,围绕x轴旋转方法
 *  @param angle   开始旋转角度
 *  @param to      结束旋转角度
 *  @param duraton 旋转时间
 *  @param layer   添加动画的层
 */
+ (void)addRotation_X_AnimationFromAngle:(CGFloat)angle to:(CGFloat)toAngle duration:(CGFloat)duraton onLayer:(CALayer*)layer;

//获取手机型号
+ (NSString* )clientModel;

+ (NSDateComponents *)timeIntervalWithTimeStamp:(NSTimeInterval)start endStamp:(NSTimeInterval)end;
//对象转json字符串
+(NSString*)dataToJsonString:(id)object;


+(NSString *)datetimeStrbyNoSS:(NSString*)jsontimeStr;

//
///**
// 用户角色验证，供应商限制部分操作
//
// @return 角色是否合法
// */
//+(BOOL)corporateTypeValidate;

/**
  获取相册图片处理,是上传到后台的图片方向一致
 
 @return image
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/**
 转换十六进制
 @return 十六进制数
 */
+ (NSString *)hexStringFromString:(NSString *)string;


/**
 十进制转换十六进制
 
 @param decimal 十进制数
 @return 十六进制数
 */
+ (NSString *)getHexByDecimal:(NSInteger)decimal;

// 16进制转10进制
+ (NSNumber *)numberHexString:(NSString *)aHexString;

/**
 十六进制转换为二进制
 
 @param hex 十六进制数
 @return 二进制数
 */
+ (NSString *)getBinaryByHex:(NSString *)hex;

//十进制转二进制

+ (NSString *)toBinarySystemWithDecimalSystem:(NSInteger)decimal;

+ (NSString *)getHexByBinary:(NSString *)binary;

//+ (NSString *)hexStringFromString:(NSString *)string;

//时间间隔时分秒
+ (NSString *)gapDateFrom:(NSDate *)fromDate toDate:(NSDate *)toDate;
@end
