//
//  BlueBindingViewController.m
//  RoseRiding
//
//  Created by mac on 2020/4/28.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "BlueBindingViewController.h"
#import "UserInfoCell.h"
#import "GYBabyBluetoothManager.h"

@interface BlueBindingViewController () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIButton * attachBtn;
    NSString * macString;
    UILabel * promptLabel;
    UIView * headView, * line;
    UITextField * codeTextField;
    int devicenumber;
    int sec;

}
@property (nonatomic, strong) NSMutableArray <GYPeripheralInfo *>* dataSource; //蓝牙列表
@property (nonatomic, assign) BOOL          authSuccess;
@property (nonatomic, strong) UITableView      *userTable;
@property (nonatomic, strong) UIView           *maskView;
@property (nonatomic, strong) GYPeripheralInfo *currentSelectPeripheral; //当前选择的蓝牙
@property (nonatomic, assign) BOOL              isRealScanInCurrenPage;
@property (nonatomic, assign) BOOL              isConnecting;
@property (nonatomic, assign) BOOL             currentDeviceIsConnected;
@property (nonatomic, assign) BOOL             isActivating; //是否正在激活流程中
@property (nonatomic, strong) NSMutableArray *bluetootharray;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BlueBindingViewController


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     self.isRealScanInCurrenPage = NO;

    self.isActivating = NO;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)dealloc
{
    NSLog(@"销毁成功");
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    devicenumber = 0;
    
     self.barStyle = NavigationBarStyleWhite;
    self.title = self.activeBike.equipment;
     [self.view bringSubviewToFront:self.navView];
//    NSLog(@"bikeid________________%@",self.activeBike);
    
    [self setUI];
    [self requestbluename];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveBluetoothConnectFailMessage:) name:GYBabyBluetoothManagerConnectFailed object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveBluetoothConnectSuccessMessage:) name:GYBabyBluetoothManagerConnectSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveBluetoothMessageAction:) name:GYBabyBluetoothManagerRead object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bluetoothDeviceListUpdate:) name:GYBabyBluetoothManagerDevicesListUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noDeviceFound:) name:GYBabyBluetoothManagerNoDeviceFound object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert) name:GYBabyBluetoothManagerActivate object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changebutton:) name:BabyNotificationAtDidUpdateValueForCharacteristic object:nil];
    [[GYBabyBluetoothManager sharedManager].babyBluetooth cancelAllPeripheralsConnection];
}
- (void)Timered:(NSTimer*)timer {
    if (sec < 60) {
        sec +=1;
    }else{
        sec = 0;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        attachBtn.enabled = YES;
        [attachBtn setBackgroundColor:[UIColor blackColor]];
        return;
    }
}
- (void)showAlert{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [[GYBabyBluetoothManager sharedManager] connectPeripheral:self.currentSelectPeripheral.peripheral];
   attachBtn.enabled = YES;
   [attachBtn setBackgroundColor:[UIColor blackColor]];
}
-(void)setUI{

     macString = [[NSMutableString alloc]init];
    self.dataSource = [NSMutableArray new];
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight, UIWidth, 300)];

    [self.view addSubview:headView];
    
    promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UIWidth, 250)];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.textColor = [UIColor blackColor];
    promptLabel.font = [UIFont systemFontOfSize:24];
    promptLabel.numberOfLines = 0;
    [headView addSubview:promptLabel];
    codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 250, UIWidth-20, 50)];
     codeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    codeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    [codeTextField setTextColor:[UIColor blackColor]];
    codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    codeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    codeTextField.keyboardType = UIKeyboardTypeDefault;
    codeTextField.font = [UIFont systemFontOfSize:20];
    codeTextField.returnKeyType = UIReturnKeyDone;
    codeTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    codeTextField.delegate = self;
    [headView addSubview:codeTextField];
    line = [[UIView alloc] initWithFrame:CGRectMake(10,299, UIWidth-20, 1)];
    line.backgroundColor =kRGB(229, 229, 229,1);
    [headView addSubview:line];
    codeTextField.hidden = YES;
    line.hidden = YES;
    UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
    add.frame = CGRectMake(40, kNavHeight+350, UIWidth-80, 48);
    attachBtn = add;
    [self.view addSubview:add];
    [add setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [add setTitle:[GlobalControlManger enStr:@"Attach Bike" geStr:@"Attach Bike"] forState:UIControlStateNormal];
    add.backgroundColor =[UIColor blackColor];
    add.layer.cornerRadius = 8;
    kWeakSelf
    [[add rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf addBtn];
    }];
    
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
    title.text = @"Select Device";
    title.textColor = [UIColor colorWithHexString:@"#999999"];
    [contentView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(25);
        make.leading.equalTo(contentView).offset(28);
    }];
    self.userTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [contentView addSubview:self.userTable];
    [self.userTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(contentView);
        make.trailing.equalTo(contentView);
        make.top.equalTo(title.mas_bottom).offset(20);
        make.bottom.equalTo(contentView).offset(-40);
    }];
    [self.userTable registerNib:[UINib nibWithNibName:@"UserInfoCell" bundle:nil] forCellReuseIdentifier:@"UserInfoCell"];
    self.userTable.delegate = self;
    self.userTable.dataSource = self;
    self.userTable.tableFooterView = [UIView new];
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
}

