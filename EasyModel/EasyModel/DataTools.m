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
    if([type isEqualToString:@"TB"]){
        return @(NO);
    }else if ([type isEqualToString:@"Tc"]) {
        return @(NO);
    }else if ([type isEqualToString:@"Ti"]) {
        return @(0);
    }else if([type isEqualToString:@"Td"]){
        return @(0);
    }else if([type isEqualToString:@"Tf"]){
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
+(NSString *)propertyTypeWithPropertyName:(NSString *)propertyName{
    NSString *property_type = nil;
    
    Class class_t = [self class];
    u_int count;
    objc_property_t* properties = class_copyPropertyList(class_t, &count);
    
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
