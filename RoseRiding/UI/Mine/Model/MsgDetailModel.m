//
//  MsgDetailModel.m
//  RoseRiding
//
//  Created by Mac on 2020/6/3.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "MsgDetailModel.h"

@implementation MsgDetailModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Id":@"id",@"title":@"class",@"date":@"time",@"msgtype":@"class_id",@"time":@"create_time"};
}
@end
