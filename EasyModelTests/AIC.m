//
//  AIC.m
//  EasyModel
//
//  Created by ileo on 15/6/8.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import "AIC.h"

@implementation AIC

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSuperPropertyWithClass:[AITest class]];
    }
    return self;
}

@end
