//
//  AntitheftinterfaceController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/8.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "AntitheftinterfaceController.h"
#import "SetAreaGeoFenceController.h"
#import "SetAreaGyroFenceCell.h"
#import "SetAreaGyroFenceHead.h"
#import "timeTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
@interface AntitheftinterfaceController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    BOOL isSelect;
    BOOL onChoose;
    BOOL onTime;
    BOOL isSelecttime;
    CGFloat tableviewheight;
    CGFloat   offsetheight;
    NSInteger listcount;
    CGFloat rowheight;
    NSInteger timelistcount;
    CLLocationManager *_locationManager;//定位服务管理类
    CLGeocoder * _geocoder;//初始化地理编码器
}
- (IBAction)setVibrationtime:(UIButton *)sender;

@property (nonatomic, strong) IBOutlet UISwitch * alarmSwitch;
@property (nonatomic, strong) IBOutlet UISwitch * autoSwitch;
@property (nonatomic, strong) IBOutlet UISwitch * activateSwitch;
@property (nonatomic, strong) IBOutlet UILabel * electricLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastLocation;
@property (weak, nonatomic) IBOutlet UILabel *delaytime;
@property (nonatomic,strong)NSMutableArray <BikeDeviceModel *>*list;
@property (weak, nonatomic) IBOutlet UIButton *lastLocationBtn;
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fiftyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *Vibrationimageview;
@property (strong, nonatomic) IBOutlet UIView *Vibrationview;
@property (weak, nonatomic) IBOutlet UIView *timeView;

@property (weak, nonatomic) IBOutlet UIButton *showareaButton;
@property (nonatomic, strong) CLLocation *currentLocation;
//当前位置详细信息
- (IBAction)showArea:(UIButton *)sender;
@property (nonatomic, strong) NSDictionary *currentLocationDetailInfo;
@property (weak, nonatomic) IBOutlet UILabel *activategeo_fenceLabel;
@property (weak, nonatomic) IBOutlet UIView *activegeo_fenceView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (copy, nonatomic) IBOutlet NSString * areaString;
@property (copy, nonatomic) IBOutlet NSString * delaytimeString;
@property (copy, nonatomic) IBOutlet NSArray * fenArray;
@property (copy, nonatomic) IBOutlet NSString * fence;
@property (copy, nonatomic) NSString * timestring;
@property (copy, nonatomic) IBOutlet NSString * lng;
@property (copy, nonatomic) IBOutlet NSString * lat;
@property (copy, nonatomic) IBOutlet NSString * Longdevice;
@property (copy, nonatomic) IBOutlet NSString * Latdevice;
@property (nonatomic, strong) NSString *currentlocation;
@property (strong, nonatomic) NSString * deviceimei;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)BOOL showContent;
@property (nonatomic, strong) SetAreaGyroFenceHead *head;
@property (nonatomic, strong)BikeDeviceModel * currentbike;
@property (nonatomic , strong)GYPeripheralInfo *currentConnectDevice;//当前连接的蓝牙硬件
@end
@implementation AntitheftinterfaceController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.lat = @"";
    self.lng = @"";
    self.Longdevice = @"";
    self.Latdevice = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(deviceConnectDismiss)
                                                    name:BabyNotificationAtDidDisconnectPeripheral object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReciveBluetoothConnectSuccessMessage:) name:GYBabyBluetoothManagerConnectSuccess
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceAnti_geoOpenSuccess:) name:GYBabyBluetoothMangerOpenSuccess object:nil];
    
