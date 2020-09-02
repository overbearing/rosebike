//
//  WorkingModeListController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/12.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "WorkingModeListController.h"
#import "WorkModelListCell.h"
#import "WorkModel.h"


@interface WorkingModeListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray <WorkModel *>*list;
@property (nonatomic , assign)BOOL  isCurrenPageBluetoothOperation;
@end

@implementation WorkingModeListController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isCurrenPageBluetoothOperation = NO;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isCurrenPageBluetoothOperation = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveBluetoothMessageAction:) name:GYBabyBluetoothManagerRead object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterairmode:) name:@"enterairplanemode" object:nil];
    [self initUI];
    [self getCurrentWorkMode];
}

- (void)enterairmode:(NSNotification * )notify{
    if(!self.isCurrenPageBluetoothOperation){
        return;
    }
    [self AIRPLANEWaring];
}
- (void)initUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIWidth, 60)];
    self.tableView.tableHeaderView = head;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"WorkModelListCell" bundle:nil] forCellReuseIdentifier:@"WorkModelListCell"];
    self.tableView.separatorColor = [UIColor clearColor];
}

- (void)viewWillLayoutSubviews{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WorkModel *m = self.list[indexPath.row];
    if (m.desc != nil) {
         return Adaptive(73);
    }else{
        return Adaptive(58);
    }
    return Adaptive(58);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WorkModelListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkModelListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [cell configureWithIndexpath:indexPath];
    cell.model = self.list[indexPath.row];
   
    //    if (indexPath.row == 3 || indexPath.row == 4) {
//        cell.userInteractionEnabled = YES;
        cell.trans = ^{
            if (indexPath.row == 2) {
                NSLog(@"进入省电模式");
                [self PAWERSAVINGMODE];
            }else if(indexPath.row == 3) {
                if ([MyDevicemanger shareManger].mainDevice.isConnecting) {
                   [self INSTALLATIONMODE];
                }else{
                    [self enterInstall];
                }
                NSLog(@"进入安装模式");
            }else if (indexPath.row == 4) {
                 if (![[MyDevicemanger shareManger].mainDevice.is_default isEqualToString:@"2" ] ||[[MyDevicemanger shareManger].mainDevice.Id isEqualToString:@"0"]   ) {
                           [Toast showToastMessage:[GlobalControlManger enStr:AIRMODE geStr:AIRMODE] inview:self.view interval:1];
//                           return;
                 }else{
                     [self AIRPLANEMODE];
                }
            }
            [self.tableView reloadData];
        };
//    }else{
//        cell.userInteractionEnabled = NO;
//    }
    return cell;
}
//安装模式接口
- (void)enterInstall{
    [[NetworkingManger shareManger] postDataWithUrl:host(@"users/SetShake") para:@{@"imei":[MyDevicemanger shareManger].mainDevice.device_imei == nil ? @"":[MyDevicemanger shareManger].mainDevice.device_imei } success:^(NSDictionary * _Nonnull result) {
        if (![result[@"msg"]isEqualToString:@""]) {
            [Toast showToastMessage:result[@"msg"]];
        }
        if ([result[@"code"]isEqualToString:@"1"]) {
             [self getCurrentWorkMode];
        }
          
       } fail:^(NSError * _Nonnull error) {
           
       }];
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
        [self syncAirPModelToService:@"5"];
    }];
    [alertVC addAction:sexWoman];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)syncAirPModelToService:(NSString *)typeid{
    [[NetworkingManger shareManger] postDataWithUrl:host(@"users/updateMode") para:@{@"id":typeid,@"inc_type":@"1"} success:^(NSDictionary * _Nonnull result) {
        if ([typeid isEqualToString:@"5"]) {
            [Toast showToastMessage:[GlobalControlManger enStr:@"Enter flight mode successful" geStr:@"Enter flight mode successful"]];
        }else if ([typeid isEqualToString:@"4"]){
             [Toast showToastMessage:@"The device has entered the installation mode"];
        }else if ([typeid isEqualToString:@"3"]){
            [Toast showToastMessage:@"Device has entered power saving mode"];
        }
        [self getCurrentWorkMode];
    } fail:^(NSError * _Nonnull error) {
        
    }];
}
//开启安装模式
-(void)INSTALLATIONMODE
{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:[GlobalControlManger enStr:@"TURN ON INSTALLATION MODE?"geStr:@"TURN ON INSTALLATION MODE?"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sexMan = [UIAlertAction actionWithTitle:[GlobalControlManger enStr:@"Don’t Allow" geStr:@"Don’t Allow"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     }];
     UIAlertAction *sexWoman = [UIAlertAction actionWithTitle:[GlobalControlManger enStr: @"OK"geStr: @"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

//         [[GYBabyBluetoothManager sharedManager] writeState:CLOSE_CAR_THIEF_Bluetooth];
//         [[GYBabyBluetoothManager sharedManager] writeState:CLOSE_ROLLOVER_Bluetooth];
//         [[GYBabyBluetoothManager sharedManager] writeState:CLOSE_VIBRATION_Bluetooth];
       
     }];
    

     [alertVC addAction:sexMan];
     [alertVC addAction:sexWoman];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}
//开启省电模式
-(void)PAWERSAVINGMODE
{
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:[GlobalControlManger enStr:@"TURN ON PAWERSAVING MODE?"geStr:@"TURN ON PAWERSAVING MODE?"] preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *sexMan = [UIAlertAction actionWithTitle:[GlobalControlManger enStr:@"Don’t Allow" geStr:@"Don’t Allow"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     }];
     UIAlertAction *sexWoman = [UIAlertAction actionWithTitle:[GlobalControlManger enStr: @"OK"geStr: @"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

         [[GYBabyBluetoothManager sharedManager] writeState:OPEN_PAWERSAVING_Bluetooth];
       
     }];
    

     [alertVC addAction:sexMan];
     [alertVC addAction:sexWoman];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
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
//         [self AIRPLANEWaring];
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
//    else if ([obj isEqual:@(CLOSE_VIBRATION_Bluetooth)]||[obj isEqual:@(CLOSE_CAR_THIEF_Bluetooth)]||[obj isEqual:@(CLOSE_ROLLOVER_Bluetooth)]){
//         [self syncAirPModelToService:@"4"];
//       
//    }
    else if([obj isEqual:@(PAWERSAVING_Bluetooth)]){
         [self syncAirPModelToService:@"3"];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     
}

- (void)getCurrentWorkMode{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetworkingManger shareManger] postDataWithUrl:host(@"users/workmodeList") para:@{} success:^(NSDictionary * _Nonnull result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.list = [WorkModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        [self.tableView reloadData];
    } fail:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
