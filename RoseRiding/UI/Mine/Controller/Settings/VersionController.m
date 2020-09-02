//
//  VersionController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/20.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "VersionController.h"

@interface VersionController ()
@property (weak, nonatomic) IBOutlet UILabel *currentVersion;
@end
@implementation VersionController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.barStyle = NavigationBarStyleWhite;
    self.title = [GlobalControlManger enStr:@"version" geStr:@"version"];
    [self.view bringSubviewToFront:self.navView];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.currentVersion.text = app_Version;
    [self showAlertIsUpdae:NO];
}
- (void)showAlertIsUpdae:(BOOL)isUpdate{
    NSString *alertTitle;
    if (isUpdate) {
        alertTitle = [GlobalControlManger enStr: @"Discover New Version"geStr: @"Discover New Version"];
    }else{
       alertTitle = [GlobalControlManger enStr:@"It is the latest version"geStr:@"It is the latest version"];
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:[NSString stringWithFormat:@"Leopard | %@",self.currentVersion.text] preferredStyle:UIAlertControllerStyleAlert];
    if (isUpdate) {
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Update" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //去appstore
        }]];
    }else{
        [alert addAction:[UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
    }
    [self presentViewController:alert animated:YES completion:nil];
}


@end
