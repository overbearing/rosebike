//
//  HelpController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/31.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "HelpController.h"
#import "HelpCell.h"
#import "UserAgreementController.h"
#import "HotQuestionController.h"

@interface HelpController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation HelpController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.barStyle = NavigationBarStyleWhite;
     self.title = [GlobalControlManger enStr:@"help" geStr:@"help"];;
     [self.view bringSubviewToFront:self.navView];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"HelpCell" bundle:nil] forCellReuseIdentifier:@"HelpCell"];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Adaptive(71);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HelpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HelpCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureCellWithIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        UserAgreementController *VC = [UserAgreementController new];
        [self presentViewController:VC animated:YES completion:nil];
    }else if (indexPath.row == 2){
        HotQuestionController *VC = [[HotQuestionController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

@end
