//
//  UserModel.m
//  RoseRiding
//
//  Created by MR_THT on 2020/5/8.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Id":@"id"};
}

@end
