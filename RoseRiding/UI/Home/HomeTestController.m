//
//  HomeTestController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/5/1.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "HomeTestController.h"
#import "LoginController.h"
#import "GYBabyBluetoothManager.h"


@interface HomeTestController ()<UITableViewDelegate,UITableViewDataSource>
{
    GYBabyBluetoothManager * _babyMgr;
}


@property (nonatomic, strong) UIButton * startBtn;
@property (nonatomic, strong) UIButton * sendBtn;
@property (nonatomic, strong) UIButton * endBtn;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * senddataSource;
@property (nonatomic, strong) UITableView * sendtableView;

@property (nonatomic, strong)dispatch_source_t timer;

@property (nonatomic, strong) GYBabyBluetoothManager * babyMgr;
@end

@implementation HomeTestController



#pragma mark lazy - load
- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

-(NSMutableArray *)senddataSource
{
    if (!_senddataSource) {
        _senddataSource = [NSMutableArray new];
    }
    return _senddataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hideNavigationView = YES;
    
    
//    [self creatBlueManger];
    [self creatTableView];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveCharacteristicAction:) name:BabyNotificationAtDidUpdateNotificationStateForCharacteristic object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveCharacteristicAction:) name:BabyNotificationAtDidUpdateValueForCharacteristic object:nil];
   
    
    
    
}

-(void)creatTableView
{
    
    
    UIButton *startBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
       [startBtn setTitle:@"开启蓝牙扫描" forState:(UIControlStateNormal)];
       [startBtn setTitleColor:[UIColor colorWithHexString:@"#4B4B4B"] forState:(UIControlStateNormal)];
       startBtn.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
       [self.view addSubview:startBtn];
       self.startBtn = startBtn;
       [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.view.mas_top).offset(kNavHeight);
           make.trailing.equalTo(self.view).offset(-Adaptive(65));
           make.leading.equalTo(self.view).offset(Adaptive(65));
           make.height.equalTo(@48);
       }];
       self.startBtn.layer.cornerRadius = 2;
    
    [[self.startBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(UIButton *sender) {
    
        [self startBlue];
    }];
    
    
    
  
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,kNavHeight+48, UIWidth, 176) style:UITableViewStylePlain];
//    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor grayColor] ;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    self.tableView.tag =1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    UIButton *sendBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [sendBtn setTitle:@"发送消息" forState:(UIControlStateNormal)];
    [sendBtn setTitleColor:[UIColor colorWithHexString:@"#4B4B4B"] forState:(UIControlStateNormal)];
    sendBtn.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [self.view addSubview:sendBtn];
    self.sendBtn = sendBtn;
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(self.tableView.mas_bottom).offset(10);
             make.left.equalTo(self.view.mas_left).offset(0);

             make.width.equalTo(@(UIWidth/2));
              make.height.equalTo(@48);
    }];
    self.sendBtn.layer.cornerRadius = 2;
      
      [[self.sendBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(UIButton *sender) {
      
          [self sendAction:sender];
      }];
    
    
    
    
          UIButton *endBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
         [endBtn setTitle:@"断开连接" forState:(UIControlStateNormal)];
         [endBtn setTitleColor:[UIColor colorWithHexString:@"#4B4B4B"] forState:(UIControlStateNormal)];
         endBtn.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
         [self.view addSubview:endBtn];
         self.endBtn = endBtn;
         [self.endBtn mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(self.tableView.mas_bottom).offset(10);
             make.right.equalTo(self.view.mas_right).offset(0);
            make.width.equalTo(@(UIWidth/2));
             make.height.equalTo(@48);
             
         }];
         self.endBtn.layer.cornerRadius = 2;
      
      [[self.endBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(UIButton *sender) {
      
          [self disconnectAction:sender];

      }];
    
    
    self.sendtableView = [[UITableView alloc] initWithFrame:CGRectMake(0,kNavHeight+48, UIWidth, 176) style:UITableViewStylePlain];
    //    self.tableView.bounces = NO;
    //        self.sendtableView.showsVerticalScrollIndicator = NO;
    self.sendtableView.backgroundColor = [UIColor yellowColor] ;
    self.sendtableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    self.sendtableView.tag =2;
    self.sendtableView.delegate = self;
    self.sendtableView.dataSource = self;
        [self.view addSubview:self.sendtableView];
    [self.sendtableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.endBtn.mas_bottom).offset(0);
                make.trailing.equalTo(self.view).offset(-Adaptive(0));
                make.leading.equalTo(self.view).offset(Adaptive(0));
                make.height.equalTo(@200);
                
            }];
    
    self.sendBtn.hidden = YES;
    self.endBtn.hidden = YES;
}

