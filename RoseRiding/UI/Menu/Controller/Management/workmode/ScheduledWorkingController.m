//
//  ScheduledWorkingController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/12.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "ScheduledWorkingController.h"
#import "ScheduledWorkingCell.h"
#import "ScheduledWorkingAddCell.h"
#import "EditWorkScheduleController.h"
#import "ScheWorkModel.h"
@interface ScheduledWorkingController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)BOOL         isEdit;
@property (nonatomic, strong)NSMutableArray <ScheWorkModel *>*list;


@end

@implementation ScheduledWorkingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getCurrentWorkMode];
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
    
    UIImageView *editIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"edit"]];
    [head addSubview:editIcon];
    editIcon.userInteractionEnabled = YES;
    [editIcon mas_makeConstraints:^(MASConstraintMaker *make) {
         make.bottom.equalTo(head).offset(-Adaptive(14));
         make.leading.equalTo(head).offset(Adaptive(22));
        make.height.width.equalTo(@18);
     }];
    
    UILabel *editLabel = [[UILabel alloc] init];
    editLabel.userInteractionEnabled = YES;
    [head addSubview:editLabel];
    [editLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(head).offset(-Adaptive(14));
//        make.leading.equalTo(head).offset(Adaptive(22));
        make.centerY.equalTo(editIcon);
        make.left.equalTo(editIcon.mas_right).offset(Adaptive(8));
    }];
    [editLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editA:)]];
    [editIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editA:)]];

    
//    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"   Confirm"];
//    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#121212"] range:NSMakeRange(0, @"   Confirm".length)];
//    [att addAttribute:NSFontAttributeName value:kMediumFont(14) range:NSMakeRange(0, @"Confirm".length)];
//    NSTextAttachment *attchment = [[NSTextAttachment alloc] init];
//    UIImage *image = [UIImage imageNamed:@"edit"];
//    attchment.image = image;
//    attchment.bounds = CGRectMake(0, (-4), 18, 18);
//    NSAttributedString *imageAtt = [NSAttributedString attributedStringWithAttachment:attchment];
//    [att insertAttributedString:imageAtt atIndex:0];
//    editLabel.attributedText = att;
    editLabel.text = @"Confirm";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"ScheduledWorkingCell" bundle:nil] forCellReuseIdentifier:@"ScheduledWorkingCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ScheduledWorkingAddCell" bundle:nil] forCellReuseIdentifier:@"ScheduledWorkingAddCell"];
    self.tableView.separatorColor = [UIColor clearColor];
}

- (void)viewWillLayoutSubviews{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.list.count + 1) {
        return Adaptive(176);
    }
    return Adaptive(125);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof (self)weakSelf = self;
    if (indexPath.row == self.list.count || self.list.count == 0) {
        ScheduledWorkingAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduledWorkingAddCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView *viw in cell.subviews) {
            if (self.isEdit) {
                viw.hidden = YES;
            }else{
                viw.hidden = NO;
            }
        }
        return cell;
    }else{
        ScheduledWorkingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduledWorkingCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configureCellWithName:[self.list[indexPath.row].schedule_type isEqualToString:@"1"] ?  @"Weekday":@"Weekend" isEdit:self.isEdit];
//        cell.editAction = ^{
//            EditWorkScheduleController *VC = [[EditWorkScheduleController alloc] initWithIsEdit:YES model:self.list[indexPath.row + 1]];
//            [weakSelf.navigationController pushViewController:VC animated:YES];
//        };
//        cell.delAction = ^{
//
//        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.list.count || self.list.count == 0) {
        EditWorkScheduleController *VC = [[EditWorkScheduleController alloc] initWithIsEdit:NO model:nil];
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        EditWorkScheduleController *VC = [[EditWorkScheduleController alloc] initWithIsEdit:YES model:self.list[indexPath.row]];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (void)editA:(UITapGestureRecognizer *)gesture{
    self.isEdit = !self.isEdit;
    [self.tableView reloadData];
}

- (void)getCurrentWorkMode{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetworkingManger shareManger] postDataWithUrl:host(@"users/workList") para:@{} success:^(NSDictionary * _Nonnull result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.list = [ScheWorkModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        NSLog(@"%@",result[@"data"]);
        [self.tableView reloadData];
    } fail:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