//    [self uploadlocation];
    if ([MyDevicemanger shareManger].mainDevice.isConnecting) {
        self.fence = @"10";
    }else{
        self.fence = @"100";
    }
    self.timestring = @"40 s";
   [[NSNotificationCenter defaultCenter] addObserver:self
   selector:@selector(SetGeoFencesuccess:)
       name:GYBabyBluetoothManagerSetGeoFence object:nil];
   if ([[NSUserDefaults standardUserDefaults]objectForKey:@"anti_theft_text"] != nil ) {
       self.areaLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"anti_theft_text"];
   }else{
       self.areaLabel.text = self.fence;
   }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"SetAreaGyroFenceIndex"] integerValue] < 0) {
        self.defaultSelectIndex = -1;
    }else{
        self.defaultSelectIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SetAreaGyroFenceIndex"] integerValue];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"SetDelayTimeIndex"] integerValue] < 0) {
        self.defaultSelecttimeIndex = -1;
    }else{
        self.defaultSelecttimeIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SetDelayTimeIndex"] integerValue];
    }
    isSelect = NO;
    onChoose = NO;
    isSelecttime = NO;
    listcount = 4;
    timelistcount = 2;
    tableviewheight = 440;
    offsetheight = 44;
    rowheight = 54;
    [self loadareaList];
    [self starLoaction];
    self.autoSwitch.userInteractionEnabled = NO;
    self.activateSwitch.userInteractionEnabled = NO;
    self.alarmSwitch.userInteractionEnabled = NO;
    self.barStyle = NavigationBarStyleWhite;
    self.title = @"Anti-theft";
    // Do any additional setup after loading the view from its nib.
    [self loadMyDevice];
    [self.alarmSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.autoSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.activateSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}
- (void)loadMyDevice{
     
    NSString *url = host(@"bicycle/equimentList");
    if ([UserInfo shareUserInfo].token == nil ) {
        return;
    }
//     NSLog(@"%@",  [UserInfo shareUserInfo].token);
    NSDictionary *para = @{@"token":[UserInfo shareUserInfo].token};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger stateCode = [result[@"code"] integerValue];
        NSString *msg = result[@"msg"];
        if (stateCode == 1) {
          self.list = [BikeDeviceModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"list"]];
                   [MyDevicemanger shareManger].Devices = [self.list mutableCopy];
            if (self.list.count == 0) {
               self.lastLocation.text = @"Unknown";
            }else{
                for (BikeDeviceModel * m in self.list) {
                    if ([MyDevicemanger shareManger].mainDevice == nil) {
                        if ([m.is_default isEqualToString:@"2"]) {
                            [MyDevicemanger shareManger].mainDevice = m;
                        }else{
                            [MyDevicemanger shareManger].mainDevice = self.list.lastObject;
                        }
                    }else{
                        [MyDevicemanger shareManger].mainDevice = self.list.lastObject;
                    }
                }
                if ([[MyDevicemanger shareManger].mainDevice.activation isEqualToString:@"3"]) {
                     [self requestWaring];
                }
            }            
        }else{
            if (![msg isEqualToString:@""]) {
                [Toast showToastMessage:msg];
            }
        }
    } fail:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)didReciveBluetoothConnectSuccessMessage:(NSNotification *)notify{
  [MyDevicemanger shareManger].mainDevice.isConnecting = YES;
    [self loadMyDevice];
}
- (void)deviceConnectDismiss{
    [MyDevicemanger shareManger].mainDevice.isConnecting = NO;
    
    [[GYBabyBluetoothManager sharedManager].babyBluetooth cancelAllPeripheralsConnection];
    [self loadMyDevice];
}
- (void)loadCurentLocation{
    NSString * lattt = @"";
    NSString * longgg = @"";
    if (self.currentConnectDevice.peripheral.state == 2) {
        lattt = self.lat;
        longgg = self.lng;
    }else{
        lattt = self.Latdevice;
        longgg = self.Longdevice;
    }
    NSString *requestUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&key=AIzaSyABQXPBUnlE_DzVKG7ga0ZJhx9QmlygldU",lattt,longgg];
    [[NetworkingManger shareManger] postDataWithUrl:requestUrl para:nil success:^(NSDictionary * _Nonnull result) {
        self.currentLocationDetailInfo = [result[@"results"] firstObject];
        NSLog(@"%@",result);
         NSString *currentLocationName = @"";
         NSArray *locationinfos = [[self.currentLocationDetailInfo[@"address_components"] reverseObjectEnumerator] allObjects];
        for (NSDictionary *dic in locationinfos) {
            if ([dic[@"types"] containsObject:@"postal_code"]){
                continue;
            }
            currentLocationName = [NSString stringWithFormat:@"%@, %@",dic[@"long_name"],currentLocationName];
        }
        currentLocationName = [currentLocationName //替换某段字符
                               stringByReplacingCharactersInRange:NSMakeRange(currentLocationName.length-2, 1) withString:@""];
        NSLog(@"currentLocationName---------%@",currentLocationName);
        if (currentLocationName != nil) {
            self.lastLocation.text = currentLocationName;

        }else{
            self.lastLocation.text = @"Unkonw";

        }
    } fail:^(NSError * _Nonnull error) {
        self.lastLocation.text = @"Unknow";
    }];
}
- (void)SetGeoFencesuccess:(NSNotification *)notify{
    [Toast showToastMessage:@"The Geofence has been set up successfully"];
}
- (void)deviceAnti_geoOpenSuccess:(NSNotification *)notify{
    if (self.activateSwitch.isOn) {
        [Toast showToastMessage:@"Geofence is open"];
    }else{
        [Toast showToastMessage:@"Geofence is closed "];
    }
}
- (void)starLoaction{
    
    if (![CLLocationManager locationServicesEnabled]) {
        self.lat = self.lng = @"";
          NSLog(@"您的设备暂未开启定位服务");
        return;
       }
       // 2、初始化定位服务

       _locationManager = [[CLLocationManager alloc] init];

       // 3、请求定位授权*

       // 请求在使用期间授权（弹框提示用户是否允许在使用期间定位）,需添加NSLocationWhenInUseUsageDescription到info.plist

       [_locationManager requestWhenInUseAuthorization];

       // 请求在后台定位授权（弹框提示用户是否允许不在使用App时仍然定位）,需添加NSLocationAlwaysUsageDescription添加key到info.plist

       [_locationManager requestAlwaysAuthorization];

       // 4、设置定位精度

       _locationManager.desiredAccuracy = kCLLocationAccuracyBest;

       // 5、设置定位频率，每隔多少米定位一次

       _locationManager.distanceFilter = 10.0;

       // 6、设置代理

       _locationManager.delegate = self;

       // 7、开始定位

       // 注意：开始定位比较耗电，不需要定位的时候最好调用 [stopUpdatingLocation] 结束定位。

       [_locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray *)locations {

    // 获取最新定位
    CLLocation*location = locations.lastObject;
    self.currentLocation = location;
//    [self.ridingLocations addObject:location];
    // 打印位置信息
    
    self.lat = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude];
    self.lng = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude];
    NSLog(@"lat-->%@lng-->%@",self.lat,self.lng);
    // 停止定位
    
    [_locationManager stopUpdatingLocation];
    
    //如果是国内，就会转化坐标系，如果是国外坐标，则不会转换。
    
