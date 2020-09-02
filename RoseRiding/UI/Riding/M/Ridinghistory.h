//
//  Ridinghistory.h
//  RoseRiding
//
//  Created by 蜡笔小新 on 2020/8/12.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Ridinghistory : NSObject
@property (nonatomic , strong)NSString *Id;
@property (nonatomic , strong)NSString *altitude;
@property (nonatomic , strong)NSString *max_altitude;
@property (nonatomic , strong)NSString *min_altitude;
@property (nonatomic , strong)NSString *average_speed;
@property (nonatomic , strong)NSString *max_speed;
@property (nonatomic , strong)NSString *min_speed;
@property (nonatomic , strong)NSString *mileage;
@property (nonatomic , strong)NSString *time_consuming;
@property (nonatomic , strong)NSString *city_level;
@property (nonatomic , strong)NSString *end_lat;
@property (nonatomic , strong)NSString *end_lng;
@property (nonatomic , strong)NSString *end_time;
@property (nonatomic , strong)NSString *user_id;
@property (nonatomic , strong)NSString *system_start_time;
@property (nonatomic , strong)NSString *start_time;
@property (nonatomic , strong)NSString *start_lng;
@property (nonatomic , strong)NSString *start_lat;
@property (nonatomic , strong)NSString *equipment_id;
@property (nonatomic , strong)NSString *status;
@property (nonatomic , strong)NSString *startaddr;
@property (nonatomic , strong)NSString *endaddr;


@end

NS_ASSUME_NONNULL_END
