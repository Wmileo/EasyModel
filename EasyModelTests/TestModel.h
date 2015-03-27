//
//  TestModel.h
//  EasyModel
//
//  Created by ileo on 15/2/6.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import "DataBaseModel.h"
#import <UIKit/UIKit.h>

@interface TestModel : DataBaseModel

@property (nonatomic, assign) CGFloat intT;
@property (nonatomic, strong) NSDate *stringT;
@property (nonatomic, copy) NSArray *arrr;
@property (nonatomic, copy) NSDictionary *dicdic;

@end