//    _coordinate2D = [JZLocationConverter wgs84ToGcj02:location.coordinate];
//
//    //移动地图中心到当前位置
//    GMSMarker *marker = [GMSMarker markerWithPosition:_coordinate2D];
//    marker.title = @"";
//    marker.map = self.mapView;
//    marker.icon = [UIImage imageNamed:@"home_bicycle"];
//    _mapView.camera = [GMSCameraPosition cameraWithTarget:_coordinate2D
//
//                                                     zoom:14];
}
- (void)loadareaList{
  self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kNavHeight, UIWidth, UIHeight-kNavHeight)style:UITableViewStylePlain];
    self.Vibrationview.frame = CGRectMake(0, 0, UIWidth, offsetheight);
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.topView;
    self.tableView.tableHeaderView.height = self.topView.height;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"SetAreaGyroFenceCell" bundle:nil] forCellReuseIdentifier:@"SetAreaGyroFenceCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"timeTableViewCell" bundle:nil] forCellReuseIdentifier:@"timeTableViewCell"];
    self.tableView.separatorColor = [UIColor clearColor];
//    self.tableView
    [self.view bringSubviewToFront:self.navView];
    
//    [self.tableView addSubview:self.topView];
    [self.view addSubview:self.tableView];
//    [self.tableView addSubview:self.Vibrationview];
    kWeakSelf
    self.head.show = ^{
        weakSelf.showContent = !weakSelf.showContent;
        [weakSelf.tableView reloadData];
    };
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return listcount;
    }else{
        return timelistcount;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return timelistcount;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return self.topView;
//    }else{
//        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIWidth, offsetheight)];
////        [view addSubview:self.Vibrationview];
//        return view;
//    }
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (isSelect == NO) {
            return 0;
        }else{
            return rowheight;
        }
    }else{
        if (isSelecttime == NO) {
            return 0;
        }else{
            return rowheight;
        }
    }
   
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return 0;
//    }else{
//        return offsetheight;
//    }
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    SetAreaGyroFenceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetAreaGyroFenceCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
           if (![MyDevicemanger shareManger].mainDevice.isConnecting) {
               if(indexPath.row == 0){
                       cell.userInteractionEnabled = NO;
               }else{
                       cell.userInteractionEnabled = YES;
               }
           }
           [cell configureWithIndexpath:indexPath showSelect:indexPath.row == self.defaultSelectIndex];
           return cell;
    }else{
        timeTableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:@"timeTableViewCell"];
       if ([MyDevicemanger shareManger].mainDevice.isConnecting) {
           cell1.userInteractionEnabled = NO;
       }
       [cell1 configureWithIndexpath:indexPath showSelect:indexPath.row == self.defaultSelecttimeIndex];
       return cell1;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (indexPath.section == 0) {
            self->onChoose = YES;
             self.defaultSelectIndex = indexPath.row;
                   [[NSUserDefaults standardUserDefaults] setObject:@(indexPath.row) forKey:@"SetAreaGyroFenceIndex"];
                   switch (indexPath.row) {
                              case 0:
                                  self.areaString = @"10";
                                  break;
                              case 1:
                                  self.areaString = @"100";
                                  break;
                              case 2:
                                  self.areaString = @"200";
                                  break;
                              case 3:
                                  self.areaString = @"300";
                                  break;
                              default:
                                  break;
                          }
                   [[NSUserDefaults standardUserDefaults] setObject:self.areaString forKey:@"anti_theft_text"];
                   if ([MyDevicemanger shareManger].mainDevice.isConnecting) {
                       [[GYBabyBluetoothManager sharedManager] writeState:SET_ELECTRONIC_FENCE_Bluetooth widthFence:self.areaString andLng:self.lng andLat:self.lat andImei:self.deviceimei];
                   }else{
                       [self uploadlocation];
                   }
                   [self requestSetWaring];
        }else if (indexPath.section == 1){
            self->onTime = YES;
            self.defaultSelecttimeIndex = indexPath.row;
            [[NSUserDefaults standardUserDefaults] setObject:@(indexPath.row) forKey:@"SetDelayTimeIndex"];
                              switch (indexPath.row) {
                                         case 0:
                                             self.delaytimeString = @"10 s";
                                             break;
                                         case 1:
                                             self.delaytimeString = @"40 s";
                                             break;
                                         default:
                                             break;
                                     }
            [[NSUserDefaults standardUserDefaults] setObject:self.delaytimeString forKey:@"delaytimetext"];
        }
        [self.tableView reloadData];
    });
}
//根据维度获取地理名称
- (IBAction)goLastLocation:(id)sender {
    NSLog(@"查看最后的位置");
//    [self uploadlocation];
}
//- (IBAction)goArea:(id)sender {
//
//    SetAreaGeoFenceController *VC = [SetAreaGeoFenceController new];
//    [self.navigationController pushViewController:VC animated:YES];
//}
-(void)switchAction:(UISwitch *)sw
{
    if(sw == self.activateSwitch){
         if (self.activateSwitch.isOn == YES){
                if ([MyDevicemanger shareManger].mainDevice.isConnecting) {
                    [[GYBabyBluetoothManager sharedManager] writeState:OPEN_ELECTRONIC_FENCE_Bluetooth];
                }else{
                    [self requestSetWaring];
                }
                self.showareaButton.enabled = YES;
            }else{
                if ([MyDevicemanger shareManger].mainDevice.isConnecting) {
                    [[GYBabyBluetoothManager sharedManager] writeState:CLOSE_ELECTRONIC_FENCE_Bluetooth];
                }else{
                    [self requestSetWaring];
                }
                self.showareaButton.enabled = NO;
                 [self.arrowImageView setImage:[UIImage imageNamed:@"down_arrow"]];
                            isSelect = NO;
                            if (onChoose) {
                                self.areaLabel.text = self.areaString;
                            }else{
                                if ([[NSUserDefaults standardUserDefaults]objectForKey:@"anti_theft_text"] ) {
                                    self.areaLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"anti_theft_text"];
                                }else{
                                    self.areaLabel.text = self.fence;
                                }
                            }
        //                    self.tableView.frame = CGRectMake(0,self.headView.origin.y+self.headView.height,UIWidth, tableviewheight.size.height );
                //            self.areaLabel.text = @"";
                            self.headView.hidden = NO;
        //                    self.tableView.hidden = YES;
                [self.tableView reloadData];
            }
    }
    if (sw == self.autoSwitch) {
    if (self.autoSwitch.isOn == YES) {
        if ([MyDevicemanger shareManger].mainDevice.isConnecting) {
            [[GYBabyBluetoothManager sharedManager]writeState:OPEN_AUTOLOCK_Bluetooth];
        }
        [self requestSetWaring];
        [MyDevicemanger shareManger].mainDevice.is_autolock = YES;
//        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"autolock"];
//        NSLog(@"自动上锁%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"autolock"]);
    }else{
        if ([MyDevicemanger shareManger].mainDevice.isConnecting) {
            [[GYBabyBluetoothManager sharedManager]writeState:CLOSE_AUTOLOCK_Bluetooth];
        }
         [self requestSetWaring];
//        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"autolock"];
//        NSLog(@"自动上锁%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"autolock"]);
        [MyDevicemanger shareManger].mainDevice.is_autolock = NO;
    }
    }
    if (sw == self.alarmSwitch) {

        [self requestSetWaring];
    
    }
}

