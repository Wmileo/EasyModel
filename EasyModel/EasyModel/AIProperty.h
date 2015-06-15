//
//  AIProperty.h
//  AIProperty
//
//  Created by ileo on 14-3-7.
//  Copyright (c) 2014年 ileo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIProperty : NSObject

-(instancetype)init;
-(instancetype)initWithSuperClass:(Class)superClass;

-(void)clear;

-(NSArray *)withoutPropertys;

@end
