//
//  MydeviceSectionHead.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/5.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "MydeviceSectionHead.h"

@interface MydeviceSectionHead ()

@property (nonatomic , strong)UILabel     *name;
@property (nonatomic , strong)UIImageView *icon;

@end

@implementation MydeviceSectionHead

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSub];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setupSub{
    self.name = [[UILabel alloc] init];
    self.name.font = kFont(15);
    self.name.textColor = [UIColor colorWithHexString:@"#121212"];
    [self addSubview:self.name];
    [self.name  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(33);
    }];
    
    self.icon = [[UIImageView alloc] init];
    [self addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.name.mas_right).offset(8);
    }];
    
}


- (void)configureWithTitle:(NSString *)title iconName:(NSString *)iconName{
    self.name.text = title;
    self.icon.image = [UIImage imageNamed:iconName];
}

@end
