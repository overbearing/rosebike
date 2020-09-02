//
//  MessageDetailController.h
//  RoseRiding
//
//  Created by Mac on 2020/6/3.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^MessageDetailControllerRead)(void);
@interface MessageDetailController : RootViewController
@property (nonatomic,strong)NSString * msgid;
@property (nonatomic,assign)BOOL isread;
@property (nonatomic,assign)BOOL isnew;
@property (nonatomic,assign)BOOL isalarm;
@property (nonatomic , copy)MessageDetailControllerRead readDetail;
@end

NS_ASSUME_NONNULL_END
