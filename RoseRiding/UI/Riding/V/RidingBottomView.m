//
//  RidingBottomView.m
//  RoseRiding
//
//  Created by MR_THT on 2020/6/5.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "RidingBottomView.h"

@interface RidingBottomView ()
@end

@implementation RidingBottomView
- (IBAction)showdetail:(UIButton *)sender {
    self.statusBtn = sender;
    if (self.showAction) {
        self.showAction();
    }
}
@end
