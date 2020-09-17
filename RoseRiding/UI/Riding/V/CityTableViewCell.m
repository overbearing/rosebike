//
//  CityTableViewCell.m
//  RoseRiding
//
//  Created by 蜡笔小新 on 2020/7/31.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "CityTableViewCell.h"
@interface CityTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation CityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
    _name.textColor = [UIColor blackColor];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(CityModel *)model{
    self.name.text = model.name;
    
}
@end
