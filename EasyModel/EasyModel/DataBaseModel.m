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
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:count];

    objc_property_t* properties = class_copyPropertyList(class_t, &count);
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