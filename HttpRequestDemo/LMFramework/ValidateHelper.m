//
// Created by ivan on 6/5/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ValidateHelper.h"


@implementation ValidateHelper

+ (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)validateMobile:(NSString*)mobile
{
    NSString* phoneRegex=@"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL)validateName:(NSString*)name
{
    NSString* nameRegex=@"^[A-Za-z0-9]+$";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
    NSLog(@"nameTest is %@",nameTest);
    return [nameTest evaluateWithObject:name];
}

+ (BOOL)validateUnEqualToNil:(id)string{
    if(string == nil || [string isEqual:[NSNull null]] || [string isEqualToString:@""]){
        return NO;
    }
    return YES;
}
+ (BOOL)validateEqualToNil:(id)string{
    if(string == nil || [string isEqual:[NSNull null]] || [string isEqualToString:@""]){
        return YES;
    }
    return NO;
}

@end