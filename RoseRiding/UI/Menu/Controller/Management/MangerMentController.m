//
//  MangerMentController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/7.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "MangerMentController.h"
#import "MangerMentCell.h"
#import "MajorDeviceController.h"
#import "DeviceMangerController.h"
#import "WorkingModeController.h"



@interface MangerMentController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation MangerMentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view.
    self.barStyle = NavigationBarStyleWhite;
    self.title = [GlobalControlManger enStr:@"management" geStr:@"management"];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"MangerMentCell" bundle:nil] forCellReuseIdentifier:@"MangerMentCell"];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view bringSubviewToFront:self.navView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Adaptive(72);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MangerMentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MangerMentCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureCellwith:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        MajorDeviceController *VC = [[MajorDeviceController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 2){
        DeviceMangerController *VC = [DeviceMangerController new];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 3){
        WorkingModeController *VC = [WorkingModeController new];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
@end
