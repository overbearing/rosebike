//
//  UserInfo.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/24.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+ (UserInfo *)shareUserInfo{
    static dispatch_once_t onceToken;
    static UserInfo *userinfo;
    dispatch_once(&onceToken, ^{
        userinfo = [[UserInfo alloc] init];
    });
    return userinfo;
}

- (void)setUserData:(NSDictionary *)userInfo{
    
    self.Id = userInfo[@"id"];
    self.parent_id = [userInfo[@"parent_id"] stringValue];
    self.equipment = [userInfo[@"equipment"] stringValue];
    self.name = userInfo[@"name"];
    self.mobile = userInfo[@"mobile"];
    self.nickname = userInfo[@"nickname"];
    self.sex = [userInfo[@"sex"] stringValue];
    self.email = userInfo[@"email"];
    self.headimg = userInfo[@"headimg"];
    self.country = userInfo[@"country"];
    self.province = userInfo[@"province"];
    self.city = userInfo[@"city"];
    self.openid = userInfo[@"openid"];
    self.unionid = userInfo[@"unionid"];
    self.userlevel = userInfo[@"userlevel"];
    self.password = userInfo[@"password"];
    self.telphone = userInfo[@"telphone"];
    self.token = userInfo[@"token"];
    self.userid = userInfo[@"userid"];
    self.device_id =[userInfo[@"device_id"] stringValue];
   
}



@end
