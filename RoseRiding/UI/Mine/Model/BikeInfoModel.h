//
//  BikeInfoModel.h
//  RoseRiding
//
//  Created by MR_THT on 2020/4/29.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BikeInfoModel : NSObject

@property (nonatomic , strong)NSString *Id;
@property (nonatomic , strong)NSString *equipment;
@property (nonatomic , strong)NSString *details;
@property (nonatomic , strong)NSString *model;
@property (nonatomic , strong)NSString *color;
@property (nonatomic , strong)NSString *buytime;
@property (nonatomic , strong)NSString *guarantee;
@property (nonatomic , strong)NSString *serial_number;
@property (nonatomic , strong)NSString *act_id; //     激活碼id
@property (nonatomic , strong)NSString *bluetooth_left_day; //服务剩余天数
@end

NS_ASSUME_NONNULL_END
