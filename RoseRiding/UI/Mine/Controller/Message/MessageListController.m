//
//  MessageListController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/30.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "MessageListController.h"
#import "MessageListCell.h"
#import "MessageListModel.h"
#import "AllMessageListModel.h"
#import "AllMessageTableViewCell.h"
#import "MessageDetailController.h"
//#import "WarningView.h"
@interface MessageListController ()<JXCategoryViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong)JXCategoryDotView *segment;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UITableView *alllisttableView;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, assign)NSInteger pagesnumber;
@property (nonatomic, assign)NSInteger messagenumber;
@property (nonatomic, assign)NSInteger rowheight;
@property (nonatomic, assign)NSInteger warningheight;
@property (nonatomic, strong)UIView * redDot;
@property (nonatomic, assign)BOOL isSystemMesaage;
@property (nonatomic, assign)BOOL canrefresh;
@property (nonatomic, strong)NSMutableArray <MessageListModel *>*list;
@property (nonatomic, strong)NSMutableArray <AllMessageListModel *>*alllist;
@property (nonatomic, strong)BikeDeviceModel * maindevice;
@property (nonatomic, strong)NSString * warningtime;
@property (nonatomic, strong)UILabel * warningTime;
@property (nonatomic, strong)NSString * warningId;
@property (nonatomic, strong)NSString * deviceimei;
@property (nonatomic, strong)UILabel * warningName;
@property (nonatomic, strong)UILabel * warningContent;
@property (nonatomic, assign)NSInteger * tableviewindex;

@end

@implementation MessageListController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self noWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.barStyle = NavigationBarStyleWhite;
    self.title = [GlobalControlManger enStr:@"Messages" geStr:@"Messages"];
    [self.view bringSubviewToFront:self.navView];
    
//  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveJPushNotification:) name:@"didReceiveJPushNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jpushNotificationCenter:) name:@"jpushNotificationCenter" object:nil];
    // Do any additional setup after loading the view.
    [self setupUI];
    self.tableviewindex = 0;
      self.messagenumber = 0;
      self.page = 0;
      self.pagesnumber = 20;
     self.list = [NSMutableArray array];
       self.alllist = [NSMutableArray array];
       self.isSystemMesaage = NO;
       [self loadData];
//    self.isnotify = YES;
//    [self showWarning];
}
- (void)refresh{
//    [self.tableView.mj_header beginRefreshing];
    [self.list removeAllObjects];
          [self.alllist removeAllObjects];
          self.page = 0;
          self.pagesnumber = 20;
          [self loadData];
   
}
- (void)getimei{
    if ([UserInfo shareUserInfo].Id == nil) {
        return;
    }
    if ([UserInfo shareUserInfo].token == nil) {
        return;
    }
    [[NetworkingManger shareManger] postDataWithUrl:host(@"user/mesg") para:@{@"userid":[UserInfo shareUserInfo].Id,@"token":[UserInfo shareUserInfo].token} success:^(NSDictionary * _Nonnull result) {
        if ([result[@"code"] integerValue] == 1) {
            [[NSUserDefaults standardUserDefaults]setObject:result[@"data"][@"imei"] forKey:@"device_imei"];
            self.deviceimei = result[@"data"][@"imei"];
            NSLog(@"imei--------------%@",result[@"data"][@"imei"]);
        }
        } fail:^(NSError * _Nonnull error) {
        }];
}
- (void)jpushNotificationCenter:(NSNotification*)notify{
//
    if ([notify.object[@"type"] isEqual:@"16"] || [notify.object[@"type"] isEqual:@"17"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshUI" object:nil userInfo:nil];
    }
}
/*
- (void)didReceiveJPushNotification:(NSNotification *)notification{

     //(@"notification====================%@",notification);
     //(@"notification===================%@",notification.userInfo.allKeys);
     //(@"%@",[[notification.userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    if ([[notification.userInfo objectForKey:@"type"]isEqualToString:@"4"]) {
        self.warningContent.text = [[notification.userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        self.warningTime.text = [notification.userInfo objectForKey:@"time"];
        self.warningName.text = [notification.userInfo objectForKey:@"msg_title"];
        self.isnotify = YES;
        [self showWarning];
    }else{
        self.isnotify = NO;

        [self noWarning];
    }
}
*/
- (void)setupUI{
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    self.warningheight = 104;
    _rowheight = 71;
    self.segment = [[JXCategoryDotView alloc] initWithFrame:CGRectMake(0, kNavHeight, UIWidth, 50)];
    self.segment.delegate = self;
    self.segment.titleColor = [UIColor colorWithHexString:@"#838383"];
    self.segment.titleSelectedColor = [UIColor colorWithHexString:@"#121212"];
    self.segment.dotSize = CGSizeMake(8, 8);
    [self.view addSubview:self.segment];
    self.warningView = [[UIView alloc]initWithFrame:CGRectMake(0,self.segment.frame.origin.y + self.segment.height  + 21, self.view.width, self.warningheight)];
    [tapGesture setNumberOfTapsRequired:1];
    [self.warningView addGestureRecognizer:tapGesture];
    UILabel * warningLabel = [[UILabel alloc]init];
    warningLabel.text = @"Warning!";
    warningLabel.textColor = [UIColor whiteColor];
    warningLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.warningView addSubview:warningLabel];
    [warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.warningView);
        make.height.offset(30);
        make.top.equalTo(self.warningView).offset(9);
    }];
