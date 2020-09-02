//
//  BlueToothAlertManger.h
//  RoseRiding
//
//  Created by MR_THT on 2020/4/29.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlueToothAlertManger : NSObject

+ (BlueToothAlertManger *)shareManger;

//如果需要全局的监听蓝牙消息并弹窗在appdelegate启用
- (void)startMonitor;

@end

NS_ASSUME_NONNULL_END
