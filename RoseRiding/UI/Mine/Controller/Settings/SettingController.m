//
//  SettingController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/30.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "SettingController.h"

//controller
#import "SetLanguageController.h"
#import "AccountsController.h"
#import "AboutUsController.h"
#import "VersionController.h"
#import "ResetPasswordViewController.h"
#import "LoginController.h"
//view
#import "MenuCell.h"


@interface SettingController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSString * password;

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.barStyle = NavigationBarStyleWhite;
    self.title = @"Settings";
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
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    self.tableView.separatorColor = [UIColor clearColor];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Adaptive(108);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setIsSetting:YES];
    [cell configureCellwith:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            SetLanguageController * SL = [[SetLanguageController alloc]init];
            [self.navigationController pushViewController:SL animated:YES];
        }
            break;
        case 1:
        {
            AboutUsController *VC = [[AboutUsController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 2:
        {
            VersionController  *VC = [[VersionController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 3:
        {
            AccountsController *VC = [[AccountsController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 4:
        {
            ResetPasswordViewController *VC = [[ResetPasswordViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
            
            case 5:
            {
                //删除账号
                [self showAlert];
            }
                break;
//        default:
            break;
    }
    
}
- (void)showAlert{
    NSString * apnCount = [GlobalControlManger enStr:@"We will delete all the information under your account from the background, and you will not be able to use any vehicles until you re-register your account." geStr:@"We will delete all the information under your account from the background, and you will not be able to use any vehicles until you re-register your account."];
    NSString * title = [GlobalControlManger enStr:@"Are you sure you want to delete the account?" geStr:@"Are you sure you want to delete the account?"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:apnCount preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[GlobalControlManger enStr:@"no" geStr:@"no"] style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:[GlobalControlManger enStr:@"yes" geStr:@"yes"]style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
         [self inputpasswrod];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)deleteAccount{
    NSString *url = host(@"user/delusers");
    [[NetworkingManger shareManger]postDataWithUrl:url para:@{@"password":self.password} success:^(NSDictionary * _Nonnull result) {
        if ([result[@"code"] intValue] == 1) {
            [Toast showToastMessage:@"delete account successed" inview:self.view];
            NSMutableArray *localAccounts = [[[NSUserDefaults standardUserDefaults] objectForKey:@"accounts"] mutableCopy];
            for (NSDictionary * user in localAccounts) {
                if ([user[@"userid"] isEqual:[UserInfo shareUserInfo].userid]) {
                    [localAccounts removeObject:user];
                }
            }
            [[NSUserDefaults standardUserDefaults] setObject:localAccounts forKey:@"accounts"];
             LoginController *loginVC = [LoginController new];
            loginVC.islogout = YES;
                   loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
                   [self presentViewController:loginVC animated:YES completion:nil];
        }
    } fail:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
-(void)inputpasswrod{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Delete account"
                                                                                 message: @"Please input your password,or enter ‘delete’ for the third party account"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
//       [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//           textField.placeholder = @"name";
//           textField.textColor = [UIColor blueColor];
//           textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//           textField.borderStyle = UITextBorderStyleRoundedRect;
//       }];
       [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
           textField.placeholder = @"password";
           textField.textColor = [UIColor blackColor];
           textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//           textField.borderStyle = UITextBorderStyleRoundedRect;
           textField.secureTextEntry = YES;
       }];
       [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
           NSArray * textfields = alertController.textFields;
//           UITextField * namefield = textfields[0];
           UITextField * passwordfiled = textfields[0];
           self.password = passwordfiled.text;
           [self deleteAccount];
    
       }]];
       [self presentViewController:alertController animated:YES completion:nil];
}
@end