//    UIButton * closeButton = [[UIButton alloc]init];
//    [closeButton setBackgroundImage:[UIImage imageNamed:@"cancel_warning"] forState:UIControlStateNormal];
//    [closeButton addTarget:self action:@selector(closeWarning:) forControlEvents:UIControlEventTouchUpInside];
//    closeButton.hidden = YES;
//    [_warningView addSubview: closeButton];
//    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_warningView).offset(12);
//        make.trailing.equalTo(_warningView).offset(-12);
//        make.width.height.offset(25);
//       }];
    UIView * line = [[UIView alloc]init];
    [line setBackgroundColor:[UIColor whiteColor]];
    [_warningView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_warningView);
        make.top.equalTo(_warningView).offset(45);
        make.leading.equalTo(_warningView).offset(45);
        make.height.offset(0.5);
    }];
    self.warningName = [[UILabel alloc]init];
    self.warningName.text = @"Alarm prompt";
    self.warningName.textColor = [UIColor whiteColor];
    self.warningName.font = [UIFont systemFontOfSize:14];
    [_warningView addSubview:self.warningName];
    [self.warningName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_warningView).offset(16);
        make.top.equalTo(line).offset(9);
    }];
    self.warningContent = [[UILabel alloc]init];
    _warningContent.text = self.msgcontent ;
    _warningContent.textColor = [UIColor whiteColor];
    _warningContent.font = [UIFont systemFontOfSize:10];
    [_warningView addSubview:_warningContent];
    [_warningContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(31);
        make.centerX.equalTo(_warningView);
        make.leading.equalTo(_warningView).offset(16);
    }];
    self.warningTime = [[UILabel alloc]init];
    _warningTime.text = @"23-08-2020";
    _warningTime.textColor = [UIColor whiteColor];
    _warningTime.font = [UIFont systemFontOfSize:10];
    [_warningView addSubview:_warningTime];
    [_warningTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_warningName);
        make.trailing.equalTo(_warningView).offset(-16);
    }];
    [_warningView setBackgroundColor:[UIColor colorWithHexString:@"#FF3F3F"]];
