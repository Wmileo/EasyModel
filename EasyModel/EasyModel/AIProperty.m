//
//  AIProperty.m
//  AIProperty
//
//  Created by ileo on 14-3-7.
//  Copyright (c) 2014年 ileo. All rights reserved.
//

#import "AIProperty.h"
#import <objc/runtime.h>

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
        
        NSString *property_name = [self propertyNameWithObjc:property];
        
        NSString *property_type = [self propertyTypeWithObjc:property];
        
        id obj = [self zeroValueByType:property_type];

        if (obj) {
            [self setValue:obj forKey:property_name];
        }
    }
    free(properties);
    
}

#pragma mark -

- (NSString *)propertyTypeWithObjc:(objc_property_t)property {
    NSString *property_type = [NSString  stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    
    NSArray *arr = [property_type componentsSeparatedByString:@","];
    if (arr.count > 0) {
        property_type = arr[0];
    }else{
        property_type = nil;
    }
    return property_type;
}

- (NSString *)propertyNameWithObjc:(objc_property_t)property {
    NSString *property_name = [NSString  stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
    return property_name;
}

-(id)zeroValueByType:(NSString *)type{

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
-(NSString *)propertyTypeWithPropertyName:(NSString *)propertyName{
    
    NSString *property_type = nil;
    
    Class class_t = [self class];
    u_int count;
    objc_property_t* properties = class_copyPropertyList(class_t, &count);
    
    for (int i = 0; i < count ; i++)
    {
        objc_property_t property = properties[i];
        [propertyName isEqualToString:[self propertyNameWithObjc:property]];
        property_type = [self propertyTypeWithObjc:property];
        break;
    }
    free(properties);
    
    return property_type;
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

        NSString *property_name = [self propertyNameWithObjc:property];
        
        NSString *property_type = [self propertyTypeWithObjc:property];
        
        id obj = [config objectForKey:[self keyNameWithClassName:class_name propertyName:property_name]];
        
        if (!obj) {
            obj = [self zeroValueByType:property_type];
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
    
    if ([obj isEqual:[NSNull null]]) {
        obj = [self zeroValueByType:[self propertyTypeWithPropertyName:keyPath]];
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
