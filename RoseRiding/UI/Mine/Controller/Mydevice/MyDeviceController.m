//
//  MyDeviceController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/2.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "MyDeviceController.h"
#import "MyDeviceCell.h"
#import "LinkDeviceCell.h"
#import "MydeviceSectionHead.h"
#import "LinkDeviceController.h"
#import "EditDeviceInfoController.h"
#import "BikeDeviceModel.h"
#import "EditDeviceInfoController.h"
#import "EditDeviceInfoNewController.h"
#import "BluetoothListCell.h"


#import "BlueBindingViewController.h"
@interface MyDeviceController ()<UITableViewDelegate,UITableViewDataSource,GYBabyBluetoothManagerDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray <BikeDeviceModel *>*list;
@property (nonatomic,strong)NSMutableArray <BikeDeviceModel *>*MySelfBikeList;
@property (nonatomic,strong)NSMutableArray <BikeDeviceModel *>*otherBikeList;
@property (nonatomic,strong)NSArray <GYPeripheralInfo *>*bluetoothList;
@property (nonatomic, strong)UIView      *emptyView;
@property (nonatomic, strong)UITableView *bluetoothTable;
@property (nonatomic, strong)BikeDeviceModel *currentDevice;
@property (nonatomic, strong) GYBabyBluetoothManager * babyMgr;
@property (nonatomic, assign)BOOL isAutoConnect;
@property (nonatomic, assign)BOOL isRealScanInCurrenPage;
@property (nonatomic , strong)GYPeripheralInfo *currentConnectDevice;//当前连接的蓝牙硬件
@end

@implementation MyDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.babyMgr = [GYBabyBluetoothManager sharedManager];
    [self setNavi];
    [self setupUI];
    self.barStyle = NavigationBarStyleWhite;
    self.title = [GlobalControlManger enStr:@"My Bikes" geStr: @"My Bikes"];
    [self.view bringSubviewToFront:self.navView];
    [self initEmptyView];

    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadMyDevice];
    if (self.currentDevice != nil && !self.currentDevice.isConnecting && [self.currentDevice.activation isEqualToString:@"3"] ) {
//        [self deailAutoConnect];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isRealScanInCurrenPage = NO;
}


-(void)setNavi{
    UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navView addSubview:add];
    [add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_top).offset(kStatusBarHeight + 7);
        make.right.equalTo(self.navView.mas_right).offset(0);
        make.height.equalTo(@30);
        make.width.equalTo(@45);
    }];
    add.titleLabel.font = [UIFont systemFontOfSize:12];
    [add setImage:[UIImage imageNamed:@"add_bike"] forState:UIControlStateNormal];
    [[add rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        EditDeviceInfoNewController *VC = [[EditDeviceInfoNewController alloc] init];
        VC.type = DeviceInfoAdd;
        [self.navigationController pushViewController:VC animated:YES];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(deviceConnectDismiss:)
                                                    name:BabyNotificationAtDidDisconnectPeripheral object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveBluetoothConnectFailMessage:) name:GYBabyBluetoothManagerConnectFailed object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveBluetoothConnectSuccessMessage:) name:GYBabyBluetoothManagerConnectSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveBluetoothMessageAction:) name:GYBabyBluetoothManagerRead object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothDeviceListUpdate:) name:GYBabyBluetoothManagerDevicesListUpdate object:nil];
}

- (void)deviceConnectDismiss:(NSNotification *)notify{
    if (!self.isRealScanInCurrenPage) {
        return;
    }
    [MyDevicemanger shareManger].mainDevice.isConnecting = NO;
    //失去连接
    if ([MyDevicemanger shareManger].mainDevice == nil) {
        return;
    }
    if (self.currentDevice.device_imei == nil) {
        return;
    }
    kWeakSelf
    [[NetworkingManger shareManger] postDataWithUrl:host(@"users/disconnectBle") para:@{@"id":self.currentDevice.Id,@"imei":self.currentDevice.device_imei } success:^(NSDictionary * _Nonnull result) {
        NSInteger stateCode = [result[@"code"] integerValue];
        if (stateCode == 1) {
            [weakSelf loadMyDevice];
        }else{

        }
    } fail:^(NSError * _Nonnull error) {

    }];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"MyDeviceCell" bundle:nil] forCellReuseIdentifier:@"MyDeviceCell"];
     [self.tableView registerNib:[UINib nibWithNibName:@"LinkDeviceCell" bundle:nil] forCellReuseIdentifier:@"LinkDeviceCell"];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    self.tableView.hidden = YES;
    
}

- ( NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.otherBikeList.count == 0 ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.MySelfBikeList.count;
    }else{
        return self.otherBikeList.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Adaptive(49);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyDeviceCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        if(self.MySelfBikeList.count != 0){
            cell.model= self.MySelfBikeList[indexPath.row];
        }
    }else{
        if (self.otherBikeList.count != 0) {
            cell.model= self.otherBikeList[indexPath.row];
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Adaptive(44);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MydeviceSectionHead *head = [[MydeviceSectionHead alloc] initWithFrame:CGRectMake(0, 0, UIWidth, Adaptive(44))];
    if (section == 0) {
       [head configureWithTitle:[GlobalControlManger enStr:@"current bike" geStr:@"current bike"] iconName:@"Current device"];
    }else{
       [head configureWithTitle:[GlobalControlManger enStr:@"others bike" geStr:@"others bike"] iconName:@"Current device"];
    }
    return head;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%@",self.currentDevice.equipment);
    if (indexPath.section == 0) {
        BikeDeviceModel * model= self.MySelfBikeList[indexPath.row];
        self.currentDevice = model;
        if ([model.activation isEqualToString:@"1"]) { //未激活
            [[GYBabyBluetoothManager sharedManager]stopScanPeripheral];
            BlueBindingViewController * VC = [[BlueBindingViewController alloc] init];
            VC.activeBike = model;
            if (self.currentDevice.photo != nil) {
                VC.bluename = self.currentDevice.photo;
            }
            [self.navigationController pushViewController:VC animated:YES];
        }else if([model.activation isEqualToString:@"2"]){//等待激活中
            //(提示用户)
            [Toast showToastMessage:[GlobalControlManger enStr:DEVICEISACTIVATING geStr:DEVICEISACTIVATING] inview:self.view interval:1];
        }else if([model.activation isEqualToString:@"3"]){
            //扫描蓝牙匹配连接
            if (model.isConnecting) {
                return; //当前设备连接
            }else{
                [self startBlue];
                self.isAutoConnect = NO;
//                [Toast showToastMessage:[GlobalControlManger enStr:BLUETOOTHHASBEENDISCONNECTED geStr:BLUETOOTHHASBEENDISCONNECTED]];
            }
        }
    }else{
        //别人授权给我设备(已激活，是否需要考虑授权时间内是否可用-授权过期?)
        BikeDeviceModel * model= self.otherBikeList[indexPath.row];
        self.currentDevice = model;
        self.isAutoConnect = NO;
        [self startBlue];
    }
}
- (void)loadMyDevice{
    self.MySelfBikeList = [NSMutableArray array];
    self.otherBikeList = [NSMutableArray array];
    NSString *url = host(@"bicycle/equimentList");
    NSDictionary *para = @{@"token":[UserInfo shareUserInfo].token};
       [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
           NSInteger stateCode = [result[@"code"] integerValue];
           NSString *msg = result[@"msg"];
           if (stateCode == 1) {
               self.list = [BikeDeviceModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"list"]];
               [MyDevicemanger shareManger].Devices = self.list;
               if (self.list.count == 0) {
                   self.emptyView.hidden = NO;
                   self.tableView.hidden = YES;
               }else{
                   self.emptyView.hidden = YES;
                   self.tableView.hidden = NO;
                   for (BikeDeviceModel *m in self.list) {
                       if (m.is_auth) {
                           [self.otherBikeList addObject:m];
                       }else{
                           [self.MySelfBikeList addObject:m];
                       }
                       if ([MyDevicemanger shareManger].mainDevice == nil) {
                           if ([m.is_default isEqualToString:@"2"]) {
                               self.currentDevice = m;
//                               [self deailAutoConnect];
                           }
                       }
                   }
               }
               [self.tableView reloadData];
           }else{
               if (![msg isEqualToString:@""]) {
                   [Toast showToastMessage:msg];
               }
           }
       } fail:^(NSError * _Nonnull error) {
           [MBProgressHUD hideHUDForView:self.view animated:YES];
       }];
}
- (void)showAlert{
    UIView *bg = [[UIView alloc] initWithFrame:UIKeyWindow.bounds];
    bg.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [bg addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bg);
        make.width.equalTo(@312);
        make.height.equalTo(@218);
    }];
    contentView.layer.cornerRadius = 8;
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close setBackgroundImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
    [contentView addSubview:close];
    [close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(contentView).offset(-28);
        make.top.equalTo(contentView).offset(20);
        make.height.equalTo(@19);
        make.width.equalTo(@19);
    }];
    [[close rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [bg removeFromSuperview];
    }];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithHexString:@"#121212"];
    label.text = @"No bike found. Please add a new bike";
    label.font = kFont(20);
    [contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(contentView).offset(15);
        make.trailing.equalTo(contentView).offset(-15);
        make.top.equalTo(contentView).offset(60);
    }];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:add];
    [add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(label.mas_bottom).offset(20);
        make.height.equalTo(@48);
        make.width.equalTo(@244);
    }];
    [add setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [add setTitle:@"Add new bike" forState:UIControlStateNormal];
    add.backgroundColor = [UIColor colorWithHexString:@"#15BA39"];
    add.layer.cornerRadius = 4;
    kWeakSelf
    [[add rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [bg removeFromSuperview];
        EditDeviceInfoNewController *VC = [[EditDeviceInfoNewController alloc] init];
        VC.type = DeviceInfoAdd;
        VC.success = ^{
            [weakSelf loadMyDevice];
        };
        [self.navigationController pushViewController:VC animated:YES];
    }];
    [UIKeyWindow addSubview:bg];
}
- (void)initEmptyView{
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@312);
        make.height.equalTo(@218);
    }];
    contentView.layer.cornerRadius = 8;
    [self.view sendSubviewToBack:contentView];
    self.emptyView = contentView;
    self.emptyView.hidden = YES;
    UILabel *label = [[UILabel alloc] init];
       label.textColor = [UIColor colorWithHexString:@"#121212"];
       label.text = @"No bike found. Please add a new bike";
       label.font = kFont(20);
       [contentView addSubview:label];
       [label mas_makeConstraints:^(MASConstraintMaker *make) {
           make.leading.equalTo(contentView).offset(15);
           make.trailing.equalTo(contentView).offset(-15);
           make.top.equalTo(contentView).offset(60);
       }];
       label.textAlignment = NSTextAlignmentCenter;
       label.numberOfLines = 0;
       UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
       [contentView addSubview:add];
       [add mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerX.equalTo(contentView);
           make.top.equalTo(label.mas_bottom).offset(20);
           make.height.equalTo(@48);
           make.width.equalTo(@244);
       }];
       [add setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       [add setTitle:@"Add new bike" forState:UIControlStateNormal];
       add.backgroundColor = [UIColor colorWithHexString:@"#15BA39"];
       add.layer.cornerRadius = 4;
    [[add rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        EditDeviceInfoNewController *VC = [[EditDeviceInfoNewController alloc] init];
        VC.type = DeviceInfoAdd;
        [self.navigationController pushViewController:VC animated:YES];
    }];
}

