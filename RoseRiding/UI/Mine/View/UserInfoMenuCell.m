//
//  UserInfoMenuCell.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/31.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "UserInfoMenuCell.h"

@interface UserInfoMenuCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *rightContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConetntCons;

@end

@implementation UserInfoMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithIndexpath:(NSIndexPath *)indexPath rightContent:(NSString *)content{
    switch (indexPath.row) {
        case 0:
        {
            self.name.text = @"ID";
            self.icon.image = [UIImage imageNamed:@"icon_ID_black"];
           self.rightContent.text = [NSString stringWithFormat:@"%@",content];
            self.accessoryType =  UITableViewCellAccessoryNone;
             self.rightConetntCons.constant = Adaptive(55);
        }
            break;
        case 1:
        {
            self.name.text = @"Gender";
            self.icon.image = [UIImage imageNamed:@"mine-click"];
            self.rightContent.text = content;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.rightConetntCons.constant = Adaptive(25);
        }
            break;
        case 2:
        {
            self.name.text = @"Email";
            self.icon.image = [UIImage imageNamed:@"phone"];
            self.rightContent.text = content;
            self.accessoryType = UITableViewCellAccessoryNone;
            self.rightConetntCons.constant = Adaptive(55);
        }
            break;
            
        default:
            break;
    }
}


@end