//    [self.tableView addSubview: self.warningView];
//      [self.view addSubview:warningView];

    self.segment.titles = @[[GlobalControlManger enStr:@"list of unread messages" geStr:@"list of unread messages"],[GlobalControlManger enStr:@"list of all messages" geStr:@"list of all messages"]];
    self.segment.titleColorGradientEnabled = YES;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor colorWithHexString:@"#121212"];
    lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    self.segment.indicators = @[lineView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavHeight + 50 );
    }];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = self.warningView;
    self.tableView.tableHeaderView.height = 0;
    self.tableView.tableHeaderView.hidden = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageListCell" bundle:nil] forCellReuseIdentifier:@"MessageListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AllMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"AllMessageTableViewCell"];
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_header beginRefreshing];
             [self.list removeAllObjects];
                   [self.alllist removeAllObjects];
                   self.page = 0;
                   self.pagesnumber = 20;
                   [self loadData];

    }];
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        [self.tableView.mj_footer beginRefreshing];
        if (self.messagenumber/self.pagesnumber>0 && self.page < self.messagenumber/self.pagesnumber ) {
            self.page += 1;
            [self loadData];
        }else{
           [self.tableView.mj_footer endRefreshing];
            return;
        }
        
    }];
    
}
- (void)closeWarning:(UIButton *)sender{
//   NSString *apnCount = @"Are you sure you want to turn off the alarm? You won't get any more messages";
    NSString * apnCount = [GlobalControlManger enStr:@"was this a false alarm?" geStr:@"was this a false alarm?"];
     
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:apnCount preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[GlobalControlManger enStr:@"no" geStr:@"no"] style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:[GlobalControlManger enStr:@"yes" geStr:@"yes"] style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
        [self setCancelalarm];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)setCancelalarm{
    NSLog(@"%@", self.warningId);
    NSLog(@"%@", self.deviceimei);
    NSLog(@"%@", [UserInfo shareUserInfo].token);
//if (![MyDevicemanger shareManger].mainDevice.isConnecting) {
//    NSString * i_mei = [[NSUserDefaults standardUserDefaults] objectForKey:@"device_imei"];
    if (self.deviceimei == nil) {
        return;
    }
    if (self.warningId == nil) {
        return;
    }
    if ([UserInfo shareUserInfo].token == nil) {
        return;
    }
    [[NetworkingManger shareManger] postDataWithUrl:host(@"/users/setCancelalarm") para:@{@"imei":self.deviceimei,@"token":[UserInfo shareUserInfo].token,@"id":self.warningId,@"is_theft":@"1"} success:^(NSDictionary * _Nonnull result) {
        NSLog(@"%@",result);
//           NSInteger stateCode = [result[@"code"] integerValue];
           NSString *msg = result[@"msg"];
        if (![msg isEqualToString:@""]) {
            [Toast showToastMessage:msg inview:self.view];
        }
       } fail:^(NSError * _Nonnull error) {
    //                    [MBProgressHUD hideHUDForView:self.view animated:YES];
           NSLog(@"%@",error);
//           [Toast showToastMessage:@"" inview:self.view];
       }];
    if ([MyDevicemanger shareManger].mainDevice.isConnecting) {
        [[GYBabyBluetoothManager sharedManager] writeState:NOT_WARING_Bluetooth];
    }
//}
}
- (void)event:(UITapGestureRecognizer *)gestur {
    MessageDetailController * MD = [[MessageDetailController alloc]init];
    MD.readDetail = ^{
        [self.list removeAllObjects];
        [self.alllist removeAllObjects];
        self.page = 0;
        [self loadData];
    };
    if (self.list.count>0) {
        MD.title = self.list[0].msgTitle;

        if ([self.list[0].alarm isEqualToString:@"2"]) {
            MD.isnew = YES;
        }else{
            MD.isnew = NO;
        }
    }
    
    MD.msgid = self.warningId;
    MD.isread = NO;
    MD.isalarm = YES;
    [self.navigationController pushViewController:MD animated:YES];

}
- (void)requestSetWaring
{
    NSString *url = host(@"users/setDevicemsg");
    NSMutableDictionary *para =[[NSMutableDictionary alloc] init];
    [para setValue:[UserInfo shareUserInfo].token forKey:@"token"];
    [para setValue:[MyDevicemanger shareManger].mainDevice.Id forKey:@"id"];
    [para setValue:@"1" forKey:@"is_alarm"];
       //@{@"id":[UserInfo shareUserInfo].device_id,@"token":};
              [MBProgressHUD showHUDAddedTo:self.view animated:YES];
              [[NetworkingManger shareManger] postDataWithUrl:url para:para success:^(NSDictionary * _Nonnull result) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                  NSInteger stateCode = [result[@"code"] integerValue];
                
                  NSString *msg = result[@"msg"];
                  if (stateCode == 1) {
//                      [self readed];
                      if ([self.list[0].msgtype isEqualToString:@"4"]||[self.list[0].msgtype isEqualToString:@"6"]) {
                          self.isnotify = NO;
                          [self showWarning];
                      }
                      [self.list removeAllObjects];
                      [self.alllist removeAllObjects];
                      self.page = 0;
                      [self loadData];
                  }else{
                      self.isnotify = YES;
                      if (![msg isEqualToString:@""]) {
                          [Toast showToastMessage:msg];
                      }
                  }
              } fail:^(NSError * _Nonnull error) {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
              }];
}
- (void)showWarning{
    if (self.isnotify == YES) {
        self.tableView.tableHeaderView.hidden = NO;
        self.tableView.tableHeaderView.height = self.warningheight;
        [self.tableView reloadData];
         [self  getimei];
    }else{
        [self noWarning];
    }
}
   
