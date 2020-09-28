//
//  LoginController.h
//  RoseRiding
//
//  Created by MR_THT on 2020/3/26.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class GIDSignInButton;
@interface LoginController : RootViewController
@property (nonatomic,strong) GIDSignInButton *login_gl;
@property (nonatomic,assign) BOOL  islogout;
- (void)loginAction;
@end

NS_ASSUME_NONNULL_END
