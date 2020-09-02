//
//  AllMessageListModel.h
//  RoseRiding
//
//  Created by Mac on 2020/6/2.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AllMessageListModel : NSObject
@property (nonatomic , strong)NSString *Id;
@property (nonatomic , strong)NSString *nickname;
@property (nonatomic , strong)NSString *username;
@property (nonatomic , strong)NSString *value;
@property (nonatomic , strong)NSString *msgTtile;
@property (nonatomic , strong)NSString *status;
@property (nonatomic , strong)NSString *time;
@property (nonatomic , strong)NSString *date;
@end

NS_ASSUME_NONNULL_END
