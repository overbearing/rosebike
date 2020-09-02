//
//  Toast.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/16.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "Toast.h"

@implementation Toast

+(void)showToastMessage:(NSString *)message{
    [self showToastMessage:message inview:UIKeyWindow];
}

+(void)showToastMessage:(NSString *)message inview:(UIView *)view{
    [self showToastMessage:message inview:view interval:1.5];
}

+(void)showToastMessage:(NSString *)message inview:(UIView *)view interval:(NSTimeInterval)interval{
    [self showToastMessage:message inview:view interval:interval position:CGPointMake(UIWidth/2, UIHeight/2)];
}

+(void)showToastMessage:(NSString *)message inview:(UIView *)view interval:(NSTimeInterval)interval position:(CGPoint)position{
    [self showToastMessage:message inview:view interval:interval position:position style:nil];
}

+(void)showToastMessage:(NSString *)message inview:(UIView *)view interval:(NSTimeInterval)interval position:(CGPoint)position style:(nullable CSToastStyle *)style{
    [view makeToast:message duration:interval position:[NSValue valueWithCGPoint:position] title:nil image:nil style:style completion:nil];
}

@end
