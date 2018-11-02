
//
//  Utils.m
//  UFA
//
//  Created by YangLin on 2017/7/19.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>
#import "sys/utsname.h"
#import "FileHeader.pch"
//#import "DebuggingANDPublishing.pch"
CGRect CGRectChangeWidth(CGRect frame, CGFloat width)
{
    frame.size.width = width;
    return frame;
}

CGRect CGRectChangeHeight(CGRect frame, CGFloat height)
{
    frame.size.height = height;
    return frame;
}

CGRect CGRectChangeX(CGRect frame, CGFloat x)
{
    frame.origin.x = x;
    return frame;
}

CGRect CGRectChangeY(CGRect frame, CGFloat y)
{
    frame.origin.y = y;
    return frame;
}

CGRect CGRectChangeOrigin(CGRect frame, CGFloat x, CGFloat y)
{
    frame.origin.x = x;
    frame.origin.y = y;
    return frame;
}

CGRect CGRectChangeSize(CGRect frame, CGFloat width, CGFloat height)
{
    frame.size.width = width;
    frame.size.height = height;
    return frame;
}

CGSize getTextSize(UIFont *font,NSString *text, CGFloat maxWidth)
{
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName: font}
                                         context:nil].size;
    return textSize;
    
}

CGSize getTextSizeWithAttributes(UIFont *font,NSString *text, CGFloat maxWidth, NSMutableParagraphStyle * paragraphStyle)
{
    
    
    
    //    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    //    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary * attributes = @{NSFontAttributeName : font,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    
    CGSize contentSize = [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                            options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                         attributes:attributes
                                            context:nil].size;
    contentSize.width  = contentSize.width;
    contentSize.height = contentSize.height;
    return contentSize;
    
    
    //
    //    CGSize textSize = [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
    //                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
    //                                      attributes:@{NSFontAttributeName: font}
    //                                         context:nil].size;
    //    return textSize;
    
}

CGSize getTextSizeWithAttributesDic(NSString *text, CGFloat maxWidth, NSStringDrawingOptions options, NSDictionary * attributes)
{
    
    CGSize contentSize = [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                            options:options
                                         attributes:attributes
                                            context:nil].size;
    contentSize.width  = contentSize.width;
    contentSize.height = contentSize.height;
    return contentSize;
}


@implementation Utils


+ (NSString *)filterHTML:(NSString *)html
{
    
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        
    }
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    //    html = [html stringByReplacingOccurrencesOfString:@"&nbsp" withString:@""];
    
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}



+ (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return string;
}

+ (NSString*)encodeURL:(NSString *)string
{
    NSString *newString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    if (newString) {
        return newString;
    }
    return @"";
}


+ (NSString *)md5:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}


+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     最新
     包括中国联通：联通130、131、132、155、156、176、185、186、145手机号码段。
     
     中国电信CDMA号段：133、1349、153、177、180、181、189手机号码段。
     
     中国移动：134、135、136、137、138、139、147、150、151、152、157、158、159、178、182、183、184、187、188手机号段。
     
     虚拟运营商号段：170
     
     新增：移动：147，152，178，183、184、187
     联通：145，176
     电信：
     **/
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186，145，176
     * 电信：133,1349,153,177,180,181,189
     */
    NSString * MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[06-8]|8[0-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|4[7]|5[0127-9]|7[8]|8[2-478])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,155,156,185,186，145，176
     17         */
    NSString * CU = @"^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,181,189,177
     22         */
    NSString * CT = @"^1((33|53|77|8[019])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    /*
     大范围
     NSString *TEL = @"^[1][3-8]+\\d{9}";
     */
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


+ (BOOL)isCTNumber:(NSString *)mobileNum
{
    NSString * CT = @"^(0[0-9]{2,3}-)?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^(13[0-9]|15[0|3|6|7|8|9]|18[8|9])\\d{8}$)";
    
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if ([regextestct evaluateWithObject:mobileNum] == YES){
        return YES;
    }else{
        return NO;
    }
}


+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


+(BOOL)isUrl:(NSString *)URL
{
    if(URL == nil)
        return NO;
    
    NSString *url;
    if (URL.length>4 && [[URL substringToIndex:4] isEqualToString:@"www."]) {
        url = [NSString stringWithFormat:@"http://%@",URL];
    }else{
        url = URL;
    }
    NSString *urlRegex = @"(https|http|ftp|rtsp|igmp|file|rtspt|rtspu)://((((25[0-5]|2[0-4]\\d|1?\\d?\\d)\\.){3}(25[0-5]|2[0-4]\\d|1?\\d?\\d))|([0-9a-z_!~*'()-]*\\.?))([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.([a-z]{2,6})(:[0-9]{1,4})?([a-zA-Z/?_=]*)\\.\\w{1,5}";
    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlTest evaluateWithObject:url];
}


