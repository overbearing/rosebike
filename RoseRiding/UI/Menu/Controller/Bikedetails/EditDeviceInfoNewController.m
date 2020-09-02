//
//  EditDeviceInfoNewController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/27.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "EditDeviceInfoNewController.h"
#import "BikeInfoModel.h"

@interface EditDeviceInfoNewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollowView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSize;
@property (weak, nonatomic) IBOutlet UILabel *bikeName;
@property (weak, nonatomic) IBOutlet UITextField *bikeNameContent;
@property (weak, nonatomic) IBOutlet UILabel *bikeType;
@property (weak, nonatomic) IBOutlet UITextField *bikeTypeContent;
@property (weak, nonatomic) IBOutlet UILabel *bikeColor;
@property (weak, nonatomic) IBOutlet UITextField *bikeColorContent;
@property (weak, nonatomic) IBOutlet UILabel *manufactoryDate;
@property (weak, nonatomic) IBOutlet UITextField *manufactoryDateContent;
@property (weak, nonatomic) IBOutlet UILabel *bikeManuFactory;
@property (weak, nonatomic) IBOutlet UITextField *bikeManuFactoryContent;
@property (weak, nonatomic) IBOutlet UILabel *bikeNum;
@property (weak, nonatomic) IBOutlet UITextField *bikeNumContent;
@property (weak, nonatomic) IBOutlet UILabel *lastServeDate;
@property (weak, nonatomic) IBOutlet UITextField *lastServeDateContent;
@property (weak, nonatomic) IBOutlet UILabel *bluetoothLeftDay;
@property (weak, nonatomic) IBOutlet UITextField *bluetoothLeftDayContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollowBotCons;

@property (weak, nonatomic) IBOutlet UIView *lastServiceDateView;

@property (weak, nonatomic) IBOutlet UIView *AuthView;

@property (weak, nonatomic) IBOutlet UIView *remainDaysView;


@property (nonatomic , strong)UIView *menuBg;


@end

@implementation EditDeviceInfoNewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"type-----------------%lu",(unsigned long)_type);
//    NSLog(@"%@",[MyDevicemanger shareManger ].indexCurrentShowDevice.Id);
    if ([MyDevicemanger shareManger ].mainDevice.Id  != nil) {
               self.deviceId = [MyDevicemanger shareManger ].mainDevice.Id;
           }else{
               self.deviceId = @"";
           }
    self.barStyle = NavigationBarStyleWhite;
    if (self.type == DeviceInfoEdit || self.type == DeviceInfoDefault) {
        self.title = [GlobalControlManger enStr:@"bike details" geStr:@"bike details"];
        self.url = @"bicycle/set_equipment";
       
    }
    if(self.type == DeviceInfoAdd || [MyDevicemanger shareManger].Devices.count == 0){
        self.title = [GlobalControlManger enStr:@"add bike" geStr:@"add bike"];
        self.url = @"bicycle/in_equipment";
    }
    [self fixInfoContent];
    [self setupUI];
    if (self.type != DeviceInfoAdd) {
        [self queryBikeInfo];
    }
    if (self.type == DeviceInfoDefault) {
       
        [self disableInput:YES];
    }else{
         [self disableInput:NO];
    }
    
    self.manufactoryDateContent.delegate = self;
    self.lastServeDateContent.delegate = self;
}

