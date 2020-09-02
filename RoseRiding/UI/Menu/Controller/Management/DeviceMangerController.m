//
//  DeviceMangerController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/8.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "DeviceMangerController.h"
#import "DeviceMangerCell.h"
#import "DeviceMangerHead.h"
#import "DeviceMangerSectionHead.h"
#import "FirmwareController.h"
#import "SetupEquipmentController.h"
#import "AuthDeviceController.h"
#import "WorkingModeController.h"
#import "AddNewDeviceAlertView.h"
#import "UserDeviceInfo.h"
#import "UserModel.h"
#import "UserInfoCell.h"
#import "AddNewDeviceAlertView.h"
#import "BikeDeviceModel.h"


@interface DeviceMangerController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)DeviceMangerHead *head;
@property (nonatomic, strong)DeviceMangerSectionHead *sectionHead;
@property (nonatomic, strong)AddNewDeviceAlertView *alertView;
@property (nonatomic, strong)UITableView      *userTable;
@property (nonatomic, strong)UIView           *maskView;
@property (nonatomic, strong)NSMutableArray   <UserModel *>*userList;
@property (nonatomic, strong)UserModel    *transformUser;
@property (nonatomic, strong)BikeDeviceModel    *transformDevice;
@property (nonatomic, assign)NSInteger start_page;

@end

@implementation DeviceMangerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.barStyle = NavigationBarStyleWhite;
     self.title = @"Device Manager";
    [self setupUI];
    self.start_page = 0;
    [self getUserList:nil];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"DeviceMangerCell" bundle:nil] forCellReuseIdentifier:@"DeviceMangerCell"];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view bringSubviewToFront:self.navView];
    self.head = [[NSBundle mainBundle] loadNibNamed:@"DeviceMangerHead" owner:self options:nil].firstObject;
    self.head.frame = CGRectMake(0, 0, UIWidth, Adaptive(87));
    self.tableView.tableHeaderView = self.head;
    __weak typeof (self)weakSelf = self;
    self.head.click = ^(NSInteger index) {
        if (index == 0) {
            SetupEquipmentController *VC = [[SetupEquipmentController alloc] initWithDevide:[MyDevicemanger shareManger].mainDevice];
             [weakSelf.navigationController pushViewController:VC animated:YES];
        }else if (index == 1){
            FirmwareController *VC = [FirmwareController new];
            [weakSelf.navigationController pushViewController:VC animated:YES];
        }else{
            AuthDeviceController *VC = [AuthDeviceController new];
            [weakSelf.navigationController pushViewController:VC animated:YES];
        }
    };
    
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIWidth, UIHeight)];
    self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.maskView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.maskView);
        make.width.equalTo(@312);
        make.height.equalTo(@316);
    }];
    contentView.layer.cornerRadius = 17;
    
    UILabel *title = [[UILabel alloc] init];
    title.font = kFont(16);
    title.text = @"Transferred Device Name";
    title.textColor = [UIColor colorWithHexString:@"#999999"];
    [contentView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(25);
        make.leading.equalTo(contentView).offset(28);
    }];
    
    UIView *search = [[UIView alloc] init];
    search.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    [contentView addSubview:search];
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(title.mas_bottom).offset(Adaptive(21));
        make.width.equalTo(@264);
        make.height.equalTo(@30);
    }];
    search.layer.cornerRadius = 15;
    
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    [search addSubview:searchIcon];
    [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(search);
        make.leading.equalTo(search).offset(15);
        make.height.width.equalTo(@20);
    }];
    
    UITextField *input = [[UITextField alloc] init];
    [search addSubview:input];
    [input mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchIcon.mas_right).offset(4);
        make.trailing.equalTo(search).offset(-5);
        make.top.bottom.equalTo(search);
    }];
    input.returnKeyType = UIReturnKeySearch;
    input.font = kFont(12);
    input.placeholder = @"please input user id to search";
    input.delegate = self;
    
    self.userTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [contentView addSubview:self.userTable];
    [self.userTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(contentView);
        make.trailing.equalTo(contentView);
        make.top.equalTo(search.mas_bottom).offset(20);
        make.bottom.equalTo(contentView).offset(-40);
    }];
    [self.userTable registerNib:[UINib nibWithNibName:@"UserInfoCell" bundle:nil] forCellReuseIdentifier:@"UserInfoCell"];
    self.userTable.delegate = self;
    self.userTable.dataSource = self;
    self.userTable.tableFooterView = [UIView new];
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length > 0) {
         [textField resignFirstResponder];
        self.start_page = 0;
        [self getUserList:textField.text];
        return YES;
    }else{
        [textField resignFirstResponder];
        [Toast showToastMessage:@"please input user id" inview:self.view interval:1];
       return NO;
    }
    
}

