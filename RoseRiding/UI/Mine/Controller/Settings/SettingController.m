//
//  SettingController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/30.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "SettingController.h"

//controller
#import "SetLanguageController.h"
#import "AccountsController.h"
#import "AboutUsController.h"
#import "VersionController.h"
#import "ResetPasswordViewController.h"

//view
#import "MenuCell.h"


@interface SettingController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.barStyle = NavigationBarStyleWhite;
    self.title = @"Settings";
    [self.view bringSubviewToFront:self.navView];
}

- (void)setupUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavHeight);
    }];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    self.tableView.separatorColor = [UIColor clearColor];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Adaptive(108);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setIsSetting:YES];
    [cell configureCellwith:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            SetLanguageController * SL = [[SetLanguageController alloc]init];
            [self.navigationController pushViewController:SL animated:YES];
        }
            break;
        case 1:
        {
            AboutUsController *VC = [[AboutUsController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 2:
        {
            VersionController  *VC = [[VersionController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
//        case 3:
//        {
//            AccountsController *VC = [[AccountsController alloc] init];
//            [self.navigationController pushViewController:VC animated:YES];
//        }
//            break;
        case 3:
        {
            ResetPasswordViewController *VC = [[ResetPasswordViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        default:
            break;
    }
    
}


@end
