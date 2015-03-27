//
//  BaseModel.m
//  CarCare
//
//  Created by ileo on 14-8-29.
//  Copyright (c) 2014年 baozun. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>
#import "DataTools.h"

@implementation BaseModel

-(id)initWithDic:(NSDictionary *)dic{
    
    self = [super init];
    if (self) {
        [self fillModelWithDic:dic];
    }
    return self;
}

-(void)fillModelWithDic:(NSDictionary *)dic{
    Class class_t = [self class];
    u_int count;
    objc_property_t* properties = class_copyPropertyList(class_t, &count);
    
    NSArray *keys = [dic allKeys];
    for (int i = 0; i < keys.count; i++) {
        NSString *key = keys[i];
        for (int j = 0; j < count ; j++)
        {
            objc_property_t property = properties[j];
            NSString *property_name = [DataTools propertyNameWithObjc:property];
            NSString *property_type = [DataTools propertyTypeWithObjc:property];
            if ([property_name isEqualToString:key]) {
                id newValue = dic[property_name];
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

-(NSDictionary *)modelDic{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:4];
    
    Class class_t = [self class];
    u_int count;
    objc_property_t* properties = class_copyPropertyList(class_t, &count);
    for (int i = 0; i < count ; i++)
    {
        NSString *property_name = [NSString  stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        if ([self valueForKeyPath:property_name]) {
            [dic setObject:[self valueForKeyPath:property_name] forKey:property_name];
        }
        
        NSString *property_type = [DataTools propertyTypeWithObjc:properties[i]];
        NSLog(@"%@ - %@ - %@",[DataTools nullValueByType:property_type],property_name,property_type);
    }
    free(properties);
    
    return dic;
}

@end