- (void)tapAction:(UITapGestureRecognizer *)gesture{
    [self.maskView removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.userTable) {
        return self.userList.count;
    }
    return [MyDevicemanger shareManger].Devices.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.userTable) {
        return Adaptive(64);
    }
    return Adaptive(87);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof (self)weakSelf = self;
    if (tableView == self.userTable) {
        UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.userList[indexPath.row];
        cell.add = ^{
            [weakSelf.maskView removeFromSuperview];
            weakSelf.transformUser = self.userList[indexPath.row];
            weakSelf.transformDevice = [MyDevicemanger shareManger].mainDevice;
            [weakSelf getVerificationCode];
        };
        return cell;
    }
    DeviceMangerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceMangerCell" forIndexPath:indexPath];
    cell.model = [MyDevicemanger shareManger].Devices[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.del = ^{
         weakSelf.transformDevice = [MyDevicemanger shareManger].Devices[indexPath.row];
        if ( [MyDevicemanger shareManger].Devices.count > 0) {
            [[MyDevicemanger shareManger].Devices removeObjectAtIndex:indexPath.row];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        [weakSelf bindingDevice:(NSUInteger)indexPath.row];
    };
    cell.edit = ^{
        [weakSelf beginTransferToOhter];
    };
    return cell;
}

- (void)beginTransferToOhter{
    
    [UIKeyWindow addSubview:self.maskView];
}

- (void)getUserList:(NSString * _Nullable)searcKey{
    
    NSString *url = host(@"users/userList");
    NSDictionary *temp = @{@"pages":@"10",@"start_page":@(self.start_page++)};
    NSMutableDictionary *para = [temp mutableCopy];
    if (searcKey != nil) {
        [para setValue:searcKey forKey:@"userid"];
    }
    [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
        NSInteger stateCode = [result[@"code"] integerValue];
        if (stateCode == 1) {
            //成功
            NSMutableArray *array = [UserModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"list"]];
            if (self.start_page == 1) {
                self.userList = array;
            }else{
                [self.userList addObjectsFromArray:array];
            }
            [self.userTable reloadData];
        }
    } fail:^(NSError * _Nonnull error) {
    }];
}

