//
//  MineHeadView.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/30.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "MineHeadView.h"

@interface MineHeadView ()

@end

@implementation MineHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setSub];
    }
    return self;
}

- (void)setSub{
    self.headImg = [[UIImageView alloc] init];
    [self addSubview:self.headImg];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(kStatusBarHeight);
        make.height.width.equalTo(@Adaptive(121));
    }];
    self.headImg.clipsToBounds = YES;
    self.headImg.layer.cornerRadius = Adaptive(60.5);
    self.headImg.userInteractionEnabled = YES;
    self.headImg.layer.borderWidth = 1;
    self.headImg.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    
    self.nick = [[UILabel alloc] init];
    [self addSubview:self.nick];
    self.nick.font = kMediumFont(18);
    self.nick.textColor = [UIColor colorWithHexString:@"#121212"];
    [self.nick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.headImg.mas_bottom).offset(Adaptive(17));
    }];
    self.nick.userInteractionEnabled = YES;
}


@end