#pragma marl -- UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (tableView.tag == 1) {
       return self.dataSource.count;
    } else {
       return self.senddataSource.count;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  
    if (tableView.tag == 1) {
        
             static NSString *linecellidentify = @"PPSettingLineCell";
             UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:linecellidentify];
             if(cell == nil)
             {
                 cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:linecellidentify];
                 cell.accessoryType=UITableViewCellAccessoryNone;
                 cell.selectionStyle = UITableViewCellSelectionStyleNone;
             }
        GYPeripheralInfo *info = self.dataSource[indexPath.row];
         if ([info.advertisementData objectForKey:@"kCBAdvDataLocalName"])
         {
                cell.textLabel.text =   [info.advertisementData objectForKey:@"kCBAdvDataLocalName"];
         } else {
                 cell.textLabel.text =   info.peripheral.name;
         }

         cell.textLabel.textColor = [UIColor blackColor];
             return cell ;
    }else
    {

             static NSString *sendlidentify = @"sendCell";
             UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sendlidentify];
             if(cell == nil)
             {
                 cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sendlidentify];
                 cell.accessoryType=UITableViewCellAccessoryNone;
                 cell.selectionStyle = UITableViewCellSelectionStyleNone;
             }
       
        NSString * string = self.senddataSource[indexPath.row];
        
        cell.textLabel.text = string;
         cell.textLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor redColor];
             return cell ;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 1) {
          GYPeripheralInfo *info = self.dataSource[indexPath.row];
        
         // 去连接当前选择的Peripheral
         [_babyMgr connectPeripheral:info.peripheral];
    } else {
        
        if (indexPath.row == 0) {
            
            _babyMgr.bluetoohh_type = IMEI_Bluetooth;
        } else if(indexPath.row == 1){
            _babyMgr.bluetoohh_type = ICCID_Bluetooth;
        }else if (indexPath.row == 2)
        {
            _babyMgr.bluetoohh_type = AUTHEBTICATION_Bluetooth;
        }else if (indexPath.row == 3)
        {
            _babyMgr.bluetoohh_type = NOT_WARING_Bluetooth;
        }else if (indexPath.row == 4)
        {
            _babyMgr.bluetoohh_type = LOOKING_CAR_Bluetooth;
        }else if (indexPath.row == 5)
        {
            _babyMgr.bluetoohh_type = AIRPLANE_MODE_Bluetooth;
        }
    }

   
}


-(GYBabyBluetoothManager *)babyMgr
{
    if (_babyMgr == nil) {
        
        _babyMgr = [GYBabyBluetoothManager sharedManager];
          _babyMgr.delegate = self;
    }
    return _babyMgr;
}


#pragma mark -- 蓝牙连接协议
//开始蓝牙扫描
-(void)startBlue
{
    
//    [self requestList];
//    [self beginCountdown];
    
//    LoginController * vc = [LoginController new];
//    self.definesPresentationContext = YES;
//    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//
//    [self presentViewController:vc animated:NO completion:Nil];
   
    
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    
    [self.babyMgr stopScanPeripheral];
    [self.babyMgr startScanPeripheral];
    
    
//    [self connectSuccess];
}


-(void)alartstring:(NSString *)string
{
        __weak  HomeTestController  * wSelf = self;
        UIAlertController * alart = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *conform = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if ([string isEqualToString:@"蓝牙连接成功"]) {
                wSelf.startBtn.enabled = NO;
                wSelf.sendBtn.hidden = NO;
                wSelf.endBtn.hidden = NO;
            } else {
                wSelf.startBtn.enabled = YES;
                wSelf.sendBtn.hidden = YES;
                wSelf.endBtn.hidden = YES;
            }

          }];
         
          //3.将动作按钮 添加到控制器中
          [alart addAction:conform];
       
      
      
      [self presentViewController:alart animated:YES completion:nil];
}


