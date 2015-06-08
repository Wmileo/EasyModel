//
//  DataTools.m
//  EasyModel
//
//  Created by ileo on 15/2/28.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import "DataTools.h"

@implementation DataTools

+(NSString *)propertyTypeWithObjc:(objc_property_t)property{
    NSString *property_type = [NSString  stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    
    NSArray *arr = [property_type componentsSeparatedByString:@","];
    
    if (arr.count > 0) {
        property_type = arr[0];
    }else{
        property_type = nil;
    }
    return property_type;
}
+(NSString *)propertyNameWithObjc:(objc_property_t)property{
    NSString *property_name = [NSString  stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
    return property_name;
}
+(id)nullValueByType:(NSString *)type{
    if([type isEqualToString:@"TB"]){//BOOL bool
        return @(NO);
    }else if ([type isEqualToString:@"TC"]) {//Boolean
        return @(NO);
    }else if ([type isEqualToString:@"Tq"]) {//NSInteger
        return @(0);
    }else if ([type isEqualToString:@"Ti"]) {//int
        return @(0);
    }else if([type isEqualToString:@"Td"]){//NSTimeInterval double
        return @(0);
    }else if([type isEqualToString:@"Tf"]){//float
        return @(0);
    }else if([type isEqualToString:@"T@\"NSString\""]){
        return @"";
    }else if([type isEqualToString:@"T@\"NSDictionary\""]){
        return @{};
    }else if([type isEqualToString:@"T@\"NSArray\""]){
        return @[];
    }else{
        NSLog(@"------------------------>>>>----%@",type);
        return nil;
    }
}
+(NSString *)dbTypeWithType:(NSString *)type{
    
    if ([type isEqualToString:@"TB"] || [type isEqualToString:@"Tc"] || [type isEqualToString:@"Tq"] || [type isEqualToString:@"Ti"]) {
        return @"INTEGER";
    }else if ([type isEqualToString:@"Td"] || [type isEqualToString:@"Tf"]) {
        return @"REAL";
    }else if ([type isEqualToString:@"T@\"NSString\""] || [type isEqualToString:@"T@\"NSDictionary\""] || [type isEqualToString:@"T@\"NSArray\""]) {
        return @"TEXT";
    }
    return nil;
}
+(BOOL)isJsonType:(NSString *)type{
    return [type isEqualToString:@"T@\"NSDictionary\""] || [type isEqualToString:@"T@\"NSArray\""];
}
+(NSString *)propertyTypeWithPropertyName:(NSString *)propertyName Class:(__unsafe_unretained Class)aClass{
    NSString *property_type = nil;
    
    u_int count;
    objc_property_t* properties = class_copyPropertyList(aClass, &count);
    
    for (int i = 0; i < count ; i++)
    {
        objc_property_t property = properties[i];
        if ([propertyName isEqualToString:[DataTools propertyNameWithObjc:property]]) {
            property_type = [DataTools propertyTypeWithObjc:property];
            break;
        }
    }
    free(properties);
    
    return property_type;
}
+(BOOL)isNullValueWithValue:(id)value{
    return [value isEqual:[NSNull null]] || ([value isKindOfClass:[NSString class]] && [value isEqualToString:@"<null>"]);
}
@end