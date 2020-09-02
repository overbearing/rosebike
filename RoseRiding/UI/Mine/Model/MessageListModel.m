//
//  MessageListModel.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/20.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "MessageListModel.h"

@implementation MessageListModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Id":@"id",@"msgTitle":@"class",@"date":@"time",@"msgtype":@"class_id",@"time":@"create_time",@"alarm":@"alarm"};
}

@end
