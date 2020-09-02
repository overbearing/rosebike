//
//  MenuController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/23.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "MenuController.h"
#import "MenuCell.h"
#import "MangerMentController.h"
#import "AntitheftinterfaceController.h"
#import "BeeperSettingController.h"
#import "EditDeviceInfoNewController.h"
#import "RidingViewContrller.h"
#import "HelloMapViewController.h"
#import "popularcityViewController.h"

@interface MenuController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray <BikeDeviceModel *>*list;
@property (nonatomic, strong)BikeDeviceModel *currentDevice;
@property (nonatomic , assign)BOOL  isCurrenPageBluetoothOperation;
@end

@implementation MenuController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isCurrenPageBluetoothOperation = YES;
    [self loadMyDevice];
    if (self.tableView) {
        [self.tableView reloadData];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isCurrenPageBluetoothOperation = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadMyDevice];
    // Do any additional setup after loading the view.
    self.barStyle = NavigationBarStyleWhite;
    self.title = @"Menu";
    self.leftButton.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveBluetoothMessageAction:) name:GYBabyBluetoothManagerRead object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self
                                                    selector:@selector(deviceConnectDismiss)
                                                        name:BabyNotificationAtDidDisconnectPeripheral object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReciveBluetoothConnectSuccessMessage:) name:GYBabyBluetoothManagerConnectSuccess
                                                   object:nil];
