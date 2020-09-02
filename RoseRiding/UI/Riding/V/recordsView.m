//
//  recordsView.m
//  RoseRiding
//
//  Created by 蜡笔小新 on 2020/8/7.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "recordsView.h"
@interface recordsView()
@end
@implementation recordsView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self.recorddetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.equalTo(@240);
        make.height.equalTo(@258);
    }];
}


@end
