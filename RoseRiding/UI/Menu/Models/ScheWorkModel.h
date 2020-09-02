//
//  ScheWorkModel.h
//  RoseRiding
//
//  Created by MR_THT on 2020/5/6.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScheWorkModel : NSObject

@property (nonatomic , strong)NSString *Id;
@property (nonatomic , strong)NSString *modify_name;
@property (nonatomic , strong)NSArray *schedule_time;
@property (nonatomic , strong)NSString *schedule_type;
@property (nonatomic , strong)NSString * start_time;
@property (nonatomic , strong)NSString * end_time;
@end

NS_ASSUME_NONNULL_END
