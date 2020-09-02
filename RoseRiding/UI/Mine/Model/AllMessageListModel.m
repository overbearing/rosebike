//
//  AllMessageListModel.m
//  RoseRiding
//
//  Created by Mac on 2020/6/2.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "AllMessageListModel.h"

@implementation AllMessageListModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Id":@"id",@"msgTtile":@"class",@"date":@"time",@"time":@"create_time"};
}
@end