#pragma mark 获取验证码
- (void)getVerificationCode{
    //TODO 获取验证码地址(三木运算)
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = host(@"email/email");
    NSDictionary *para = @{@"id":@"5",@"email":[UserInfo shareUserInfo].email};
    [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger stateCode = [result[@"code"] integerValue];
        NSString *msg = result[@"msg"];
        if (![msg isEqualToString:@""]) {
            [Toast showToastMessage:msg];
        }
        if (stateCode == 1) {
            //成功
                self.alertView = [[AddNewDeviceAlertView alloc] initWithFrame:CGRectMake(0, 0, UIWidth, UIHeight)];
                self.alertView.inputTF.text = @"";
                self.alertView.titleLabel.text = @"Enter Verification Code";
                kWeakSelf
                [self.alertView setReturnTextBlock:^(NSString * _Nonnull text) {
                    [weakSelf submitTransformWithCode:text];
                    [weakSelf.alertView hideAlertView];
                }];
                [UIKeyWindow addSubview:self.alertView];
        }
    } fail:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)submitTransformWithCode:(NSString *)code{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       NSString *url = host(@"users/transferDevice");
    NSDictionary *para = @{@"id":self.transformDevice.Id,@"transfer_uid":self.transformUser.Id,@"code":code};
       [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
           NSInteger stateCode = [result[@"code"] integerValue];
           NSString *msg = result[@"msg"];
           if (![msg isEqualToString:@""]) {
               [Toast showToastMessage:msg];
           }
           if (stateCode == 1) {
               //成功
           }else{
               
           }
       } fail:^(NSError * _Nonnull error) {
           [MBProgressHUD hideHUDForView:self.view animated:YES];
       }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.userTable) {
        return CGFLOAT_MIN;;
    }
    return Adaptive(40);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    self.sectionHead = [[DeviceMangerSectionHead alloc] initWithFrame:CGRectMake(0, 0, UIWidth, Adaptive(40))];
    self.sectionHead.addBth.hidden = YES;
    [self.sectionHead.addBth addTarget:self action:@selector(addNewDeviceClick:) forControlEvents:UIControlEventTouchUpInside];
    return self.sectionHead;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - 首次添加蓝牙设备
///**添加新设备*/
- (void)addNewDeviceClick:(UIButton *)sender {
//    //[[BluetoothManger sharedInstance] startScan];
//
//    self.alertView = [[AddNewDeviceAlertView alloc] initWithFrame:CGRectMake(0, 0, UIWidth, UIHeight)];
//    self.alertView.inputTF.text = @"LP_B910_0009";
//    self.alertView.titleLabel.text = @"Please enter Bluetooth name";
//    kWeakSelf
//    [self.alertView setReturnTextBlock:^(NSString * _Nonnull text) {
//        [weakSelf startScanBluetoothWithName:text];
//        [weakSelf.alertView hideAlertView];
//    }];
//    [UIKeyWindow addSubview:self.alertView];
//
//}
//
//- (void)startScanBluetoothWithName:(NSString *)name {
//    /** 连接过程可能需要输入蓝牙默认配对密码*/
//    kWeakSelf
//    [[BluetoothManger sharedInstance] addFirstDeviceWithBleName:name completeBlock:^(BOOL isSuccess) {
//        if (isSuccess) {
//            // 连接蓝牙成功
//            //获取ICCID
//            [weakSelf getICCIDForBluetooth];
//        }
//    }];
}

