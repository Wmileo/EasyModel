//
//  DataBaseModel.m
//  EasyModel
//
//  Created by ileo on 15/3/27.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import "DataBaseModel.h"
#import <objc/runtime.h>
#import "NSJSONSerialization+Addition.h"
#import "DataTools.h"

@implementation DataBaseModel

-(NSDictionary *)jsonObjectDic{
    
    Class class_t = [self class];
    u_int count;
    objc_property_t* properties = class_copyPropertyList(class_t, &count);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:count];

    for (int i = 0; i < count ; i++)
    {
        objc_property_t property = properties[i];
        NSString *property_name = [DataTools propertyNameWithObjc:property];
        id obj = [self valueForKeyPath:property_name];
        if (obj) {
            NSString *property_type = [DataTools propertyTypeWithObjc:property];
            if ([DataTools isJsonType:property_type]) {
                NSString *json = [NSJSONSerialization stringWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
                [dic setObject:json forKey:property_name];
            }else{
                [dic setObject:obj forKey:property_name];
            }
        }
    }
    free(properties);
    return dic;
}

-(void)fillJsonObjectDic:(NSDictionary *)json{
    Class class_t = [self class];
    u_int count;
    objc_property_t* properties = class_copyPropertyList(class_t, &count);
    
    NSArray *keys = [json allKeys];
    for (int i = 0; i < keys.count; i++) {
        NSString *key = keys[i];
        for (int j = 0; j < count ; j++)
        {
            objc_property_t property = properties[j];
            NSString *property_name = [DataTools propertyNameWithObjc:property];
            NSString *property_type = [DataTools propertyTypeWithObjc:property];
            if ([property_name isEqualToString:key]) {
                id newValue = json[property_name];
                if ([DataTools isJsonType:property_type]) {
                    NSData *data = [newValue dataUsingEncoding:NSUTF8StringEncoding];
                    newValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                }
                if ([DataTools isNullValueWithValue:newValue]) {
                    newValue = [DataTools nullValueByType:property_type];
                }
                [self setValue:newValue forKey:property_name];
                break;
            }
        }
    }
    free(properties);
}

+(NSArray *)allColumns{
    Class class_t = [self class];
    u_int count;
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:count];
    objc_property_t* properties = class_copyPropertyList(class_t, &count);
    for (int i = 0; i < count ; i++)
    {
        objc_property_t property = properties[i];
        NSString *property_name = [DataTools propertyNameWithObjc:property];
        BOOL isLess = NO;
        for (NSString *name in [self lessPropertys]) {
            if ([property_name isEqualToString:name]) {
                isLess = YES;
                break;
            }
        }
        if (!isLess) {
            [arr addObject:property_name];
        }
    }
    free(properties);
    return arr;
}

+(NSArray *)dbColumns{
    
    Class class_t = [self class];
    u_int count;
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:count];
    
    objc_property_t* properties = class_copyPropertyList(class_t, &count);
    for (int i = 0; i < count ; i++)
    {
        objc_property_t property = properties[i];
        NSString *property_name = [DataTools propertyNameWithObjc:property];
        
        BOOL isLess = NO;
        for (NSString *name in [self lessPropertys]) {
            if ([property_name isEqualToString:name]) {
                isLess = YES;
                break;
            }
        }
        
        if (!isLess) {
            NSString *property_type = [DataTools propertyTypeWithObjc:property];
            
            NSString *column_type = [DataTools dbTypeWithType:property_type];
            if (column_type) {
                NSMutableString *column = [NSMutableString stringWithFormat:@"%@ %@",property_name,column_type];
                if ([property_name isEqualToString:[self primaryKey]]) {
                    [column appendFormat:@" PRIMARY KEY"];
                }
                [arr addObject:column];
            }
        }

    }
    
    free(properties);
    
    return arr;
}

+(NSString *)primaryKey{
    return @"";
}

+(NSArray *)lessPropertys{
    return @[];
}

@end