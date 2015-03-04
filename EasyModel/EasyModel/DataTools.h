//
//  DataTools.h
//  EasyModel
//
//  Created by ileo on 15/2/28.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface DataTools : NSObject

+(NSString *)propertyTypeWithObjc:(objc_property_t)property;
+(NSString *)propertyNameWithObjc:(objc_property_t)property;
+(id)nullValueByType:(NSString *)type;
+(NSString *)propertyTypeWithPropertyName:(NSString *)propertyName Class:(Class)aClass;
+(BOOL)isNullValueWithValue:(id)value;

@end
