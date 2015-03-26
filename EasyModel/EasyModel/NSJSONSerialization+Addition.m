//
//  NSJSONSerialization+Addition.m
//  EasyModel
//
//  Created by ileo on 15/3/26.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import "NSJSONSerialization+Addition.h"

@implementation NSJSONSerialization (Addition)

+(NSString *)stringWithJSONObject:(id)obj options:(NSJSONWritingOptions)opt error:(NSError **)error{
    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:obj options:opt error:error];
    NSString *strJson = [[NSString alloc] initWithData:dataJson encoding:NSUTF8StringEncoding];
    return strJson;
}

@end