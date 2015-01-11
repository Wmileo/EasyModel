//
//  BaseModel.m
//  CarCare
//
//  Created by ileo on 14-8-29.
//  Copyright (c) 2014年 baozun. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

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
            NSString *property_name = [NSString  stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            if ([property_name isEqualToString:key]) {
                [self setValue:dic[property_name] forKey:property_name];
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
    }
    free(properties);
    
    return dic;
}

@end
