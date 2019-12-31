//
// Created by ivan on 6/5/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface ValidateHelper : NSObject
+ (BOOL)validateEmail: (NSString*)email;
+ (BOOL)validateMobile:(NSString*)mobile;
+ (BOOL)validateName:(NSString*)name;
+ (BOOL)validateUnEqualToNil:(id)string;
+ (BOOL)validateEqualToNil:(id)string;
@end