- (void)setupUI{
    
    UIButton *setting = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat minX = [UIScreen mainScreen].bounds.size.width - 30 - Adaptive(20);
    setting.frame = CGRectMake(minX, kStatusBarHeight+15, 15, 15);
    [setting addTarget:self action:@selector(EditDeviceInfo) forControlEvents:UIControlEventTouchUpInside];
    [setting setImage:[UIImage imageNamed:@"edit_equipment"] forState:UIControlStateNormal];
    setting.hidden = self.type == DeviceInfoAdd;
    [self.navView addSubview:setting];
    if (self.type == DeviceInfoDefault ) {
        setting.hidden = NO;
        self.menuBg.hidden = YES;
    }
    if (self.type == DeviceInfoAdd || self.type == DeviceInfoEdit ) {
        self.scrollowBotCons.constant = Adaptive(160);
        self.menuBg.hidden = NO;
        setting.hidden = YES;
    }else{
        self.scrollowBotCons.constant = 0;
//        self.menuBg.hidden = YES;
//        setting.hidden = YES;
    }
    if (self.type == DeviceInfoAdd) {
        self.AuthView.hidden = YES;
        self.lastServiceDateView.hidden = NO;
        self.remainDaysView.hidden = YES;
        self.bikeName.text = [GlobalControlManger enStr:@"Bike Name"  geStr:@"Bike Name"];
        self.bikeNameContent.placeholder = [GlobalControlManger enStr:@"you must enter bike name" geStr:@"you must enter bike name"];
        self.bikeType.text = [GlobalControlManger enStr:@"bike type" geStr:@"bike type"];
        self.bikeTypeContent.placeholder = [GlobalControlManger enStr:@"input bike type" geStr:@"input bike type"];
        self.bikeColor.text = [GlobalControlManger enStr:@"bike color" geStr:@"bike color"];
        self.bikeColorContent.placeholder = [GlobalControlManger enStr:@"input bike color" geStr:@"input bike color"];
        self.manufactoryDate.text = [GlobalControlManger enStr:@"manufactory date" geStr:@"manufactory date"];
        self.manufactoryDateContent.placeholder =[GlobalControlManger enStr:@"input manufactore date" geStr:@"input manufactore date"];
        self.bikeManuFactory.text = [GlobalControlManger enStr:@"bike manufacturer" geStr:@"bike manufacturer"];
        self.bikeManuFactoryContent.placeholder = [GlobalControlManger enStr:@"input bike manufacturer" geStr:@"input bike manufacturer"];
        self.bikeNum.text = [GlobalControlManger enStr:@"bike serial number" geStr:@"bike serial number"];
        self.bikeNumContent.placeholder = [GlobalControlManger enStr:@"input bike serial number" geStr:@"input bike serial number"];
        self.lastServeDate.text = [GlobalControlManger enStr:@"last servicing date" geStr:@"last servicing date"];
        self.lastServeDateContent.placeholder = [GlobalControlManger enStr:@"last servicing date" geStr:@"last servicing date"];
        self.bluetoothLeftDay.text = [GlobalControlManger enStr:@"" geStr:@""];
        self.bluetoothLeftDayContent.placeholder = [GlobalControlManger enStr:@"" geStr:@""];
    }else if (self.type == DeviceInfoEdit){
        self.bikeName.text = [GlobalControlManger enStr:@"modify bike name" geStr:@"modify bike name"];
    }else{
        self.bikeName.text = [GlobalControlManger enStr:@"bike name" geStr:@"bike name"];
    }
}

- (void)EditDeviceInfo{
    
    self.type = DeviceInfoEdit;
    self.scrollowBotCons.constant = Adaptive(160);
    self.menuBg.hidden = NO;
    [self disableInput:NO];
}

- (void)fixInfoContent{
    UIView *menuBg = [[UIView alloc] initWithFrame:CGRectMake(0, UIHeight - Adaptive(160), UIWidth, Adaptive(160))];
    menuBg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:menuBg];
    self.menuBg = menuBg;
    
    UIButton *submit = [[UIButton alloc] init];
    submit.backgroundColor = [UIColor colorWithHexString:@"#15BA39"];
    [submit setTitle:[GlobalControlManger enStr:@"save" geStr:@"save"] forState:UIControlStateNormal];
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
        [self submit];
    }];
    
