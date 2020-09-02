//
//  SetAreaGyroFenceHead.m
//  RoseRiding
//
//  Created by MR_THT on 2020/5/4.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "SetAreaGyroFenceHead.h"

@interface SetAreaGyroFenceHead ()

@property (nonatomic , strong)UILabel *name;
@property (nonatomic , strong)UIButton *showContentBtn;

@end

@implementation SetAreaGyroFenceHead

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setSubUI];
    }
    return self;
}

- (void)setSubUI{
    
    self.name = [[UILabel alloc] init];
    self.name.textColor = [UIColor colorWithHexString:@"#838383"];
    self.name.text = @"Set the area of Gyro-fence";
    self.name.font = kFont(14);
    [self addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(Adaptive(33));
    }];
    
    self.showContentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.showContentBtn];
    [self.showContentBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [self.showContentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.equalTo(self);
        make.width.equalTo(@45);
    }];
    [[self.showContentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (self.show) {
            self.show();
        }
    }];
    
}


@end
