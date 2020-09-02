//
//  UserInfo.h
//  RoseRiding
//
//  Created by MR_THT on 2020/3/24.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfo : NSObject

+ (UserInfo *)shareUserInfo;

- (void)setUserData:(NSDictionary *)userInfo;

@property (nonatomic, strong)NSString *token;
@property (nonatomic, strong)NSString *Id;
@property (nonatomic, strong)NSString *userid;
@property (nonatomic, strong)NSString *parent_id;
@property (nonatomic, strong)NSString *equipment;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *mobile;
@property (nonatomic, strong)NSString *nickname;
@property (nonatomic, strong)NSString *sex;
@property (nonatomic, strong)NSString *email;
@property (nonatomic, strong)NSString *headimg;
@property (nonatomic, strong)NSString *country;
@property (nonatomic, strong)NSString *province;
@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *openid;
@property (nonatomic, strong)NSString *unionid;
@property (nonatomic, strong)NSString *userlevel;
@property (nonatomic, strong)NSString *updatelv;
@property (nonatomic, strong)NSString *password;
@property (nonatomic, strong)NSString *telphone;
@property (nonatomic, strong)NSString *ordertotal;
@property (nonatomic, strong)NSString *commission_ordertotal;
@property (nonatomic, strong)NSString *gold;
@property (nonatomic, strong)NSString *cardgold;
@property (nonatomic, strong)NSString *commission;
@property (nonatomic, strong)NSString *cashoutCommission;
@property (nonatomic, strong)NSString *score;
@property (nonatomic, strong)NSString *remarks;
@property (nonatomic, strong)NSString *status;
@property (nonatomic, strong)NSString *create_time;
@property (nonatomic, strong)NSString *update_time;
@property (nonatomic, strong)NSString *checkpwd;
@property (nonatomic, strong)NSString *firstcard;
@property (nonatomic, strong)NSString *cardnumber;
@property (nonatomic, strong)NSString *device_id;
@end

NS_ASSUME_NONNULL_END
