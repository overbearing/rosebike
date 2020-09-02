//
//  AuthDeviceController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/4/10.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "AuthDeviceController.h"
#import "AuthDeviceCell.h"
#import "DeviceMangerSectionHead.h"
#import "UserModel.h"
#import "UserInfoCell.h"
#import "AuthModel.h"

@interface AuthDeviceController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    BOOL on_search;
}

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)DeviceMangerSectionHead *sectionHead;
@property (nonatomic, strong)UITableView      *userTable;
@property (nonatomic, strong)UIView           *maskView;
@property (nonatomic, strong)NSMutableArray   <UserModel *>*userList;
@property (nonatomic, strong)NSMutableArray   <AuthModel *>*authorList;
@property (nonatomic, strong)AuthModel    *authorUser;
@property (nonatomic, strong)UserModel    *transformUser;
@property (nonatomic, strong)BikeDeviceModel    *transformDevice;
@property (nonatomic, assign)NSInteger start_page;
@property (nonatomic , assign)NSInteger currentTimeIndex;
@property (nonatomic , assign)NSString* deviceId;
@property (nonatomic , strong)NSString *on_time;

@end

@implementation AuthDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.barStyle = NavigationBarStyleWhite;
     self.title = [GlobalControlManger enStr:@"authorized device" geStr:@"authorized device"];
    self.currentTimeIndex = 2;
    self.deviceId = @"0";
    [self setupUI];
    self.start_page = 0;
     [self getUserList:nil];
     
    self.on_time = @"1";
    // Do any additional setup after loading the view.
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
    [self.tableView registerNib:[UINib nibWithNibName:@"AuthDeviceCell" bundle:nil] forCellReuseIdentifier:@"AuthDeviceCell"];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view bringSubviewToFront:self.navView];
    
    
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIWidth, UIHeight)];
    self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.maskView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.maskView);
        make.width.equalTo(@312);
        make.height.equalTo(@316);
    }];
    contentView.layer.cornerRadius = 17;
    UILabel *title = [[UILabel alloc] init];
    title.font = kFont(16);
    title.text = @"Authed Device Name";
    title.textColor = [UIColor colorWithHexString:@"#999999"];
    [contentView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(25);
        make.leading.equalTo(contentView).offset(28);
    }];
    
    UIView *search = [[UIView alloc] init];
    search.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    [contentView addSubview:search];
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(title.mas_bottom).offset(Adaptive(21));
        make.width.equalTo(@264);
        make.height.equalTo(@30);
    }];
    search.layer.cornerRadius = 15;
    
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
     [search addSubview:searchIcon];
     [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.equalTo(search);
         make.leading.equalTo(search).offset(15);
         make.height.width.equalTo(@20);
     }];
     
     UITextField *input = [[UITextField alloc] init];
     [search addSubview:input];
     [input mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(searchIcon.mas_right).offset(4);
         make.trailing.equalTo(search).offset(-5);
         make.top.bottom.equalTo(search);
     }];
     input.returnKeyType = UIReturnKeySearch;
     input.font = kFont(12);
     input.placeholder = @"please input user id to search";
     input.delegate = self;
    
    self.userTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [contentView addSubview:self.userTable];
    [self.userTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(contentView);
        make.trailing.equalTo(contentView);
        make.top.equalTo(search.mas_bottom).offset(20);
        make.bottom.equalTo(contentView).offset(-40);
    }];
    [self.userTable registerNib:[UINib nibWithNibName:@"UserInfoCell" bundle:nil] forCellReuseIdentifier:@"UserInfoCell"];
    self.userTable.delegate = self;
    self.userTable.dataSource = self;
    self.userTable.tableFooterView = [UIView new];
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length > 0) {
        on_search = true;
         [textField resignFirstResponder];
        self.start_page = 0;
        [self getUserList:textField.text];
        return YES;
    }else{
        [textField resignFirstResponder];
        [Toast showToastMessage:@"please input user id" inview:self.view interval:1];
       return NO;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.userTable) {
        return self.userList.count;
    }
    return [MyDevicemanger shareManger].Devices.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.userTable) {
        return Adaptive(38);
    }
    return 74;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof (self)weakSelf = self;
   if (tableView == self.userTable) {
       UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell" forIndexPath:indexPath];
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
       cell.model = self.userList[indexPath.row];
      
       cell.add = ^{
           [weakSelf.maskView removeFromSuperview];
           weakSelf.transformUser = self.userList[indexPath.row];
           [weakSelf submitTransformWithCode:@""];
           ;
       };
       
       
       return cell;
   }
    AuthDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AuthDeviceCell" forIndexPath:indexPath];
    __weak typeof (cell)weakCell = cell;
    weakCell.selectionStyle = UITableViewCellSelectionStyleNone;

   weakCell.model = [MyDevicemanger shareManger].Devices[indexPath.row];
