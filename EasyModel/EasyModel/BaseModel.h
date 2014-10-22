//
//  BaseModel.h
//  CarCare
//
//  Created by ileo on 14-8-29.
//  Copyright (c) 2014年 baozun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property (nonatomic, readonly) NSDictionary *modelDic;

-(id)initWithDic:(NSDictionary *)dic;

@end
