//
//  RootViewController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/23.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "RootViewController.h"

#import "MessageListController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (instancetype)init{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    if (!self.hideNavigationView) {
        [self.view addSubview:self.navView];
        [self.navView addSubview:self.leftButton];
        [self.navView addSubview:self.titleView];
        [self.navView addSubview:self.rightButton];
    }
    // 2、默认设置，部分属性放在init方法设置
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([UIApplication sharedApplication].statusBarStyle != self.statusBarStyle) {
        [UIApplication sharedApplication].statusBarStyle = self.statusBarStyle;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@的对象被释放了(所属类名)", NSStringFromClass([self class]));
}

# pragma mark- 自定义导航栏
- (void)setBarStyle:(NavigationBarStyle)barStyle {
    _barStyle = barStyle;
    
    switch (_barStyle) {
        case NavigationBarStyleNormal:{
            
            self.statusBarStyle = UIStatusBarStyleDefault;
            self.navView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
            
            [self.leftButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            [self.leftButton setImage:[UIImage imageNamed:@"public_back_black"] forState:UIControlStateNormal];
            
            if (self.titleView && [self.titleView isKindOfClass:[UIButton class]]) {
                [self.titleView setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            }
            
            [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            
            break;
        }
        case NavigationBarStyleWhite:{
            
            self.statusBarStyle = UIStatusBarStyleDefault;
            self.navView.backgroundColor = [UIColor whiteColor];
            
            [self.leftButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            [self.leftButton setImage:[UIImage imageNamed:@"public_back_black"] forState:UIControlStateNormal];
            
            if (self.titleView && [self.titleView isKindOfClass:[UIButton class]]) {
                [self.titleView setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            }
            [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            
            break;
        }
        case NavigationBarStyleClearWhiteContent:{
            
            self.statusBarStyle = UIStatusBarStyleLightContent;
            self.navView.backgroundColor = [UIColor clearColor];
            
            [self.leftButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
            [self.leftButton setImage:[UIImage imageNamed:@"public_back_white"] forState:UIControlStateNormal];
            
            if (self.titleView && [self.titleView isKindOfClass:[UIButton class]]) {
                [self.titleView setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
            }
            
            [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
            
            break;
        }
        case NavigationBarStyleClearBlackContent:{
            
            self.statusBarStyle = UIStatusBarStyleDefault;
            self.navView.backgroundColor = [UIColor clearColor];
            
            [self.leftButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            [self.leftButton setImage:[UIImage imageNamed:@"public_back_black"] forState:UIControlStateNormal];
            
            if (self.titleView && [self.titleView isKindOfClass:[UIButton class]]) {
                [self.titleView setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            }
            
            [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            
            break;
        }
        default:
            break;
    }
}

- (void)setShowNavigationBottomLine:(BOOL)showNavigationBottomLine {
    _showNavigationBottomLine = showNavigationBottomLine;
}

# pragma mark- 默认方法，子类可重载
- (void)goBack {
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightButtonClick:(UIButton *)button {
    
}

- (void)buttonClick:(UIButton *)button {
    
}

# pragma mark- Getter/Setter
- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    
    if (self.titleView) {
        
        if ([self.titleView isKindOfClass:[UIButton class]]) {
            [self.titleView setTitle:title forState:UIControlStateNormal];
        }else if ([self.titleView isKindOfClass:[UILabel class]]) {
            ((UILabel *)self.titleView).text = title;
        }else if ([self.titleView isKindOfClass:[UITextField class]]) {
            ((UITextField *)self.titleView).text = title;
        }
    }
}

// 导航栏相关
- (void)setHideNavigationView:(BOOL)hideNavigationView {
    _hideNavigationView = hideNavigationView;
    
    if (_hideNavigationView && self.navView.superview) {
        [self.navView removeFromSuperview];
    }else if (!_hideNavigationView && !self.navView.superview) {
        [self.view addSubview:self.navView];
    }
}

- (UIImageView *)navView {
    if (!_navView) {
        _navView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIWidth, 64 + kSafeAreaTopHeight)];
        _navView.userInteractionEnabled = YES;
        _navView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return _navView;
}

- (UIButton *)titleView {
    if (!_titleView) {
        _titleView = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleView.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [_titleView setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _titleView.adjustsImageWhenHighlighted = NO;
        
        CGFloat minX = (UIWidth - Adaptive(300)) / 2.0;
        _titleView.frame = CGRectMake(minX, kStatusBarHeight, Adaptive(300), 44);
    }
    return _titleView;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [_leftButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _leftButton.adjustsImageWhenHighlighted = NO;
        _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        _leftButton.frame = CGRectMake(Adaptive(12), kStatusBarHeight, 44, 44);
        
        [_leftButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [_rightButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _rightButton.adjustsImageWhenHighlighted = NO;
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _rightButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        CGFloat minX = [UIScreen mainScreen].bounds.size.width - 44 - Adaptive(40);
        _rightButton.frame = CGRectMake(minX, kStatusBarHeight, 44, 44);
        [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if (@available(iOS 13.0, *)) {
        if (viewControllerToPresent.modalPresentationStyle == UIModalPresentationAutomatic) {
            viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
        }
    }
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}
@end
