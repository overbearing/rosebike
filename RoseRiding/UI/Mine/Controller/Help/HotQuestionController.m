//
//  HotQuestionController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/31.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "HotQuestionController.h"
#import "HotQuestionCell.h"
#import "HelpModel.h"
@interface HotQuestionController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray <HelpModel *>*list;
@property (nonatomic, assign)NSInteger page;


@end

@implementation HotQuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.page = 1;
    self.list = [NSMutableArray array];
    self.barStyle = NavigationBarStyleWhite;
    self.title = [GlobalControlManger enStr:@"help" geStr:@"help"];
    [self.view bringSubviewToFront:self.navView];
    [self loadData];
}
- (void)setupUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavHeight);
    }];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"HotQuestionCell" bundle:nil] forCellReuseIdentifier:@"HotQuestionCell"];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.list removeAllObjects];
        self.page = 1;
        [self loadData];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Adaptive(51);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotQuestionCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.list[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
- (void)loadData{
        [[NetworkingManger shareManger] postDataWithUrl:host(@"api/problem") para:@{@"id":@"1",@"token":[UserInfo shareUserInfo].token} success:^(NSDictionary * _Nonnull result) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            NSInteger stateCode = [result[@"code"] integerValue];
            if (stateCode != 1) {
                [Toast showToastMessage:result[@"msg"] inview:self.view];
                return;
            }
            NSMutableArray *temp  = [HelpModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            if (temp.count < 10) {
                //TODO no more data
            }
            if (self.page == 1) {
                self.list = temp;
            }else{
                [self.list addObjectsFromArray:temp];
            }
            [self.tableView reloadData];
        } fail:^(NSError * _Nonnull error) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
}


@end
