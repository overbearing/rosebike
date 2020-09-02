//
//  NSObject+MSHUD.h
//  RoseRiding
//
//  Created by LaoSun on 2020/4/13.
//  Copyright © 2020 MR_THT. All rights reserved.
//

//#import <AppKit/AppKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MSHUD)

// 文字HUD
- (void)showTextHUD:(NSString *)text;
//文字加载HUD
- (void)showTextLoadingHUD:(NSString *)text;
//// 加载HUD
- (void)showLoadingHUD;
//// 隐藏加载HUD
- (void)hideLoadingHUD;

@end

NS_ASSUME_NONNULL_END
