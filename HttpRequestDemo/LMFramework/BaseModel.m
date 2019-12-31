//
//  BaseModel.m
//  Express
//
//  Created by Zero on 14-10-30.
//  Copyright (c) 2014年 Zero. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>
@implementation BaseModel

- (id)initWithDic:(NSDictionary*)dic
{
    self = [super init];
    
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return self;
}

+ (id)initWithArray:(NSArray*)array{
    NSMutableArray* arr = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id dic = [[[self class]alloc]initWithDic:obj];
        [arr addObject:dic];
    }];
    return arr;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"undefined key = %@",key);
}

+ (NSArray*)toDictionaryWithArray:(NSArray*)array{
    NSMutableArray* arr = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [arr addObject:[obj toDictionary]];
    }];
    return arr;
}

- (NSDictionary*)toDictionary{
    u_int count = 0;
    objc_property_t* properties = class_copyPropertyList([self class], &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray* typeArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        objc_property_t pro = properties[i];
        const char* propertyName = property_getName(pro);
        NSString* propertyNameString = [NSString stringWithUTF8String:propertyName];
        //        if([propertyNameString isEqualToString:@"ID"]){
        //            propertyNameString = @"id";
        //        }
        [propertyArray addObject:propertyNameString];
        NSString* typecode = [NSString stringWithUTF8String:property_getAttributes(pro)];
        NSArray* attributesArray = [typecode componentsSeparatedByString:@","];
        if(attributesArray.count == 4){
            NSString* type = [attributesArray[0] substringWithRange:NSMakeRange(3, [(NSString*)attributesArray[0] length]-4)];
            [typeArray addObject:type];
        }else{
            NSString* type = [attributesArray[0] substringWithRange:NSMakeRange(1, 1)];
            [typeArray addObject:type];
        }
    }
    
    count = (u_int)propertyArray.count;
    NSMutableArray* valueArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        
        if([[typeArray objectAtIndex:i]isEqualToString:@"c"]){
            NSNumber* number = [self valueForKey:propertyArray[i]];
            [valueArray addObject:number];
        }else{
            NSString* key = propertyArray[i];
            //            if([key isEqualToString:@"id"]){
            //                key = @"ID";
            //            }
            NSObject* obj = [self valueForKey:key];
            //当值为空时，自动填充NSNull
            if(obj == nil){
                obj = [NSNull null];
            }
            [valueArray addObject:obj];
        }
        
    }
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjects:valueArray forKeys:propertyArray];
    
    return dict;
}

@end