//身份证号
+ (BOOL)CheckIsIdentityCard: (NSString *)identityCard
{
    //判断是否为空
    if (identityCard==nil||identityCard.length <= 0) {
        return NO;
    }
    //判断是否是18位，末尾是否是x
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if(![identityCardPredicate evaluateWithObject:identityCard]){
        return NO;
    }
    //判断生日是否合法
    NSRange range = NSMakeRange(6,8);
    NSString *datestr = [identityCard substringWithRange:range];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyyMMdd"];
    if([formatter dateFromString:datestr]==nil){
        return NO;
    }
    
    //判断校验位
    if(identityCard.length==18)
    {
        NSArray *idCardWi= @[ @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2" ]; //将前17位加权因子保存在数组里
        NSArray * idCardY=@[ @"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2" ]; //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        int idCardWiSum=0; //用来保存前17位各自乖以加权因子后的总和
        for(int i=0;i<17;i++){
            idCardWiSum+=[[identityCard substringWithRange:NSMakeRange(i,1)] intValue]*[idCardWi[i] intValue];
        }
        
        int idCardMod=idCardWiSum%11;//计算出校验码所在数组的位置
        NSString *idCardLast=[identityCard substringWithRange:NSMakeRange(17,1)];//得到最后一位身份证号码
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2){
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]){
                return YES;
            }else{
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast intValue]==[idCardY[idCardMod] intValue]){
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
}


+(BOOL)vertifyTheAccount:(NSString *)account{
    NSString *accountRegex = @"^[a-zA-Z][a-zA-Z0-9_]{4,15}$";
    NSPredicate *accountTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", accountRegex];
    return [accountTest evaluateWithObject:account];
}

+(BOOL)vertifyThePassword:(NSString *)password{
    //    NSString *passwordRegex = @"^[a-zA-Z][a-zA-Z0-9_]{6,16}$";
    //    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    //    return [passwordTest evaluateWithObject:password];
    BOOL result = false;
    if ([password length] >= 6 && [password length]<= 12){
        // 判断长度大于6位后再接着判断是否同时包含数字和字符
        
        NSString * regex = @"^[A-Za-z0-9]{6,12}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:password];
    }
    return result;
    
}

+(BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}

+ (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}


+(NSString *)countNumAndChangeformat:(NSString *)num
{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}

//
//+ (NSString *)messageWithCode:(int)code {
//    NSString *message = @"";
//    switch (code) {
//        case 1003:
//            message = @"报文解析错误";
//            break;
//
//        default:
//            break;
//    }
//    return message;
//
//}


+ (void)addRotation_X_AnimationFromAngle:(CGFloat)angle to:(CGFloat)toAngle duration:(CGFloat)duraton onLayer:(CALayer*)layer
{
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"sublayerTransform"];
    
    
    CATransform3D rotationA = CATransform3DIdentity;
    CATransform3D rotationB = CATransform3DMakeRotation(((angle+180.0)/180.0*M_PI), 1, 0, 0);
    CATransform3D rotationC = CATransform3DMakeRotation(((angle+360.0)/180.0*M_PI), 1, 0, 0);
    CATransform3D rotationD = CATransform3DMakeRotation(((angle+540.0)/180.0*M_PI), 1, 0, 0);
    CATransform3D rotationE = CATransform3DMakeRotation(((angle+720.0)/180.0*M_PI), 1, 0, 0);
    
    opacityAnimation.values = @[[NSValue valueWithCATransform3D:rotationA], [NSValue valueWithCATransform3D:rotationB], [NSValue valueWithCATransform3D:rotationC], [NSValue valueWithCATransform3D:rotationD], [NSValue valueWithCATransform3D:rotationE]];
    opacityAnimation.keyTimes = @[@(0) ,@(0.1),@(0.2),@(0.3),@(0.4)];
    opacityAnimation.duration = 0.4;
    opacityAnimation.beginTime =  CACurrentMediaTime() + (angle>0?0.8:0.2);
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [layer addAnimation:opacityAnimation forKey:nil];
    
}

+ (CABasicAnimation *)rotation_X_AnimationFormAngle:(CGFloat)formAngle to:(CGFloat)toAngle duration:(CGFloat)duraton beginTime:(CFTimeInterval)beginTime
{
    CATransform3D rotationTransform = CATransform3DMakeRotation((formAngle/180.0*M_PI), 1, 0, 0);
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform"];
    rotation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation((toAngle/180.0*M_PI), 1, 0, 0)];
    rotation.beginTime =  CACurrentMediaTime() + beginTime;
    rotation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
    rotation.duration  =  duraton;
    rotation.fillMode = kCAFillModeForwards;
    return rotation;
}