- (void)requestbluename{
    kWeakSelf
        NSString *url = host(@"users/bluetoothName");
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSMutableDictionary * paradic =[NSMutableDictionary new];
        [paradic setValue:[UserInfo shareUserInfo].token forKey:@"token"];
        [[NetworkingManger shareManger] postDataWithUrl:url para:paradic success:^(NSDictionary * _Nonnull result) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSInteger stateCode = [result[@"code"] integerValue];
                NSString *msg = result[@"msg"];
                if (stateCode == 1) {
                    weakSelf.bluetootharray = result[@"data"];
                    NSLog(@"bluetoothName        %@",result[@"data"]);
                }else{
                    if (![msg isEqualToString:@""]) {
                        NSLog(@"verifyBluetooth---------%@",msg);
                        [Toast showToastMessage:msg];
    //                    NSLog(@"%@",msg);
                    }
                }
               } fail:^(NSError * _Nonnull error) {
                   self.isActivating = NO;
                   [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            }];
}
- (void)tapAction:(UITapGestureRecognizer *)gesture{
    [self.maskView removeFromSuperview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
            if ([self.dataSource[indexPath.row].advertisementData[@"kCBAdvDataLocalName"] isEqualToString:self.bluetootharray[indexPath.row][@"photo"]] ||[self.dataSource[indexPath.row].advertisementData[@"kCBAdvDataLocalName"] isEqualToString:self.bluename]) {
                   return 0;
               }else{
                 return Adaptive(64);
            }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof (self)weakSelf = self;
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.blueInfo = self.dataSource[indexPath.row];
    NSLog(@"%@", self.dataSource[indexPath.row].advertisementData[@"kCBAdvDataLocalName"]);
    if ([self.dataSource[indexPath.row].advertisementData[@"kCBAdvDataLocalName"] isEqualToString:self.bluetootharray[indexPath.row][@"photo"]] ||[self.dataSource[indexPath.row].advertisementData[@"kCBAdvDataLocalName"] isEqualToString:self.bluename] ) {
            cell.hidden = YES;
        }else{
            devicenumber += 1;
            if (devicenumber == 0) {
            [Toast showToastMessage:[GlobalControlManger enStr:@"No device" geStr:@"No device"]];
            }
        }
    cell.add = ^{
//        NSLog(@"%@",self.activeBike.equipment);
         self.timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Timered:) userInfo:nil repeats:YES];
        [self.timer setFireDate:[NSDate distantPast]];
        [weakSelf.maskView removeFromSuperview];
        weakSelf.currentSelectPeripheral = weakSelf.dataSource[indexPath.row];
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
//        [Toast showToastMessage:@"Please wait while the device is activated. . ." inview:self.view interval:5];
        self->attachBtn.enabled = NO;
        [self->attachBtn setBackgroundColor:[UIColor grayColor]];
        [[GYBabyBluetoothManager sharedManager] disconnectAllPeripherals];
        GYPeripheralInfo *info  = weakSelf.currentSelectPeripheral;
        [weakSelf macstring:info.advertisementData];
        self->_bluename = info.advertisementData[@"kCBAdvDataLocalName"];
        [[GYBabyBluetoothManager sharedManager] connectPeripheral:info.peripheral];
        self.isConnecting = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.isConnecting && !self.currentDeviceIsConnected) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [Toast showToastMessage:@"connect timeout" inview:self.view interval:1];
            }
            self.isConnecting = NO;
            self->attachBtn.enabled = YES;
            [self->attachBtn setBackgroundColor:[UIColor blackColor]];