//再获取蓝牙设备ICCID
//- (void)getICCIDForBluetooth {
//    kWeakSelf
//    [[BluetoothSendDataManger sharedInstance] sendDataToBleForICCID:^(NSString * _Nonnull data, NSError * _Nonnull error) {
//        if (error == nil) {
//            //获取ICCID成功
//            dispatch_async(dispatch_get_main_queue(), ^{
//                weakSelf.alertView = [[AddNewDeviceAlertView alloc] initWithFrame:CGRectMake(0, 0, UIWidth, UIHeight)];
//                weakSelf.alertView.titleLabel.text = @"Please enter Activation code";
//                weakSelf.alertView.inputTF.returnKeyType = UIReturnKeySend;
//                [weakSelf.alertView setReturnTextBlock:^(NSString * _Nonnull text) {
//                    [weakSelf sendActivationCodeToServerIccid:data code:text];
//                    [weakSelf.alertView hideAlertView];
//                }];
//                [UIKeyWindow addSubview:weakSelf.alertView];
//            });
//        }else {
//            [weakSelf showTextHUD:@"获取蓝牙ICCID失败"];
//        }
//    }];
//}
//
//// 发送激活码 到服务器进行绑定
//- (void)sendActivationCodeToServerIccid:(NSString *)iccid code:(NSString *)code {
//
//    //请求接口
//    NSDictionary *parm = @{@"code":code,@"iccid":iccid};
//    /**
//     ......*/
//
//    //接口返回成功，去进行蓝牙鉴权
//    [self getIMEIForBluetoothICCID:iccid];
//
//
//}
//
////获取蓝牙设备IMEI
//- (void)getIMEIForBluetoothICCID:(NSString *)iccid {
//    //获取IMEI
//    kWeakSelf
//    [self showLoadingHUD];
//    [[BluetoothSendDataManger sharedInstance] sendDataToBleForIMEI:^(NSString * _Nonnull data, NSError * _Nonnull error) {
//        if (error == nil) {
//            //获取IMEI成功后上传
//            [weakSelf sendDataToServerForRequest:data iccid:iccid];
//        }else {
//            [weakSelf showTextHUD:@"获取蓝牙IMEI失败"];
//        }
//    }];
//}
//
//
//
////调接口上传IMEI ICCID
//-(void)sendDataToServerForRequest:(NSString *)imei iccid:(NSString *)iccid {
//    DeviceInfoModel *model = [[UserDeviceInfo shareUserInfo] getTemporaryDeviceData];
//    NSDictionary *parm = @{@"imei":imei,@"iccid":iccid,@"macAdress":model.macAddress};
//    //请求接口
//    /**..............
//     */
//    //接口返回成功后 进行蓝牙鉴权
//    [self bluetoothAuthenticationWithIMEI:imei];
//}
//
////计算哈希  进行蓝牙鉴权
//- (void)bluetoothAuthenticationWithIMEI:(NSString *)imei {
//    //NSString *imeissss = @"860788040359761";
//    NSString *fanzhuan = [GlobalControlManger reversalString:imei];
//    //NSString *tihuan = [GlobalControlManger replaceString:fanzhuan];
//    NSLog(@"处理后—_______%@",fanzhuan);
//    // 383630373838303430333539373631 IMEI
//    // 处理后 31 36 38 39 35 33 30 34 30 38 38 37 30 36 37
//    //转换后   8  6  0  7  8  8  0  4  0  3  5  9  7  6  1
//    //处理后的数据 转换成860788040359761 再算哈希 则鉴权成功
//    NSString *hash = [GlobalControlManger sha1:fanzhuan];
//    NSLog(@"哈希_________%@",hash);
//    uint8_t but[160];
//    memcpy(but, [hash UTF8String], hash.length + 1);
//    NSLog(@"%s",but);
//    kWeakSelf
//    [[BluetoothSendDataManger sharedInstance] sendDataToBleForAuthorityWithIMEIhash:hash completeBlock:^(NSString * _Nonnull data, NSError * _Nonnull error) {
//        if (error == nil) {
//          //蓝牙鉴权成功。。。。。。成功绑定设备
//            if ([data isEqualToString:@"00"]) {
//                NSLog(@"蓝牙鉴权成功");
//                [weakSelf showTextHUD:@"蓝牙鉴权成功"];
//            }else {
//                [weakSelf showTextHUD:@"蓝牙鉴权失败"];
//            }
//        }else {
//            [weakSelf showTextHUD:@"蓝牙鉴权失败，请重试"];
//        }
//    }];
//}

- (void)bindingDevice:(NSUInteger)index{
    NSString *url = host(@"bicycle/del_equipment");
       NSDictionary *para = @{@"id":self.transformDevice.Id};
          [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
               [MBProgressHUD hideHUDForView:self.view animated:YES];
              NSInteger stateCode = [result[@"code"] integerValue];
              NSString *msg = result[@"msg"];
              if (![msg isEqualToString:@""]) {
                  [Toast showToastMessage:msg];
              }
              if (stateCode == 1) {
                  //成功
                  [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteDeviceSuccess" object:nil];

                if ([MyDevicemanger shareManger].Devices.count == 0) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                 
                  [[GYBabyBluetoothManager sharedManager].babyBluetooth cancelAllPeripheralsConnection];
                  [[GYBabyBluetoothManager sharedManager] stopScanPeripheral];
                  [self.tableView reloadData];
              }else{
                  
              }
          } fail:^(NSError * _Nonnull error) {
              [MBProgressHUD hideHUDForView:self.view animated:YES];
          }];
       
}


@end
