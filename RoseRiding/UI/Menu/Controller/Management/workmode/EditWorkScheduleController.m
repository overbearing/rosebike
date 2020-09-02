//
//  EditWorkScheduleController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/13.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "EditWorkScheduleController.h"
#import "EditWorkScheduleNameController.h"
#import "EditWorkScheduleTimeController.h"

@interface EditWorkScheduleController ()

@property (nonatomic , assign)BOOL isEdit;
@property (weak, nonatomic) IBOutlet UILabel *workModeName;
@property (weak, nonatomic) IBOutlet UILabel *workModeTime;
@property (nonatomic , strong,nullable)ScheWorkModel *model;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (nonatomic , strong)NSArray * index;

- (IBAction)selectTime:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic , strong)NSMutableArray *timeInterVal;

@property (nonatomic , strong)NSMutableArray *hourInterVal;

@property (nonatomic , strong)NSMutableArray *secondInterVal;

@property (nonatomic , strong)NSString *begin;
@property (weak, nonatomic) IBOutlet UIImageView *time_imageView;

@property (weak, nonatomic) IBOutlet UIButton *selectBtton;
@property (nonatomic , strong)NSString *end;
@property (nonatomic , assign)WorkingMode workingmode;
@property (nonatomic, strong)NSMutableArray * weekdayArray;
@property (nonatomic, strong)NSMutableArray * weekendArray;
@property (nonatomic, strong)NSMutableArray * everydayArray;
@property (nonatomic, strong)NSArray * weekdaytimearray;
@property (nonatomic, strong)NSArray * weekendtimearray;
@property (nonatomic, strong)NSArray * everydaytimearray;
@end

@implementation EditWorkScheduleController

- (instancetype)initWithIsEdit:(BOOL)isEdit model:(ScheWorkModel * _Nullable)model{
    if (self = [super init]) {
        self.isEdit = isEdit;
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.weekdayArray = [NSMutableArray arrayWithObjects:@"",@"Mon.",@"Tue.",@"Wen.",@"Thu.",@"Fir.",@"", nil];
    self.weekendArray = [NSMutableArray arrayWithObjects:@"Sun.",@"",@"",@"",@"",@"",@"Sat.",nil];
    self.everydayArray = [NSMutableArray arrayWithObjects:@"Sun.",@"Mon.",@"Tue.",@"Wen.",@"Thu.",@"Fir.",@"Sat.", nil];
    self.weekdaytimearray = [NSArray arrayWithObjects:@"",@"1",@"2",@"3",@"4",@"5",@"",nil];
    self.weekendtimearray = [NSArray arrayWithObjects:@"7",@"",@"",@"",@"",@"",@"6",nil];
    self.everydaytimearray = [NSArray arrayWithObjects:@"7",@"1",@"2",@"3",@"4",@"5",@"6",nil];
    self.barStyle = NavigationBarStyleWhite;
    self.timeLabel.userInteractionEnabled = YES;
    self.title = self.isEdit ? @"Edit Work Schedule" : @"Add Work Schedule";
    if (self.isEdit) {
        self.workModeName.text = self.model.modify_name;
        if ([self.model.schedule_time isEqualToArray:self.weekendtimearray]) {
            self.workingmode = WeekendMode;
        }else if ([self.model.schedule_time isEqualToArray:self.weekdayArray]){
            self.workingmode = WeekdayMode;
        }else if ([self.model.schedule_time isEqualToArray:self.everydaytimearray]){
            self.workModeTime.text = @"Everyday";
        }else{
            for (int i = 0 ; i< self.model.schedule_time.count;i++) {
            self.workModeTime.text = [self.workModeTime.text stringByAppendingString:self.everydayArray[i]];
         }
        }
        self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",self.model.start_time,self.model.end_time];
    }else{
        self.delBtn.backgroundColor = [UIColor blackColor];
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)goModifyname:(id)sender {
    EditWorkScheduleNameController *VC = [[EditWorkScheduleNameController alloc] initWithWorkModel:self.model];
    if (self.model.modify_name != nil) {
               VC.nameText.text = self.model.modify_name;
           } else {
               VC.nameText.text = @"";
           }
    VC.inputResult = ^(NSString * _Nullable str) {
       
        if (str!=nil) {
            self.workModeName.text = str;
        }
    };
    [self.navigationController pushViewController:VC animated:YES];
   
}
- (IBAction)goModifTime:(id)sender {
    EditWorkScheduleTimeController *VC = [[EditWorkScheduleTimeController alloc] initWithWorkModel:self.model];
    VC.selectResult = ^(NSMutableArray * _Nullable str, NSArray * _Nullable index) {
        if (str != nil) {
            if ([str isEqualToArray:self.weekendArray]) {
                self.workingmode = WeekendMode;
            }else if ([str isEqualToArray:self.weekdayArray]){
                self.workingmode = WeekdayMode;
            }else{
              for (NSString * time in str) {
                    self.workModeTime.text = [self.workModeTime.text stringByAppendingString:time];
              }
            }
        }
        if (index != nil) {
            self.index = [NSArray arrayWithArray:index];
        }
        
    };
    [self.navigationController pushViewController:VC animated:YES];
    
}
- (IBAction)submit:(id)sender {
    
    if (self.workModeName.text == nil || self.workModeName.text.length == 0) {
        [Toast showToastMessage:@"Please Input Scheduled Name" inview:self.view];
        return;
    }
    
    if (self.workModeTime.text == nil || self.workModeTime.text.length == 0) {
         [Toast showToastMessage:@"Please Input Scheduled Timer" inview:self.view];
        return;
    }
    if (self.timeLabel.text == nil || self.timeLabel.text.length == 0) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.isEdit) {//修改模式
        
        [[NetworkingManger shareManger] postDataWithUrl:host(@"users/updateWorkmode") para:@{@"modify_name":self.workModeName.text,@"schedule_time":self.index==nil?self.model.schedule_time:self.index,@"id":self.model.Id,@"start_time":self.begin == nil?self.model.start_time:self.begin,@"end_time":self.end == nil?self.model.end_time:self.end} success:^(NSDictionary * _Nonnull result) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSInteger stateCode = [result[@"code"] integerValue];
            NSString *msg = result[@"msg"];
            if (![msg isEqualToString:@""]) {
                [Toast showToastMessage:msg];
            }
            if (stateCode == 1) {
                [self goBack];
            }
        } fail:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    }else{ //添加模式
        [[NetworkingManger shareManger] postDataWithUrl:host(@"users/setWorkmode") para:@{@"modify_name":self.workModeName.text,@"schedule_time":self.index,@"start_time":self.begin,@"end_time":self.end} success:^(NSDictionary * _Nonnull result) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSInteger stateCode = [result[@"code"] integerValue];
            NSString *msg = result[@"msg"];
            if (![msg isEqualToString:@""]) {
                [Toast showToastMessage:msg];
            }
            if (stateCode == 1) {
                [self goBack];
            }
            
        } fail:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }

    
    
}
- (void)setWorkingmode:(WorkingMode)workingmode{
    _workingmode = workingmode;
    if (workingmode == WeekdayMode) {
        _workModeTime.text = @"Weekday";
    }else if (workingmode == WeekendMode){
        _workModeTime.text = @"Weekend";
    }
}


- (IBAction)selectTime:(UIButton *)sender {
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
@end