//            self->attachBtn.userInteractionEnabled = YES;
        });
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)changebutton :(NSNotification*)notify{
    NSLog(@"%@",notify.object);
//    if ([[notify.object objectForKey:@"error"] isEqualToString:@""]) {
//        return;
//    }else{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [[GYBabyBluetoothManager sharedManager] connectPeripheral:self.currentSelectPeripheral.peripheral];
    attachBtn.enabled = YES;
        [attachBtn setBackgroundColor:[UIColor blackColor]];
//    }
//    [Toast showToastMessage:notify.object[@"error"]];
}
-(void)addBtn{
    if ([[attachBtn currentTitle] isEqualToString:[GlobalControlManger enStr:@"Attach Bike" geStr:@"Attach Bike"]]) {
//        NSLog(@"点击了按钮Attach Bike");
        self.isRealScanInCurrenPage = YES;
       [self startBlue];
    }
    else if ([[attachBtn currentTitle] isEqualToString:@"O K"])
    {
//       return;
        [self.navigationController popToViewController:self animated:YES];
        return;
    }
    else
    {
        if (self.dataSource.count > 0 && codeTextField.text.length > 0) {
            [codeTextField resignFirstResponder];
            [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
        }else if (codeTextField.text.length == 0)
        {
            attachBtn.enabled = NO;
            [attachBtn setBackgroundColor:[UIColor lightGrayColor]];
            [Toast showToastMessage:[GlobalControlManger enStr:@"Input Activation Code" geStr:@"Input Activation Code"]];
            return;
        }
    }
}
//获取蓝牙设备MAC地址
-(void)macstring:(NSDictionary *)advertisementData
{
    NSDictionary*dic = advertisementData[@"kCBAdvDataManufacturerData"];
    if( dic ) {
        @try {
            NSData*data = advertisementData[@"kCBAdvDataManufacturerData"];
            const int MAC_BYTE_LENGTH =6;
            Byte bytes[MAC_BYTE_LENGTH +1] = {0};
            if([data length] >= MAC_BYTE_LENGTH) {
                [data getBytes:bytes range:NSMakeRange([data length] - MAC_BYTE_LENGTH, MAC_BYTE_LENGTH)];
                NSMutableArray *macs = [NSMutableArray array];
                for(int i =0;i < MAC_BYTE_LENGTH ;i ++) {
                    NSString * strByte = [NSString stringWithFormat:@"%02x",bytes[MAC_BYTE_LENGTH-i-1]];
                    [macs addObject:strByte];
                }
                //                macString = [macs componentsJoinedByString:@":"];
                macString = [self convertDataToHexStr:data];
            }
            
//            NSMutableString *strTemp = [NSMutableString stringWithCapacity:[data length]*2];
//
//            const unsigned char *szBuffer = [data bytes];
//
//            for (NSInteger i=0; i < [data length]; ++i) {
//
//                [strTemp appendFormat:@"%02lx",(unsigned long)szBuffer[i]];
//
//            }
            
        } @catch (NSException *exception) {
                             
        }
    }
}

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

//开启蓝牙扫描
-(void)startBlue
{
    attachBtn.enabled = NO;
    [attachBtn setBackgroundColor:[UIColor lightGrayColor]];
    [[GYBabyBluetoothManager sharedManager] stopScanPeripheral];
    [[GYBabyBluetoothManager sharedManager] startScanPeripheral];
}
//统一异常处理
-(void)exceptionHandling
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
     promptLabel.text = @"Sorry, but there seems to be a technical problem.\n Please contact ROSE customer support for help.";
    codeTextField.hidden =YES;
    line.hidden = YES;
    attachBtn.enabled = YES;
//    [Toast showToastMessage:@" Bluetooth connection Failed "];

    attachBtn.backgroundColor =[UIColor blackColor];
    [attachBtn setTitle:@"O K" forState:UIControlStateNormal];
}

