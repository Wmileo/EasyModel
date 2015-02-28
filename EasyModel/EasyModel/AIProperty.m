//
//  AIProperty.m
//  AIProperty
//
//  Created by ileo on 14-3-7.
//  Copyright (c) 2014年 ileo. All rights reserved.
//

#import "AIProperty.h"
#import <objc/runtime.h>
#import "DataTools.h"

@implementation AIProperty

- (id)init
{
    self = [super init];
    if (self) {
        [self loadValue];
    }
    return self;
}

-(void)clear{
    
    Class class_t = [self class];
    u_int count;
    objc_property_t* properties = class_copyPropertyList(class_t, &count);
    for (int i = 0; i < count ; i++)
    {
        
        objc_property_t property = properties[i];
        
        NSString *property_name = [DataTools propertyNameWithObjc:property];
        
        NSString *property_type = [DataTools propertyTypeWithObjc:property];
        
        id obj = [DataTools nullValueByType:property_type];

        if (obj) {
            [self setValue:obj forKey:property_name];
        }
    }
    free(properties);
    
}

-(void)loadValue{
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    Class class_t = [self class];
    NSString *class_name = [NSString  stringWithCString:class_getName(class_t) encoding:NSUTF8StringEncoding];
    u_int count;
    objc_property_t* properties = class_copyPropertyList(class_t, &count);
    for (int i = 0; i < count ; i++)
    {
        objc_property_t property = properties[i];

        NSString *property_name = [DataTools propertyNameWithObjc:property];
        
        NSString *property_type = [DataTools propertyTypeWithObjc:property];
        
        id obj = [config objectForKey:[self keyNameWithClassName:class_name propertyName:property_name]];
        
        if (!obj) {
            obj = [DataTools nullValueByType:property_type];
        }
        
        if (obj) {
            [self setValue:obj forKey:property_name];
        }
        
        [self addObserver:self forKeyPath:property_name options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    free(properties);
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([change[NSKeyValueChangeNewKey] isEqual:change[NSKeyValueChangeOldKey]]) {
        return;
    }
    
    id obj = change[NSKeyValueChangeNewKey];
    
    if ([DataTools isNullValueWithValue:obj]) {
        obj = [DataTools nullValueByType:[DataTools propertyTypeWithPropertyName:keyPath]];
        [self setValue:obj forKey:keyPath];
    }
    
    Class class_t = [self class];
    NSString *class_name = [NSString  stringWithCString:class_getName(class_t) encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@-%@->%@ ->new '%@'",class_name,keyPath,change,obj);
    
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:[self keyNameWithClassName:class_name propertyName:keyPath]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)keyNameWithClassName:(NSString *)className propertyName:(NSString *)propertyName{
    return [NSString stringWithFormat:@"%@_%@",className,propertyName];
}

@end
