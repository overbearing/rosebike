//
//  DeviceMangerHead.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/9.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "DeviceMangerHead.h"

@interface DeviceMangerHead ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftwidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleWidth;
@property (weak, nonatomic) IBOutlet UILabel *leftTitle;
@property (weak, nonatomic) IBOutlet UILabel *rightTitle;
@property (weak, nonatomic) IBOutlet UILabel *middleTitle;

@end

@implementation DeviceMangerHead

- (void)awakeFromNib{
    [super awakeFromNib];
    UIView *firView = [self viewWithTag:1001];
    [firView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionL:)]];
    UIView *setUp = [self viewWithTag:1000];
    [setUp addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionL:)]];
    UIView *authView = [self viewWithTag:1002];
    [authView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionL:)]];
    if (Device_iPhone5) {
        self.leftTitle.font = self.middleTitle.font = self.rightTitle.font = kFont(10);
        self.leftwidth.constant = 120;
        self.middleWidth.constant = 70;
    }
    self.leftTitle.text = [GlobalControlManger enStr:@"set up equipment" geStr:@"set up equipment"];
    self.rightTitle.text = [GlobalControlManger enStr:@"authorized device" geStr:@"authorized device"];
}

- (void)tapActionL:(UITapGestureRecognizer *)gesture{
    if (self.click) {
        self.click(gesture.view.tag - 1000);
    }
}

@end
