//
//  WorkModelListCell.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/12.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "WorkModelListCell.h"

@interface WorkModelListCell ()
- (IBAction)transWorkmode:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *des;

@property (weak, nonatomic) IBOutlet UIButton *transBtn;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end


@implementation WorkModelListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setSelected:selected];
    // Configure the view for the selected state
}

- (void)configureWithIndexpath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
            self.name.text = @"Sports Mode";
//            self.des.text = @"(Work independently,every 10s)";
        }
            break;
        case 1:
        {
            self.name.text = @"Normal Mode";
//            self.des.text = @"（Work together,every 10s）";
        }
            break;
        case 2:
        {
            self.name.text = @"Normal Mode";
//            self.des.text = @"（Work independently,every 1m）";
        }
            break;
        case 3:
        {
           self.name.text = @"Stand-by Mode";
//            self.des.text = @"（Work independently,every 12h）";
        }
            break;
        case 4:
        {
           self.name.text = @"Power-saving Mode";
//            self.des.text = @"（Big shock to activatebluetooth,every 12h）";
        }
            break;
        case 5:
        {
            self.name.text = @"Installation Mode";
            self.des.text = @"";
        }
            break;
        case 6:
          {
              self.name.text = @"Airplane Mode";
              self.des.text = @"";
          }
              break;
        default:
            break;
    }
    
}

- (void)setModel:(WorkModel *)model{
    _model = model;
    self.name.text = model.value;
    self.des.text = @"";
    if ([model.inc_type isEqualToString:@"1"]) {
        self.icon.image = [UIImage imageNamed:@"bofangsanjiaoxing"];

    }else{
        self.icon.image = [UIImage imageNamed:@"bofangsanjiaoxing-1"];
    }
}



-(void)setSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (self.isSelected) {
        if (self.trans) {
            self.trans();
        }
    }
    
}
@end
