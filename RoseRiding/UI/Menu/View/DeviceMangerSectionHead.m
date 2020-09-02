//
//  DeviceMangerSectionHead.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/9.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "DeviceMangerSectionHead.h"

@implementation DeviceMangerSectionHead

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#121212"];
        self.titleLabel.text = [NSString stringWithFormat:@"%@%ld" ,[GlobalControlManger enStr:@"No.of devices:" geStr:@"No.of devices:"],[MyDevicemanger shareManger].Devices.count];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(Adaptive(21));
            make.centerY.equalTo(self);
        }];
        
        self.addBth = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.addBth setTitle:@"+" forState:UIControlStateNormal];
        self.addBth.titleLabel.font = kBoldFont(20);
        [self.addBth setTitleColor:[UIColor colorWithHexString:@"#121212"] forState:UIControlStateNormal];
        [self addSubview:self.addBth];
        [self.addBth mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.trailing.equalTo(self).offset(-Adaptive(10));
            make.width.equalTo(@60);
            make.height.equalTo(@40);
        }];
        self.addBth.hidden = YES;
    }
    return self;
}

@end
