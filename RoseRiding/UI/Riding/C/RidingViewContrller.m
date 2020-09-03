//
//  RidingViewContrller.m
//  RoseRiding
//
//  Created by MR_THT on 2020/6/5.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "RidingViewContrller.h"
#import "RidingTopView.h"
#import "RidingBottomView.h"
#import "recordsView.h"
#import "RidingrecordViewController.h"
#import "NSString+ZXXExtension.h"
@interface RidingViewContrller ()<GMSMapViewDelegate,CLLocationManagerDelegate,GMSAutocompleteResultsViewControllerDelegate>
{
    float sec;
    float min;
    float hou;
    float currentsec;
    NSString * catchtime;
}
@property (nonatomic,strong)GMSMapView *mapView;
@property (nonatomic,strong)GMSPlace *place;
@property (nonatomic,strong)UIView *maskView;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,assign)BOOL firstLocationUpdate;
@property (nonatomic,assign)BOOL isstart;
@property (nonatomic,assign)BOOL isstop;
@property (nonatomic,assign)BOOL ispaused;
@property (nonatomic,assign)BOOL issearch;
@property (nonatomic , assign)BOOL iscount;
@property (nonatomic , strong)NSString * keyword;
@property (nonatomic , strong)NSString * province;
@property (nonatomic , strong)NSString * level;
@property (nonatomic,assign)CLLocationCoordinate2D coordinate2D;

@property (nonatomic, strong)RidingBottomView *bottomView;//底部视图
@property (nonatomic, strong)recordsView *recordview;//骑行记录
@property (nonatomic, strong)UISearchController *searchController;
@property (nonatomic, strong)GMSAutocompleteResultsViewController *resultsViewController;
//当前位置
@property (nonatomic, strong) CLLocation *currentLocation;
//当前位置详细信息
@property (nonatomic, strong) NSDictionary *currentLocationDetailInfo;
//开始骑行的位置
@property (nonatomic, strong) CLLocation *startRidingLocation;
//结束骑行的位置
@property (nonatomic, strong) CLLocation *endRidingLocation;
//开始骑行时间 NSString *currentLocationName = @"";
@property (nonatomic, assign)NSString * beginRiddingTimeInver;
//结束骑行时间
@property (nonatomic, assign)NSString * endRiddingTimeInver;
//总行程
@property (nonatomic, assign)CGFloat  totalDistance;
//开始骑行的海拔高度
@property (nonatomic, assign)CGFloat  beginRidingElevation;
//结束骑行的海拔高度
@property (nonatomic, assign)CGFloat  endRidingElevation;
//骑行路线规划经纬度数组
@property (nonatomic, strong)NSMutableArray <CLLocation *>*roadsLocations;
//骑行过程中定位经纬度数组
@property (nonatomic, strong)NSMutableArray <CLLocation *>*ridingLocations;
//要上报的gps数据
@property (nonatomic, strong)NSString *gprsData;
//时间计时
@property (weak, nonatomic) NSTimer * timer;
//骑行数据计时
@property (weak, nonatomic) NSTimer * uploadtimer;

//最大速度
@property (nonatomic, assign)CGFloat  maxspeed;
//最低速度
@property (nonatomic, assign)CGFloat  minspeed;
//平均速度
@property (nonatomic, assign)CGFloat  avgspeed;
//最高海拔
@property (nonatomic, assign)CGFloat  maxaltitude;
//最低海拔
@property (nonatomic, assign)CGFloat  minaltitude;
//平均海拔
@property (nonatomic, assign)CGFloat  avgaltitude;
//采样次数
@property (nonatomic, assign)NSInteger  Samplingaccount;
//采样总速度
@property (nonatomic, assign)CGFloat  totalspeed;
//总海拔
@property (nonatomic, assign)CGFloat  totalaltitude;
//当前海拔
@property (nonatomic, assign)CGFloat  currentaltitude;

@property (nonatomic , assign)BOOL  isCurrenPageBluetoothOperation;

@property (nonatomic, strong)NSString * status;

@property (strong , nonatomic)NSString * startlocation;
@property (strong , nonatomic)NSString * h1;
@property (strong , nonatomic)NSString * h2;
@property (strong , nonatomic)NSString * h3;
@end

@implementation RidingViewContrller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isCurrenPageBluetoothOperation = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(deviceConnectDismiss:)
        name:BabyNotificationAtDidDisconnectPeripheral object:nil];
    self.keyword = @"";
    self.level = @"";
    self.province = @"";
    self.h1 = @"";
    self.h2 = @"";
    self.h3 = @"";
    self.iscount = NO;
    self.status = @"0";
    hou = 0;
    min = 0;
    sec = 0;
    currentsec = 0;
    self.maxspeed = 0;
    self.avgspeed = 0;
    self.minspeed = 0;
    self.totalspeed = 0;
    self.avgaltitude = 0;
    self.minaltitude = 0;
    self.maxaltitude = 0;
    _Samplingaccount = 0;
    self.totalDistance = 0;
    self.issearch = NO;
    self.timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Timered:) userInfo:nil repeats:YES];