//扫描不到信息处理
-(void)timeOutHandling
{
    promptLabel.text =@"Bike could not be detected.Please charge it first with usb charger.";
    attachBtn.enabled = NO;
    [attachBtn setBackgroundColor:[UIColor lightGrayColor]];
}
#pragma mark -- GYBabyBluetoothManagerDelegate
#pragma mark GYBabyBluetoothManagerDelegate 代理回调
//蓝牙连接失败 或者中断
- (void)didReciveBluetoothConnectFailMessage:(NSNotification *)notify{
//    [self exceptionHandling];
    [self.timer setFireDate:[NSDate distantFuture]];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MyDevicemanger shareManger].mainDevice.isConnecting = NO;
    [Toast showToastMessage:@"connect failed" inview:self.view interval:1];
    attachBtn.enabled = YES;
    [attachBtn setBackgroundColor:[UIColor blackColor]];
}
//蓝牙连接成功
- (void)didReciveBluetoothConnectSuccessMessage:(NSNotification *)notify{
  
    //连接成功
//    NSLog(@"连接成功--------%@",notify);
//    [Toast showToastMessage:[GlobalControlManger enStr:BLUE_SUCCESS geStr:BLUE_SUCCESS]];
//    attachBtn.enabled = YES;
//    [attachBtn setBackgroundColor:[UIColor blackColor]];
    //查询IEME
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (self.isRealScanInCurrenPage) {
        self.activeBike.isConnecting = YES;
        [MyDevicemanger shareManger].mainDevice = self.activeBike;
        [[GYBabyBluetoothManager sharedManager] writeState:IMEI_Bluetooth];
        self.currentDeviceIsConnected = YES;
        [self.timer setFireDate:[NSDate distantFuture]];
        
//        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//蓝牙发送过来的信息
- (void)didReciveBluetoothMessageAction:(NSNotification *)notify{
    [self.timer setFireDate:[NSDate distantFuture]];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (!self.isRealScanInCurrenPage) {
        return;
    }
   
    id obj = [[notify userInfo] objectForKey:@"type"];
 
    if ([obj isEqual:@(IMEI_Bluetooth)]) {
        //查询IEME成功 发送查询ICCID
        //更新蓝牙状态
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [[GYBabyBluetoothManager sharedManager] writeState:ICCID_Bluetooth];
        });
    }else if([obj isEqual:@(ICCID_Bluetooth)]){
        //绑定
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //激活sim卡
        if (self.isActivating) {
            return;
        }
        [self requestVerifyBluetooth];
    }else if ([obj isEqual:@(AUTHEBTICATION_Bluetooth)])  {//蓝牙鉴权 去除前端鉴权
        
    }else if ([obj isEqual:@(UnKonwnMessageType)]){
        
    }
  [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)sysytemBluetoothOpen {
    // 系统蓝牙已开启、开始扫描周边的蓝牙设备
    [[GYBabyBluetoothManager sharedManager] startScanPeripheral];
}
-  (void)noDeviceFound:(NSNotification *)notify{
    if (self.isRealScanInCurrenPage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Toast showToastMessage:@"Device Not Found"];
        });
    }
    attachBtn.enabled = YES;
    [attachBtn setBackgroundColor:[UIColor blackColor]];
}

