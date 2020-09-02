//
//  MenuCell.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/30.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "MenuCell.h"

@interface MenuCell (
                     
                     )
@property (weak, nonatomic) IBOutlet UILabel *menuTitle;
@property (weak, nonatomic) IBOutlet UIImageView *menuIcon;

@end

@implementation MenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellwith:(NSIndexPath *)indexpath{
    if (self.isSetting) {
        switch (indexpath.row) {
            case 0:
            {
                self.menuTitle.text = [GlobalControlManger enStr:@"languages" geStr:@"languages"];
                self.menuIcon.image = [UIImage imageNamed:@""];
            }
                break;
            case 1:
            {
                self.menuTitle.text = [GlobalControlManger enStr:@"about us" geStr:@"about us"];
                self.menuIcon.image = [UIImage imageNamed:@""];
            }
                break;
            case 2:
            {
                self.menuTitle.text = [GlobalControlManger enStr:@"version" geStr:@"version"];
                self.menuIcon.image = [UIImage imageNamed:@""];
            }
                break;
//            case 3:
//            {
//                self.menuTitle.text = @"Accounts";
//                self.menuIcon.image = [UIImage imageNamed:@""];
//            }
//                break;
            case 3:
            {
                self.menuTitle.text = [GlobalControlManger enStr:@"reset password" geStr:@"reset password"];
                self.menuIcon.image = [UIImage imageNamed:@""];
            }
                break;
                
            default:
                break;
        }
    }else{
        switch (indexpath.row) {
            case 0:
            {
                self.menuTitle.text = [GlobalControlManger enStr: @"anti-theft" geStr: @"anti-theft"];
                self.menuIcon.image = [UIImage imageNamed:@"huaban"];
            }
                break;
            case 1:
            {
                self.menuTitle.text = [GlobalControlManger enStr:@"beeper" geStr:@"beeper"];
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"beeper_trumpet"] isEqualToString:@"1"]) {
                    self.menuIcon.image = [UIImage imageNamed:@"icon_huaban"];
                }
                else {
                    self.menuIcon.image = [UIImage imageNamed:@"icon_huabanfuben"];
                }
                
            }
                break;
            case 2:
            {
                self.menuTitle.text = [GlobalControlManger enStr:@"bike details" geStr:@"bike details"];
                self.menuIcon.image = [UIImage imageNamed:@"xiangqing"];
            }
                break;
            case 3:
            {
                self.menuTitle.text =  [GlobalControlManger enStr:@"management" geStr:@"management"];
                self.menuIcon.image = [UIImage imageNamed:@"np_settings"];
            }
                break;
            case 4:
            {
                self.menuTitle.text = [GlobalControlManger enStr:@"airplane mode" geStr:@"airplane mode"];
                self.menuIcon.image = [UIImage imageNamed:@"ico"];
            }
                break;
            case 5:
            {
                self.menuTitle.text = [GlobalControlManger enStr:@"riding mode" geStr:@"riding mode"];
                self.menuIcon.image = [UIImage imageNamed:@"np_bicycle"];
            }
                break;
            case 6:
            {
                self.menuTitle.text = [GlobalControlManger enStr:@"Popular cities" geStr:@"Popular cities"];
                self.menuIcon.image = [UIImage imageNamed:@"City"];
            }
            default:
                break;
        }
    }
}

@end
