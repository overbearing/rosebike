//
//  MajorDeviceStatusController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/8.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "MajorDeviceStatusController.h"

@interface MajorDeviceStatusController ()
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIImageView *battery_view;
@property (weak, nonatomic) IBOutlet UILabel *battery_remain;
@property (nonatomic , assign)BatteryLevel batteryLevel;

@end

@implementation MajorDeviceStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(batteryLevelUpDate:)
                                                   name:GYBabyBluetoothMangerBatteryLevel
                                                 object:nil];
    self.barStyle = NavigationBarStyleWhite;
     self.title = [GlobalControlManger enStr:@"device status" geStr:@"device status"];
    self.status.text = ![MyDevicemanger shareManger].mainDevice.isConnecting?@"offline":@"online";
    [self requestWaring];
}

-(void)requestWaring
{
    
    NSString *url = host(@"users/deviceSet");
    NSMutableDictionary *para =[[NSMutableDictionary alloc] init];
    [para setValue:[UserInfo shareUserInfo].token forKey:@"token"];
    [para setValue:[MyDevicemanger shareManger].mainDevice.Id forKey:@"id"];
    //@{@"id":[UserInfo shareUserInfo].device_id,@"token":};
           [MBProgressHUD showHUDAddedTo:self.view animated:YES];
           [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
               NSInteger stateCode = [result[@"code"] integerValue];
               NSString *msg = result[@"msg"];
               NSDictionary * data =[[NSDictionary alloc] initWithDictionary:result[@"data"]];
               if (stateCode == 1) {
                   self.battery_remain.text = [NSString stringWithFormat:@"%d%%",[[data objectForKey:@"electric"] intValue] ];
                   if ([[data objectForKey:@"electric"] integerValue] > 75 && [[data objectForKey:@"electric"] integerValue] <= 100) {
                                        
                       self.batteryLevel = BatteryLevel5;
                                     
                   }else if ([[data objectForKey:@"electric"] integerValue] > 50 && [[data objectForKey:@"electric"] integerValue] <= 75){
                                        
                       self.batteryLevel = BatteryLevel4;
                                     
                   }else if ([[data objectForKey:@"electric"] integerValue] > 30 && [[data objectForKey:@"electric"] integerValue] <= 50){
                                        
                       self.batteryLevel = BatteryLevel3;
                                    
                   }else if ([[data objectForKey:@"electric"] integerValue] > 15 && [[data objectForKey:@"electric"] integerValue] <= 30){
                                        
                       self.batteryLevel = BatteryLevel2;
                                    
                   }else{
                                        
                       self.batteryLevel = BatteryLevel1;
                                    
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
- (void)batteryLevelUpDate:(NSNotification *)notify{
    if ([notify.object integerValue] == 0) {
        self.batteryLevel = BatteryLevel1;
    }else if ([notify.object integerValue] == 1){
         self.batteryLevel = BatteryLevel2;
    }else if ([notify.object integerValue] == 2){
         self.batteryLevel = BatteryLevel3;
    }else if ([notify.object integerValue] == 3){
         self.batteryLevel = BatteryLevel4;
    }else{
         self.batteryLevel = BatteryLevel5;
    }
}

- (void)setBatteryLevel:(BatteryLevel)batteryLevel{
//    self.indicate_battery.hidden = NO;
   
    _batteryLevel = batteryLevel;
    if (batteryLevel == BatteryLevel1) {
       
        [self.battery_view setImage:[UIImage imageNamed:@"15%"]];
        self.battery_remain.text = @"15%";
    }else if (batteryLevel == BatteryLevel2){
         self.battery_remain.text = @"30%";
        [self.battery_view setImage:[UIImage imageNamed:@"30%"]];
    }else if (batteryLevel == BatteryLevel3){
         self.battery_remain.text = @"50%";
         [self.battery_view setImage:[UIImage imageNamed:@"50%"]];
    }else if (batteryLevel == BatteryLevel4){
          self.battery_remain.text = @"75%";
         [self.battery_view setImage:[UIImage imageNamed:@"80%"]];
    }else if (batteryLevel == BatteryLevel5){
          self.battery_remain.text = @"100%";
        [self.battery_view setImage:[UIImage imageNamed:@"100%"]];
    }else if (batteryLevel == BatteryLevelDafault){
    
    }
}



@end
