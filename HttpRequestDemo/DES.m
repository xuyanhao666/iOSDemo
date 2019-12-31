//
//  DES.m
//  SHWDProgram
//
//  Created by xiantian on 16/3/25.
//  Copyright © 2016年 xiantian. All rights reserved.
//


#define appkey     @"9fa003a4dc0a4363b4ca21e09ba764fd"

#define appsecent  @"iD6qJgsBdOa4pFWzhI60lDIB8NnhG88x"


#import "DES.h"
#import "GTMBase64.h" 
#import <CommonCrypto/CommonCryptor.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MD5.h"
@implementation DES

+ (NSString *)encryptWithText:(NSString *)sText
{
    //kCCEncrypt 加密
    return [self encrypt:sText encryptOrDecrypt:kCCEncrypt key:appsecent];
}

+ (NSString *)decryptWithText:(NSString *)sText
{
    //kCCDecrypt 解密
    return [self encrypt:sText encryptOrDecrypt:kCCDecrypt key:appsecent];
}



//des 加密解密
+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key
{
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递过来的是decrypt 解码
    {
        //解码 base64
        NSData *decryptData = [GTMBase64 decodeData:[sText dataUsingEncoding:NSUTF8StringEncoding]];//转成utf-8并decode
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    /*
     DES加密 ：用CCCrypt函数加密一下，然后用base64编码下，传过去
     DES解密 ：把收到的数据根据base64，decode一下，然后再用CCCrypt函数解密，得到原本的数据
     
     */
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    NSString *initIv = @"DES";
    const void *vkey = (const void *) [key UTF8String];
    const void *iv = (const void *) [initIv UTF8String];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithmDES,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,  //密钥    加密和解密的密钥必须一致
                       kCCKeySizeDES,//   DES 密钥的大小（kCCKeySizeDES=8）
                       iv, //  可选的初始矢量
                       dataIn, // 数据的存储单元
                       dataInLength,// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //得到解密出来的data数据，改变为utf-8的字符串
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding] ;
    }
    else //encryptOperation==0  （加密过程中，把加好密的数据转成base64的）
    {
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [GTMBase64 stringByEncodingData:data];
    }
    
    return result;
}


//des加密

+ (NSString *) encryUseDES: (NSString *)planiText {
    
    NSString *ciphertext =nil;
    const char *textBytes = [planiText UTF8String];
    NSUInteger dataLength = [planiText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    Byte iv[] = {1,2,3,4,5,6,7,8};
    size_t numBytesEncrypted =0;
    CCCryptorStatus cryptStaus =CCCrypt(kCCEncrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding, [appsecent UTF8String], kCCKeySizeDES, iv, textBytes, dataLength, buffer, 1024, &numBytesEncrypted);
    if (cryptStaus == kCCSuccess) {
        NSData *data =[NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext =[[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];
    }
    
    return ciphertext;
}

//解密
+ (NSString *) decryptUseDES:(NSString*)cipherText
{
    NSData* cipherData = [GTMBase64 decodeString:cipherText];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    Byte iv[] = {1,2,3,4,5,6,7,8};
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [appsecent UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          1024,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return plainText;
}



// 3DES
+(NSString *)tripleDES:(NSString*)plainTex key:(NSString*)key{
    
    //kCCEncrypt 加密
    return [self tripleDES:plainTex encryptOrDecrypt:kCCEncrypt key:appsecent];
    
}



//  3DES
+ (NSString *)tripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)ancryptOrDecrypt key:(NSString*)key {
    const void *vplainText;
    size_t plainTextBufferSize;
    
#ifdef DEBUG
    NSLog(@"3DES加密前字符串:\n%@", plainText);
#endif
    
    if (ancryptOrDecrypt == kCCDecrypt)
    {
        // hexToBytes
        NSMutableData* data = [NSMutableData data];
        int idx;
        for (idx = 0; idx+2 <= plainText.length; idx+=2) {
            NSRange range = NSMakeRange(idx, 2);
            NSString* hexStr = [plainText substringWithRange:range];
            NSScanner* scanner = [NSScanner scannerWithString:hexStr];
            unsigned int intValue;
            [scanner scanHexInt:&intValue];
            [data appendBytes:&intValue length:1];
        }
        
        NSData *EncryptData = data;
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    // uint8_t ivkCCBlockSize3DES;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    //    NSString *key = @"123456789012345678901234";
    NSString *initVec = @"init Vec";
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [initVec UTF8String];
    
    ccStatus = CCCrypt(ancryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionECBMode|kCCOptionPKCS7Padding,
                       vkey, //"123456789012345678901234", //key
                       kCCKeySize3DES,
                       vinitVec, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    NSString *result;
    
    if (ancryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        
        Byte *myByte = (Byte *)[myData bytes];
        NSMutableString *tResult = [NSMutableString string];
        NSMutableString *newHexStr = [NSMutableString string];
        for (int i = 0 ; i < [myData length]; i++) {
            [newHexStr setString:[NSString stringWithFormat:@"%x", myByte[i]&0xff]];
            if([newHexStr length] == 1) {
                [tResult appendFormat:@"0%@", newHexStr];
            }
            else {
                [tResult appendString:newHexStr];
            }
        }
        result = tResult;
        
        result = [result uppercaseString];
    }
    free(bufferPtr);
    
    return result;
}



// 字典转json字符串

+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


//获取毫秒级时间戳
+(NSString *)timesecond{
    NSDate *date = [NSDate date];
    NSTimeInterval timeStamp= [date timeIntervalSince1970]*1000;
    NSString *timestring =[NSString stringWithFormat:@"%.f",timeStamp];
    return timestring;
}


// 网络请求
+(void)ASfornetworkjsonstringurl:(NSString *)myurlopen success:(void (^)(NSString *str))success
             failure:(void (^)(NSString *st))failure {

    NSString *username =@"admin";
//    md5加密； 21232f297a57a5a743894a0e4a801fc3
    NSString * md5 =[ MD5 md5:@"admin"];
    
    NSLog(@"%@", md5);
    
    NSString *signmd5 =[NSString stringWithFormat:@"password=%@&username=%@&key=%@",md5,username,appkey];
    
    
    NSLog(@"sign md5 :%@", signmd5);
    NSString*sign =[MD5 md5:signmd5];
    
//    传参字典
    NSDictionary * mydict =@{@"username":username,
                             @"password":md5,
                             @"sign":sign,
                             };

    
    NSString *nsmystring =[DES dictionaryToJson:mydict];
    NSLog(@"%@",nsmystring);
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
   
//    序列化
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer  serializer];
     //用POST来获得数据
    [manager POST:myurlopen parameters:mydict progress:^(NSProgress * _Nonnull uploadProgress) {
    }//成功回调
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSString *shabi =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (success) {
            success(shabi);
        };
//        失败回调
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure( [NSString stringWithFormat:@"%@",error]);
        };
    }];
}




//login?apiKey=112233abc&
//param=iJSrP%2BTSvN0DWIeIxKH2k5EwwESivPjI05X6R5BZrdrxQJhGICe9SW58Y4be2fG7tXjLVZZoQIIlJ65R7eBtE8c1i8IM3bLHgAcMvn6Q3n0Ge58VftyZ9kp5gYm04a8SMiu9zrh5uHlRirt3F2ReiWUuU6gA0Ojg&
//sign=23084db02f4854a944bbab1d8ca5e137


@end
