//
//  DataBaseModel.h
//  EasyModel
//
//  Created by ileo on 15/3/27.
//  Copyright (c) 2015年 ileo. All rights reserved.
//

#import "BaseModel.h"

@interface DataBaseModel : BaseModel

@property (nonatomic, readonly) NSDictionary *jsonObjectDic;
@property (nonatomic, readonly) NSArray *dbColumns;

-(NSString *)primaryKey;

@end