//    NSLog(@"id-----------%@",[MyDevicemanger shareManger].Devices[indexPath.row].Id);
    
    
        weakCell.goAuth = ^ {
            self.deviceId = [MyDevicemanger shareManger].Devices[indexPath.row].Id;
            [weakSelf beginTransferToOhter];
        };
    
    
    weakCell.cancelAuth  = ^(NSString * Deviceid){
//        [weakSelf deleteAuthDevice:Deviceid];
        [weakSelf deleteAuthDevice:[MyDevicemanger shareManger].Devices[indexPath.row].Id];
     };
    weakCell.selectTime = ^(NSInteger index) {
        self.on_time = [NSString stringWithFormat:@"%ld",index + 1];
    };
    return weakCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{    if (tableView == self.userTable) {
        return CGFLOAT_MIN;;
    }
    return Adaptive(40);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    self.sectionHead = [[DeviceMangerSectionHead alloc] initWithFrame:CGRectMake(0, 0, UIWidth, Adaptive(40))];
    self.sectionHead.addBth.hidden = YES;
//    [self.sectionHead.addBth addTarget:self action:@selector(doSth:) forControlEvents:UIControlEventTouchUpInside];

    return self.sectionHead;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell" forIndexPath:indexPath];
//          cell.selectionStyle = UITableViewCellSelectionStyleNone;
//          cell.model = self.userList[indexPath.row];
//    if (tableView == self.userTable) {
//        [self.maskView removeFromSuperview];
//        self.transformUser = self.userList[indexPath.row];
//       self.transformDevice = [MyDevicemanger shareManger].Devices[indexPath.row];
////        授权
//        [self submitTransformWithCode:[MyDevicemanger shareManger].Devices[indexPath.row].Id];
//    }
}

- (void)beginTransferToOhter{
    
    [UIKeyWindow addSubview:self.maskView];
}
- (void)deleteAuthDevice :(NSString *)sender{
//取消授权
    
   
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       NSString *url = host(@"users/cancelDevice");
    NSDictionary *dic = @{@"id": sender};
       [[NetworkingManger shareManger] postDataWithUrl:url para:dic success:^(NSDictionary * _Nonnull result) {
          
            [MBProgressHUD hideHUDForView:self.view animated:YES];
           NSInteger stateCode = [result[@"code"] integerValue];
           NSString *msg = result[@"msg"];
           if (![msg isEqualToString:@""]) {
               [Toast showToastMessage:msg];
           }
           if (stateCode == 1) {
               //成功
           }else{
               if ( self.transformDevice.status == 1) {
                   self.transformDevice.status = 1;
               }else{
                   self.transformDevice.status = 2;
               }
               [self.tableView reloadData];
           }
           
       } fail:^(NSError * _Nonnull error) {
           [MBProgressHUD hideHUDForView:self.view animated:YES];
       }];
//
}
- (void)getUserList:(NSString * _Nullable)searcKey{
    
    NSString *url = host(@"users/authUserlist");
    NSString *user_url = host(@"users/userList");
    NSDictionary *temp = @{@"pages":@"10",@"start_page":@(self.start_page++)};
    NSMutableDictionary *para = [temp mutableCopy];
    if (searcKey != nil) {
        [para setValue:searcKey forKey:@"userid"];
    }
    [[NetworkingManger shareManger] postDataWithUrl: on_search ? user_url : url para:para success:^(NSDictionary * _Nonnull result) {
        NSInteger stateCode = [result[@"code"] integerValue];
        if (stateCode == 1) {
            //成功
            NSMutableArray *array = [UserModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"list"]];
            
                    if (self.start_page == 1) {
                        self.userList = array;
                    }else{
                        [self.userList addObjectsFromArray:array];
         }
            [self.userTable reloadData];
        }
    } fail:^(NSError * _Nonnull error) {
    }];
//    NSLog(@"%lu",(unsigned long)self.userList.count);
}
- (void)submitTransformWithCode:(NSString *)code {
    NSLog(@"%@^---（￣︶￣）↗----------",self.deviceId);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       NSString *url = host(@"users/authDevice");
    NSDictionary *para = @{@"id":self.deviceId,@"auth_uid":self.transformUser.Id,@"on_time":self.on_time};
       [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
           NSInteger stateCode = [result[@"code"] integerValue];
           NSString *msg = result[@"msg"];
           if (![msg isEqualToString:@""]) {
               [Toast showToastMessage:msg];
           }
           if (stateCode == 1) {
               //成功
               [Toast showToastMessage:msg];
           }else{
               if ( self.transformDevice.status == 1) {
                   self.transformDevice.status = 1;
               }else{
                   self.transformDevice.status = 2;
               }
                [self.tableView reloadData];
           }        
       } fail:^(NSError * _Nonnull error) {
           [Toast showToastMessage:@"The request timed out"];
           [MBProgressHUD hideHUDForView:self.view animated:YES];
       }];
}

- (void)tapAction:(UITapGestureRecognizer *)gesture{
    
    
    [self.maskView removeFromSuperview];
    if ( self.transformDevice.status == 1) {
        self.transformDevice.status = 1;
    }else{
        self.transformDevice.status = 2;
    }
     [self.tableView reloadData];
}


@end
