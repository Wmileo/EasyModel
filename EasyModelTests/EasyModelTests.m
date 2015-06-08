//
//  EasyModelTests.m
//  EasyModelTests
//
//  Created by ileo on 14/10/22.
//  Copyright (c) 2014年 ileo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "AITest.h"
#import "AIC.h"

@interface EasyModelTests : XCTestCase

@end

@implementation EasyModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
//    XCTAssert(YES, @"Pass");
    
//    AITest *test = [[AITest alloc] init];
//    
//    [test clear];
//    
//    test.arr = @[@"a",@"b"];
//    test.dic = @{@"a":@[@"a",@"b"],@"b":@[@"a",@"b"]};
//    
//    test.model = [[TestModel alloc] init];
//    test.f = 0.4;
//    test.b = YES;
//    test.i = 1;
    
    AIC *aic = [[AIC alloc] init];
    [aic clear];
    aic.arr = @[@"aaaa"];
    aic.aiccc = 5;
    
    
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
