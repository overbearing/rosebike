//
//  MessageListModel.h
//  RoseRiding
//
//  Created by MR_THT on 2020/4/20.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageListModel : NSObject

@property (nonatomic , strong)NSString *Id;
@property (nonatomic , strong)NSString *nickname;
@property (nonatomic , strong)NSString *username;
@property (nonatomic , strong)NSString *value;
@property (nonatomic , strong)NSString *msgTitle;
@property (nonatomic , strong)NSString *status;
@property (nonatomic , strong)NSString *date;
@property (nonatomic , strong)NSString *msgtype;
@property (nonatomic , strong)NSString *time;
@property (nonatomic , strong)NSString *alarm;

@end

NS_ASSUME_NONNULL_END