- (void)bluetoothDeviceListUpdate:(NSNotification *)notify{    
    NSArray <GYPeripheralInfo *>*peripheralInfoArr = notify.object;
    for (GYPeripheralInfo *info in peripheralInfoArr) {
//         NSLog(@"name = ---------------->%@",info.peripheral.name);
     }
     codeTextField.hidden = YES;
     line.hidden = YES;
     attachBtn.enabled = NO;
     attachBtn.backgroundColor =[UIColor lightGrayColor];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
     if (self.dataSource.count>0) {
         [self.dataSource removeAllObjects];
     }
     [self.dataSource addObjectsFromArray:peripheralInfoArr];
//     if (peripheralInfoArr.count == 1) {
         codeTextField.hidden = NO;
         line.hidden = NO;
         promptLabel.text = [GlobalControlManger enStr:@"Input Activation Code􏰀􏰁􏰂􏰃" geStr:@"Input Activation Code􏰀􏰁􏰂􏰃"];
         attachBtn.enabled = YES;
         attachBtn.backgroundColor =[UIColor blackColor];
         [attachBtn setTitle:@"OK" forState:UIControlStateNormal];
//     }
//         else if (peripheralInfoArr.count > 1){
//         promptLabel.text = @"There are more than one bike nearby.\nPlease move your bike to another location which is at least 15 meters from here.";
////         [attachBtn setTitle:@"Attach Bike" forState:UIControlStateNormal];
//        attachBtn.enabled = YES;
//
//         attachBtn.backgroundColor =[UIColor blackColor];
//         [attachBtn setTitle:@"O K" forState:UIControlStateNormal];
//     }
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField
{
    
    if (textField.tag == 1) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
        
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == codeTextField) {
        if (textField.text.length > 0) {
            attachBtn.enabled = YES;
            [attachBtn setBackgroundColor:[UIColor blackColor]];
        }
    }
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark --request
//校验设备
-(void)requestVerifyBluetooth
{
    if ([[GYBabyBluetoothManager sharedManager] getICCD] == nil) {
        [[GYBabyBluetoothManager sharedManager] writeState:ICCID_Bluetooth];
        return;
    }
    if ([[GYBabyBluetoothManager sharedManager] getIMEI] == nil) {
        [[GYBabyBluetoothManager sharedManager] writeState:IMEI_Bluetooth];
        return;
    }
 self.isActivating = YES;
    kWeakSelf
    NSString *url = host(@"users/verifyBluetooth");
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary * paradic =[NSMutableDictionary new];
    [paradic setValue:[UserInfo shareUserInfo].token forKey:@"token"];
    [paradic setValue:self.activeBike.Id forKey:@"id"];
    [paradic setValue:[[GYBabyBluetoothManager sharedManager] getICCD] forKey:@"iccid"];
    [paradic setValue:[[GYBabyBluetoothManager sharedManager] getIMEI]forKey:@"imei"];
    [paradic setValue:[[GYBabyBluetoothManager sharedManager] getIMEIHash] forKey:@"hash"];
    NSLog(@"哈希%@",[[GYBabyBluetoothManager sharedManager] getIMEIHash]);
    [paradic setValue:macString forKey:@"mac_id"];
    [[NetworkingManger shareManger] postDataWithUrl:url para:paradic success:^(NSDictionary * _Nonnull result) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSInteger stateCode = [result[@"code"] integerValue];
            NSString *msg = result[@"msg"];
            if (stateCode == 1) {
                [weakSelf activiceDevice];
            }else{
                if (![msg isEqualToString:@""]) {
//                    NSLog(@"verifyBluetooth---------%@",msg);
                    [Toast showToastMessage:msg];
                    self->attachBtn.enabled = YES;
                    [self->attachBtn setBackgroundColor:[UIColor blackColor]];
//                    NSLog(@"%@",msg);
                }
                self.isActivating = NO;
            }
           } fail:^(NSError * _Nonnull error) {
               self.isActivating = NO;
               [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }];
}
- (void)activiceDevice{
   
    kWeakSelf
    if (self->_bluename == nil) {
        return;
    }
    NSString *url = host(@"users/getSimmsg");
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     NSMutableDictionary * paradic =[NSMutableDictionary new];
     [paradic setValue:[UserInfo shareUserInfo].token forKey:@"token"];
//    NSLog(@"activeBike----------------%@",self.activeBike.Id);
    [paradic setValue:self.activeBike.Id forKey:@"id"];
    [paradic setValue:self->_bluename forKey:@"photo"];
     [paradic setValue:[[GYBabyBluetoothManager sharedManager] getICCD] forKey:@"iccid"];
    [paradic setValue:codeTextField.text forKey:@"auth_code"];
     [[NetworkingManger shareManger] postDataWithUrl:url para:paradic success:^(NSDictionary * _Nonnull result) {
         [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
             NSInteger stateCode = [result[@"code"] integerValue];
             NSString *msg = result[@"msg"];
        
             if (stateCode == 1) {
                 [Toast showToastMessage:[GlobalControlManger enStr:@"Active success" geStr:@"Active success"] inview:weakSelf.view interval:1];
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"activatesuccess" object:nil];
                  [weakSelf requestCheckBluetooth];
                 if (weakSelf.success) {
                     weakSelf.success();
                 }
                 [weakSelf goBack];
                 return;
             }else{
                self.isActivating = NO;
                 self->attachBtn.enabled = YES;
                 [self->attachBtn setBackgroundColor:[UIColor blackColor]];
                if (![msg isEqualToString:@""]) {
                    [Toast showToastMessage:msg];
//                   NSLog(@"getSimmsg---------%@",msg);
                    self->attachBtn.enabled = YES;
                    [self->attachBtn setBackgroundColor:[UIColor blackColor]];
                }
             }
            } fail:^(NSError * _Nonnull error) {
                self.isActivating = NO;
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
         }];
}


//更新蓝牙状态
-(void)requestCheckBluetooth
{
    kWeakSelf
    NSString *url = host(@"users/checkBluetooth");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetworkingManger shareManger] postDataWithUrl:url para:@{@"token":[UserInfo shareUserInfo].token,@"id":self.activeBike.Id,@"mac_id":macString} success:^(NSDictionary * _Nonnull result) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            NSInteger stateCode = [result[@"code"] integerValue];
            NSString *msg = result[@"msg"];
        
            if (stateCode == 1) {
                
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"activatesuccess" object:nil];
//                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                if (![msg isEqualToString:@""]) {
                    NSLog(@"checkBluetooth---------%@",msg);
                    [Toast showToastMessage:msg];
                }
                self->attachBtn.enabled = YES;
                [self->attachBtn setBackgroundColor:[UIColor blackColor]];
            }
           } fail:^(NSError * _Nonnull error) {
               [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }];
}




@end