//    UIButton *cancle = [[UIButton alloc] init];
//    cancle.layer.borderColor = [UIColor colorWithHexString:@"#EDEDED"].CGColor;
//    cancle.layer.borderWidth = 1;
//    [cancle setTitle:@"Cancel" forState:UIControlStateNormal];
//    cancle.titleLabel.font = kFont(16);
//    [cancle setTitleColor:[UIColor colorWithHexString:@"#121212"] forState:UIControlStateNormal];
//    [menuBg addSubview:cancle];
//    [cancle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(menuBg);
//        make.width.equalTo(@244);
//        make.top.equalTo(submit.mas_bottom).offset(13);
//        make.height.equalTo(@48);
//    }];
//    [[cancle rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        if (self.type == DeviceInfoEdit) {
//               self.type = DeviceInfoDefault;
//               self.scrollowBotCons.constant = 0;
//               self.menuBg.hidden = YES;
//           }else if(self.type == DeviceInfoAdd){
//               [self goBack];
//           }
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
}

- (void)submit{
    
    //判空处理 TODO
    
    if ((self.bikeNameContent.text.length == 0)) {
        //只需对bikeName 双语处理
        [Toast showToastMessage:[NSString stringWithFormat:@"%@",@"You must enter bike name"]];
        return;
    }
    
    if ((self.bikeTypeContent.text.length == 0)) {
        [Toast showToastMessage:[NSString stringWithFormat:@"Please Input %@",self.bikeType.text]];
        return;
    }
    
    if ((self.bikeColorContent.text.length == 0)) {
        [Toast showToastMessage:[NSString stringWithFormat:@"Please Input %@",self.bikeColor.text]];
        return;
    }
    
    if ((self.bikeManuFactoryContent.text.length == 0)) {
        //只需对bikeName 双语处理
        [Toast showToastMessage:[NSString stringWithFormat:@"Please Input %@",self.bikeManuFactory.text]];
        return;
    }
    kWeakSelf
    NSString *url = host(self.url);
    NSDictionary *para = @{@"token":[UserInfo shareUserInfo].token,@"id":self.deviceId,@"equipment":self.bikeNameContent.text,@"model":self.bikeTypeContent.text,@"color":self.bikeColorContent.text,@"details":self.bikeManuFactoryContent.text,@"buytime":self.lastServeDateContent.text,@"guarantee":self.manufactoryDateContent.text,@"serial_number":self.bikeNumContent.text};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        NSInteger stateCode = [result[@"code"] integerValue];
        NSString *msg = result[@"msg"];
      if (![msg isEqualToString:@""]) {
      [Toast showToastMessage:msg];
      }
        if (stateCode == 1) {
            if (self.type == DeviceInfoEdit) {
                self.type = DeviceInfoDefault;
                self.scrollowBotCons.constant = 0;
                self.menuBg.hidden = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"editNamesuccess" object:nil userInfo:@{@"name":self.bikeNameContent.text}];
                [self disableInput:YES];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"addBikeSuccess" object:nil
                 ];
                if (weakSelf.success){
                    weakSelf.success();
                }
                [weakSelf goBack];
            }
        }else{
            
        }
    } fail:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)queryBikeInfo{
    
    if ([MyDevicemanger shareManger].Devices.count == 0) {
//         [Toast showToastMessage:@"NO Bikes"];
        [self disableInput:NO];

        return;
    }
    kWeakSelf
    NSString *url = host(@"bicycle/equipmentDetail");
    NSDictionary *para = @{@"token":[UserInfo shareUserInfo].token,@"id":[MyDevicemanger shareManger].mainDevice == nil ? [MyDevicemanger shareManger].Devices.lastObject.Id:[MyDevicemanger shareManger].mainDevice.Id};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        NSInteger stateCode = [result[@"code"] integerValue];
        NSString *msg = result[@"msg"];
        if (![msg isEqualToString:@""]) {
            [Toast showToastMessage:msg];
        }
        if (stateCode == 1) {
            BikeInfoModel *info = [BikeInfoModel mj_objectWithKeyValues:result[@"data"]];
            self.bikeNameContent.text = info.equipment == nil ? @"" :info.equipment;
            self.bikeTypeContent.text = info.model == nil ? @"" :info.model;
            self.bikeColorContent.text = info.color == nil ? @"" :info.color;
            self.manufactoryDateContent.text = info.guarantee == nil ? @"" :info.guarantee;
            self.bikeManuFactoryContent.text = info.details == nil ? @"" :info.details;
            self.bikeNumContent.text = info.serial_number == nil ? @"" :info.serial_number;
            self.lastServeDateContent.text = info.buytime == nil ? @"" :info.buytime;
            self.bluetoothLeftDayContent.text = info.bluetooth_left_day == nil ? @"" :info.bluetooth_left_day;
        }
    } fail:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (IBAction)goAuthorizedView:(id)sender {
}

