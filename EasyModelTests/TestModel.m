//
//  TestModel.m
//  EasyModel
//
//  Created by ileo on 15/2/6.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import "TestModel.h"


@interface TestModel()

@property (nonatomic, assign) NSInteger pppaiii;

@end

@implementation TestModel

+(NSString *)primaryKey{
    return @"intT";
}

+(NSArray *)lessPropertys{
    return @[@"arrr"];
}

@end