//    self.uploadtimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(uploadrefresh:) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
//    [self.uploadtimer setFireDate:[NSDate distantFuture]];
    self.roadsLocations = [NSMutableArray array];
    self.ridingLocations = [NSMutableArray array];
    self.barStyle = NavigationBarStyleWhite;
     [self setSearchVC];
    [self initUI];
    [self starLoaction];
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)deviceConnectDismiss:(NSNotification *)notify{
if (!self.isCurrenPageBluetoothOperation) {
    return;
}
    [[GYBabyBluetoothManager sharedManager].babyBluetooth cancelAllPeripheralsConnection];
       [[GYBabyBluetoothManager sharedManager] stopScanPeripheral];
    self.issearch = NO;
    if (self.isstart) {
        self.isstop = YES;
        [self.timer setFireDate:[NSDate distantFuture]];
//           [self.uploadtimer setFireDate:[NSDate distantFuture]];
        if (self.totalDistance > 100) {
            self.status = @"2";
            [self updatedistance];
        }
    [self stopandclear];
    
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)Timered:(NSTimer*)timer {
    if (!_isstart) {
        return;
    }
    [self refreshBottomView];
    sec += 1;
    self.status = @"1";
    if ((int)sec % 5 == 0) {
         self.Samplingaccount += 1;
           [self starLoaction];
//           self.endRidingLocation = self.currentLocation;
           [self updatedistance];
    }
    if (sec == 60) {
        sec = 0;
        min += 1;
    }
    if (min == 60) {
        hou += 1;
        min = 0;
    }
    if (hou == 99) {
        [self.timer setFireDate:[NSDate distantFuture]];
//        [self.uploadtimer setFireDate:[NSDate distantFuture]];
        return;
    }
}
//- (void)uploadrefresh:(NSTimer *)timer{
//     self.Samplingaccount += 1;
//    [self starLoaction];
//    self.endRidingLocation = self.currentLocation;
//    [self updatedistance];
//}
- (void)initUI{
//    [self.topView buttonunused];
    [self.titleView setTitle:@"Riding" forState:UIControlStateNormal];
    //初始化头部视图
    self.topView = [[NSBundle mainBundle] loadNibNamed:@"RidingTopView" owner:nil options:nil].firstObject;
    self.topView.frame = CGRectMake(0, kNavHeight, UIWidth, Adaptive(60));
    [self.view addSubview:self.topView];
    kWeakSelf
   
    //搜索
    self.topView.searchAction = ^{
//        [self loadpopularcity];
//        [weakSelf.navigationController pushViewController:weakSelf.searchController animated:YES];
      [weakSelf presentViewController:weakSelf.searchController animated:YES completion:nil];
      weakSelf.issearch = YES;
    };
    //开始骑行(上报起始位置，及时间戳给后台)
   //    [self.topView canuserstart];
        self.topView.startRidingAction = ^{
            if (weakSelf.isstop) {
                return;
            }
            weakSelf.bottomView.ridingDataView.hidden = NO;
            weakSelf.bottomView.triangel.hidden = NO;
            if (self->currentsec < 60) {
                self->sec = self->currentsec;
            }else{
                self->sec = 0;
            }
            weakSelf.startRidingLocation = weakSelf.currentLocation;
           weakSelf.isstart = YES;
            [weakSelf starLoaction];
            weakSelf.beginRiddingTimeInver = [weakSelf getcurrenttime];
            [[NSUserDefaults standardUserDefaults]setObject:weakSelf.beginRiddingTimeInver forKey:@"starttime"];
            [weakSelf.timer setFireDate:[NSDate distantPast]];
//            [weakSelf.uploadtimer setFireDate:[NSDate distantPast]];
            
            if (weakSelf.issearch == YES && weakSelf.place.name.isNotBlank) {
//                weakSelf.keyword = weakSelf.place.name;
                weakSelf.level = @"1";
                weakSelf.iscount = YES;
                [weakSelf loadpopularcity];
//                [weakSelf gogoogleWithlat:weakSelf.place.coordinate.latitude andLng:weakSelf.place.coordinate.longitude];
                [weakSelf gogoogleWithaddress:weakSelf.place.formattedAddress];
            }else{
//                NSLog(@"%@%d",weakSelf.name,weakSelf.isjump);
             if (weakSelf.isjump == YES && weakSelf.name.isNotBlank) {
//                 weakSelf.keyword = weakSelf.name;
                 weakSelf.level = @"1";
                 weakSelf.iscount = YES;
                 [weakSelf loadpopularcity];
                     [weakSelf gogoogleWithaddress:weakSelf.name];
             }
                return;
            }
       //        weakSelf.startRidingLocation = weakSelf.currentLocation;
               //上报开始骑行数据给服务端
              
       //        [weakSelf upLoadStartRidingDataToService];
          
           };
           //停止骑行(上报结束位置，及时间戳给后台)
           self.topView.stopRidingAction = ^{
               weakSelf.issearch = NO;
               if (weakSelf.isstart) {
                   weakSelf.isstop = YES;
                   [weakSelf.topView.startBtn setUserInteractionEnabled:NO];
                   [weakSelf.timer setFireDate:[NSDate distantFuture]];
//                   [weakSelf.uploadtimer setFireDate:[NSDate distantFuture]];
                   weakSelf.recordview.endtime.text = [weakSelf getcurrenttime];
                   if ([[NSUserDefaults standardUserDefaults]objectForKey:@"starttime"] != nil) {
                        weakSelf.recordview.begintime.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"starttime"];
                   }
                   if (self.totalDistance > 100) {
                       weakSelf.status = @"2";
                     [weakSelf updatedistance];
                   }
                   [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.maskView];
               }else{
               }
           };
           //暂停骑行
           self.topView.pauseRidingAction = ^{
               weakSelf.issearch = NO;
               weakSelf.isjump = NO;
               weakSelf.ispaused = YES;
               if (self->sec < 60) {
                  self->currentsec = self->sec;
               }else{
                   self->currentsec = 0;
               }
               if (self.totalDistance > 100) {
                 [weakSelf updatedistance];
               }
   //            weakSelf.topView.stopBtn.userInteractionEnabled = NO;
   //            [weakSelf.topView.startBtn setImage:[UIImage imageNamed:@"bofang-3"] forState:UIControlStateNormal];
               [weakSelf.timer setFireDate:[NSDate distantFuture]];
//               [weakSelf.uploadtimer setFireDate:[NSDate distantFuture]];
              return;
           };
    //初始化地图
    
    //x预定一个维度
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
    longitude:151.2086
         zoom:16];
    self.mapView = [[GMSMapView alloc] initWithFrame:CGRectMake(0, kNavHeight + Adaptive(60), UIWidth, UIHeight - kNavHeight - Adaptive(60)) camera:camera];
    self.mapView.delegate = self;
    self.mapView.settings.compassButton = YES;//是否启用指南针
    [self.view addSubview:_mapView];
    self.mapView.myLocationEnabled = YES;
    //初始化底部视图
    self.bottomView = [[NSBundle mainBundle] loadNibNamed:@"RidingBottomView" owner:nil options:nil].firstObject;
    self.bottomView.frame = CGRectMake(0, UIHeight - Adaptive(168), UIWidth, Adaptive(168));
    self.bottomView.ridingDataView.hidden = YES;
    self.bottomView.triangel.hidden = YES;
     self.bottomView.showAction = ^{
//            NSLog(@"历史记录");
            RidingrecordViewController * VC = [[RidingrecordViewController alloc]init];
         VC.title = @"Riding Records";
            [weakSelf.navigationController pushViewController:VC animated:YES];
    //         [weakSelf refreshBottomView];
        };
    if (!self.isjump) {
        [self.topView.startBtn setUserInteractionEnabled:NO];
    }
    [self.topView.stopBtn setUserInteractionEnabled:NO];
    [self.topView.pauseBtn setUserInteractionEnabled:NO];
    [self.topView.stopBtn setImage:[UIImage imageNamed:self.topView.startBtn.selected?@"stop":@"tingzhi"] forState:UIControlStateNormal];
    [self.topView.pauseBtn setImage:[UIImage imageNamed:self.topView.startBtn.selected?@"zanting":@"pause"] forState:UIControlStateNormal];
    [self.view addSubview:self.bottomView];
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIWidth, UIHeight)];
    self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.recordview = [[NSBundle mainBundle] loadNibNamed:@"recordsView" owner:nil options:nil].firstObject;
    [self.maskView addSubview:self.recordview];
    self.recordview.layer.cornerRadius = 10.f;
    self.recordview.layer.masksToBounds = YES;
    [self.recordview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.maskView);
        make.centerY.equalTo(self.maskView);
        make.width.equalTo(@240);
        make.height.equalTo(@258);
    }];
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
}
- (void)tapAction:(UITapGestureRecognizer *)gesture{
    [self.maskView removeFromSuperview];
     [self stopandclear];
     [self presentViewController:self.searchController animated:YES completion:nil];
}
- (void)loadpopularcity{
//    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"historylocation"]);
    NSString * url = host(@"bicycle/historyList");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetworkingManger shareManger] postDataWithUrl:url para:@{@"keywords":self.keyword ,@"province":self.province,@"level": self.level,@"type":[Languagemanger shareManger].isEn?@"1":@"2",@"count":self.iscount?@"1":@"2",@"city":self.h2} success:^(NSDictionary * _Nonnull result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
       
    } fail:^(NSError * _Nonnull error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
/*
- (void)showAlert{
    NSString *apnCount = @"Do you want to end the ride?";
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:apnCount preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction* _Nonnull action){
//        self.isstop = self.topView.stopBtn.selected = NO;
//        self.topView.startBtn.selected = YES;
//        [self.topView.startBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
//        [self.topView.stopBtn setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
       
        
        //上报结束骑行数据给服务端
//        [self uploadEndRiddingDataToService];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
 */
//地图移动后的代理方法，我这里的需求是地图移动需要刷新网络请求

-(void)mapView:(GMSMapView*)mapView idleAtCameraPosition:(GMSCameraPosition*)position{

}
- (void)endcycling{
    [self.timer setFireDate:[NSDate distantFuture]];
//    [self.uploadtimer setFireDate:[NSDate distantFuture]];
    return;
}
- (void)starLoaction{
    
    if (![CLLocationManager locationServicesEnabled]) {

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
    [self.ridingLocations addObject:location];
    self.currentaltitude = self.currentLocation.altitude;
     [self loadCurentLocation:[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude] andlng:[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude]];
//    NSLog(@"%@",self.startlocation);
    // 打印位置信息
//    NSLog(@"经度：%.2f, 纬度：%.2f", location.coordinate.latitude,location.coordinate.longitude);
    // 停止定位
    [_locationManager stopUpdatingLocation];
    [self.mapView clear];
    //如果是国内，就会转化坐标系，如果是国外坐标，则不会转换。
    _coordinate2D = [JZLocationConverter wgs84ToGcj02:location.coordinate];
    //移动地图中心到当前位置
    if (![MyDevicemanger shareManger].mainDevice.isConnecting) {
        GMSMarker *marker = [GMSMarker markerWithPosition:_coordinate2D];
        marker.title = @"";
        marker.map = self.mapView;
        marker.icon = [UIImage imageNamed:@"home_bicycle"];
        _mapView.camera = [GMSCameraPosition cameraWithTarget:_coordinate2D
        zoom:16];
    }else{
//        CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.lat floatValue] longitude:[self.lng floatValue]];
//        self.coordinate2D = location.coordinate;
        
        self->_mapView.camera = [GMSCameraPosition cameraWithTarget:self.currentLocation.coordinate
        zoom:16];
//        _mapView.camera = [GMSCameraPosition cameraWithTarget:self.currentLocation.coordinate
//        zoom:16];
    }
    
}
- (void)setSearchVC{
    self.resultsViewController = [[GMSAutocompleteResultsViewController alloc] init];
    GMSAutocompleteFilter *autocompleteFilter = [[GMSAutocompleteFilter alloc] init];
    NSLocale *currentLocalestr = [NSLocale currentLocale];
       NSString * countryCode = [currentLocalestr objectForKey:NSLocaleCountryCode];
    autocompleteFilter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;
    autocompleteFilter.country = countryCode;
    self.resultsViewController.autocompleteFilter = autocompleteFilter;
    self.resultsViewController.delegate = self;
    self.searchController = [[UISearchController alloc]
                         initWithSearchResultsController:self.resultsViewController];
    _searchController.searchResultsUpdater = self.resultsViewController;
    // Put the search bar in the navigation bar.
    [_searchController.searchBar sizeToFit];
    self.searchController.searchBar.text = self.name;
    self.navigationItem.titleView = _searchController.searchBar;
   
    // When UISearchController presents the results view, present it in
    // this view controller, not one further up the chain.
    self.definesPresentationContext = YES;
    // Prevent the navigation bar from being hidden when searching.
    _searchController.hidesNavigationBarDuringPresentation = NO;
    if (self.isjump) {
           [self presentViewController:self.searchController animated:YES completion:nil];
        
       }
}

// Handle the user's selection.
- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
  didAutocompleteWithPlace:(GMSPlace *)place {
    _searchController.active = NO;
//    NSLog(@"%@",[NSString replaceUnicode:place.formattedAddress]);
    NSString * str = [ NSString replaceUnicode:place.formattedAddress];
    self.keyword = str;
    [self loadCurentLocation:[NSString stringWithFormat:@"%f",place.coordinate.latitude ] andlng:[NSString stringWithFormat:@"%f",place.coordinate.longitude]];
    // Do something with the selected place.
    if (place.name.isNotBlank) {
    self.place = place;
        self.issearch = YES;
        self.isstop = NO;
        if (place.name.length == 0) {
            self.isstop = YES;
        }else{
            self.isstop = NO;
            [self.topView.startBtn setUserInteractionEnabled:YES];
        }
        
    [self.topView.startBtn setUserInteractionEnabled:YES];
    [self.topView.startBtn setImage:[UIImage imageNamed:self.issearch?@"bofang-3":@"开始"] forState:UIControlStateNormal];
    //查询导航路线
    [self.mapView clear];
    _coordinate2D = [JZLocationConverter wgs84ToGcj02:place.coordinate];
       //移动地图中心到当前位置
       GMSMarker *marker = [GMSMarker markerWithPosition:_coordinate2D];
       marker.title = @"";
       marker.map = self.mapView;
       _mapView.camera = [GMSCameraPosition cameraWithTarget:_coordinate2D
                                                        zoom:16];
    }
   
}
- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
didFailAutocompleteWithError:(NSError *)error {
  [self dismissViewControllerAnimated:YES completion:nil];
  // TODO: handle the error.
//  NSLog(@"Error: %@", [error description]);
}
// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictionsForResultsController:
    (GMSAutocompleteResultsViewController *)resultsController {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)didUpdateAutocompletePredictionsForResultsController:
    (GMSAutocompleteResultsViewController *)resultsController {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark 获取导航规划路线(起点为当前位置的经纬度反编码)
//当前位置详细信息
/*
- (void)loadCurentLocation:(GMSPlace *)place{
    kWeakSelf
    NSString *requestUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&key=AIzaSyABQXPBUnlE_DzVKG7ga0ZJhx9QmlygldU",self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude];
    [[NetworkingManger shareManger] postDataWithUrl:requestUrl para:nil success:^(NSDictionary * _Nonnull result) {
        self.currentLocationDetailInfo = [result[@"results"] firstObject];
        NSLog(@"%@",result);
    
        [self openScheme:@"tweetbot://timeline"];
       
    } fail:^(NSError * _Nonnull error) {
        
    }];
}
- (void)openScheme:(NSString *)scheme {
  UIApplication *application = [UIApplication sharedApplication];
  NSURL *URL = [NSURL URLWithString:scheme];

  if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
    [application openURL:URL options:@{}
       completionHandler:^(BOOL success) {
      NSLog(@"Open %@: %d",scheme,success);
    }];
  } else {
    BOOL success = [application openURL:URL];
    NSLog(@"Open %@: %d",scheme,success);
  }
}
*/
// Typical usage
//跳转google
//- (void)gogoogleWithlat:(float)lat andLng:(float)lng{
//
//    NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%f,%f&directionsmode=cycling",lat,
//    lng] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
//
//
//    }else{
//        [Toast showToastMessage:[GlobalControlManger enStr:@"You have not downloaded Google Maps" geStr:@"You have not downloaded Google Maps"]];
//        return;
//    }
//}
- (void)gogoogleWithaddress:(NSString *) name{
    NSLog(@"%@",name);
    NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%@&directionsmode=bicycling",name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];

          
      }else{
          [Toast showToastMessage:[GlobalControlManger enStr:@"You have not downloaded Google Maps" geStr:@"You have not downloaded Google Maps"]];
          return;
      }
}
//查询路线
/*
- (void)loadRoadPaths:(GMSPlace *)place{
    [self.mapView clear];
    NSString *currentLocationName = @"";
    NSArray *locationinfos = [[self.currentLocationDetailInfo[@"address_components"] reverseObjectEnumerator] allObjects];
    for (NSDictionary *dic in locationinfos) {
        if ([dic[@"types"] containsObject:@"postal_code"]) {
            continue;
        }
        currentLocationName = [NSString stringWithFormat:@"%@%@",currentLocationName,dic[@"long_name"]];
        NSLog(@"currentLocationName---%@",currentLocationName);
    }
    NSString *tagrgetLoactionName = @"";
    for (GMSAddressComponent *addressComponent in [[place.addressComponents reverseObjectEnumerator] allObjects]) {
        tagrgetLoactionName = [NSString stringWithFormat:@"%@%@",tagrgetLoactionName,addressComponent.name];
    }
    NSLog(@"----------%@",tagrgetLoactionName);
    NSString *requestUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&key=AIzaSyCz__61dyfIqih5r684g6j4e4V1me_9EEo",[currentLocationName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],[tagrgetLoactionName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [[NetworkingManger shareManger] getDataWithUrl:requestUrl para:nil success:^(NSDictionary * _Nonnull result) {
        NSLog(@"resultDictionary== %@",result);
        int status = [result[@"status"] intValue];
        if (status == 0) {
            GMSMutablePath *rodepath = [GMSMutablePath path];
            if ( ![result[@"routes"] isKindOfClass:[NSNull class]]) {//routes路线方案
                NSArray *routes = result[@"routes"];
                NSDictionary *rotDic = routes[0]; //这里取第一条线路
                if (![rotDic[@"legs"] isKindOfClass:[NSNull class]]) {//legs规划详情
                    NSArray *legArr = [NSArray arrayWithArray:rotDic[@"legs"]];
                    for (int i = 0; i < [legArr count] ; i++) {
                        NSDictionary *legDic = legArr[i];
                        if (![legDic[@"steps"] isKindOfClass:[NSNull class]]) {
                            NSArray * steps = legDic[@"steps"];
                            for (int j = 0; j < steps.count; j++) {
                                NSDictionary *dic = steps[j];
                                NSDictionary *start_location = dic[@"start_location"];
                                [rodepath addLatitude:[start_location[@"lat"] floatValue] longitude:[start_location[@"lng"] floatValue]];
                                NSDictionary *end_location = dic[@"end_location"];
                                [rodepath addLatitude:[end_location[@"lat"] floatValue] longitude:[end_location[@"lng"] floatValue]];
                                CLLocation *start = [[CLLocation alloc] initWithLatitude:[start_location[@"lat"] floatValue] longitude:[start_location[@"lng"] floatValue]];
                                CLLocation *end = [[CLLocation alloc] initWithLatitude:[start_location[@"lat"] floatValue] longitude:[start_location[@"lng"] floatValue]];
                                [self.roadsLocations addObject:start];
                                [self.ridingLocations addObject:end];
                                if (i == 0 && j == 0) {
                                    //设置起点的图标
                                    //移动地图中心到当前位置
                                    if (![MyDevicemanger shareManger].mainDevice.isConnecting) {
                                        self->_coordinate2D = [JZLocationConverter wgs84ToGcj02:start.coordinate];
                                        GMSMarker *marker = [GMSMarker markerWithPosition:self->_coordinate2D];
                                        marker.title = @"";
                                               marker.map = self.mapView;
                                               marker.icon = [UIImage imageNamed:@"home_bicycle"];
                                        self->_mapView.camera = [GMSCameraPosition cameraWithTarget:self->_coordinate2D zoom:16];
                                    }
                                }
                                if (i == legArr.count - 1 && j == steps.count - 1) {
                                    //设置终点坐标
                                    self->_coordinate2D = [JZLocationConverter wgs84ToGcj02:end.coordinate];

                                    GMSMarker *marker = [GMSMarker markerWithPosition:self->_coordinate2D];
                                    marker.title = @"";
                                           marker.map = self.mapView;
                                           marker.icon = [UIImage imageNamed:@"location"];
                                    self->_mapView.camera = [GMSCameraPosition cameraWithTarget:self->_coordinate2D zoom:16];
                                }
                            }
                        }
                        GMSPolyline *polyline = [GMSPolyline polylineWithPath:rodepath];
                        polyline.strokeColor = [UIColor systemTealColor];
                        polyline.strokeWidth = 10.f;
                        polyline.map = self->_mapView;
                    }
                }
            }
        }else{
            [Toast showToastMessage:@"no path" inview:self.view interval:1];
            NSLog(@"暂未路径规划");
        }
    } fail:^(NSError * _Nonnull error) {
        
    }];
}
*/
//上报开始骑行数据到服务端
/*
- (void)upLoadStartRidingDataToService{
     //获取开始骑行时间
    NSDate *currentDate = [NSDate date];
    self.beginRiddingTimeInver = [currentDate timeIntervalSince1970];
   //开始上传
    [[NetworkingManger shareManger] postDataWithUrl:host(@"bicycle/start_cycling") para:@{@"id":[MyDevicemanger shareManger].mainDevice.Id,@"token":[UserInfo shareUserInfo].token,@"start_lng":[NSString stringWithFormat:@"%f",self.startRidingLocation.coordinate.longitude],@"start_lat":[NSString stringWithFormat:@"%f",self.startRidingLocation.coordinate.latitude],@"system_start_time":[NSString stringWithFormat:@"%f",self.beginRiddingTimeInver]} success:^(NSDictionary * _Nonnull result) {
        if ([result[@"code"] integerValue] != 1) {
        }else{
        }
        
    } fail:^(NSError * _Nonnull error) {

    }];
}
*/
- (NSString *)loadCurentLocation:(NSString *)lat andlng:(NSString* )lng{
    NSString * lattt = @"";
    NSString * longgg = @"";
    if (lat.isNotBlank && lng.isNotBlank) {
        lattt = lat;
        longgg = lng;
    }
    NSString *requestUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&key=AIzaSyABQXPBUnlE_DzVKG7ga0ZJhx9QmlygldU",lattt,longgg];
    [[NetworkingManger shareManger] postDataWithUrl:requestUrl para:nil success:^(NSDictionary * _Nonnull result) {
        self.currentLocationDetailInfo = [result[@"results"] firstObject];
         NSString *currentLocationName = @"";
         NSArray *locationinfos = [[self.currentLocationDetailInfo[@"address_components"] reverseObjectEnumerator] allObjects];
//        NSLog(@"%@",locationinfos);
        for (NSDictionary *dic in locationinfos) {
            if ([dic[@"types"] containsObject:@"postal_code"]){
                continue;
            }
            if ([dic[@"types"] containsObject:@"administrative_area_level_1"]) {
                self.province = dic[@"long_name"] ;
//                NSLog(@"%@",self.province);
            }
            if ([dic[@"types"] containsObject:@"country"]) {
                self.h1 = dic[@"long_name"];
            }
            if ([dic[@"types"] containsObject:@"locality"]) {
                self.h2 = dic[@"long_name"];
            }
            if ([dic[@"types"] containsObject:@"sublocality"]) {
                self.h3 = dic[@"long_name"];
            }
            
            currentLocationName = [NSString stringWithFormat:@"%@, %@",dic[@"long_name"],currentLocationName];
        }
        currentLocationName = [currentLocationName //替换某段字符
                               stringByReplacingCharactersInRange:NSMakeRange(currentLocationName.length-2, 1) withString:@""];
//        NSLog(@"currentLocationName---------%@",currentLocationName);
    
        if (currentLocationName != nil) {
            self.startlocation = currentLocationName;
        }else{
            self.startlocation = @"--";
        }
        [self reloadInputViews];
    } fail:^(NSError * _Nonnull error) {
        self.startlocation= @"--";
    }];
    return self.startlocation;
}
- (void)goBack{
    if (self.isstart) {
        if (self.totalDistance < 10) {
            [self stopandclear];
             [self.navigationController popViewControllerAnimated:YES];
        }else{
            self.isstart = NO;
            self.isstop = YES;
            [self.timer setFireDate:[NSDate distantFuture]];
//               [self.uploadtimer setFireDate:[NSDate distantFuture]];
            self.status = @"2";
            [self updatedistance];
            [self stopandclear];
        }
    }else{
       [self.navigationController popViewControllerAnimated:YES];
    }
}
/*
- (void)uploadEndRiddingDataToService{
    //获取结束骑行时间
    NSDate *currentDate = [NSDate date];
    self.beginRiddingTimeInver = [currentDate timeIntervalSince1970];
   
    //处理路线经纬度数据
    for (int i = 0; i < self.ridingLocations.count; i++) {
        if (i == 0) {
            self.gprsData = [NSString stringWithFormat:@"lat=%f,lng=%f",self.ridingLocations[i].coordinate.latitude,self.ridingLocations[i].coordinate.longitude];
        }else{
            self.gprsData = [NSString stringWithFormat:@"%@|lat=%f,lng=%f",self.gprsData,self.ridingLocations[i].coordinate.latitude,self.ridingLocations[i].coordinate.longitude];
        }
    }
    //获取行程的总距离
    [self getDistance];
}
*/
- (void)stopandclear{
    hou = 0;
    min = 0;
    sec = 0;
    currentsec = 0;
    self.maxspeed = 0;
    self.avgspeed = 0;
    self.minspeed = 0;
    self.totalspeed = 0;
    self.avgaltitude = 0;
    self.minaltitude = 0;
    self.maxaltitude = 0;
    _Samplingaccount = 0;
    self.totalDistance = 0;
    self.bottomView.hour.text = @"00";
           self.bottomView.minutes.text = @"00";
           self.bottomView.seconds.text = @"00";
            self.bottomView.distance.text = @"0.0km";
            self.bottomView.speed.text = @"0.0km/h";
    self.place = nil;
   
}
/*
//查询该次总行程距离
- (void)getDistance{
    NSString *requestUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?origin=%f,%f&destination=%f,%f&key=AIzaSyCz__61dyfIqih5r684g6j4e4V1me_9EEo",self.startRidingLocation.coordinate.latitude,self.startRidingLocation.coordinate.longitude,self.endRidingLocation.coordinate.latitude,self.endRidingLocation.coordinate.longitude];
    [[NetworkingManger shareManger] getDataWithUrl:requestUrl para:nil success:^(NSDictionary * _Nonnull result) {
        NSLog(@"resultDictionary== %@",result);
        self.totalDistance = [[result[@"rows"] firstObject][@"elements"][@"distance"][@"value"] floatValue];//m
        [self getBeginRidingElevation];
    } fail:^(NSError * _Nonnull error) {
        
    }];
}

//获取开始骑行海拔高度
- (void)getBeginRidingElevation{
    
    NSString *requestUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/elevation/json?locations=%f,%f&key=AIzaSyCz__61dyfIqih5r684g6j4e4V1me_9EEo",self.startRidingLocation.coordinate.latitude,self.startRidingLocation.coordinate.longitude];
    [[NetworkingManger shareManger] getDataWithUrl:requestUrl para:nil success:^(NSDictionary * _Nonnull result) {
        NSLog(@"resultDictionary== %@",result);
        self.beginRidingElevation = [[result[@"results"] firstObject][@"elevation"] floatValue];
        [self getEndRidingElevation];
    } fail:^(NSError * _Nonnull error) {
        
    }];
}
//获取结束骑行海拔高度
- (void)getEndRidingElevation{
    NSString *requestUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/elevation/json?locations=%f,%f&key=AIzaSyCz__61dyfIqih5r684g6j4e4V1me_9EEo",self.endRidingLocation.coordinate.latitude,self.endRidingLocation.coordinate.longitude];
    [[NetworkingManger shareManger] getDataWithUrl:requestUrl para:nil success:^(NSDictionary * _Nonnull result) {
        NSLog(@"resultDictionary== %@",result);
        self.endRidingElevation = [[result[@"results"] firstObject][@"elevation"] floatValue];
        [self upLoadEndData];
    } fail:^(NSError * _Nonnull error) {
        
    }];
}
*/
- (void)upLoadEndData{
    NSLog(@"%@",self.status);
    //上报结束骑行数据到服务端
    if ([MyDevicemanger shareManger].mainDevice.Id == nil) {
         return;
    }
//    NSLog(@"alt %f",self.endRidingLocation.altitude);
//    NSLog(@"lat  %f",self.endRidingLocation.coordinate.latitude);
//    NSLog(@"lng  %f",self.endRidingLocation.coordinate.longitude);
//    NSLog(@"totaldistance%f",self.totalDistance);
//    NSLog(@"avgspeed%f",self.avgspeed);
//    NSLog(@"maxspeed%f",self.maxspeed);
//    NSLog(@"minspeed%f",self.minspeed);
//    NSLog(@"avgaltitude%f",self.avgaltitude);
//    NSLog(@"maxaltitude%f",self.maxaltitude);
//    NSLog(@"minaltitude%f",self.minaltitude);
//    NSLog(@"id------%@",[MyDevicemanger shareManger].mainDevice.Id);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetworkingManger shareManger] postDataWithUrl:host(@"bicycle/end_cycling") para:@{@"id":[MyDevicemanger shareManger].mainDevice.Id,@"token":[UserInfo shareUserInfo].token,@"end_lng":[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude],@"end_lat":[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude],@"system_end_time":@"",@"mileage":[NSString stringWithFormat:@"%.1f",self.totalDistance*0.001],@"time_consuming":[NSString stringWithFormat:@"%@",self->catchtime],@"average_speed":[NSString stringWithFormat:@"%.f",self.avgspeed],@"max_speed":[NSString stringWithFormat:@"%.f",self.maxspeed],@"min_speed":[NSString stringWithFormat:@"%.f",self.minspeed],@"altitude":[NSString stringWithFormat:@"%.f",self.avgaltitude],@"max_altitude":[NSString stringWithFormat:@"%.f",self.maxaltitude],@"min_altitude":[NSString stringWithFormat:@"%.f",self.minaltitude],@"gps_data":@"",@"status":self.status,@"addr":self.startlocation,@"h1":self.h1,@"h2":self.h2,@"h3":self.h3} success:^(NSDictionary * _Nonnull result) {
        if ([result[@"code"] integerValue] != 1) {
            [Toast showToastMessage:result[@"msg"]];
        }else{
            //更新底部视图数据
             [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } fail:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
/**
- (NSString *)getTimeFromTimestamp:(double)str{
    //将对象类型的时间转换为NSDate类型

    double time = str;

    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:time];

    //设置时间格式

    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];

    [formatter setDateFormat:@"DD.MM.YYYY HH:mm:ss"];

    //将时间转换为字符串

    NSString *timeStr=[formatter stringFromDate:myDate];

    return timeStr;
}
 */
- (NSString *)getcurrenttime{
    NSDate *date=[NSDate date];
               NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
               [dateformatter setDateFormat:@"dd.MM.YYYY - HH:mm:ss"];
               NSString *locationString=[dateformatter stringFromDate:date];
//    NSLog(@"date----------------%@",locationString);
    return locationString;
}
- (void)updatedistance{
    float speed = 0.0;
    float altitude = self.currentLocation.altitude;
    if (altitude < self.maxaltitude) {
        self.minaltitude = altitude;
    }else if(altitude >= self.maxaltitude){
        self.maxaltitude = altitude;
    }
    self.totalaltitude += altitude;
    NSTimeInterval dTime = [self.currentLocation.timestamp timeIntervalSinceDate:self.startRidingLocation.timestamp];
    CLLocationDistance meter = [self.currentLocation distanceFromLocation:self.startRidingLocation];
    self.startRidingLocation = self.currentLocation;
//    if (self.ispaused) {
        self.totalDistance += meter;
//    }else{
//        self.totalDistance = meter;
//    }
    
    if (meter > 1.0f) {
        speed = 2.236* meter / dTime;
        if (speed > 0) {
            self.totalspeed += speed;
            if (speed < self.maxspeed) {
                self.minspeed = speed;
            }else if(speed >= self.maxspeed){
                self.maxspeed = speed;
            }
        }
        if (self.Samplingaccount > 1) {
            self.avgspeed = self.totalspeed/(self.Samplingaccount - 1);
        }else{
            self.avgspeed = self.totalspeed/self.Samplingaccount;
        }
        self.avgaltitude = self.totalaltitude/self.Samplingaccount;
    }
    if(!(meter > 0)){
        [self.topView.pauseBtn setSelected:YES];
        [self.topView.startBtn setSelected:NO];
        [self.topView.startBtn setUserInteractionEnabled:YES];
        self.issearch = NO;
        self.isjump = NO;
        self.ispaused = YES;
        if (sec < 60) {
           self->currentsec = self->sec;
        }else{
            self->currentsec = 0;
        }       
//        [self.uploadtimer setFireDate:[NSDate distantFuture]];
        [self.timer setFireDate:[NSDate distantFuture]];
    }
//    NSLog(@"当前速度为-------%.1f",speed);
    if ([[NSString stringWithFormat:@"%f",speed] isEqualToString:@"nan"]) {
        self.bottomView.speed.text = @"0.0km/h";
    }else{
         self.bottomView.speed.text = [NSString stringWithFormat:@"%.1fkm/h",speed*3.6];
    }
    if (self.totalDistance <=0) {
        self.bottomView.distance.text = @"0m";
    }else if (self.totalDistance < 100) {
        self.bottomView.distance.text = [NSString stringWithFormat:@"%dm",(int)self.totalDistance];
    }else{
        self.bottomView.distance.text = [NSString stringWithFormat:@"%.1fkm",self.totalDistance*0.001];
    }
    self.recordview.distance.text = self.bottomView.distance.text;
//    self.recordview.begintime.text = @"";
//    self.recordview.endtime.text = @"";
    self.recordview.avgspeed.text =[NSString stringWithFormat:@"%.1fkm/h", self.avgspeed * 3.6];
    self.recordview.clambheight.text = [NSString stringWithFormat:@"%d - %dm",(int)self.minaltitude,(int)self.maxaltitude];
    if ([MyDevicemanger shareManger].mainDevice.isConnecting) {
        [self upLoadEndData];
    }else{
        
    }
    
    if ([self.status isEqualToString:@"0"]) {
        self.status = @"1";
    }
}

- (void)refreshBottomView{
   
//    NSLog(@"begin%f \n    end%f      \n     dis%f",self.beginRiddingTimeInver,self.endRiddingTimeInver,self.totalDistance);
   
    if (self->hou>=10) {
        self.bottomView.hour.text = [NSString stringWithFormat:@"%d",(int)self->hou];
    }else{
         self.bottomView.hour.text = [NSString stringWithFormat:@"0%d",(int)self->hou];
    }
    if (self->min>=10) {
         self.bottomView.minutes.text = [NSString stringWithFormat:@"%d",(int)self->min];
    }else{
         self.bottomView.minutes.text = [NSString stringWithFormat:@"0%d",(int)self->min];
    }
    if (self->sec>=10) {
       self.bottomView.seconds.text = [NSString stringWithFormat:@"%d",(int)self->sec];
    }else{
        self.bottomView.seconds.text = [NSString stringWithFormat:@"0%d",(int)self->sec];
    }
    self->catchtime = [NSString stringWithFormat:@"%@:%@:%@",self.bottomView.hour.text,self.bottomView.minutes.text,self.bottomView.seconds.text];
    self.recordview.costtime.text = self->catchtime;
//    self.bottomView.distance.text = [NSString stringWithFormat:@"%.1fkm",self.totalDistance];
//    self.bottomView.speed.text = [NSString stringWithFormat:@"%.1f",self.currentLocation.speed];
}
@end
