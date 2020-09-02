
//
//  EditDeviceInfoController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/2.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "EditDeviceInfoController.h"
#import "EditDeviceCell.h"

@interface EditDeviceInfoController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic , strong)NSArray *leftNames;
@property (nonatomic , strong)NSArray *rightInfos;
@property (nonatomic , strong)UIView *menuBg;

@end

@implementation EditDeviceInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.leftNames = @[@"Modify device name",@"Bike type",@"Bike Color",@"Manufactory date",@"Bike Manufactorer",@"Bike serial number",@"Last servicing date",@"Authorized contract view",@"Bluetooth days left display"];
     self.rightInfos = @[@"My device",@"TIger 2.0",@"Red",@"10.08.2019",@"Colnago",@"0514",@"23.04.2020",@"",@"30"];
    [self setupUI];
    self.barStyle = NavigationBarStyleWhite;
    self.title = @"Devices Info";
    [self.view bringSubviewToFront:self.navView];
    [self fixInfoContent];
}
- (void)setupUI{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    if (self.isAddOrFix) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-Adaptive(244));
            make.top.equalTo(self.view).offset(kNavHeight);
        }];
        [self fixInfoContent];
    }else{
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(kNavHeight);
        }];
    }

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"EditDeviceCell" bundle:nil] forCellReuseIdentifier:@"EditDeviceCell"];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.leftNames.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Adaptive(74);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EditDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditDeviceCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.canInput = YES;
    NSString *name = self.leftNames[indexPath.row];
    if ([name isEqualToString:@"Authorized contract view"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [cell configureLeftName:name rightInfo:self.rightInfos[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Adaptive(44);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


}


- (void)fixInfoContent{
    UIView *menuBg = [[UIView alloc] initWithFrame:CGRectMake(0, UIHeight - Adaptive(244), UIWidth, Adaptive(244))];
    menuBg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:menuBg];
    self.menuBg = menuBg;
    
    UIButton *submit = [[UIButton alloc] init];
    submit.backgroundColor = [UIColor colorWithHexString:@"#15BA39"];
    [submit setTitle:@"save" forState:UIControlStateNormal];
    submit.titleLabel.font = kFont(16);
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [menuBg addSubview:submit];
    [submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(menuBg);
        make.width.equalTo(@244);
        make.top.equalTo(menuBg).offset(60);
        make.height.equalTo(@48);
    }];
    [[submit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Toast showToastMessage:[GlobalControlManger enStr:@"Save failed" geStr:@"Save failed"]  inview:self.view interval:3];
        });
    }];
    
    UIButton *cancle = [[UIButton alloc] init];
    cancle.layer.borderColor = [UIColor colorWithHexString:@"#EDEDED"].CGColor;
    cancle.layer.borderWidth = 1;
    [cancle setTitle:[GlobalControlManger enStr:@"Cancel" geStr:@"Cancel"] forState:UIControlStateNormal];
    cancle.titleLabel.font = kFont(16);
    [cancle setTitleColor:[UIColor colorWithHexString:@"#121212"] forState:UIControlStateNormal];
    [menuBg addSubview:cancle];
    [cancle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(menuBg);
        make.width.equalTo(@244);
        make.top.equalTo(submit.mas_bottom).offset(13);
        make.height.equalTo(@48);
    }];
    [[cancle rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.bottom.equalTo(self.view);
                make.top.equalTo(self.view).offset(kNavHeight);
            }];
      
        });
    }];
}



@end
