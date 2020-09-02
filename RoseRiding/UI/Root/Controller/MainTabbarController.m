//
//  MainTabbarController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/23.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "MainTabbarController.h"
#import "MainNavController.h"
#import "MineController.h"
#import "MenuController.h"
#import "HomeController.h"
#import "LoginController.h"
#import "HomeTestController.h"

@interface MainTabbarController ()<UITabBarControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong)NSArray *tabbarTitles;
@property (nonatomic, strong)NSArray *tabarNormalImages;
@property (nonatomic, strong)NSArray *tabarSelectedImages;
@property (nonatomic, strong)NSArray *childVCNames;
@end
@implementation MainTabbarController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    [self setChildVC];
    NSArray *languages = [NSLocale preferredLanguages];
//    NSLog(@"当前本地语言%@",languages);
   self.tabBar.tintColor = [UIColor colorWithHexString:@"#333333"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)setChildVC{
    self.childVCNames = @[@"HomeController", @"MineController",@"MenuController"];
    self.tabarNormalImages = @[@"home-normal", @"mine-normal", @"sort-normal"];
    self.tabarSelectedImages  = @[ @"home-click", @"mine-click", @"sort-click"];
     self.tabbarTitles = @[[GlobalControlManger enStr:@"Home" geStr:@"Home"], [GlobalControlManger enStr:@"Profile" geStr:@"Profile"], [GlobalControlManger enStr:@"Menu" geStr:@"Menu"]];
    
    // 设置子控制器
    for (int i = 0; i < self.childVCNames.count; i++) {
        UINavigationController *naviController = [self getNavWithRootVCName:self.childVCNames[i]];
         if (@available(iOS 13.0, *)) {[naviController setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];}
        [self addChildViewController:naviController];
    }
}
- (UINavigationController *)getNavWithRootVCName:(NSString *)name{
    NSInteger index = [self.childVCNames indexOfObject:name];
    UIViewController *vc = [[NSClassFromString(name) alloc] init];
    // 导航控制器的rootVC hidesBottomBarWhenPushed要设置为NO
    vc.hidesBottomBarWhenPushed = NO;
    if (@available(iOS 13.0, *)) {
        self.tabBar.tintColor = [UIColor colorWithHexString:@"#333333"];
        self.tabBar.unselectedItemTintColor =[UIColor colorWithHexString:@"#666666"];
        vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        [vc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
        [vc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateSelected];
    } else {
        vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        [vc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]} forState:UIControlStateNormal];
        [vc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]} forState:UIControlStateSelected];
    }
    vc.tabBarItem.title = self.tabbarTitles[index];
    vc.tabBarItem.image = [[UIImage imageNamed:self.tabarNormalImages[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:self.tabarSelectedImages[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.delegate = self;
    return nav;
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    NSLog(@"maintabbarcontroller%@",[UserInfo shareUserInfo].token);
    if ([UserInfo shareUserInfo].token == nil) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"dhGuidePage"]) {
            if (self.navigationController == nil) {
                return;
            }
            LoginController *loginVC = [LoginController new];
            if (@available(iOS 13.0, *)) {
               loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
            }
            [self presentViewController:loginVC animated:YES completion:nil];
            return;
        }else{
//            NSLog(@"bug");
        }
    }else{
//        NSLog(@"bugbug");
    }
}
@end
