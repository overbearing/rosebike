//
//  SetupEquipmentController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/9.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "SetupEquipmentController.h"

@interface SetupEquipmentController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UIImageView *bianji;

@end

@implementation SetupEquipmentController

- (instancetype)initWithDevide:(BikeDeviceModel *)device{
    if (self = [super init]) {
        self.device = device;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.barStyle = NavigationBarStyleWhite;
       self.title = [GlobalControlManger enStr:@"set up equipment" geStr:@"set up equipment"];
    self.bianji.hidden = YES;
    self.nameText.text = self.device.equipment;
    [self.switchBtn setOn:self.device.isConnecting];
    // Do any additional setup after loading the view from its nib.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.bianji.hidden = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
    self.bianji.hidden = YES;
}

- (void)fixDeviceName{
    
}


@end