- (void)deailAutoConnect{
    //扫描设备
    self.isAutoConnect = YES;
    self.isRealScanInCurrenPage = YES;
    //系统蓝牙是否已经打开
    if (self.babyMgr.systemBluetoothIsOpen) {
        [self.babyMgr.babyBluetooth cancelAllPeripheralsConnection];
        [self.babyMgr stopScanPeripheral];
        [self.babyMgr startScanPeripheral];
    }else{
       //系统蓝牙未开启
//        [Toast showToastMessage:[GlobalControlManger enStr:PLEASE_CONNECT_SYSTEM_BLUETOOTH geStr:PLEASE_CONNECT_SYSTEM_BLUETOOTH] inview:self.view interval:2];
    }
}

- (void)initBluetoothListTable{
    UIView *coverView = [[UIView alloc] initWithFrame:UIKeyWindow.bounds];
    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.bluetoothTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.bluetoothTable];
    [self.bluetoothTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@280);
        make.height.equalTo(@360);
    }];
    self.bluetoothTable.layer.cornerRadius = 8;
    [self.tableView registerNib:[UINib nibWithNibName:@"BluetoothListCell" bundle:nil] forCellReuseIdentifier:@"BluetoothListCell"];
    self.bluetoothTable.delegate = self;
    self.bluetoothTable.dataSource = self;
}

- (void)showBluetoothTable{
    [UIKeyWindow addSubview:self.bluetoothTable];
}

- (void)dissMissBluetoothTable{
    [self.bluetoothTable removeFromSuperview];
}

- (void)didReciveBluetoothMessageAction:(NSNotification *)notify{

  if (!self.isRealScanInCurrenPage) {
      return;
  }
}