- (void)noWarning{
   self.tableView.tableHeaderView.hidden = YES;
   self.tableView.tableHeaderView.height = 0;
    [self.tableView reloadData];
    

}

//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    [self.list removeAllObjects];
        [self.alllist removeAllObjects];
       self.page = 0;
    if (index == 0) {
         //(@"%d",self.isnotify);
        self.isSystemMesaage = NO;
        self.tableviewindex = 0;
        if (self.list.count>0) {
            if ([self.list[0].msgtype isEqualToString:@"4"]||[self.list[0].msgtype isEqualToString:@"6"]) {
                self.isnotify = YES;
            }else{
                self.isnotify = NO;
            }
        }
    }else{
        self.isSystemMesaage = YES;
        self.tableviewindex = 1;
        self.isnotify = NO;
    }
   [self showWarning];
    [self loadData];
}

//点击选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index{
  
}

//滚动选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index{

}

//正在滚动中的回调
- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.tableviewindex == 0 ) {
        if (self.list.count > 0) {
             return self.list.count;
        }else{
            return 0;
        }
       
    }
    if (self.alllist.count>0) {
        return self.alllist.count;
    }else{
        return  0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isnotify == YES) {
        return self.warningheight;
    }else{
        return 0;
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return self.rowheight ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableviewindex == 0) {
         MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageListCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.list.count > 0) {
             cell.model = self.list[indexPath.row];
        }
        return cell;
    }else{
        AllMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllMessageTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.alllist.count > 0 ) {
             cell.model = self.alllist[indexPath.row];
        }
       
        return cell;
    }
}
//-(void)dealloc
//
//{
//
////移除观察者，Observer不能为nil
//
//[[NSNotificationCenter defaultCenter] removeObserver:self];
//
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.segment.userInteractionEnabled = NO;
//    NSLog(@"滑动了列表01");
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.segment.userInteractionEnabled = YES;
//    NSLog(@"滑动了列表02");
}

