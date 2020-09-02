//
//  MessageDetailController.m
//  RoseRiding
//
//  Created by Mac on 2020/6/3.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "MessageDetailController.h"
#import "MsgDetailCell.h"
#import "MsgDetailModel.h"
@interface MessageDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * msgDetail;
@property (nonatomic,strong)UITableView * detailTable;
@property (nonatomic, strong)NSMutableArray <MsgDetailModel *>*list;
@property (nonatomic,strong)MsgDetailModel * model;
@end

@implementation MessageDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.list = [NSMutableArray array];
    self.barStyle = NavigationBarStyleWhite;
    [self.view bringSubviewToFront:self.navView];
    [self setupUI];
    [self readed];
    // Do any additional setup after loading the view.
}
- (void)showalert{
    if (!self.isread && self.isalarm && self.isnew) {
        [self cancelalarm];
    }else{
        NSLog(@"已读");
    }
}
- (void)setupUI{
    self.detailTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
     [self.view addSubview:self.detailTable];
    [self.detailTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavHeight);
    }];
    self.detailTable.dataSource = self;
    self.detailTable.delegate = self;
    self.detailTable.scrollEnabled = NO;
   [self.detailTable registerNib:[UINib nibWithNibName:NSStringFromClass([MsgDetailCell class]) bundle:nil] forCellReuseIdentifier:@"MsgDetailCell"];
    self.detailTable.separatorColor = [UIColor clearColor];
}
- (void)goBack{
    [super goBack];
    if (self.readDetail) {
        self.readDetail();
    }
}
- (void)cancelalarm{
    NSString *apnCount = @"Was this a false alarm?";
         UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:apnCount preferredStyle:UIAlertControllerStyleAlert];
       UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
       UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
           [self setCancelalarm];
       }];
       [alert addAction:cancelAction];
       [alert addAction:okAction];
       [self presentViewController:alert animated:YES completion:nil];
}
- (void)setCancelalarm{
    if (![MyDevicemanger shareManger].mainDevice.isConnecting) {
        NSString * i_mei = [[NSUserDefaults standardUserDefaults] objectForKey:@"device_imei"];
        [[NetworkingManger shareManger] postDataWithUrl:host(@"api/users/setCancelalarm") para:@{@"imei":i_mei == nil? @"0":i_mei,@"token":[UserInfo shareUserInfo].token,@"id":self.msgid == nil ?@"": self.msgid} success:^(NSDictionary * _Nonnull result) {
               NSInteger stateCode = [result[@"code"] integerValue];
               NSString *msg = result[@"msg"];
            if (![msg isEqualToString:@""]) {
                [Toast showToastMessage:msg];
            }
               if (stateCode == 1) {
        
               }else{
                   
               }
               
           } fail:^(NSError * _Nonnull error) {
        //                    [MBProgressHUD hideHUDForView:self.view animated:YES];
           }];
    }else{
         [[GYBabyBluetoothManager sharedManager] writeState:NOT_WARING_Bluetooth];
    }
    
}
- (void)readed{
    [[NetworkingManger shareManger] postDataWithUrl:host(@"api/typedet") para:@{@"typeid":self.msgid == nil ?@"":self.msgid,@"token":[UserInfo shareUserInfo].token} success:^(NSDictionary * _Nonnull result) {
       NSInteger stateCode = [result[@"code"] integerValue];
       NSString *msg = result[@"msg"];
       [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       if (stateCode == 1) {
           NSMutableArray * temp = [NSMutableArray array];
           if (result[@"data"] != nil) {
               [temp addObject:result[@"data"]];
           }
           
           self.list = [MsgDetailModel mj_objectArrayWithKeyValuesArray:temp];
           [self showalert];
           [self.detailTable reloadData];
       }else{
           if (![msg isEqualToString:@""]) {
               [Toast showToastMessage:msg];
           }
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
//*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MsgDetailCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"MsgDetailCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.list.count > 0) {
         cell.model = self.list[indexPath.row];
    }
   
     if(!cell){//如果没有创建mycell的话
            //通过xib的方式加载单元格
    cell = [[[NSBundle mainBundle] loadNibNamed:@"MsgDetailCell" owner:self options:nil] lastObject];
            //把模型数据设置给单元格
    }
//    cell.model = self.model;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.list.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.detailTable.height;
}
@end
