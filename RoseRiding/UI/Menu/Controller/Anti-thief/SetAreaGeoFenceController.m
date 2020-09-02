//
//  SetAreaGeoFenceController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/5/4.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "SetAreaGeoFenceController.h"
#import "SetAreaGyroFenceCell.h"
#import "SetAreaGyroFenceHead.h"
@interface SetAreaGeoFenceController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)BOOL showContent;
@end

@implementation SetAreaGeoFenceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"SetAreaGyroFenceIndex"] integerValue] < 0) {
        self.defaultSelectIndex = -1;
    }else{
        self.defaultSelectIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SetAreaGyroFenceIndex"] integerValue];
    }
    self.barStyle = NavigationBarStyleWhite;
    self.title = @"Set the area of geo-fence";
    [self initUI];
    // Do any additional setup after loading the view.
}



- (void)initUI{

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, UIWidth, UIHeight - kNavHeight) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    SetAreaGyroFenceHead *head = [[SetAreaGyroFenceHead alloc] initWithFrame:CGRectMake(0, 0, UIWidth, 45)];
    self.tableView.tableHeaderView = head;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"SetAreaGyroFenceCell" bundle:nil] forCellReuseIdentifier:@"SetAreaGyroFenceCell"];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view bringSubviewToFront:self.navView];
    kWeakSelf
    head.show = ^{
        weakSelf.showContent = !weakSelf.showContent;
        [weakSelf.tableView reloadData];
    };
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showContent ? 3 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return Adaptive(54);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SetAreaGyroFenceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetAreaGyroFenceCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureWithIndexpath:indexPath showSelect:indexPath.row == self.defaultSelectIndex];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.defaultSelectIndex = indexPath.row;
        [[NSUserDefaults standardUserDefaults] setObject:@(indexPath.row) forKey:@"SetAreaGyroFenceIndex"];
        [self.tableView reloadData];
    });

}



@end
