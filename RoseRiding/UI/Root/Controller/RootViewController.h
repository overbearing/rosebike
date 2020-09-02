//
//  RootViewController.h
//  RoseRiding
//
//  Created by MR_THT on 2020/3/23.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NavigationBarStyle) {
    NavigationBarStyleNormal,   //默认风格，F2F2F2
    NavigationBarStyleWhite,     //白色
    NavigationBarStyleClearWhiteContent, // 透明。白色标题
    NavigationBarStyleClearBlackContent  // 透明。黑色标题
};

@interface RootViewController : UIViewController


///期望的状态栏样式。原则是控制器只关系自己想展示什么样式，不需要管其他页面的效果
@property (nonatomic, assign) UIStatusBarStyle          statusBarStyle;

///是否push过
@property (nonatomic, assign) BOOL                      isPushed;

/**
 * 销毁当前导航控制器中的哪些页面，默认nil
 */
@property (nonatomic, copy) NSArray<NSString *>         *removeClassArray;

/**
 * push后是否从导航控制器中移除本页面，默认NO
 * 如果不能确定该页面push到所有页面后都要移除，建议在openURL或者push前一步设置
 */
@property (nonatomic, assign) BOOL                      removeAfterPush;

#pragma mark - 导航栏
///导航栏
@property (nonatomic, assign) NavigationBarStyle    barStyle;

///导航栏View
@property (nonatomic, strong) UIImageView               *navView;
///是否隐藏自定义导航栏,默认NO
@property (nonatomic, assign) BOOL                      hideNavigationView;
///是否显示navView底部的线条,默认NO
@property (nonatomic, assign) BOOL                      showNavigationBottomLine;
///导航栏左按钮。默认显示返回按钮，默认goBack
@property (nonatomic, strong) UIButton                  *leftButton;
///导航栏标题按钮，设置self.title即可。默认无点击事件
@property (nonatomic, strong) UIButton                  *titleView;
///导航栏右按钮。默认rightButtonClick:
@property (nonatomic, strong) UIButton                  *rightButton;

/** 返回到上级控制器 */
- (void)goBack;

/** 右边按钮的点击事件,空实现,可在子类中重写 */
- (void)rightButtonClick:(UIButton *)button;

/** 按钮绑定方法, 空实现, 子类重写时直接提示, 方便敲代码*/
- (void)buttonClick:(UIButton *)button;

@end

NS_ASSUME_NONNULL_END
