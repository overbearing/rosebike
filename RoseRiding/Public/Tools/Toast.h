//
//  Toast.h
//  RoseRiding
//
//  Created by MR_THT on 2020/4/16.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Toast : NSObject

+(void)showToastMessage:(NSString *)message;

+(void)showToastMessage:(NSString *)message inview:(UIView *)view;

+(void)showToastMessage:(NSString *)message inview:(UIView *)view interval:(NSTimeInterval)interval;

+(void)showToastMessage:(NSString *)message inview:(UIView *)view interval:(NSTimeInterval)interval position:(CGPoint)position;
//可以继续扩展(根据项目需求)
+(void)showToastMessage:(NSString *)message inview:(UIView *)view interval:(NSTimeInterval)interval position:(CGPoint)position style:(nullable CSToastStyle *)style;

@end

NS_ASSUME_NONNULL_END
