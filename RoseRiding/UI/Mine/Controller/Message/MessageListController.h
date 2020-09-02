//
//  MessageListController.h
//  RoseRiding
//
//  Created by MR_THT on 2020/3/30.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageListController : RootViewController
@property (nonatomic, strong)UIView * warningView;
@property (nonatomic, assign)BOOL  isnotify;
@property (nonatomic, strong)NSString * msgcontent;
- (void)requestSetWaring;
- (void)showWarning;

@end

NS_ASSUME_NONNULL_END
