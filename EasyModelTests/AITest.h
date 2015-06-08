//
//  AITest.h
//  EasyModel
//
//  Created by ileo on 15/6/8.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import "AIProperty.h"
#import "TestModel.h"

@interface AITest : AIProperty

@property (nonatomic, copy) NSArray *arr;

@property (nonatomic, copy) NSDictionary *dic;

@property (nonatomic, strong) TestModel *model;

@property (nonatomic, assign) BOOL b;
@property (nonatomic, assign) Boolean bb;
@property (nonatomic, assign) NSInteger i;
@property (nonatomic, assign) int ii;
@property (nonatomic, assign) NSTimeInterval t;
@property (nonatomic, assign) float f;
@property (nonatomic, copy) NSString *ss;
@property (nonatomic, copy) NSDictionary *dd;
@property (nonatomic, copy) NSArray *aa;

@end
