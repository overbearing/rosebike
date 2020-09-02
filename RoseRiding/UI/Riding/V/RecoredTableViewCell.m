//
//  RecoredTableViewCell.m
//  RoseRiding
//
//  Created by 蜡笔小新 on 2020/8/12.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "RecoredTableViewCell.h"
@interface RecoredTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet UILabel *start;
@property (weak, nonatomic) IBOutlet UILabel *end;
@property (weak, nonatomic) IBOutlet UILabel *avg_speed;
@property (weak, nonatomic) IBOutlet UILabel *avg_height;
@property (weak, nonatomic) IBOutlet UILabel *speed;
@property (weak, nonatomic) IBOutlet UILabel *height;
@property (weak, nonatomic) IBOutlet UILabel *distace;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *dateandtime;
@property (strong , nonatomic)NSString * startlocation;
@property (strong , nonatomic)NSString * endlocation;
@property (nonatomic, strong) NSDictionary *currentLocationDetailInfo;

@end
@implementation RecoredTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    // Initialization code
}
- (void)setBackground:(UIView *)background{
    background.layer.cornerRadius = 10.f;
    background.layer.masksToBounds = YES;
}
- (void)setModel:(Ridinghistory *)model{
    self.dateandtime.text = model.system_start_time;
    self.avg_speed.text = [NSString stringWithFormat:@"%.fkm/h",[model.average_speed floatValue]];
    self.speed.text = [NSString stringWithFormat:@"%.f - %.fkm/h",[model.min_speed floatValue],[model.max_speed floatValue]];
    self.height.text = [NSString stringWithFormat:@"%d - %dm",[model.min_altitude intValue],[model.max_altitude intValue]];
    self.distace.text = [NSString stringWithFormat:@"%.1fkm",[model.mileage floatValue]];
    self.time.text = model.time_consuming;
    self.avg_height.text = [NSString stringWithFormat:@"%dm",[model.altitude intValue]];
    if (model.startaddr.isNotBlank && model.endaddr.isNotBlank) {
        self.start.text = model.startaddr;
        self.end.text = model.endaddr;
    }else{
        self.start.text = @"--";
        self.end.text = @"--";
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
