//
//  popularTableViewCell.m
//  RoseRiding
//
//  Created by 蜡笔小新 on 2020/7/30.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "popularTableViewCell.h"
@interface popularTableViewCell ()
- (IBAction)goriding:(UIButton *)sender;
@end
@implementation popularTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   [self.firstcity.layer setBorderColor:[UIColor colorWithHexString:@"#838383"].CGColor];
             [self.firstcity.layer setBorderWidth:0.0f];
             [self.secondcity.layer setBorderColor:[UIColor colorWithHexString:@"#838383"].CGColor];
                [self.secondcity.layer setBorderWidth:0.0f];
             [self.thirdcity.layer setBorderColor:[UIColor colorWithHexString:@"#838383"].CGColor];
                [self.thirdcity.layer setBorderWidth:0.0f];
//      NSLog(@"%@",self.history);
    // Initialization code
}
//- (void)setHistory:(NSMutableArray *)history{
//    if ([self.title.text isEqualToString:@"Used City"]) {
//        if (history.count == 0) {
//            [self.firstcity.layer setBorderWidth:0];
//             [self.secondcity.layer setBorderWidth:0];
//             [self.thirdcity.layer setBorderWidth:0];
//        }else if (history.count == 1) {
//
////            self.firstcity.hidden = NO;
////            self.secondcity.hidden = YES;
////            self.thirdcity.hidden = YES;
//            [self.firstcity setTitle:history[0] forState:UIControlStateNormal];
//            [self.firstcity.layer setBorderWidth:0.5];
//            [self.secondcity.layer setBorderWidth:0];
//            [self.thirdcity.layer setBorderWidth:0];
//        }else if (history.count == 2){
//
//            [self.firstcity setTitle:history[0] forState:UIControlStateNormal];
//            [self.secondcity setTitle:history[1] forState:UIControlStateNormal];
//            [self.firstcity.layer setBorderWidth:0.5f];
//            [self.secondcity.layer setBorderWidth:0.5f];
//            [self.thirdcity.layer setBorderWidth:0];
////            self.firstcity.hidden = NO;
////            self.secondcity.hidden = NO;
////            self.thirdcity.hidden = YES;
//        }else{
//            [self.firstcity setTitle:history[0] forState:UIControlStateNormal];
//            [self.secondcity setTitle:history[1] forState:UIControlStateNormal];
//            [self.thirdcity setTitle:history[2] forState:UIControlStateNormal];
//
//            [self.firstcity.layer setBorderWidth:0.5];
//            [self.secondcity.layer setBorderWidth:0.5f];
//            [self.thirdcity.layer setBorderWidth:0.5f];
////            self.firstcity.hidden = NO;
////            self.secondcity.hidden = NO;
////            self.thirdcity.hidden = NO;
//        }
//    }else{
//
//        self.firstcity.hidden = NO;
//        self.secondcity.hidden = NO;
//        self.thirdcity.hidden = NO;
//    }
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)setHiscity:(NSMutableArray<historyModel *> *)hiscity{
    if ([self.title.text isEqualToString:@"Used City"]) {
           if (hiscity.count >0) {
                [self.firstcity setTitle:hiscity[0].addr forState:UIControlStateNormal];
                self.firstcity.layer.borderWidth = hiscity[0].addr == nil?0:0.5;
            }
            if(hiscity.count >1){
                [self.secondcity setTitle:hiscity[1].addr forState:UIControlStateNormal];
                 self.secondcity.layer.borderWidth = hiscity[1].addr == nil?0:0.5;
            }
            if(hiscity.count >2){
                 self.thirdcity.layer.borderWidth = hiscity[2].addr == nil?0:0.5;
                 [self.thirdcity setTitle:hiscity[2].addr forState:UIControlStateNormal];
            }
    }

}
- (void)setHotcity:(NSMutableArray<hotCityModel *> *)hotcity{
    if ([self.title.text isEqualToString:@"Popular City"]) {
    if (hotcity.count >0) {
        [self.firstcity setTitle:hotcity[0].addr forState:UIControlStateNormal];
        self.firstcity.layer.borderWidth = hotcity[0].addr == nil?0:0.5;
    }
    if(hotcity.count >1){
        [self.secondcity setTitle:hotcity[1].addr forState:UIControlStateNormal];
         self.secondcity.layer.borderWidth = hotcity[1].addr == nil?0:0.5;
    }
    if(hotcity.count >2){
         self.thirdcity.layer.borderWidth = hotcity[2].addr == nil?0:0.5;
         [self.thirdcity setTitle:hotcity[2].addr forState:UIControlStateNormal];
    }
    }
}
- (IBAction)goriding:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickTest:)]) {
        [self.delegate clickTest:sender.currentTitle];
    }
//     if (self.click) {
//        self.click();
//     }
}
@end
