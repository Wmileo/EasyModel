//
//  NSJSONSerialization+Addition.h
//  EasyModel
//
//  Created by ileo on 15/3/26.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (Addition)

+(NSString *)stringWithJSONObject:(id)obj options:(NSJSONWritingOptions)opt error:(NSError **)error;

@end
