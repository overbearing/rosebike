//
//  AccountsController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/31.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "AccountsController.h"

@interface AccountsController ()


@end

@implementation AccountsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.barStyle = NavigationBarStyleWhite;
    self.title = @"Accounts";
    [self.view bringSubviewToFront:self.navView];
    [self.rightButton setTitle:@"Mange" forState:UIControlStateNormal];
    CGRect rect = self.rightButton.frame;
    rect.origin.x = rect.origin.x + Adaptive(16);
    self.rightButton.frame = rect;
}

@end