#pragma mark -- request
-(void)requestList
{
    [[NetworkingManger shareManger] postDataWithUrl:@"http://leopard.hbhb.vip/api/bicycle/equimentList" para:@{@"token":@"2b3eba5e078086f625b63124f3afd3c6ea53876e"} success:^(NSDictionary * _Nonnull result) {
        
        if ([result[@"code"] integerValue] != 1) {
            
        }else{
            
            NSDictionary * dict =[[NSDictionary alloc] initWithDictionary:result[@"data"]];
           
        }
       
        
    } fail:^(NSError * _Nonnull error) {
        
        NSLog(@"错误信息 ==%@",[error localizedDescription]);
    }];
}


-(void)requestverify
{
    
     [[NetworkingManger shareManger] postDataWithUrl:@"http://leopard.hbhb.vip/api/users/verifyBluetooth" para:@{@"token":@"2b3eba5e078086f625b63124f3afd3c6ea53876e",@"id":@"2",@"iccid":[_babyMgr getIMEI],@"imei":[_babyMgr getICCD]} success:^(NSDictionary * _Nonnull result) {
            
            if ([result[@"code"] integerValue] != 1) {
                
            }else{
                
//                                                 NSDictionary * dict =[[NSDictionary alloc] initWithDictionary:result[@"data"]];
               
                [self requestcheck];
            }
           
            
        } fail:^(NSError * _Nonnull error) {
            
            NSLog(@"错误信息 ==%@",[error localizedDescription]);
        }];
    
    
}

-(void)requestcheck
{
    [[NetworkingManger shareManger] postDataWithUrl:@"http://leopard.hbhb.vip/api/users/checkBluetooth" para:@{@"token":@"2b3eba5e078086f625b63124f3afd3c6ea53876e",@"id":@"2"} success:^(NSDictionary * _Nonnull result) {
               
               if ([result[@"code"] integerValue] != 1) {
                   
               }else{
                   
                   NSDictionary * dict =[[NSDictionary alloc] initWithDictionary:result[@"data"]];
                  
               }
              
               
           } fail:^(NSError * _Nonnull error) {
               
               NSLog(@"错误信息 ==%@",[error localizedDescription]);
           }];
    
}





// 十六进制转换为普通字符串的。
- (NSString *)stringFromHexString:(NSString *)hexString {
        
        char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
        bzero(myBuffer, [hexString length] / 2 + 1);
        for (int i = 0; i < [hexString length] - 1; i += 2) {
            unsigned int anInt;
            NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
            NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
            [scanner scanHexInt:&anInt];
            myBuffer[i / 2] = (char)anInt;
        }
        NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];

        return unicodeString;
    }

    // NSData转16进制 第一种
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



#pragma mark HKBabyBluetoothManageDelegate 代理回调
- (void)systemBluetoothClose {
    // 系统蓝牙被关闭、提示用户去开启蓝牙
}

- (void)sysytemBluetoothOpen {
    // 系统蓝牙已开启、开始扫描周边的蓝牙设备
    [_babyMgr startScanPeripheral];
}

- (void)getScanResultPeripherals:(NSArray *)peripheralInfoArr {
    // 这里获取到扫描到的蓝牙外设数组、添加至数据源中
    if (self.dataSource.count>0) {
        [self.dataSource removeAllObjects];
    }
    
    [self.dataSource addObjectsFromArray:peripheralInfoArr];
    [self.tableView reloadData];
    
    
    for (GYPeripheralInfo * info in self.dataSource) {
        
        [self macstring:info.advertisementData];
    }
    

    
   
}