- (void)goBack{
    if (self.navigationController.viewControllers.count > 1) {
           [self.navigationController popToRootViewControllerAnimated:YES];
       } else {
           [self dismissViewControllerAnimated:YES completion:nil];
       }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageDetailController * MD = [[MessageDetailController alloc]init];
    MD.readDetail = ^{
        [self.list removeAllObjects];
         [self.alllist removeAllObjects];
        self.page = 0;
        [self loadData];
    };
//        self.redDot.hidden = YES;
    if (!self.isSystemMesaage) {
//        UIApplication *app = [UIApplication sharedApplication];
//        // App右上角数字
//        if (app.applicationIconBadgeNumber - 1 >0) {
//            app.applicationIconBadgeNumber -= 1;
//
//        }else{
//            app.applicationIconBadgeNumber = 0;
//        }        
        NSInteger  badge = [[UIApplication sharedApplication] applicationIconBadgeNumber];
        if (badge -1>=0) {
            [[UIApplication sharedApplication]setApplicationIconBadgeNumber:badge-1];
            [JPUSHService setBadge:badge-1];
        }
        if (self.list.count>0) {
        
        MessageListModel * model = self.list[indexPath.row];
        MD.title = model.msgTitle;
        if ([model.alarm isEqualToString:@"2"]) {
            MD.isnew = YES;
        }else{
            MD.isnew = NO;
        }
        if ([model.msgtype isEqualToString:@"4"]||[model.msgtype isEqualToString:@"6"]) {
            MD.isalarm = YES;
            
        }else{
            MD.isalarm = NO;
        }
        MD.msgid = model.Id;
            
        }
    }else{
        if (self.alllist.count>0) {
        
        AllMessageListModel* model = self.alllist[indexPath.row];
        MD.title = model.msgTtile;
        MD.isread = YES;
        MD.msgid = model.Id;
        }
    }
    [self.navigationController pushViewController:MD animated:YES];
}
- (void)loadData{
//     //(@"token---%@",[UserInfo shareUserInfo].token);
    if (!self.isSystemMesaage) {
        [[NetworkingManger shareManger] postDataWithUrl:host(@"api/type") para:@{@"id":[UserInfo shareUserInfo].Id,@"token":[UserInfo shareUserInfo].token,@"start_page":[NSString stringWithFormat:@"%ld",(long)self.page],@"pages":[NSString stringWithFormat:@"%ld",(long)self.pagesnumber]} success:^(NSDictionary * _Nonnull result) {
//            NSLog(@"result%@",result);
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            NSInteger stateCode = [result[@"code"] integerValue];
            if (stateCode != 1) {
                [Toast showToastMessage:result[@"msg"] inview:self.view];
                return;
            }
            NSMutableArray *temp  = [MessageListModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            if (temp.count>0) {
                self.segment.dotStates = @[@(YES),@(NO)];
            }else{
                self.segment.dotStates = @[@(NO),@(NO)];
            }
            [self.segment reloadData];
            if (temp.count < 20) {
                //TODO no more data
                
            }
            if (self.page == 0) {
                self.list = temp;
            }else{
                [self.list addObjectsFromArray:temp];
            }
            if (self.list.count == 0) {
                [Toast showToastMessage:@"no messages"];
                [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
                [self noWarning];
            }else if(self.list.count > 0){
//                self.warningId = self.list[0].Id;
                NSInteger badge = [result[@"msg"] integerValue];
               
                [[UIApplication sharedApplication]setApplicationIconBadgeNumber:badge];
                [JPUSHService setBadge:badge];
                self.messagenumber = [result[@"msg"] integerValue];
             
                if ([self.list[0].msgtype isEqualToString:@"4"]||[self.list[0].msgtype isEqualToString:@"6"]) {
                        self.isnotify = YES;
                        self.warningContent.text = self.list[0].value;
                        self.warningName.text = self.list[0].msgTitle;
                        self.warningTime.text = self.list[0].date;
                        self.warningId = self.list[0].Id;
                        NSArray *array = [self.list[0].date componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
                           NSString * newtime = @"";
                           for (int i = (int)array.count-1 ; i>= 0; i--) {
                                newtime = [newtime stringByAppendingFormat:@"%@.", [array objectAtIndex:i]];
                           }
                        self.warningTime.text = newtime;
                        [self showWarning];
                }else{
                    self.isnotify = NO;
                }
            }
            [self.tableView reloadData];
        } fail:^(NSError * _Nonnull error) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
    }else{
        [[NetworkingManger shareManger] postDataWithUrl:host(@"api/notice") para:@{@"token":[UserInfo shareUserInfo].token} success:^(NSDictionary * _Nonnull result) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
//              //(@"1111111%@",result[@"msg"]);
            NSInteger stateCode = [result[@"code"] integerValue];
            
            if (stateCode != 1) {
                [Toast showToastMessage:result[@"msg"] inview:self.view];
               
                return;
            }
            NSMutableArray *temp  = [AllMessageListModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            if (self.page == 0) {
                self.alllist = temp;
            }else{
                [self.alllist addObjectsFromArray:temp];
            }
            if (self.alllist.count == 0) {
                [Toast showToastMessage:@"no messages"];
            }
            [self.tableView reloadData];
         } fail:^(NSError * _Nonnull error) {
             [self.tableView.mj_header endRefreshing];
             [self.tableView.mj_footer endRefreshing];
         }];
    }
}


@end
