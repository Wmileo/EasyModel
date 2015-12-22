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

@interface Property : NSObject

@property (nonatomic, copy) NSString *property_name;
@property (nonatomic, copy) NSString *property_type;

@end

@implementation Property

@end

@interface AIProperty(){
    NSArray *__propertys;
}

@end

@implementation AIProperty

-(void)dealloc{
    for (Property *pro in __propertys) {
        [self removeObserver:self forKeyPath:pro.property_name];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initPropertys];
        [self loadValue];
    }
    return self;
}

-(void)clear{
    for (Property *pro in __propertys) {
        id obj = [DataTools nullValueByType:pro.property_type];
        if (obj) {
            [self setValue:obj forKey:pro.property_name];
        }
    }
}

-(NSArray *)withoutPropertys{
    return @[];
}

-(void)loadValue{
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    Class class_t = [self class];
    NSString *class_name = [NSString  stringWithCString:class_getName(class_t) encoding:NSUTF8StringEncoding];
    
    for (Property *pro in __propertys) {
        id obj = [config objectForKey:[self keyNameWithClassName:class_name propertyName:pro.property_name]];
        if (!obj) {
            obj = [DataTools nullValueByType:pro.property_type];
        }
        if (obj) {
            [self setValue:obj forKey:pro.property_name];
            [self addObserver:self forKeyPath:pro.property_name options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:(__bridge void *)(class_t)];
        }
    }
}

-(void)initPropertys{
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:3];
    [self enumerateObjectsFromClass:[self class] UsingBlock:^(Property *property) {
        [tmp addObject:property];
    }];
    __propertys = [tmp copy];
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

-(void)enumerateObjectsFromClass:(Class)aClass UsingBlock:(void(^)(Property *property))block{
    u_int count;
    objc_property_t *properties = class_copyPropertyList(aClass, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *property_name = [DataTools nameWithProperty:property];
        if ([[self withoutPropertys] containsObject:property_name] || [DataTools isReadOnlyWithProperty:property]) {
            continue;
        }
        NSString *property_type = [DataTools typeWithProperty:property];
        if (block) {
            Property *pro = [[Property alloc] init];
            pro.property_name = property_name;
            pro.property_type = property_type;
            block(pro);
        }
    }
    free(properties);
}

@end