+ (NSString* )clientModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *model = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([model isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([model isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([model isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([model isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([model isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([model isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([model isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([model isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([model isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([model isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([model isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([model isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([model isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([model isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([model isEqualToString:@"iPhone8,1"])    return @"iPhone 6s Plus";
    if ([model isEqualToString:@"iPhone8,2"])    return @"iPhone 6s";
    if ([model isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([model isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([model isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([model isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([model isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([model isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([model isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([model isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([model isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([model isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([model isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([model isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([model isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([model isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([model isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([model isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([model isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([model isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([model isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([model isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([model isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([model isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";
    if ([model isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";
    if ([model isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([model isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (Cellular)";
    if ([model isEqualToString:@"iPad6,8"])      return @"iPad Pro";
    if ([model isEqualToString:@"i386"])         return @"Simulator";
    if ([model isEqualToString:@"x86_64"])       return @"Simulator";
    return model;
}


+ (NSDateComponents *)timeIntervalWithTimeStamp:(NSTimeInterval)start endStamp:(NSTimeInterval)end

{
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:[NSDate dateWithTimeIntervalSince1970:start/1000] toDate:[NSDate dateWithTimeIntervalSince1970:end/1000] options:0];
    
    return dateCom;
    
}

+(NSString*)dataToJsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        ZPLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


+(NSString *)datetimeStrbyNoSS:(NSString*)jsontimeStr
{
    if ([jsontimeStr  isKindOfClass:[NSNull class]] || [jsontimeStr isEqualToString:@""])
    {
        return @"";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:jsontimeStr];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
}

//+(BOOL)corporateTypeValidate
//{
//    UserInfoManager *manager = [UserInfoManager sharedInstance];
//
//    if ([manager.userInfo.corporateType isEqualToString:@"1"]) {
//        [HintView showHint:@"您是供应商！暂无权此操作。"];
//        return NO;
//    }
//
//    return YES;
//}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    if (aImage.imageOrientation == UIImageOrientationUp)
        
        return aImage;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/**
 转换十六进制
 @return 十六进制数
 */
+ (NSString *)hexStringFromString:(NSString *)string{
    //先十六进制转十进制相加
    NSInteger count = 0;
    for (int i=0; i<string.length/2; i++) {
        count += [[self numberHexString:[string substringWithRange:NSMakeRange(i*2, 2)]] integerValue];
    }
    return [self getHexByDecimal:count];
}


/**
 十进制转换十六进制
 
 @param decimal 十进制数
 @return 十六进制数
 */
+ (NSString *)getHexByDecimal:(NSInteger)decimal {
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    //保留4位
    hex = [Utils addZero:hex withLength:4];
    return hex;
}

// 16进制转10进制
+ (NSNumber *)numberHexString:(NSString *)aHexString {
    if (nil == aHexString){
        return nil;
    }
    NSScanner * scanner = [NSScanner scannerWithString:aHexString];
    unsigned long long longlongValue;
    [scanner scanHexLongLong:&longlongValue];
    NSNumber * hexNumber = [NSNumber numberWithLongLong:longlongValue];
    return hexNumber;
}

+ (NSString *)getBinaryByHex:(NSString *)hex {
    NSMutableDictionary *hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    //    以上是未设置成功
    [hexDic setObject:@"0000" forKey:@"0"];
    [hexDic setObject:@"0001" forKey:@"1"];
    [hexDic setObject:@"0010" forKey:@"2"];
    [hexDic setObject:@"0011" forKey:@"3"];
    [hexDic setObject:@"0100" forKey:@"4"];
    [hexDic setObject:@"0101" forKey:@"5"];
    [hexDic setObject:@"0110" forKey:@"6"];
    [hexDic setObject:@"0111" forKey:@"7"];
    //    [hexDic setObject:@"0000" forKey:@"8"];
    //    [hexDic setObject:@"0001" forKey:@"9"];
    //    [hexDic setObject:@"0010" forKey:@"10"];
    //    [hexDic setObject:@"0011" forKey:@"A"];
    //    [hexDic setObject:@"0100" forKey:@"B"];
    //    [hexDic setObject:@"0101" forKey:@"C"];
    //    [hexDic setObject:@"0110" forKey:@"D"];
    //    [hexDic setObject:@"0111" forKey:@"E"];
    //     以下是设置家长模式参数
    [hexDic setObject:@"1000" forKey:@"8"];
    [hexDic setObject:@"1001" forKey:@"9"];
    [hexDic setObject:@"1002" forKey:@"10"];
    [hexDic setObject:@"1010" forKey:@"A"];
    [hexDic setObject:@"1011" forKey:@"B"];
    [hexDic setObject:@"1100" forKey:@"C"];
    [hexDic setObject:@"1101" forKey:@"D"];
    [hexDic setObject:@"1110" forKey:@"E"];
    [hexDic setObject:@"1111" forKey:@"F"];
    
    NSString *binary = @"";
    for (int i=0; i<[hex length]; i++) {
        
        NSString *key = [hex substringWithRange:NSMakeRange(i, 1)];
        NSString *value = [hexDic objectForKey:key.uppercaseString];
        if (value) {
            
            binary = [binary stringByAppendingString:value];
        }
    }
    return binary;
}


//十进制转二进制

+ (NSString *)toBinarySystemWithDecimalSystem:(NSInteger)decimal

{
    
    NSInteger num = decimal;//[decimal intValue];
    
    NSInteger remainder = 0;      //余数
    
    NSInteger divisor = 0;        //除数
    
    NSString * prepare = @"";
    
    while (true)
        
    {
        
        remainder = num%2;
        
        divisor = num/2;
        
        num = divisor;
        
        prepare = [prepare stringByAppendingFormat:@"%ld",remainder];
        
        if (divisor == 0)
            
        {
            
            break;
        }
        
    }
    
    NSString * result = @"";
    
    for (NSInteger i = prepare.length - 1; i >= 0; i --)
        
    {
        
        result = [result stringByAppendingFormat:@"%@",
                  
                  [prepare substringWithRange:NSMakeRange(i , 1)]];
        
    }
    
    return result;
    
}

/**
 二进制转换成十六进制
 
 @param binary 二进制数
 @return 十六进制数
 */
+ (NSString *)getHexByBinary:(NSString *)binary {
    
    NSMutableDictionary *binaryDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [binaryDic setObject:@"0" forKey:@"0000"];
    [binaryDic setObject:@"1" forKey:@"0001"];
    [binaryDic setObject:@"2" forKey:@"0010"];
    [binaryDic setObject:@"3" forKey:@"0011"];
    [binaryDic setObject:@"4" forKey:@"0100"];
    [binaryDic setObject:@"5" forKey:@"0101"];
    [binaryDic setObject:@"6" forKey:@"0110"];
    [binaryDic setObject:@"7" forKey:@"0111"];
    //    [binaryDic setObject:@"0" forKey:@"1000"];
    //    [binaryDic setObject:@"1" forKey:@"1001"];
    //    [binaryDic setObject:@"2" forKey:@"1010"];
    //    [binaryDic setObject:@"3" forKey:@"1011"];
    //    [binaryDic setObject:@"4" forKey:@"1100"];
    //    [binaryDic setObject:@"5" forKey:@"1101"];
    //    [binaryDic setObject:@"6" forKey:@"1110"];
    //    [binaryDic setObject:@"7" forKey:@"1111"];
    //     以下是设置成功
    [binaryDic setObject:@"8" forKey:@"1000"];
    [binaryDic setObject:@"9" forKey:@"1001"];
    [binaryDic setObject:@"A" forKey:@"1010"];
    [binaryDic setObject:@"B" forKey:@"1011"];
    [binaryDic setObject:@"C" forKey:@"1100"];
    [binaryDic setObject:@"D" forKey:@"1101"];
    [binaryDic setObject:@"E" forKey:@"1110"];
    [binaryDic setObject:@"F" forKey:@"1111"];
    
    if (binary.length % 4 != 0) {
        
        NSMutableString *mStr = [[NSMutableString alloc]init];;
        for (int i = 0; i < 4 - binary.length % 4; i++) {
            
            [mStr appendString:@"0"];
        }
        binary = [mStr stringByAppendingString:binary];
    }
    NSString *hex = @"";
    for (int i=0; i<binary.length; i+=4) {
        
        NSString *key = [binary substringWithRange:NSMakeRange(i, 4)];
        NSString *value = [binaryDic objectForKey:key];
        if (value) {
            
            hex = [hex stringByAppendingString:value];
        }
    }
    return hex;
}


//字符串补零操作

+(NSString *)addZero:(NSString *)str withLength:(int)length{
    
    NSString *string = nil;
    
    if (str.length==length) {
        
        return str;
        
    }
    
    if (str.length<length) {
        
        NSUInteger inter = length-str.length;
        
        for (int i=0;i< inter; i++) {
            
            string = [NSString stringWithFormat:@"0%@",str];
            
            str = string;
            
        }
        
    }
    
    return string;
    
}

+ (NSString *)gapDateFrom:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取两个日期的间隔
    NSDateComponents *comp = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
    
    return [NSString stringWithFormat:@"%02lu:%02lu:%02lu",comp.hour,comp.minute,comp.second];
    
}
@end