- (void)disableInput:(BOOL)disable{
    if (disable) {
        self.bikeNameContent.userInteractionEnabled = NO;
        self.bikeTypeContent.userInteractionEnabled = NO;
        self.bikeColorContent.userInteractionEnabled = NO;
        self.manufactoryDateContent.userInteractionEnabled = NO;
        self.bikeManuFactoryContent.userInteractionEnabled = NO;
        self.bikeNumContent.userInteractionEnabled = NO;
        self.lastServeDateContent.userInteractionEnabled = NO;
        self.bluetoothLeftDayContent.userInteractionEnabled = NO;
    }else{
        self.bikeNameContent.userInteractionEnabled = YES;
        self.bikeTypeContent.userInteractionEnabled = YES;
        self.bikeColorContent.userInteractionEnabled = YES;
        self.manufactoryDateContent.userInteractionEnabled = YES;
        self.bikeManuFactoryContent.userInteractionEnabled = YES;
        self.bikeNumContent.userInteractionEnabled = YES;
        self.lastServeDateContent.userInteractionEnabled = YES;
        self.bluetoothLeftDayContent.userInteractionEnabled = YES;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.manufactoryDateContent){
        Dialog()
        .wEventOKFinishSet(^(id anyID, id otherData) {
//            NSLog(@"选中 %@ %@",anyID,otherData);
            NSString *time = [NSString stringWithFormat:@"%@/%@/%@",anyID[2],anyID[1],anyID[0]];
            self.manufactoryDateContent.text = time;
        })
        //默认选中时间 不传默认是当前时间
        .wTitleSet(@"Manufacturing Date")
        .wDefaultDateSet([NSDate date])
        .wDateTimeTypeSet(@"yyyy-MM-dd")
        .wPickRepeatSet(NO)
        .wTypeSet(DialogTypeDatePicker)
        .wMessageColorSet([UIColor blackColor])
        .wMessageFontSet(16)
        .wOKTitleSet(@"OK")
        .wCancelTitleSet(@"Cancel")
        .wStart();
        return NO;
    }else if (textField == self.lastServeDateContent){
//        NSLog(@"last");
        Dialog()
               .wEventOKFinishSet(^(id anyID, id otherData) {
                   NSLog(@"选中 %@ %@",anyID,otherData);
                   NSString *time = [NSString stringWithFormat:@"%@/%@/%@",anyID[2],anyID[1],anyID[0]];
                   self.lastServeDateContent.text = time;
               })
               //默认选中时间 不传默认是当前时间
               .wTitleSet(@"Lastserve Date")
               .wDefaultDateSet([NSDate date])
               .wDateTimeTypeSet(@"yyyy-MM-dd")
               .wPickRepeatSet(NO)
               .wTypeSet(DialogTypeDatePicker)
               .wMessageColorSet([UIColor blackColor])
               .wMessageFontSet(16)
               .wOKTitleSet(@"OK")
               .wCancelTitleSet(@"Cancel")
               .wStart();
               return NO;
    }
    return YES;
}


@end
