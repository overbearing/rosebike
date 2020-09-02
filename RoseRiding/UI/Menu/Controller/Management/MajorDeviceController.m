//
//  MajorDeviceController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/8.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "MajorDeviceController.h"
#import "MajorDeviceStatusController.h"

@interface MajorDeviceController ()
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation MajorDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (UILabel * subview in self.view.subviews) {
        if (subview.tag == 1200) {
            subview.text = [GlobalControlManger enStr:@"name of major device" geStr:@"name of major device"];
        }
        if (subview.tag == 1201) {
            subview.text = [GlobalControlManger enStr:@"device status" geStr:@"device status"];
        }
    }
    self.barStyle = NavigationBarStyleWhite;
    self.title = [GlobalControlManger enStr:@"name of major device" geStr:@"name of major device"];
    self.name.text = [MyDevicemanger shareManger].mainDevice.equipment;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)goDeviceDetail:(id)sender {
    MajorDeviceStatusController *VC = [MajorDeviceStatusController new];
    [self.navigationController pushViewController:VC animated:YES];
}

@end
