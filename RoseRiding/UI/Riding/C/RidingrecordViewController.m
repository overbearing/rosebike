//
//  RidingrecordViewController.m
//  RoseRiding
//
//  Created by 蜡笔小新 on 2020/8/12.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "RidingrecordViewController.h"
#import "RecoredTableViewCell.h"
@interface RidingrecordViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * table;
@property (nonatomic,strong)NSMutableArray <Ridinghistory *>*datalist;
@end

@implementation RidingrecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.barStyle = NavigationBarStyleWhite;
    [self initUI];
    [self loadrecord];
    // Do any additional setup after loading the view.
}
- (NSMutableArray *)datalist{
    if (!_datalist) {
        _datalist = [NSMutableArray new];
    }
    return _datalist;
}
-(void)initUI{
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, UIWidth, UIHeight- kNavHeight) style:UITableViewStylePlain];
    [self.table registerNib:[UINib nibWithNibName:@"RecoredTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecoredTableViewCell"];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.table];
}
#pragma mark //获取骑行记录
- (void)loadrecord{
    if ([MyDevicemanger shareManger].mainDevice.Id == nil) {
            return;
       }
    NSString * url = host(@"bicycle/cycling");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetworkingManger shareManger] postDataWithUrl:url para:@{@"id":[MyDevicemanger shareManger].mainDevice.Id,@"start_time":@"" ,@"end_time":@"",@"status":@"2"} success:^(NSDictionary * _Nonnull result) {
        NSLog(@"%@",result);
        if ([result[@"code"] intValue]== 1) {
            self.datalist = [Ridinghistory mj_objectArrayWithKeyValuesArray:result[@"data"]];
            if (self.datalist.count == 0) {
                [Toast showToastMessage:@"No records" inview:self.view];
            }
            [self.table reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } fail:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableViewCell *)tableView:( UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecoredTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RecoredTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.datalist.count>0) {
        Ridinghistory * model = self.datalist[indexPath.row];
        cell.model = model;
        
    }
    return cell;
}
- (NSInteger)tableView:( UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datalist.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 413;
}
@end
