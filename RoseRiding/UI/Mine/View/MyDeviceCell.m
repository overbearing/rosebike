//
//  MyDeviceCell.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/3.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "MyDeviceCell.h"
#import "BikeDeviceModel.h"
@interface MyDeviceCell ()

@property (weak, nonatomic) IBOutlet UILabel * nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *attachBtn;
@property (weak, nonatomic) IBOutlet UIImageView *connectIcon;


@end

@implementation MyDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.attachBtn.hidden = YES;
    self.connectIcon.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (IBAction)goAttach:(id)sender {
    
    if (self.attach) {
        self.attach();
    }
}


-(void)setModel:(BikeDeviceModel *)model
{
    self.nameLabel.text = model.equipment;
    if (model.isConnecting && [model.activation isEqualToString:@"3"]) {
//        NSLog(@"设备已连接");
        self.userInteractionEnabled = NO;
        self.connectIcon.hidden = NO;
    }else{
//        NSLog(@"设备未连接");
        self.connectIcon.hidden = YES;
        self.userInteractionEnabled = YES;
    }
}
- (void)setShowAttach:(BOOL)showAttach{
    
    
    _showAttach = showAttach;
  
    self.attachBtn.hidden = !showAttach;
    
}



@end
