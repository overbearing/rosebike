//
//  MsgDetailModel.h
//  RoseRiding
//
//  Created by Mac on 2020/6/3.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MsgDetailModel : NSObject
@property (nonatomic , strong)NSString *Id;
@property (nonatomic , strong)NSString *title;
@property (nonatomic , strong)NSString *value;
@property (nonatomic , strong)NSString *date;
@property (nonatomic , strong)NSString *time;
@end

NS_ASSUME_NONNULL_END
