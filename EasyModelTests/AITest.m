//
//  AITest.m
//  EasyModel
//
//  Created by ileo on 15/6/8.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import "AITest.h"

@implementation AITest


-(NSArray *)withoutPropertys{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[super withoutPropertys]];
//    [arr addObject:@"arr"];
    return arr;
}

@end
