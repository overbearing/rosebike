//
//  AccountTableViewCell.m
//  RoseRiding
//
//  Created by 蜡笔小新 on 2020/9/21.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "AccountTableViewCell.h"
@interface AccountTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *isloginimg;

@end
@implementation AccountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
      
    // Configure the view for the selected state
}
- (void)setModel:(accountModel *)model{
//    NSLog(@"%@",model.headimg);
    if ([model.userid isEqualToString:[UserInfo shareUserInfo].userid]) {
        self.isloginimg.hidden = NO;
        self.background.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
        self.username.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        self.username.text = [UserInfo shareUserInfo].nickname;
    }else{
        self.isloginimg.hidden = YES;
        self.background.backgroundColor = [UIColor whiteColor];
        self.username.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
         self.username.text = model.nickname;
    }
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:[UIImage imageNamed:@"defaulticon"]];
   
}

@end