//     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterairmode:) name:GYBabyBluetoothManagerConnectDismiss object:nil];
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterairmode:) name:@"enterairplanemode" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addsuccess) name:@"addBikeSuccess" object:nil];
       [[NSNotificationCenter defaultCenter]addObserver:self
                                               selector:@selector(activatesuccess)
                                                   name:@"activatesuccess"
                                                 object:nil];
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
- (void)enterairmode:(NSNotification * )notify{
    if(!self.isCurrenPageBluetoothOperation){
        return;
    }
    [self AIRPLANEWaring];
}
- (void)loadMyDevice{
    
    NSString *url = host(@"bicycle/equimentList");
    if ([UserInfo shareUserInfo].token.length == 0) {
        return;
    }
//     NSLog(@"%@",  [UserInfo shareUserInfo].token);
    NSDictionary *para = @{@"token":[UserInfo shareUserInfo].token};
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger stateCode = [result[@"code"] integerValue];
        NSString *msg = result[@"msg"];
        if (stateCode == 1) {
        self.list = [BikeDeviceModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"list"]];
        [MyDevicemanger shareManger].Devices = self.list;
            if (self.list.count == 0) {
                return;
            }else{
                for (BikeDeviceModel *m in self.list) {
                    if ([MyDevicemanger shareManger].mainDevice == nil) {
                        if ([m.is_default isEqualToString:@"2"]) {
                            self.currentDevice = m;
                        }else{
                            self.currentDevice = m;
                        }
                    }else{
                        self.currentDevice = self.list.firstObject;
                    }
                }
                
            }
//            NSLog(@"%@",result[@"data"][@"list"]);
//            NSLog(@"%@%@",self.currentDevice.equipment,self.currentDevice.activation);
            [self.tableView reloadData];
        }else{
            if (![msg isEqualToString:@""]) {
//                [Toast showToastMessage:msg];
            }
        }
    } fail:^(NSError * _Nonnull error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)activatesuccess{
    [self loadMyDevice];
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
    
    [self.view bringSubviewToFront:self.navView];
    
}
- (void)addsuccess{
    [self loadMyDevice];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Adaptive(108);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureCellwith:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
#pragma mark  禁用一切功能
///*
    if ([MyDevicemanger shareManger].Devices.count == 0) {
        NSString *apnCount = @"You haven’t added any bikes yet, do you want to add a new one?";
          UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:apnCount preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
            EditDeviceInfoNewController *VC = [[EditDeviceInfoNewController alloc] init];
            VC.type = DeviceInfoAdd;
            [self.navigationController pushViewController:VC animated:YES];
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
  //*/
    if (indexPath.row == 0) {
        if (![self.currentDevice.activation isEqualToString:@"3"]){
            [Toast showToastMessage:[GlobalControlManger enStr:ACVATIVEFIRST geStr:ACVATIVEFIRST] inview:self.view interval:1];
            return;
        }
        AntitheftinterfaceController *VC = [[AntitheftinterfaceController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 1){
        if(![MyDevicemanger shareManger].mainDevice.isConnecting ) {
            [Toast showToastMessage:[GlobalControlManger enStr:DEVICENOTCONNECTED geStr:DEVICENOTCONNECTED] inview:self.view interval:1];
         return;
        }
        BeeperSettingController *VC = [[BeeperSettingController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 2){
//        刚注册用户未添加车辆无法进入该界面
        if ([MyDevicemanger shareManger ].Devices.count == 0) {
            [Toast showToastMessage:[GlobalControlManger enStr:NO_DEVICE geStr:NO_DEVICE] inview:self.view interval:1];
            return;
        }
        EditDeviceInfoNewController *VC = [[EditDeviceInfoNewController alloc] init];
        VC.type = DeviceInfoDefault;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 3){
        if (![self.currentDevice.activation isEqualToString:@"3"])  {
             [Toast showToastMessage:[GlobalControlManger enStr:AIRMODE geStr:AIRMODE] inview:self.view interval:1]; return;
        }
        MangerMentController *VC = [MangerMentController new];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 4){
        if (![self.currentDevice.activation isEqualToString:@"3"]) {
            [Toast showToastMessage:[GlobalControlManger enStr:AIRMODE geStr:AIRMODE] inview:self.view interval:1];
            return;
        }else{
            self.isCurrenPageBluetoothOperation = YES;
            [self AIRPLANEMODE];
        }
    }else if (indexPath.row == 5){
        if(![self.currentDevice.activation isEqualToString:@"3"]) {
             [Toast showToastMessage:[GlobalControlManger enStr:ACVATIVEFIRST geStr:ACVATIVEFIRST] inview:self.view interval:1];
                return;
        }
        RidingViewContrller * VC = [[RidingViewContrller alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
        //将我们的storyBoard实例化，“Main”为StoryBoard的名称
//        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//
//        //将第二个控制器实例化，"SecondViewController"为我们设置的控制器的ID
//        HelloMapViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"HelloMapViewController"];
//
////        HelloMapViewController * vc = [[HelloMapViewController alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == 6){
        if(![self.currentDevice.activation isEqualToString:@"3"]) {
             [Toast showToastMessage:[GlobalControlManger enStr:ACVATIVEFIRST geStr:ACVATIVEFIRST] inview:self.view interval:1];
                return;
        }
         popularcityViewController * VC = [[popularcityViewController alloc]init];
        //        [weakSelf.navigationController pushViewController:weakSelf.searchController animated:YES];
        //      [weakSelf presentViewController:weakSelf.searchController animated:YES completion:nil];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
//开启飞行模式
-(void)AIRPLANEMODE
{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:[GlobalControlManger enStr:@"TURN ON AIRPLANE MODE?"geStr:@"TURN ON AIRPLANE MODE?"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sexMan = [UIAlertAction actionWithTitle:[GlobalControlManger enStr:@"Don’t Allow" geStr:@"Don’t Allow"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     }];
     UIAlertAction *sexWoman = [UIAlertAction actionWithTitle:[GlobalControlManger enStr: @"OK"geStr: @"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         
        [self requestSetWaring];
     }];
     [alertVC addAction:sexMan];
     [alertVC addAction:sexWoman];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}
//飞行模式警告
-(void)AIRPLANEWaring
{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:[GlobalControlManger enStr:@"warning!" geStr:@"warning!"] message:[GlobalControlManger enStr:YOUERINTOAIRPLANEMODE geStr:YOUERINTOAIRPLANEMODE]preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sexWoman = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [Toast showToastMessage:[GlobalControlManger enStr:@"Enter flight mode successful" geStr:@"Enter flight mode successful"]];
        [[GYBabyBluetoothManager sharedManager].babyBluetooth cancelAllPeripheralsConnection];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"air" object:nil];
        [self syncAirPModelToService];

    }];
    [alertVC addAction:sexWoman];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)syncAirPModelToService{
    [[NetworkingManger shareManger] postDataWithUrl:host(@"users/updateMode") para:@{@"id":@"5",@"inc_type":@"1"} success:^(NSDictionary * _Nonnull result) {
        NSLog(@"%@",result);
//
    } fail:^(NSError * _Nonnull error) {
        
    }];
}


//设置飞行模式
-(void)requestSetWaring
{
    
    if (![MyDevicemanger shareManger].mainDevice.isConnecting) {
        NSString *url = host(@"users/setAirplane");
         NSMutableDictionary *para =[[NSMutableDictionary alloc] init];
         [para setValue:[UserInfo shareUserInfo].token forKey:@"token"];
        [para setValue:[MyDevicemanger shareManger].mainDevice.device_imei == nil ? @"":[MyDevicemanger shareManger].mainDevice.device_imei forKey:@"imei"];
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             NSInteger stateCode = [result[@"code"] integerValue];
             NSString *msg = result[@"msg"];
             if (stateCode == 1) {
                 [self AIRPLANEWaring];
             }else{
                 if (![msg isEqualToString:@""]) {
                     [Toast showToastMessage:msg];
                 }
             }
         } fail:^(NSError * _Nonnull error) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }];
    }else{
        [[GYBabyBluetoothManager sharedManager] writeState:AIRPLANE_MODE_Bluetooth];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"air" object:nil userInfo:nil];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//蓝牙发送过来的信息
- (void)didReciveBluetoothMessageAction:(NSNotification *)notify{
   
    id obj = [[notify userInfo] objectForKey:@"type"];
    if ([obj isEqual:@(AIRPLANE_MODE_Bluetooth)]) {
        //查询IEME成功 发送查询ICCID
         [self AIRPLANEWaring];
    }
}



@end