- (void)didReciveBluetoothConnectSuccessMessage:(NSNotification *)notify{
    if (!self.isRealScanInCurrenPage) {
        return;
    }
    self.currentDevice.isConnecting = YES;
    if (!self.isAutoConnect) {
        [MyDevicemanger shareManger].mainDevice = self.currentDevice;
        [Toast showToastMessage:[GlobalControlManger enStr:@"Connnected Successful" geStr:@"erfolgreich verbunden"]];
        //上报给后台更新主设备
    }else{
         [Toast showToastMessage:[GlobalControlManger enStr:AUTO_CONNECT_SUCCESS geStr:AUTO_CONNECT_SUCCESS] inview:self.view interval:1];
    }
    
    [MyDevicemanger shareManger].mainDevice = self.currentDevice;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addBikeSuccess" object:nil];
    [self.tableView reloadData];
    [self requestCheckBluetooth];
    [self getimei];
}
- (void)getimei{
    [[NetworkingManger shareManger] postDataWithUrl:host(@"user/mesg") para:@{@"userid":[UserInfo shareUserInfo].Id,@"token":[UserInfo shareUserInfo].token} success:^(NSDictionary * _Nonnull result) {
        if ([result[@"code"] integerValue] == 1) {
            [[NSUserDefaults standardUserDefaults]setObject:result [@"data"][@"imei"] forKey:@"device_imei"];
            
        }
        } fail:^(NSError * _Nonnull error) {

        }];

}
- (void)didReciveBluetoothConnectFailMessage:(NSNotification *)notify{
    if (!self.isRealScanInCurrenPage) {
        return;
    }
    if (!self.isAutoConnect) {
        [Toast showToastMessage:[GlobalControlManger enStr:@"Connnected Fail" geStr:@"Connnected Fail"]];
    }
}


//已激活进行连接或自动链接
//开启蓝牙扫描
-(void)startBlue
{
    self.isAutoConnect = NO;
    
     [Toast showToastMessage:@"Start connecting to bluetooth" inview:self.view interval:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       });
    self.isRealScanInCurrenPage = YES;
    [self.babyMgr.babyBluetooth cancelAllPeripheralsConnection];
    [self.babyMgr stopScanPeripheral];
    [self.babyMgr startScanPeripheral];
//    [Toast showToastMessage:@"Blueteeth Connecting..."];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    
}

- (void)DisconnectBluetooth{
    
}
- (void)bluetoothDeviceListUpdate:(NSNotification *)notify{
    if (!self.isRealScanInCurrenPage) {
        return;
    }
    NSArray <GYPeripheralInfo *>*peripheralInfoArr = notify.object;
    for (GYPeripheralInfo *info in peripheralInfoArr) {
//        NSLog(@"name = ---------------->%@",info.peripheral.name);
        if (info.peripheral.state == CBPeripheralStateConnected) {
           [[GYBabyBluetoothManager sharedManager].babyBluetooth AutoReconnectCancel:info.peripheral];
        }
       
    }
//    self.bluetoothList = peripheralInfoArr;
//    if (self.isAutoConnect) {
//        for (GYPeripheralInfo *info in peripheralInfoArr) {
//            if ([[self macstring:info.advertisementData] isEqualToString:self.currentDevice.mac_id]) {
//                //连接蓝牙
//                 self.currentConnectDevice = info;
//                [self.babyMgr connectPeripheral:info.peripheral];
//                 [Toast showToastMessage:[GlobalControlManger enStr:AUTO_CONNECTING geStr:AUTO_CONNECTING] inview:self.view interval:1];
//            }
//            
//        }
//    }
}

//更新蓝牙状态
-(void)requestCheckBluetooth
{
    kWeakSelf
    NSString *url = host(@"users/checkBluetooth");
    [[NetworkingManger shareManger] postDataWithUrl:url para:@{@"token":[UserInfo shareUserInfo].token,@"id":self.currentDevice.Id,@"mac_id":self.currentDevice.mac_id} success:^(NSDictionary * _Nonnull result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        NSInteger stateCode = [result[@"code"] integerValue];
        NSString *msg = result[@"msg"];
       
        if (stateCode == 1) {
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            if (![msg isEqualToString:@""]) {
                [Toast showToastMessage:msg];
            }
        }
    } fail:^(NSError * _Nonnull error) {
    }];
}

//读取设备的物理地址
-(NSString *)macstring:(NSDictionary *)advertisementData
{
    NSData*data = advertisementData[@"kCBAdvDataManufacturerData"];
    return [self convertDataToHexStr:data];
}

//转化为string
- (NSString *)convertDataToHexStr:(NSData *)data
{
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    NSString * strippedBbox= [NSString new];
    if([[NSString stringWithFormat:@"%@",[string class]] isEqualToString:@"__NSCFString"]){
        NSData* xmlData = [string dataUsingEncoding:NSUTF8StringEncoding];
        strippedBbox = [[NSString alloc] initWithData:xmlData  encoding:NSUTF8StringEncoding]; ;
        
    }
    
    return string;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}





@end
