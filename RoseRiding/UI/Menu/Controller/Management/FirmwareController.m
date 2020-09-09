//
//  FirmwareController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/9.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "FirmwareController.h"

@interface FirmwareController ()
@property (weak, nonatomic) IBOutlet UILabel *currentVersion;
@property (weak, nonatomic) IBOutlet UILabel *lastVersion;

@property (weak, nonatomic) IBOutlet UIButton *updateBtn;


@end

@implementation FirmwareController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.barStyle = NavigationBarStyleWhite;
    self.title = @"firmware";
    self.currentVersion.text = [MyDevicemanger shareManger].mainDevice.version;
    self.lastVersion.text = [NSString stringWithFormat:@"Update to %@ or not",[MyDevicemanger shareManger].mainDevice.lastversion];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)updateAction:(id)sender {
    if ([MyDevicemanger shareManger].mainDevice.device_imei == nil) {
        return;
    }
    NSString * url = host(@"users/deviceUpgrades");
    [[NetworkingManger shareManger]postDataWithUrl:url para:@{@"imei":[MyDevicemanger shareManger].mainDevice.device_imei} success:^(NSDictionary * _Nonnull result) {
      
    } fail:^(NSError * _Nonnull error) {
        
    }];
    
}


@end
