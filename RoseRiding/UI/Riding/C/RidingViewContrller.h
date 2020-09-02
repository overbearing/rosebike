//
//  RidingViewContrller.h
//  RoseRiding
//
//  Created by MR_THT on 2020/6/5.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "RootViewController.h"
#import "RidingTopView.h"
NS_ASSUME_NONNULL_BEGIN

@interface RidingViewContrller : RootViewController
- (void)openURL:(NSURL *)url
        options:(NSDictionary<UIApplicationOpenExternalURLOptionsKey, id> *)options
completionHandler:(void (^)(BOOL success))completion;
@property (nonatomic,strong)NSString * name;
@property (nonatomic,assign)BOOL isjump;
@property (nonatomic, strong)RidingTopView *topView;//头部视图
@end

NS_ASSUME_NONNULL_END
