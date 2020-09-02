//
//  UserInfoHeadView.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/31.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "UserInfoHeadView.h"

@interface UserInfoHeadView ()<UITextFieldDelegate>

@end

@implementation UserInfoHeadView

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
    self.headImg.layer.cornerRadius =Adaptive (60.5);
    self.headImg.userInteractionEnabled = YES;
    self.headImg.layer.borderWidth = 1;
    self.headImg.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    self.headImg.userInteractionEnabled = YES;
    [self.headImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeadImgTap)]];
    
    self.nick = [[UITextField alloc] init];
    [self addSubview:self.nick];
    self.nick.font = kMediumFont(18);
//    self.nick.text = @"Charlotte";
    self.nick.textColor = [UIColor colorWithHexString:@"#121212"];
    self.nick.userInteractionEnabled = NO;
    [self.nick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.headImg.mas_bottom).offset(Adaptive(17));
    }];
    self.nick.keyboardType = UIReturnKeyDone;
    self.nick.delegate = self;
    
    self.edit = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.edit setImage:[UIImage imageNamed:@"xiepinglun"] forState:UIControlStateNormal];
    [self addSubview:self.edit];
    [self.edit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nick);
        make.left.equalTo(self.nick.mas_right).offset(Adaptive(11));
        make.height.width.equalTo(@(Adaptive(16)));
    }];
    
    [[self.edit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.nick.userInteractionEnabled = YES;
        [self.nick becomeFirstResponder];
        self.edit.hidden = YES;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.edit.hidden = NO;
    self.nick.userInteractionEnabled = NO;
    if (self.submit) {
        self.submit(textField.text);
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.edit.hidden = NO;
    self.nick.userInteractionEnabled = NO;
    if (self.submit) {
        self.submit(textField.text);
    }
}

- (void)changeHeadImgTap{
    if (self.changeHeadImg) {
        self.changeHeadImg();
    }
}

@end
