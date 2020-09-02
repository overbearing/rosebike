//
//  UserInfoCell.m
//  RoseRiding
//
//  Created by MR_THT on 2020/5/8.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "UserInfoCell.h"

@interface UserInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation UserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addAction:(id)sender {
    if (self.add) {
        self.add();
    }
}

- (void)setModel:(UserModel *)model{
    self.name.text = [NSString stringWithFormat:@"ROSE-%@",model.userid];
    
}

- (void)setBlueInfo:(GYPeripheralInfo *)blueInfo{
    self.name.text = [NSString stringWithFormat:@"%@",blueInfo.advertisementData[@"kCBAdvDataLocalName"]];
    NSLog(@"%@",self.name.text);
    if (self.name.text == nil) {
        self.addBtn.hidden = YES;
    }else{
        self.addBtn.hidden = NO;
    }
    
}


@end
