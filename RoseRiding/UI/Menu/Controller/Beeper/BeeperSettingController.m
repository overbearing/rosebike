//
//  BeeperSettingController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/13.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "BeeperSettingController.h"
@interface BeeperSettingController ()

@property (weak, nonatomic) IBOutlet UISwitch *regularSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *timeSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *timeInterValSwitch;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeIntervallabel;

@property (nonatomic , strong)NSMutableArray *timeInterVal;

@property (nonatomic , strong)NSMutableArray *hourInterVal;

@property (nonatomic , strong)NSMutableArray *secondInterVal;

@property (nonatomic , strong)NSString *begin;

@property (nonatomic , strong)NSString *end;

@end

@implementation BeeperSettingController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.regularSwitch.isOn || self.timeSwitch.isOn || self.timeInterValSwitch.isOn) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"beeper_trumpet"];
        self.alarm = YES;
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"beeper_trumpet"];
        self.alarm = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.barStyle = NavigationBarStyleWhite;
     self.title = @"Beeper";
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"beeper_time"] isEqualToString:@"0"]) {
        self.timeLabel.userInteractionEnabled =  NO;
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"beeper_time"] isEqualToString:@"1"]) {
        self.timeLabel.userInteractionEnabled =  YES;
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"beeper_timeinterval"] isEqualToString:@"0"]) {
           self.timeIntervallabel.userInteractionEnabled =  NO;
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"beeper_timeinterval"] isEqualToString:@"1"]) {
           self.timeIntervallabel.userInteractionEnabled =  YES;
    }
    [self.timeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTimeOrTimeInterVal:)]];
    [self.timeIntervallabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTimeOrTimeInterVal:)]];
    [self.regularSwitch setOn:[[[NSUserDefaults standardUserDefaults] objectForKey:@"beeper_re"] boolValue]];
    [self.timeSwitch setOn:[[[NSUserDefaults standardUserDefaults] objectForKey:@"beeper_time"] boolValue]];
    [self.timeInterValSwitch setOn:[[[NSUserDefaults standardUserDefaults] objectForKey:@"beeper_timeinterval"] boolValue]];
    self.timeIntervallabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"beeper_timeinterval_str"] == nil ? @"5mins":[[NSUserDefaults standardUserDefaults] objectForKey:@"beeper_timeinterval_str"];
    self.timeLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"beeper_time_str"] == nil ? @"00:00-00:00":[[NSUserDefaults standardUserDefaults] objectForKey:@"beeper_time_str"];
}
- (NSMutableArray *)timeInterVal{
    if (!_timeInterVal) {
        _timeInterVal = [NSMutableArray array];
        for (int i = 1; i < 60; i++) {
            NSString *str = [NSString stringWithFormat:@"%dmins",i];
            [_timeInterVal addObject:str];
        }
    }
    return _timeInterVal;
}
- (NSMutableArray *)hourInterVal{
    if (!_hourInterVal) {
        _hourInterVal = [NSMutableArray array];
        for (int i = 0; i < 24; i++) {
            NSString *str;
            if (i < 10) {
              str = [NSString stringWithFormat:@"0%d",i];
            }else{
                str = [NSString stringWithFormat:@"%d",i];
            }
            [_hourInterVal addObject:str];
        }
    }
    return _hourInterVal;
}
- (NSMutableArray *)secondInterVal{
    if (!_secondInterVal) {
        _secondInterVal = [NSMutableArray array];
        for (int i = 0; i < 60; i++) {
            NSString *str;
            if (i < 10) {
                str = [NSString stringWithFormat:@"0%d",i];
            }else{
                str = [NSString stringWithFormat:@"%d",i];
            }
            [_secondInterVal addObject:str];
        }
    }
    return _secondInterVal;
}
- (void)selectTimeOrTimeInterVal:(UITapGestureRecognizer *)gesture{
    if (gesture.view == self.timeLabel) {
        Dialog()
        .wEventOKFinishSet(^(id anyID, id otherData) {
            self.begin = [NSString stringWithFormat:@"%@:%@",anyID[0],anyID[1]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                Dialog()
                .wEventOKFinishSet(^(id anyID, id otherData) {
                    self.end = [NSString stringWithFormat:@"%@:%@",anyID[0],anyID[1]];
                    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",self.begin,self.end];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@-%@",self.begin,self.end] forKey:@"beeper_time_str"];
                })
                .wTypeSet(DialogTypePickSelect)
                .wDataSet(@[self.hourInterVal,
                            self.secondInterVal])
                .wTitleSet(@"Select end time")
                .wOKTitleSet(@"OK")
                .wCancelTitleSet(@"Cancel")
                .wStart();
            });
        })
        .wTypeSet(DialogTypePickSelect)
        .wDataSet(@[self.hourInterVal,
                    self.secondInterVal])
        .wTitleSet(@"Select begin time")
        .wOKTitleSet(@"Sure")
        .wCancelTitleSet(@"Cancle")
        .wStart();
    }else{
        Dialog().wTypeSet(DialogTypeSheet)
        .wDataSet(self.timeInterVal)
        .wTitleSet(@"Select Interval time")
        //完成操作事件
        .wEventFinishSet(^(id anyID,NSIndexPath *path, DialogType type) {
            [[NSUserDefaults standardUserDefaults] setObject:anyID forKey:@"beeper_timeinterval_str"];
            self.timeIntervallabel.text = anyID;
        })
        .wOKTitleSet(@"Sure")
        .wCancelTitleSet(@"Cancle")
        .wParentVCSet(self)
        .wStart();
    }
}
- (IBAction)regularClickAction:(UISwitch *)sender {
    if ([MyDevicemanger shareManger].mainDevice.isConnecting == YES) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[NSUserDefaults standardUserDefaults] setObject:sender.isOn ? @"1":@"0"forKey:@"beeper_re"];
            if (sender.isOn) {
                self.alarm = YES;
                [[GYBabyBluetoothManager sharedManager] writeState:LOOKING_CAR_Bluetooth];
            }else{
                
                [[GYBabyBluetoothManager sharedManager] writeState:NOT_WARING_Bluetooth];
            }
        });
    }else{
        [self goforBeepeer];
    }
}
- (void)goforBeepeer{
    NSString *url = host(@"user/setBeeper");
    NSDictionary *para = @{@"bee_button":@"1",@"time_button":@"1",@"interval_button":@"1",@"bee_time":@"1",@"bee_interval":@"1"};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger stateCode = [result[@"code"] integerValue];
        NSString *msg = result[@"msg"];
        if (stateCode == 1) {
        }else{
            if (![msg isEqualToString:@""]) {
                [Toast showToastMessage:msg];
            }
        }
    } fail:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (IBAction)timeClickAction:(UISwitch *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self.timeInterValSwitch setOn:NO animated:YES];
        [[NSUserDefaults standardUserDefaults] setObject:sender.isOn ? @"1":@"0"forKey:@"beeper_time"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0"forKey:@"beeper_timeinterval"];
        if (sender.on) {
            self.alarm = YES;
            self.timeLabel.userInteractionEnabled = YES;
            self.timeIntervallabel.userInteractionEnabled = NO;
        }else{
            
            self.timeLabel.userInteractionEnabled = NO;
            self.timeIntervallabel.userInteractionEnabled = YES;
        }
    });
}
- (IBAction)timeInterValClickAction:(UISwitch *)sender {
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self.timeSwitch setOn:NO animated:YES];
        [[NSUserDefaults standardUserDefaults] setObject:sender.isOn ? @"1":@"0"forKey:@"beeper_timeinterval"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0"forKey:@"beeper_time"];
        if (sender.on) {
            self.alarm = YES;
            self.timeIntervallabel.userInteractionEnabled = YES;
            self.timeLabel.userInteractionEnabled = NO;
        }else{
            
            self.timeIntervallabel.userInteractionEnabled = NO;
            self.timeLabel.userInteractionEnabled = YES;
        }
    });
}

@end
