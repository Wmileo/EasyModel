//
//  EasyModelTests.m
//  EasyModelTests
//
//  Created by ileo on 14/10/22.
//  Copyright (c) 2014年 ileo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TestModel.h"

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
    
    TestModel *tm = [[TestModel alloc] init];
    
//    tm.stringT = @"<null>";
//    tm.intT = 9;
//    [tm setValue:@"<null>" forKey:@"intT"];
    
    tm.arrr = @[@"aa",@"bb"];
    tm.dicdic = @{@"cc":@"dd",@"aa":@"gg"};
    
    NSLog(@"%@",tm.dbColumns);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
