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


@interface MenuController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation MenuController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.tableView) {
        [self.tableView reloadData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    // Do any additional setup after loading the view.
    self.barStyle = NavigationBarStyleWhite;
    self.title = @"Menu";
    self.leftButton.hidden = YES;
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveBluetoothMessageAction:) name:GYBabyBluetoothManagerRead object:nil];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
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
    if (indexPath.row != 2) {
//        if (![[MyDevicemanger shareManger].mainDevice.activation isEqualToString:@"3"]) {
//            [Toast showToastMessage:@"device nonactivated" inview:self.view interval:1];
//            return;
//        }
    }
    
    if (indexPath.row == 0) {
        
        AntitheftinterfaceController *VC = [[AntitheftinterfaceController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 1){
        
        BeeperSettingController *VC = [[BeeperSettingController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 2){
//        刚注册用户未添加车辆无法进入该界面
        if ([MyDevicemanger shareManger ].Devices.count == 0) {
            [Toast showToastMessage:NO_DEVICE inview:self.view interval:1];
            return;
        }
        EditDeviceInfoNewController *VC = [[EditDeviceInfoNewController alloc] init];
        VC.type = DeviceInfoDefault;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 3){
        MangerMentController *VC = [MangerMentController new];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 4){
       
        [self AIRPLANEMODE];
    }
        
    
}



//开启飞行模式
-(void)AIRPLANEMODE
{
    
   UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:@"\nTURN ON AIRPLANE MODE?\n\n" preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *sexMan = [UIAlertAction actionWithTitle:@"Don’t Allow" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     }];
     UIAlertAction *sexWoman = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [self requestSetWaring];
     }];
    

     [alertVC addAction:sexMan];
     [alertVC addAction:sexWoman];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}
//飞行模式警告
-(void)AIRPLANEWaring
{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"WARNING!" message:@"You are entering AIRPLANE mode. You can exit the airplane mode by using a power bank ONLY." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sexWoman = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:sexWoman];
    [self presentViewController:alertVC animated:YES completion:nil];
    [self syncAirPModelToService];
}

- (void)syncAirPModelToService{
    [[NetworkingManger shareManger] postDataWithUrl:host(@"users/setSecurity") para:@{@"id":@"5",@"inc_type":@"1"} success:^(NSDictionary * _Nonnull result) {
        
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
         [para setValue:[MyDevicemanger shareManger].mainDevice.device_imei forKey:@"imei"];
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
        [self AIRPLANEMODE];
    }
}



@end
