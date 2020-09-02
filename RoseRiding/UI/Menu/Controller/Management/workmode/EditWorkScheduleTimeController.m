//
//  EditWorkScheduleTimeController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/13.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "EditWorkScheduleTimeController.h"
#import "ScheduleTimeCell.h"
@interface EditWorkScheduleTimeController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic , strong , nullable)ScheWorkModel *model;
@property (nonatomic , strong , nullable)NSString  *time;
@property (nonatomic,strong)NSMutableArray * dayArray;
@property (nonatomic,strong)NSArray * week;
@property (nonatomic,strong)NSMutableArray *numberArray;
@end
@implementation EditWorkScheduleTimeController

- (instancetype)initWithWorkModel:(ScheWorkModel *)model{
    if (self = [super init]) {
        self.model = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];
    self.dayArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];
    self.week = [NSArray arrayWithObjects:@"Sun.",@"Mon.",@"Tue.",@"Wen.",@"Thu.",@"Fir.",@"Sat.", nil];
    self.defaultSelectIndex = [NSArray arrayWithObjects:@"7",@"1",@"2",@"3",@"4",@"5",@"6", nil];
    self.barStyle = NavigationBarStyleWhite;
    self.title = @"Schedule time";
    [self initUI];
    if (self.model==nil) {
       
        self.time = nil;
    }else{
        
    }
    // Do any additional setup after loading the view.
}
- (void)initUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIWidth, 60)];
    self.tableView.tableHeaderView = head;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"ScheduleTimeCell" bundle:nil] forCellReuseIdentifier:@"ScheduleTimeCell"];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view bringSubviewToFront:self.navView];
}
- (void)viewWillLayoutSubviews{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return Adaptive(54);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ScheduleTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleTimeCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureWithIndexpath:indexPath showSelect:self.defaultSelectIndex[indexPath.row]];
    cell.choose = ^{
        if (self.dayArray.count>6) {
            [self.dayArray removeObjectAtIndex:indexPath.row];
            [self.dayArray insertObject:self.week[indexPath.row] atIndex:indexPath.row];
            [self.numberArray removeObjectAtIndex:indexPath.row];
            [self.numberArray insertObject:self.defaultSelectIndex[indexPath.row] atIndex:indexPath.row];
        }
    };
    cell.deletetime = ^{
        if (self.dayArray.count>6) {
            [self.dayArray removeObjectAtIndex:indexPath.row];
            [self.dayArray insertObject:@"" atIndex:indexPath.row];
            [self.numberArray removeObjectAtIndex:indexPath.row];
            [self.numberArray insertObject:@"" atIndex:indexPath.row];
        }
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
- (void)goBack{
    if (self.selectResult) {
        self.selectResult(self.dayArray, self.defaultSelectIndex);
        NSLog(@"%@,%@",self.dayArray,self.numberArray);
    }
    [super goBack];
}

@end
