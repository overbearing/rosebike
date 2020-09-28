//
//  AccountsController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/31.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "AccountsController.h"
#import "AccountTableViewCell.h"
#import "accountModel.h"
#import "LoginController.h"
@interface AccountsController ()<UITableViewDelegate,UITableViewDataSource>{
    float rowheight;
}
@property (nonatomic, strong)UITableView * accountTable;
@property (nonatomic, strong)NSMutableArray<accountModel*> * useraccount;
@property (nonatomic, strong)NSString * email;
@property (nonatomic, strong)NSString * password;
@end

@implementation AccountsController

- (void)viewDidLoad {
    [super viewDidLoad];
    rowheight = 78.0f;
      [[NSNotificationCenter defaultCenter] addObserver:self
                                                       selector:@selector(loginSuccess)
                                                           name:@"loginSuccess"
                                                         object:nil];
    //    NSLog(@"%@",[UserInfo shareUserInfo].headimg);
    // Do any additional setup after loading the view.
    self.barStyle = NavigationBarStyleWhite;
    self.title = @"Accounts";
    [self.view bringSubviewToFront:self.navView];
//    [self.rightButton setTitle:@"Mange" forState:UIControlStateNormal];
    CGRect rect = self.rightButton.frame;
    rect.origin.x = rect.origin.x + Adaptive(16);
    self.rightButton.frame = rect;
//    [self.rightButton addTarget:self action:@selector(deleteuser:) forControlEvents:UIControlEventTouchUpInside];
    self.useraccount = [accountModel mj_objectArrayWithKeyValuesArray:[[[NSUserDefaults standardUserDefaults] objectForKey:@"accounts"] mutableCopy]];
    [self initUI];
  
//    NSLog(@"%@",self.useraccount);
}
//- (void)deleteuser:(UIButton *)sender{
//    
//}
- (void)loginSuccess{
    [self.useraccount removeAllObjects];
    self.useraccount = [accountModel mj_objectArrayWithKeyValuesArray:[[[NSUserDefaults standardUserDefaults] objectForKey:@"accounts"] mutableCopy]];
    [self.accountTable reloadData];
}
- (NSMutableArray *)useraccount{
    if (!_useraccount) {
        _useraccount = [NSMutableArray new];
    }
    return _useraccount;
}
- (void)initUI{
    self.accountTable = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavHeight, UIWidth, UIHeight - kNavHeight) style:UITableViewStylePlain];
    self.accountTable.delegate = self;
    self.accountTable.dataSource = self;
    self.accountTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.accountTable registerNib:[UINib nibWithNibName:@"AccountTableViewCell" bundle:nil] forCellReuseIdentifier:@"AccountTableViewCell"];
    [self.view addSubview:self.accountTable];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.useraccount.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AccountTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[AccountTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountTableViewCell"];
    }
    if (self.useraccount != nil) {
        cell.model = self.useraccount[indexPath.row];
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIWidth, 30)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(108, 15, UIWidth-216, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [view addSubview:line];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * vv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIWidth, rowheight)];
    vv.backgroundColor = [UIColor whiteColor];
    UIImageView * add = [[UIImageView alloc]initWithFrame:CGRectMake(44, (rowheight-36)/2, 36, 36)];
    [add.layer setCornerRadius:18.f];
    add.layer.masksToBounds = YES;
    [add setImage:[UIImage imageNamed:@"add_uuser"]];
    UILabel * addlabel = [[UILabel alloc]initWithFrame:CGRectMake(44+36+25, (rowheight-20)/2, UIWidth/2, 20)];
    addlabel.text = [GlobalControlManger enStr:@"Add Account" geStr:@"Add Account"];
    addlabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    addlabel.textColor = [UIColor colorWithHexString:@"#121212"];
     UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
  //设置需要连续点击几次才响应，默认点击1次
    [tapGesture setNumberOfTapsRequired:1];
     [vv addGestureRecognizer:tapGesture];
    [vv addSubview:addlabel];
    [vv addSubview:add];
    return vv;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowheight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return rowheight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.useraccount != nil) {
        accountModel * model = self.useraccount[indexPath.row];
        self.email = model.email;
        self.password = model.pwd;
        if( model.type != nil) {
            [self dsfLoginwithaccount:model.email andtype:model.type];
            return;
        }else{
//             NSLog(@"1");
         [self loginAction];
           
        }
    }
    
}
- (void)dsfLoginwithaccount:(NSString*)account andtype:(NSString*)type {
    NSString * url = host(@"user/fgtLogin");
    if (account == nil || type == nil) {
        return;
    }
    [[NetworkingManger shareManger]postDataWithUrl:url para:@{@"account_type":type,@"account":account} success:^(NSDictionary * _Nonnull result) {
        NSInteger stateCode = [result[@"code"] integerValue];
        if (stateCode == 1) {
//            NSLog(@"%@",result);
            //成功获取datas保存用户信息
                    [[UserInfo shareUserInfo] setUserData:result[@"data"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
        }else{
            NSString * msg = [result objectForKey:@"msg"];
                   if (![msg isEqualToString:@""]) {
                        [Toast showToastMessage:msg];
                   }
                  
        }
       
    } fail:^(NSError * _Nonnull error) {
        NSLog(@"error-------------------%@",error);
    }];
}

-(void)event:(UITapGestureRecognizer *)gesture
{
   
    //处理事件
    LoginController *loginVC = [LoginController new];
    loginVC.islogout = YES;
    loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (NSString*) createDeviceTokenString:(NSData*) deviceToken {
    const unsigned char *tokenChars = deviceToken.bytes;

    NSMutableString *tokenString = [NSMutableString string];
    for (int i=0; i < deviceToken.length; i++) {
        NSString *hex = [NSString stringWithFormat:@"%02x", tokenChars[i]];
        [tokenString appendString:hex];
    }
    return tokenString;
}
- (void)loginAction{
    //三目运算处理
    NSString *url = host(@"login/login");
    if (self.email.length <6 || self.password.length > 30) {
        [Toast showToastMessage:@"Password is invalid"];
        return;;
    }
    NSString * email = self.email;
    NSString * password = self.password;
     AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *deviceTokenString = [self createDeviceTokenString:appDelegate.deviceToken];
    NSDictionary *para = @{@"email":email,@"password":password, @"address": deviceTokenString};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
          [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger stateCode = [result[@"code"] integerValue];
        NSString *msg = result[@"msg"];
        if (![msg isEqualToString:@""]) {
            [Toast showToastMessage:msg];
        }
        if (stateCode == 1) {
//            //成功获取datas保存用户信息
            [[UserInfo shareUserInfo] setUserData:result[@"data"]];
//            NSLog(@"%@",result[@"data"]);
//            //本地存储用户账号信息(判断账户信息是否存在，是更新，否写入)
////            [JPUSHService setAlias:[NSString stringWithFormat:@"imei_%@",result[@"data"][@"id"]] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
////              } seq:1];
             NSMutableArray *localAccounts = [[[NSUserDefaults standardUserDefaults] objectForKey:@"accounts"] mutableCopy];
    
                NSMutableDictionary *dic = [result[@"data"] mutableCopy];
               for (int i = 0 ; i<localAccounts.count;i++) {
                 if([dic[@"userid"] isEqualToString:localAccounts[i][@"userid"]]){
                     NSString * nickname = dic[@"nickname"];
                     NSString * pwd = localAccounts[i][@"pwd"];
                     [localAccounts removeObjectAtIndex:i];
                     [dic setValue:@"1" forKey:@"isMain"];
                     [dic setValue:nickname forKey:@"nickname"];
                     [dic setValue:pwd forKey:@"pwd"];
                     [localAccounts insertObject:dic atIndex:i];
                       [[NSUserDefaults standardUserDefaults] setObject:localAccounts forKey:@"accounts"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
                    [self dismissViewControllerAnimated:YES completion:nil];
                     return;
                 }
                  
               }
            //返回首页
//            [self dismissViewControllerAnimated:YES completion:nil];
           
        }
    } fail:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
