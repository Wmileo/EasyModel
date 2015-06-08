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

@interface AIProperty(){
    BOOL _addSuperProperty;
    Class _superClass;
}

@end

@implementation AIProperty

- (id)init
{
    self = [super init];
    if (self) {
        _addSuperProperty = NO;
        [self loadValue];
    }
    return self;
}

-(instancetype)initWithSuperClass:(Class)superClass{
    self = [super init];
    if (self) {
        [self addSuperPropertyWithClass:superClass];
        [self loadValue];
    }
    return self;
}

-(void)clear{
    Class class_t = [self class];
    __weak __typeof(self) wself = self;
    [self enumerateObjectsFromClass:class_t UsingBlock:^(NSString *property_name, NSString *property_type) {
        id obj = [DataTools nullValueByType:property_type];
        if (obj) {
            [wself setValue:obj forKey:property_name];
        }
    }];
    if (_addSuperProperty) {
        Class class_t = _superClass;
        [self enumerateObjectsFromClass:class_t UsingBlock:^(NSString *property_name, NSString *property_type) {
            id obj = [DataTools nullValueByType:property_type];
            if (obj) {
                [wself setValue:obj forKey:property_name];
            }
        }];
    }
}

-(void)loadValue{
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    Class class_t = [self class];
    NSString *class_name = [NSString  stringWithCString:class_getName(class_t) encoding:NSUTF8StringEncoding];
    
    __weak __typeof(self) wself = self;
    [self enumerateObjectsFromClass:class_t UsingBlock:^(NSString *property_name, NSString *property_type) {
        id obj = [config objectForKey:[wself keyNameWithClassName:class_name propertyName:property_name]];
        if (!obj) {
            obj = [DataTools nullValueByType:property_type];
        }
        if (obj) {
            [wself setValue:obj forKey:property_name];
            [wself addObserver:wself forKeyPath:property_name options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:(__bridge void *)(class_t)];
        }
    }];
    
}

-(void)addSuperPropertyWithClass:(Class)superClass{
    
    _addSuperProperty = YES;
    _superClass = superClass;
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    NSString *class_name = [NSString  stringWithCString:class_getName([self class]) encoding:NSUTF8StringEncoding];
    
    __weak __typeof(self) wself = self;
    [self enumerateObjectsFromClass:superClass UsingBlock:^(NSString *property_name, NSString *property_type) {
        id obj = [config objectForKey:[wself keyNameWithClassName:class_name propertyName:property_name]];
        if (!obj) {
            obj = [DataTools nullValueByType:property_type];
        }
        if (obj) {
            [wself setValue:obj forKey:property_name];
            [wself addObserver:wself forKeyPath:property_name options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:(__bridge void *)(superClass)];
        }
    }];

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([change[NSKeyValueChangeNewKey] isEqual:change[NSKeyValueChangeOldKey]]) {
        return;
    }
    
    Class class_t = (__bridge Class)(context);
    id nullValue = [DataTools nullValueByType:[DataTools propertyTypeWithPropertyName:keyPath Class:class_t]];
    if (nullValue) {
        
        id obj = change[NSKeyValueChangeNewKey];
        
        if ([DataTools isNullValueWithValue:obj]) {
            obj = nullValue;
            [self setValue:obj forKey:keyPath];
        }
        
        NSString *class_name = [NSString  stringWithCString:class_getName([self class]) encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@-%@->%@ ->new '%@'",class_name,keyPath,change,obj);
        
        [[NSUserDefaults standardUserDefaults] setObject:obj forKey:[self keyNameWithClassName:class_name propertyName:keyPath]];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
}

- (NSString *)keyNameWithClassName:(NSString *)className propertyName:(NSString *)propertyName{
    return [NSString stringWithFormat:@"%@_%@",className,propertyName];
}

-(void)enumerateObjectsFromClass:(Class)aClass UsingBlock:(void(^)(NSString *property_name, NSString *property_type))block{
    u_int count;
    objc_property_t *properties = class_copyPropertyList(aClass, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *property_name = [DataTools propertyNameWithObjc:property];
        NSString *property_type = [DataTools propertyTypeWithObjc:property];
        if (block) {
            block(property_name,property_type);
        }
    }
    free(properties);
}

@end