#pragma mark -- reuqest
//设备报警信息
-(void)requestWaring
{
    NSString *url = host(@"users/deviceSet");
    NSMutableDictionary *para =[[NSMutableDictionary alloc] init];
    [para setValue:[UserInfo shareUserInfo].token forKey:@"token"];
    [para setValue:[MyDevicemanger shareManger].mainDevice.Id forKey:@"id"];
    [para setValue:self.lat forKey:@"lat"];
    [para setValue:self.lng forKey:@"lng"];
    [para setValue:self.currentlocation forKey:@"location"];
    //@{@"id":[UserInfo shareUserInfo].device_id,@"token":};
           [MBProgressHUD showHUDAddedTo:self.view animated:YES];
           [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
               NSInteger stateCode = [result[@"code"] integerValue];
               NSString *msg = result[@"msg"];
               NSDictionary * data =[[NSDictionary alloc] initWithDictionary:result[@"data"]];
               if (stateCode == 1) {
                   NSInteger is_alarm = [[data objectForKey:@"is_alarm"] intValue];
                    NSInteger is_effect = [[data objectForKey:@"is_effect"] intValue];
                    NSInteger is_fence = [[data objectForKey:@"is_fence"] intValue];
//                   self.areaLabel.text = [data objectForKey:@"electronic_fence"];
                   self.alarmSwitch.on = is_alarm == 1?NO:YES;
                   self.autoSwitch.on = is_effect == 1?NO:YES;
                   [MyDevicemanger shareManger].mainDevice.is_autolock = is_effect == 1?NO:YES;
                   self.activateSwitch.on = self.showareaButton.enabled =is_fence == 1?NO:YES;
                   self.electricLabel.text =[NSString stringWithFormat:@"%d%%",[[data objectForKey:@"electric"] intValue] ];
                   self.deviceimei = [data objectForKey:@"device_imei"];
                   self.Longdevice = [data objectForKey:@"lng"];
                   self.Latdevice = [data objectForKey:@"lat"];
                   [self loadCurentLocation];
                   NSLog(@"long----%@,lat---------%@",[data objectForKey:@"lng"],[data objectForKey:@"lat"]);
                   [self.tableView reloadData];
//                   NSLog(@"lng--╥﹏╥...%@",[data objectForKey:@"lng"]);
//                   NSLog(@"lat(╥╯^╰╥)%@",[data objectForKey:@"lat"]);
//                   [self uploadlocation];
                   self.autoSwitch.userInteractionEnabled = YES;
                   self.activateSwitch.userInteractionEnabled = YES;
                   self.alarmSwitch.userInteractionEnabled = YES;
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
               }else{
                   if (![msg isEqualToString:@""]) {
                       [Toast showToastMessage:msg];
                   }
                   NSLog(@"deviceSet-----------%@",msg);
               }
           } fail:^(NSError * _Nonnull error) {
               [MBProgressHUD hideHUDForView:self.view animated:YES];
           }];
    
}
- (void)uploadlocation{
    NSString * url = host(@"users/setElectric");
    NSString * strid = [MyDevicemanger shareManger].mainDevice.Id;
    NSLog(@"%@",strid);
//    NSLog(@"%@",self.areaString);
    if (self.Longdevice == nil || self.Longdevice == nil ||self.areaString == nil) {
        return;
    }
    NSDictionary *para = @{@"imei":self.deviceimei,@"electronic_fence":self.areaString,@"lng":self.Longdevice,@"lat":self.Latdevice};
       [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
           [MBProgressHUD hideHUDForView:self.view animated:YES];

           NSInteger stateCode = [result[@"code"] integerValue];
           NSString *msg = result[@"msg"];
           if (stateCode == 1) {
               
           }else{
               if (![msg isEqualToString:@""]) {
                   [Toast showToastMessage:msg];
               }
               NSLog(@"setElectric---------%@",msg);
           }
       } fail:^(NSError * _Nonnull error) {
           [MBProgressHUD hideHUDForView:self.view animated:YES];
       }];
}
//设置报警信息
-(void)requestSetWaring
{
    NSString *url = host(@"users/setDevicemsg");
    NSMutableDictionary *para =[[NSMutableDictionary alloc] init];
    [para setValue:[UserInfo shareUserInfo].token forKey:@"token"];
    [para setValue:[MyDevicemanger shareManger].mainDevice.Id forKey:@"id"];
    [para setValue:self.alarmSwitch.isOn?@"2":@"1" forKey:@"is_alarm"];
    [para setValue:self.autoSwitch.isOn?@"2":@"1" forKey:@"is_effect"];
    [para setValue:self.activateSwitch.isOn?@"2":@"1" forKey:@"is_fence"];
    [para setValue:onChoose?self.areaString:self.areaLabel.text forKey:@"electronic_fence"];
       //@{@"id":[UserInfo shareUserInfo].device_id,@"token":};
              [MBProgressHUD showHUDAddedTo:self.view animated:YES];
              [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                  NSInteger stateCode = [result[@"code"] integerValue];
                  NSString *msg = result[@"msg"];
                 if (stateCode == 1) {
//                      self.showareaButton.enabled = YES;
                  }else{
                      if (![msg isEqualToString:@""]){
                          [Toast showToastMessage:msg];
                      }
                      NSLog(@"setDevicemsg-----------%@",msg);
                  }
              } fail:^(NSError * _Nonnull error) {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
              }];
}
//    下拉显示范围选项
- (IBAction)showArea:(UIButton *)sender {
//    closelist
        if (isSelect) {
            [self.arrowImageView setImage:[UIImage imageNamed:@"down_arrow"]];
            isSelect = NO;
            if (onChoose) {
                self.areaLabel.text = self.areaString;
            }else{
                if ([[NSUserDefaults standardUserDefaults]objectForKey:@"anti_theft_text"] ) {
                    self.areaLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"anti_theft_text"];
                }else{
                    self.areaLabel.text = self.fence;
                }
            }
            self.headView.hidden = NO;
        }else{
//    openlist
            [self.arrowImageView setImage:[UIImage imageNamed:@"arrow_up"]];
            self.headView.hidden = YES;
            isSelect = YES;
            
        }
             
          [self.tableView reloadData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
- (IBAction)setVibrationtime:(UIButton *)sender {
    if (isSelecttime) {
        [self.Vibrationimageview setImage:[UIImage imageNamed:@"down_arrow"]];
        isSelecttime = NO;
        self.timeView.hidden = NO;
        if (onTime) {
            self.delaytime.text = self.delaytimeString;
        }else{
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"delaytimetext"] ) {
                self.delaytime.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"delaytimetext"];
            }else{
                self.delaytime.text = self.timestring;
            }
        }
        
    }else{
        [self.Vibrationimageview setImage:[UIImage imageNamed:@"arrow_up"]];
        isSelecttime = YES;
        self.timeView.hidden = YES;
    }
    [self.tableView reloadData];
}
@end
