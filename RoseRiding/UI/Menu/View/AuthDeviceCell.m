//
//  AuthDeviceCell.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/10.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "AuthDeviceCell.h"
#import "YBPopupMenu.h"
@interface AuthDeviceCell ()<YBPopupMenuDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleWidth;
@property (nonatomic, strong)NSArray *titles;

@end

@implementation AuthDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (Device_iPhone5) {
        self.leftWidth.constant = 100;
        self.middleWidth.constant = 120;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BikeDeviceModel *)model{
    self.modelId = model.Id;
    
   
    self.name.text = model.equipment;
    NSLog(@"%d",model.status);
    switch (model.status) {
        case 1:
            self.authSwitch.on = NO;
            break;
         case 2:
            self.authSwitch.on = YES;
            if (model.is_auth == 1 ) {
                self.authSwitch.userInteractionEnabled = NO;
            }
            if (model.is_auth == 0){
                self.authSwitch.userInteractionEnabled = YES;
            }
            break;
        default:
            break;
    }
}
- (IBAction)selectTime:(id)sender {

    self.titles =  @[[GlobalControlManger enStr:@"1 day" geStr:@"1 day"],[GlobalControlManger enStr:@"3 days" geStr:@"3 days"],[GlobalControlManger enStr:@"1 week" geStr:@"1 week"],[GlobalControlManger enStr:@"2 weeks" geStr:@"2 weeks"],[GlobalControlManger enStr:@"1 month" geStr:@"1 month"]];
    [YBPopupMenu showRelyOnView:sender titles:self.titles icons:nil menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionBottom;
        popupMenu.borderWidth = 1;
        popupMenu.delegate = self;
        popupMenu.borderColor = [UIColor clearColor];
        popupMenu.arrowPosition = 22;
    }];
    
}
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    self.authTime.text = self.titles[index];
        if (self.selectTime) {
            self.selectTime(index);
        }
}

//    授权


- (IBAction)deleteAuthSwitch:(UISwitch *)sender {
    if (sender.on) {
        if (self.goAuth) {
            self.goAuth();
        }
    }
    else
    {
        if (self.cancelAuth) {
            self.cancelAuth(self.modelId);
        }
    }
    
}
@end
