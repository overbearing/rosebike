//
//  MineController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/23.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "MineController.h"
#import "MineHeadView.h"
#import "MineMenuCell.h"
#import "SettingController.h"
#import "UserInfoController.h"
#import "MessageListController.h"
#import "HelpController.h"
#import "MyDeviceController.h"
#import "LoginController.h"
@interface MineController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)MineHeadView *headView;

@end

@implementation MineController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    UIButton *setting = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat minX = [UIScreen mainScreen].bounds.size.width - 20 - Adaptive(20);
    setting.frame = CGRectMake(minX, kStatusBarHeight+8.5, 20, 20);
    [setting addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [setting setImage:[UIImage imageNamed:@"icon_settings_black_"] forState:UIControlStateNormal];
    [self.navView addSubview:setting];
    
    [RACObserve([UserInfo shareUserInfo], Id) subscribeNext:^(id  _Nullable x) {
        if (x == nil) {
            NSLog(@"弹出登录");
            LoginController *loginVC = [LoginController new];
            loginVC.islogout = NO;
             loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:loginVC animated:YES completion:nil];
        }else{
            [self upDateHeadData];
        }
    }];
    
    [RACObserve([UserInfo shareUserInfo], nickname) subscribeNext:^(id  _Nullable x) {
         if (x == nil) {
            
         }else{
             [self upDateHeadData];
         }
     }];
    
    [RACObserve([UserInfo shareUserInfo], headimg) subscribeNext:^(id  _Nullable x) {
         if (x == nil) {
            
         }else{
             [self upDateHeadData];
         }
     }];
}

- (void)setupUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavHeight);
    }];
    # ifdef __IPHONE_11_0
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0 );
            
           //属性的解释
            /* When contentInsetAdjustmentBehavior allows, UIScrollView may incorporate
            its safeAreaInsets into the adjustedContentInset.
            @property(nonatomic, readonly) UIEdgeInsets adjustedContentInset API_AVAILABLE(ios(11.0),tvos(11.0));
            */
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

        }
            
        }
        
    #endif
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"MineMenuCell" bundle:nil] forCellReuseIdentifier:@"MineMenuCell"];
    if (@available(iOS 13.0, *)) {
        self.tableView.automaticallyAdjustsScrollIndicatorInsets = NO;
    } else {
        // Fallback on earlier versions
    }
    self.extendedLayoutIncludesOpaqueBars = YES;
    MineHeadView *headView = [[MineHeadView alloc] initWithFrame: CGRectMake(0, 0, UIWidth, Device_iPhone5 ? 180 : 280)];
    self.headView = headView;
    self.tableView.tableHeaderView = headView;
    self.tableView.scrollEnabled = NO;
    [headView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIWidth, 40)];
    UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
    add.frame = CGRectMake(40, 0,UIWidth-80 , 40);
    [footView addSubview:add];
    [add setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [add setTitle:[GlobalControlManger enStr:@"logout" geStr:@"logout"] forState:UIControlStateNormal];
    add.backgroundColor = [UIColor blackColor];
    add.layer.cornerRadius = 4;
    [[add rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self Logout];
    }];
    self.tableView.tableFooterView = footView;
    [self.view bringSubviewToFront:self.navView];
}
- (void)Logout{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:[GlobalControlManger enStr:@"logout" geStr:@"logout"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        } seq:1];
//        NSMutableArray * account = [[NSUserDefaults standardUserDefaults] objectForKey:@"accounts"];
//        [[[NSUserDefaults standardUserDefaults] objectForKey:@"accounts"] remo];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accounts"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isfirstconnect"];
        [[GYBabyBluetoothManager sharedManager]stopScanPeripheral];
        LoginController *loginVC = [LoginController new];
        loginVC.islogout = YES;
        loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:loginVC animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)upDateHeadData{
    self.headView.nick.text = [UserInfo shareUserInfo].nickname;
    [self.headView.headImg sd_setImageWithURL:[NSURL URLWithString:[UserInfo shareUserInfo].headimg] placeholderImage:[UIImage imageNamed:@""]];
}

- (void)rightButtonClick:(UIButton *)button{
    SettingController *VC = [SettingController new];
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark--- set tableview headY;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
if ([cell respondsToSelector:@selector(setSeparatorInset:)])
{
[cell setSeparatorInset:UIEdgeInsetsZero];
}
if ([cell respondsToSelector:@selector(setLayoutMargins:)])
{
[cell setLayoutMargins:UIEdgeInsetsZero];
}
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Adaptive(75);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineMenuCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureCellWithIndexpath:indexPath showTip:YES];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        MyDeviceController *VC = [MyDeviceController new];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 1){
        MessageListController *VC = [[MessageListController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        HelpController *VC = [[HelpController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
- (void)tapAction:(UITapGestureRecognizer *)gesture{
    UserInfoController *VC = [UserInfoController new];
    [self.navigationController pushViewController:VC animated:YES];
}

@end
