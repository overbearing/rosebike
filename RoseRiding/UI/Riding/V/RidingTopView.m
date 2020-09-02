//
//  RidingTopView.m
//  RoseRiding
//
//  Created by MR_THT on 2020/6/5.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "RidingTopView.h"

@interface RidingTopView ()

@end

@implementation RidingTopView

- (IBAction)search:(id)sender {
    if (self.searchAction) {
        self.searchAction();
    }
    
}
- (IBAction)pauseRiding:(UIButton *)sender {
    sender.selected = !sender.selected ;
    self.pauseBtn = sender;
    self.pauseBtn.userInteractionEnabled = NO;
    self.startBtn.selected = NO;
    self.startBtn.userInteractionEnabled = YES;
    self.stopBtn.userInteractionEnabled = YES;
    self.stopBtn.selected = NO;
    [self.startBtn setImage:[UIImage imageNamed:@"bofang-3"] forState:UIControlStateNormal];
    [self.stopBtn setImage:[UIImage imageNamed:sender.selected?@"stop":@"tingzhi"] forState:UIControlStateNormal];
    if (self.pauseRidingAction) {
         self.pauseRidingAction();
    }
}
- (IBAction)startRiding:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.startBtn = sender;
    //    if (self.startBtn.selected) {
    self.stopBtn.userInteractionEnabled = YES;
    self.pauseBtn.selected = NO;
    self.stopBtn.selected = NO;
    self.pauseBtn.userInteractionEnabled = YES;
    self.startBtn.userInteractionEnabled = NO;
    [self.pauseBtn setImage:[UIImage imageNamed:sender.selected?@"zanting":@"pause"] forState:UIControlStateNormal];
    [self.stopBtn setImage:[UIImage imageNamed:sender.selected?@"stop":@"tingzhi"] forState:UIControlStateNormal];
         if (self.startRidingAction) {
               self.startRidingAction();
           }
//    }else{
       
//    }
   
}

- (IBAction)stopRiding:(UIButton *)sender {
   sender.selected = !sender.selected;
    
    self.stopBtn = sender;
    self.startBtn.selected = NO;
    self.pauseBtn.userInteractionEnabled = NO;
    self.pauseBtn.selected = NO;
//    self.startBtn.userInteractionEnabled = YES;
    self.stopBtn.userInteractionEnabled = NO;
    [self.startBtn setImage:[UIImage imageNamed:@"bofang-3"] forState:UIControlStateNormal];
    [self.pauseBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
//    [self.stopBtn setImage:[UIImage imageNamed:@"tingzhi"] forState:UIControlStateNormal];
    if (self.stopRidingAction) {
        self.stopRidingAction();
    }
}





@end
