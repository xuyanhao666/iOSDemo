//
//  MyControl.m
//  StudentManager
//
//  Created by leisure on 14-3-26.
//  Copyright (c) 2014年 leisure. All rights reserved.
//

#import "MyControl.h"
#import "UIWindow+YzdHUD.h"
#import <SMS_SDK/SMS_SDK.h>

@implementation MyControl


+(void)getUrl:(NSString *)url dataDict:(NSDictionary *)dataDict view:(UIView *)urlView isState:(BOOL) isState finshedBlock:(FinishBlock)block
{
    if (isState) {
        [urlView.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
        urlView.userInteractionEnabled = NO;
    }
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    FinishBlock finishBlock = block;
    [manger GET:url parameters:dataDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *datastr = [NSString stringWithFormat:@"%@",operation.responseString];
        NSData *data = [datastr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (finishBlock) {
            finishBlock(dict);
        }
        if (isState) {
            [urlView.window showHUDWithText:@"请求成功" Type:ShowPhotoYes Enabled:YES];
            urlView.userInteractionEnabled = YES;
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        if (isState) {
            [urlView.window showHUDWithText:@"请求失败" Type:ShowPhotoNo Enabled:YES];
            urlView.userInteractionEnabled = YES;
        }
    }];
}

#pragma mark - post请求
+ (void)postUrl:(NSString *)url dataDict:(NSDictionary *)dataDict view:(UIView *)urlView isState:(BOOL)isState finshedBlock:(FinishBlock)block {
    if (isState) {
        [urlView.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
        urlView.userInteractionEnabled = NO;
    }
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    FinishBlock finishBlock = block;

    
    [manger POST:url parameters:dataDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *datastr = [NSString stringWithFormat:@"%@",operation.responseString];
        NSData *data = [datastr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (finishBlock) {
            finishBlock(dict);
        }
        if (isState) {
            [urlView.window showHUDWithText:@"请求成功" Type:ShowPhotoYes Enabled:YES];
            urlView.userInteractionEnabled = YES;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        if (isState) {
            [urlView.window showHUDWithText:@"请求失败" Type:ShowPhotoNo Enabled:YES];
            urlView.userInteractionEnabled = YES;
        }
    }];
}

#pragma mark - 上传单张图片
+(void)postUrl:(NSString *)url dataDict:(NSDictionary *)dataDict imageData:(NSData *)data imageNameString:(NSString *)name view:(UIView *)urlView isState:(BOOL) isState finshedBlock:(FinishBlock)block {
    if (isState) {
        [urlView.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
        urlView.userInteractionEnabled = NO;
    }
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    FinishBlock finishBlock = block;
    [manger POST:url parameters:dataDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"imagefile" fileName:name mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *datastr = [NSString stringWithFormat:@"%@",operation.responseString];
        NSData *data = [datastr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (finishBlock) {
            finishBlock(dict);
        }
        if (isState) {
            [urlView.window showHUDWithText:@"请求成功" Type:ShowPhotoYes Enabled:YES];
            urlView.userInteractionEnabled = YES;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        if (isState) {
            [urlView.window showHUDWithText:@"请求失败" Type:ShowPhotoNo Enabled:YES];
            urlView.userInteractionEnabled = YES;
        }

    }];
}

#pragma mark - 定义成方法方便多个label调用 增加代码的复用性
+(CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(WIDHT , MAXFLOAT)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

#pragma mark - 设置圆角
+(void)setRad:(id)radView :(CGFloat) flaot
{
    CALayer *rad = [radView layer];
    [rad setMasksToBounds:YES];
    [rad setCornerRadius:flaot];
}

//判断是否是第一次登录或是否是版本更新
+(BOOL)upDataVersion
{
    //判断是否是第一次登录或是否是版本更新
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *string = [userDefaults objectForKey:@"versions"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if (string == nil||(![string isEqualToString:app_Version])) {//第一次登录或版本更新
        [[NSUserDefaults standardUserDefaults] setValue:app_Version forKey:@"versions"];
        return YES;
    }else{
        NSLog(@"其他");
        return NO;
    }
}
#pragma mark 无交互效果的提示框
+ (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert = NULL;
}
+ (void)showAlert:(NSString *) _message
{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:NO];
    
    [promptAlert show];
}
#pragma mark 判断手机的型号
+(NSString*)doDevicePlatform
{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) {
        
        platform = @"iPhone";
        
    } else if ([platform isEqualToString:@"iPhone1,2"]) {
        
        platform = @"iPhone 3G";
        
    } else if ([platform isEqualToString:@"iPhone2,1"]) {
        
        platform = @"iPhone 3GS";
        
    } else if ([platform isEqualToString:@"iPhone3,1"]||[platform isEqualToString:@"iPhone3,2"]||[platform isEqualToString:@"iPhone3,3"]) {
        
        platform = @"iPhone4";
        
    } else if ([platform isEqualToString:@"iPhone4,1"]) {
        
        platform = @"iPhone4S";
        
    } else if ([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"]) {
        
        platform = @"iPhone5";
        
    }else if ([platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"]) {
        
        platform = @"iPhone5C";
        
    }else if ([platform isEqualToString:@"iPhone6,2"]||[platform isEqualToString:@"iPhone6,1"]) {
        
        platform = @"iPhone5S";
        
    }else if ([platform isEqualToString:@"iPhone7,2"] ){
        platform = @"iPhone6";
        //|| [platform isEqualToString:@"iPhone7,1"]
    }else if ([platform isEqualToString:@"iPhone7,1"]){
        platform = @"iPhone6Plus";
    }
    else if ([platform isEqualToString:@"iPod4,1"]) {
        
        platform = @"iPod touch 4";
        
    }else if ([platform isEqualToString:@"iPod5,1"]) {
        
        platform = @"iPod touch 5";
        
    }else if ([platform isEqualToString:@"iPod3,1"]) {
        
        platform = @"iPod touch 3";
        
    }else if ([platform isEqualToString:@"iPod2,1"]) {
        
        platform = @"iPod touch 2";
        
    }else if ([platform isEqualToString:@"iPod1,1"]) {
        
        platform = @"iPod touch";
        
    } else if ([platform isEqualToString:@"iPad3,2"]||[platform isEqualToString:@"iPad3,1"]) {
        
        platform = @"iPad 3";
        
    } else if ([platform isEqualToString:@"iPad2,2"]||[platform isEqualToString:@"iPad2,1"]||[platform isEqualToString:@"iPad2,3"]||[platform isEqualToString:@"iPad2,4"]) {
        
        platform = @"iPad 2";
        
    }else if ([platform isEqualToString:@"iPad1,1"]) {
        
        platform = @"iPad 1";
        
    }else if ([platform isEqualToString:@"iPad2,5"]||[platform isEqualToString:@"iPad2,6"]||[platform isEqualToString:@"iPad2,7"]) {
        
        platform = @"ipad mini";
        
    } else if ([platform isEqualToString:@"iPad3,3"]||[platform isEqualToString:@"iPad3,4"]||[platform isEqualToString:@"iPad3,5"]||[platform isEqualToString:@"iPad3,6"]) {
        
        platform = @"ipad 3";
        
    }
    
    return platform;
}
#pragma mark - 发送验证码倒计时
//第一个参数是倒计时的时间，第二个是倒计时按钮（主要是为了改变按钮上的文字),第三个是倒计时结束时改变button的图片
+(void)startTime:(int)time :(UIButton *)timeButton :(UIImage *)image
{
    __block int timeout=time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [timeButton setBackgroundImage:image forState:UIControlStateNormal];
                [timeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                
                timeButton.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [timeButton setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                timeButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

//手机号码的有效性判断
//检测是否是手机号码
+(BOOL)isMobileNumber:(NSString *)mobile
{
    if (mobile.length == 11) {
        NSString *phone = [mobile substringToIndex:3];
        if ([phone isEqualToString:@"177"] || [phone isEqualToString:@"170"]) {//判断是不是177和170的手机号
            NSLog(@"phoen = %@",phone);
            return YES;
        }else{
            //手机号以13， 15，18开头，八个 \d 数字字符,缺少177的手机号，@"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$"
            NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|17[678]|(18[0,0-9]))\\d{8}$";
            //NSString *phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
            return [phoneTest evaluateWithObject:mobile];
        }
    }else{
        return NO;
    }
}

#pragma mark 根据色值转换成rgb
+(UIColor *)colorFromRGBHexString:(NSString *)colorString
{
    if (colorString.length == 7) {
        const char *colorUTF8String = [colorString UTF8String];
        int r, g, b;
        sscanf(colorUTF8String, "#%2x%2x%2x", &r, &g, &b);
        return [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:1.0];
    }
    
    return nil;
}
// 创建自定义常规UILabel
+(UILabel *)createLabel:(NSString *)title frame:(CGRect)frame
{
    UILabel *label=[[UILabel alloc] initWithFrame:frame ];
    //设置标题
    label.text=title;
    //设置背景色
    label.backgroundColor=[UIColor clearColor];
    //设置字体
    label.font=[UIFont systemFontOfSize:18];
    return label;
}
// 创建自定义特殊UILabel
+(UILabel *)createSpecialLabel:(NSString *)title number:(NSInteger)number
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(WIDHT/2 - 70, 27, 140, 30);
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleLabel.text];
    //设置颜色
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:74/255.0 green:69/255.0 blue:61/255.0 alpha:1] range:NSMakeRange(0, number)]; // 0为起始位置 length是从起始位置开始 设置指定颜色的长度
    //设置尺寸
    //[attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(13, 4)]; // 0为起始位置 length是从起始位置开始 设置指定字体尺寸的长度
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19] range:NSMakeRange(0, number)];
    //这段代码必须要写 否则没效果
    
    titleLabel.attributedText = attributedString;
    return titleLabel;
}
// 创建自定义UITextField
+(UITextField*)createTextField:(NSString *)placeHolder frame:(CGRect)frame tag:(NSInteger)tag delegate:(id)delegate
{
    UITextField *textField=[[UITextField alloc] initWithFrame:frame] ;
    //如果是密码输入框，设置为YES
    //textField.secureTextEntry=YES;
    //设置提示信息
    textField.placeholder=placeHolder;
    //清除按钮的模式
    textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    //开始编辑时清空
    textField.clearsOnBeginEditing=YES;
    //设置边框样式
    textField.borderStyle=UITextBorderStyleRoundedRect;
    //设置编号
    textField.tag=tag;
    //设置代理
    textField.delegate=delegate;
    
    return textField;
}
// 创建自定义UIButton
+(UIButton*)createButton:(NSString *)title frame:(CGRect)frame tag:(NSInteger)tag
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor=[UIColor clearColor];
    //设置标题色
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.tag=tag;
    button.frame=frame;
    //设置正常状态标题
    [button setTitle:title forState:UIControlStateNormal];
    //按钮的响应事件由使用者添加
    
    return button;
}
+(UIImageView*)createImageView:(NSString *)imgName frame:(CGRect)frame
{
    
    UIImageView *imageView;
    if (imgName&& [imgName length]!=0) {
        imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
         imageView.frame=frame;
    }
    else{
        imageView=[[UIImageView alloc] initWithFrame:frame];
    }
    return imageView;
}

#pragma mark 获得系统时间
+(NSString *)getCurrentTime
{
    NSDate *nowUTC = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"yyyMMddHHmmss"];
    
    return [dateFormatter stringFromDate:nowUTC];
}

#pragma mark - 图片灰色显示
+(UIImage *)grayImage:(UIImage *)sourceImage
{
    int bitmapInfo = kCGImageAlphaNone;
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,      // bits per component
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

#pragma mark - 获取验证码接口
+(void)makeGetYanZhengMaAPI:(NSString *)telephoneString
{
    NSLog(@"获取验证码接口");
    [SMS_SDK getVerificationCodeBySMSWithPhone:telephoneString zone:@"86" result:^(SMS_SDKError *error) {
        if (!error)
        {
            NSLog(@"验证码发送成功");
            [MyControl showAlert:@"验证码发送成功"];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                            message:[NSString stringWithFormat:@"状态码：%zi ,错误描述：%@",error.errorCode,error.errorDescription]
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

/**
 * 修改图片大小
 */
+ (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
//    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}

#pragma mark -将时间戳字符串转换时间
+ (NSString *)timeString:(NSString *)mytime
        formatterString:(NSString *)formatterStr
{
    NSString* string = mytime;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setDateFormat:@"yyyyMMdd"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
//    NSLog(@"date = %@", inputDate);
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:formatterStr];
    NSString *str = [outputFormatter stringFromDate:inputDate];
//    NSLog(@"testDate:%@", str);
    return str;
}

@end









