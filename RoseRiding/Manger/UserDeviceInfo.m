//
//  UserDeviceInfo.m
//  RoseRiding
//
//  Created by LaoSun on 2020/4/14.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "UserDeviceInfo.h"

#define SaveDeviceInfoKey @"SaveDeviceInfoKey"
#define DefaultDeviceKey @"DefaultDeviceKey"
#define temporaryDeviceKey @"temporaryDeviceKey"

@implementation DeviceInfoModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.macAddress forKey:@"macAddress"];
    [aCoder encodeObject:self.deviceName forKey:@"deviceName"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.macAddress = [aDecoder decodeObjectForKey:@"macAddress"];
        self.deviceName = [aDecoder decodeObjectForKey:@"deviceName"];
    }
    return self;
}

@end

@implementation UserDeviceInfo

+ (UserDeviceInfo *)shareUserInfo{
    static dispatch_once_t onceToken;
    static UserDeviceInfo *userinfo;
    dispatch_once(&onceToken, ^{
        userinfo = [[UserDeviceInfo alloc] init];
    });
    return userinfo;
}

-(void)saveDeviceInfoWithMacAddress:(NSString *)macAddress name:(NSString *)name {
    DeviceInfoModel *model = [DeviceInfoModel new];
    model.macAddress = macAddress;
    model.deviceName = name;
    if ([self isHaveDevice]) {
        NSMutableArray *deviceArray = [self readCacheDataForKey:SaveDeviceInfoKey];
        for (DeviceInfoModel *deivce in deviceArray) {
            if ([deivce.macAddress isEqualToString:model.macAddress]) {
                return;
            }
        }
        [deviceArray addObject:model];
        [self saveData:deviceArray forKey:SaveDeviceInfoKey];
    }else {
        NSMutableArray *deviceArray = [[NSMutableArray alloc] init];
        [deviceArray addObject:model];
        [self saveData:deviceArray forKey:SaveDeviceInfoKey];
    }
}

-(void)saveTemporaryDeviceWithMacAddress:(NSString *)macAddress name:(NSString *)name {
    DeviceInfoModel *model = [DeviceInfoModel new];
    model.macAddress = macAddress;
    model.deviceName = name;
    [self saveData:model forKey:temporaryDeviceKey];
}

-(DeviceInfoModel *)getTemporaryDeviceData {
    DeviceInfoModel *model = [self readCacheDataForKey:temporaryDeviceKey];
    return model;
}

-(NSMutableArray *)getAllDevice {
    if ([self isHaveDevice]) {
        NSMutableArray *deviceArray = [self readCacheDataForKey:SaveDeviceInfoKey];
        return deviceArray;
    }else {
        return nil;
    }
}

-(void)saveDefaultDeviceWithMacAddress:(NSString *)macAddress {
    [self saveData:macAddress forKey:DefaultDeviceKey];
}

-(NSString *)getDefaultDeviceMacaddress {
    NSString *address = [self readCacheDataForKey:DefaultDeviceKey];
    return address;
}

-(BOOL)isHaveDevice {
    NSArray *deviceArray = [self readCacheDataForKey:SaveDeviceInfoKey];
    if (deviceArray && deviceArray.count > 0) {
        return YES;
    }else {
        return NO;
    }
}

- (void)saveData:(NSObject *)object forKey:(NSString *)key{

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];

    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];

    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (id)readCacheDataForKey:(NSString *)key{

    NSData *cache = [[NSUserDefaults standardUserDefaults] objectForKey:key];

    if(cache){
        NSObject *object = [NSKeyedUnarchiver unarchiveObjectWithData:cache];
        return object;
    }else {
        return nil;
    }

}

- (void)deleteObjectForKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
