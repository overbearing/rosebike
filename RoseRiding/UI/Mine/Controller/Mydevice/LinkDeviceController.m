//
//  LinkDeviceController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/2.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "LinkDeviceController.h"
#import "MyDeviceCell.h"
#import "MydeviceSectionHead.h"


@interface LinkDeviceController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation LinkDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    self.barStyle = NavigationBarStyleWhite;
    self.title = @"Link Devices";
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
    [self.tableView registerNib:[UINib nibWithNibName:@"MyDeviceCell" bundle:nil] forCellReuseIdentifier:@"MyDeviceCell"];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    
}

- ( NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Adaptive(49);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyDeviceCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.showAttach = YES;
    cell.attach = ^{
       //连接设备
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Adaptive(44);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MydeviceSectionHead *head = [[MydeviceSectionHead alloc] initWithFrame:CGRectMake(0, 0, UIWidth, Adaptive(44))];
    [head configureWithTitle:section == 0 ? @"My devices":@"Other devices" iconName:section == 0 ? @"Current device":@"Link"];
    return head;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


}

@end