-(void)macstring:(NSDictionary *)advertisementData
{
//    NSDictionary * advertisementData = dics[@"advertisementData"];
    NSDictionary*dic = advertisementData[@"kCBAdvDataManufacturerData"];
    if( dic ) {
        @try {
            NSData*data = advertisementData[@"kCBAdvDataManufacturerData"];
            const int MAC_BYTE_LENGTH =6;
            Byte   bytes[MAC_BYTE_LENGTH +1] = {0};
            if([data length] >= MAC_BYTE_LENGTH) {
                [data getBytes:bytes range:NSMakeRange([data length] - MAC_BYTE_LENGTH, MAC_BYTE_LENGTH)];
                NSMutableArray *macs = [NSMutableArray array];
                for(int i =0;i < MAC_BYTE_LENGTH ;i ++) {
                    NSString * strByte = [NSString stringWithFormat:@"%02x",bytes[MAC_BYTE_LENGTH-i-1]];
                    [macs addObject:strByte];
                }
                NSString *strMac = [macs componentsJoinedByString:@":"];
                NSLog(@"mac 地址 == %@",strMac);
            }
            
        } @catch (NSException *exception) {
                             
        }
    }
}



- (void)connectSuccess {
    
//    NSLog(@"连接成功");

  
//    NSLog(@"\n sever == %@\n write = %@ \n read = %@",_babyMgr.serverUUIDString,_babyMgr.writeUUIDString,_babyMgr.readUUIDString );

    [self alartstring:@"蓝牙连接成功"];
    NSArray * array = @[@"IMEI",@"ICCD",@"AUTHEBTICATION",@"NOT_WARING",@"LOOKING_CAR",@"AIRPLANE_MODE"];
     [self.senddataSource removeAllObjects];
    for (int i = 0; i< array.count; i++) {
        
        
        [self.senddataSource addObject:array[i]];
    }
    [self.sendtableView reloadData];
    
    
    
}

- (void)connectFailed {
    // 连接失败、做连接失败的处理
    
    
    NSLog(@"连接失败");
}

- (void)sendAction:(UIButton *)sender {
//    NSInteger age;
//    UILabel *mylabel=[UILabel new];
//    mylabel.text=age?[NSString stringWithFormat:@"%@",age]:@"";

    [_babyMgr writeState:_babyMgr.bluetoohh_type];

}




- (void)readData:(NSData *)valueData {
    
}






- (void)disconnectAction:(UIButton *)sender {
    
//    [self requestverify];
    // 断开连接
    // 1、可以选择断开所有设备
    // 2、也选择断开当前peripheral
    [_babyMgr disconnectAllPeripherals];
    //[_babyMgr disconnectLastPeripheral:(CBPeripheral *)];
}

- (void)disconnectPeripheral:(CBPeripheral *)peripheral {
    // 获取到当前断开的设备 这里可做断开UI提示处理
    
    
     [self alartstring:@"蓝牙断开"];
    [self.senddataSource removeAllObjects];
    [self.sendtableView reloadData];
}


- (void)getBLue:(NSString *)string
{
    
    NSString * type = [NSString stringWithFormat:@"%@ -- %ld",string,_babyMgr.bluetoohh_type];
    [self.senddataSource addObject:type];
    [self.sendtableView reloadData];
}


- (void)beginCountdown{
    __block NSInteger second = 10;
     //(1)
     dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     //(2)
     self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
     //(3)
     dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
     //(4)
     dispatch_source_set_event_handler(self.timer, ^{
         dispatch_async(dispatch_get_main_queue(), ^{
             if (second == 0) {
//                 self.verificationBtn.userInteractionEnabled = YES;
//                 [self.verificationBtn setTitle:[NSString stringWithFormat:@"Get Code"] forState:UIControlStateNormal];
                 second = 10;
                 NSLog(@"倒计时结束 == %ld",second);
                 //(6)
                 dispatch_cancel(self.timer);
             } else {
//                 self.verificationBtn.userInteractionEnabled = NO;
//                 [self.verificationBtn setTitle:[NSString stringWithFormat:@"%lds",second] forState:UIControlStateNormal];
                 NSLog(@"倒计时 == %ld",second);
                 second--;
             }
         });
     });
     //(5)
     dispatch_resume(self.timer);
    
}


@end
