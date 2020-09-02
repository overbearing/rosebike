//
//  SetLanguageController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/31.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "SetLanguageController.h"
#import "NSBundle+Language.h"
#import "HomeController.h"
#import "MainTabbarController.h"

@interface SetLanguageController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic , strong)NSArray *languages;
@property (nonatomic , assign)NSInteger  rowIndex;
@property (nonatomic , strong)UIPickerView* pv;
@end

@implementation SetLanguageController

- (void)viewDidLoad {
    [super viewDidLoad];
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.rootViewController = [[MainTabbarController alloc] init];
    [self setupUI];
    self.barStyle = NavigationBarStyleWhite;
    self.title = @"Language";
    [self.view bringSubviewToFront:self.navView];
}

- (void)setupUI{
    self.languages = [[NSArray alloc] initWithObjects:@"English", @"Deutsch", nil];
    self.pv = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kNavHeight, UIWidth, 216)];
    self.pv.delegate = self;
    self.pv.dataSource = self;
    self.pv.showsSelectionIndicator = YES;
    //实现默认选中第一行的点
    [self.view addSubview:self.pv];
}

//多少组
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//每一组多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.languages.count;
}
//显示每一行的文本
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.languages[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    //如果是第0组
    if (component == 0) {
        //如果是第0组的第0行
        if (row == 0) {
            //return 显示的view
        }
        if (row == 1) {
            //
        }
    }
    
    UILabel* pickerLabel = (UILabel*)view;
       if (!pickerLabel){
           pickerLabel = [[UILabel alloc] init];
           // Setup label properties - frame, font, colors etc
           //adjustsFontSizeToFitWidth property to YES
           [pickerLabel setBackgroundColor:[UIColor clearColor]];
           [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
       }
       // Fill the label text here
       pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
       pickerLabel.textAlignment = NSTextAlignmentCenter;
      if ([self.languages[row] isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"LanguageIndex"]]) {
          [self.pv selectRow:row inComponent:0 animated:NO];//每次显示picker的时候都选中第一行
          [self pickerView:self.pv didSelectRow:row inComponent:0];
      }
       return pickerLabel;
}
//选择一行就会调用这个方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (row == 0) {
        [NSBundle setLanguage:@"en"];
        [[NSUserDefaults standardUserDefaults] setObject:@"English" forKey:@"LanguageIndex"];
    }else{
        [NSBundle setLanguage:@"de"];
        [[NSUserDefaults standardUserDefaults] setObject:@"Deutsch" forKey:@"LanguageIndex"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguage" object:nil];
}
- (void)goBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/*
- (void)backToHomePage
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window] ;
    UIViewController *presentedController = nil;
    
    UIViewController *rootController = [window rootViewController];
    if ([rootController isKindOfClass:[UITabBarController class]]) {
        rootController = [(UITabBarController *)rootController selectedViewController];
    }
    presentedController = rootController;
    //找到所有presented的controller，包括UIViewController和UINavigationController
    NSMutableArray<UIViewController *> *presentedControllerArray = [[NSMutableArray alloc] init];
    while (presentedController.presentedViewController) {
        [presentedControllerArray addObject:presentedController.presentedViewController];
        presentedController = presentedController.presentedViewController;
    }
    if (presentedControllerArray.count > 0) {
        //把所有presented的controller都dismiss掉
        [self dismissControllers:presentedControllerArray topIndex:presentedControllerArray.count - 1 completion:^{
            [self popToRootViewControllerFrom:rootController];
        }];
    } else {
        [self popToRootViewControllerFrom:rootController];
    }
}
- (void)dismissControllers:(NSArray<UIViewController *> *)presentedControllerArray topIndex:(NSInteger)index completion:(void(^)(void))completion
{
    if (index < 0) {
        completion();
    } else {
        [presentedControllerArray[index] dismissViewControllerAnimated:NO completion:^{
            [self dismissControllers:presentedControllerArray topIndex:index - 1 completion:completion];
        }];
    }
}
- (void)popToRootViewControllerFrom:(UIViewController *)fromViewController
{
    //pop to root
    if ([fromViewController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)fromViewController popToRootViewControllerAnimated:YES];
    }
    if (fromViewController.navigationController) {
        [fromViewController.navigationController popToRootViewControllerAnimated:YES];
    }
}
 */
@end
