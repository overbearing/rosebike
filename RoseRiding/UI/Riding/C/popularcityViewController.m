//
//  popularcityViewController.m
//  RoseRiding
//
//  Created by 蜡笔小新 on 2020/7/29.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "popularcityViewController.h"
#import "popularTableViewCell.h"
#import "CityTableViewCell.h"
#import "CityModel.h"
#import "hotCityModel.h"
#import "historyModel.h"
#import "RidingViewContrller.h"
API_AVAILABLE(ios(13.0))
@interface popularcityViewController ()<GMSAutocompleteResultsViewControllerDelegate,UISearchBarDelegate,CLLocationManagerDelegate,GMSMapViewDelegate,UITextFieldDelegate,UISearchTextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITableViewDelegate,UITableViewDataSource,popularTableViewCellDelegate,CLLocationManagerDelegate>
{
    CLLocationManager * locationManager;
    NSString * currentCity; //当前城市
    
}
@property (nonatomic, strong)UISearchController *searchController;
@property (strong, nonatomic)UISearchTextField *search;
@property (nonatomic, strong) NSDictionary *currentLocationDetailInfo;
@property (nonatomic, strong)UITableView * citylist;
@property (nonatomic, strong)UIButton *setting;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,assign)BOOL firstLocationUpdate;
@property (nonatomic , strong)NSString * lat;
@property (nonatomic , strong)NSString * lng;
@property (nonatomic , strong)NSString * keyword;
@property (nonatomic , strong)NSString * level;
@property (nonatomic , strong)NSString * cityid;
@property (nonatomic , assign)BOOL iscount;
@property (nonatomic , assign)BOOL isearch;
@property (nonatomic , assign)BOOL iscancel;
@property (nonatomic, strong)GMSAutocompleteResultsViewController *resultsViewController;
@property (strong, nonatomic)  UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *sectionTitlesArray;
@property (nonatomic,strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray * searchArray;
@property (nonatomic, strong)NSMutableArray <hotCityModel *>*hotCity;
@property (nonatomic, strong)historyModel*historyCity;
@property (nonatomic, strong) NSString *address;



@end
@implementation popularcityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.keyword = @"";
    self.address = @"";
    self.level = @"2";
    self.iscount = NO;
    self.lat = @"";
    self.lng = @"";
    self.cityid = @"";
    self.barStyle = NavigationBarStyleWhite;
    [self loadpopularcity];
    [self initUI];
    [self starLoaction];
    
    // Do any additional setup after loading the view from its nib.
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (NSMutableArray *)hotCity{
    if (!_hotCity) {
        _hotCity = [NSMutableArray new];
    }
    return _hotCity;
}

- (NSMutableArray * )sectionArray{
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray new];
    }
    return _sectionArray;;
}

- (NSMutableArray *)sectionTitlesArray{
    if (!_sectionTitlesArray) {
        _sectionTitlesArray = [NSMutableArray new];
    }
    return _sectionTitlesArray;
}
- (NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [NSMutableArray new];
    }
    return _searchArray;
}
- (void)initUI{
    [self setSearchVC];
    self.setting = [UIButton buttonWithType:UIButtonTypeCustom];
//     CGFloat minX = [UIScreen mainScreen].bounds.size.width - 30 - Adaptive(20);
    [_setting addTarget:self action:@selector(cancelsearch) forControlEvents:UIControlEventTouchUpInside];
    [_setting setTitle:@"Cancel" forState:UIControlStateNormal];
    [_setting setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _setting.titleLabel.font = [UIFont systemFontOfSize:14];
    _setting.userInteractionEnabled = NO;
//     [setting setImage:[UIImage imageNamed:@"edit_equipment"] forState:UIControlStateNormal];
//     setting.hidden = self.type == DeviceInfoAdd;
    [self.navView addSubview:_setting];
    [_setting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.search);
        make.width.equalTo(@50);
        make.trailing.equalTo(self.navView).offset(-15);
    }];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableview registerNib:[UINib nibWithNibName:@"popularTableViewCell" bundle:nil] forCellReuseIdentifier:@"popularTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CityTableViewCell" bundle:nil] forCellReuseIdentifier:@"CityTableViewCell"];
//    self.tableview.separatorStyle = UITableViewScrollPositionNone;
    [self.view addSubview:self.tableview];
     self.tableview.delegate =self;
    self.tableview.dataSource =self;
    self.tableview.sectionIndexColor = [UIColor colorWithHexString:@"#838383"];
    self.tableview.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableview.separatorColor = [UIColor clearColor];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-(kSafeAreaBottomHeight));
    }];
}
- (void)starLoaction{
    if (![CLLocationManager locationServicesEnabled]) {
         self.lat = self.lng = @"";
        NSLog(@"您的设备暂未开启定位服务");
        return;
    }
       // 2、初始化定位服务
       _locationManager = [[CLLocationManager alloc] init];
       // 3、请求定位授权*
       // 请求在使用期间授权（弹框提示用户是否允许在使用期间定位）,需添加NSLocationWhenInUseUsageDescription到info.plist
       [_locationManager requestWhenInUseAuthorization];
       // 请求在后台定位授权（弹框提示用户是否允许不在使用App时仍然定位）,需添加NSLocationAlwaysUsageDescription添加key到info.plist
       [_locationManager requestAlwaysAuthorization];
       // 4、设置定位精度
       _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
       // 5、设置定位频率，每隔多少米定位一次
//       _locationManager.distanceFilter = 10.0;
       // 6、设置代理
       _locationManager.delegate = self;
       // 7、开始定位
       // 注意：开始定位比较耗电，不需要定位的时候最好调用 [stopUpdatingLocation] 结束定位。
       [_locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
     //反编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            self->currentCity = placeMark.locality;
            if (self->currentCity != nil) {
                if ([[NSUserDefaults standardUserDefaults]objectForKey:@"historylocation"] != nil) {
                    NSMutableArray * arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"historylocation"];
                    NSMutableArray * copy = [arr mutableCopy];
                    for (int i=0 ; i<copy.count; i++) {
                        if (i<3) {
                            if ([copy[i] isEqualToString:self->currentCity]) {
                                [copy removeObject:copy[i]];
                            }
                        }
                    }
                     [copy insertObject:self->currentCity atIndex:0];
                    [[NSUserDefaults standardUserDefaults]setObject:copy forKey:@"historylocation"];
                }else{
                NSMutableArray * arr = [NSMutableArray new];
                 [arr addObject:self->currentCity];
                [[NSUserDefaults standardUserDefaults]setObject:arr forKey:@"historylocation"];
                }
            }
            if (!self->currentCity) {
                self->currentCity = [GlobalControlManger enStr:@"Unable to locate the current city" geStr:@"Unable to locate the current city"] ;
            }
            NSLog(@"%@",self->currentCity); //这就是当前的城市
            NSLog(@"%@",placeMark.name);//具体地址:  xx市xx区xx街道
        }
        else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error return");
        }
        else if (error) {
            NSLog(@"location error: %@ ",error);
        }
        [self.tableview reloadData];
   }];
}
- (void)loadpopularcity{
//    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"historylocation"]);
    NSString * url = host(@"bicycle/historyList");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetworkingManger shareManger] postDataWithUrl:url para:@{@"keywords":self.keyword ,@"level": self.level,@"type":[Languagemanger shareManger].isEn?@"1":@"2",@"count":self.iscount?@"1":@"2",@"city":@"",@"id":self.cityid
    } success:^(NSDictionary * _Nonnull result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"result--------%@",result[@"data"]);
        if (result[@"data"][@"h_addr"] != nil) {
            self.historyCity = [historyModel mj_objectWithKeyValues:result[@"data"][@"h_addr"]];
        }
        if([result[@"code"] intValue]==1){
            if (result[@"data"] != nil) {
                
                 self.hotCity = [hotCityModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"hotAreas"]];
                           if (result[@"data"][@"areas"] != nil) {
                               for (NSDictionary * dic in result[@"data"][@"areas"]) {
                                   CityModel * model = [[CityModel alloc]init];
                                   model.name = dic[@"addr"];
                                   model.Id = dic[@"id"];
                                   model.h_id = dic[@"h_id"];
                                   [self.dataArray addObject:model];
                                   [self.searchArray addObject:dic];
                               }
                               if (self.dataArray.count >0) {
                                    [self setUpTableSection];
                               }else{
                                   [self.tableview reloadData];
                                   [Toast showToastMessage:@"no addresses searched in this city" inview:self.view];
                                   return;
                               }
                           }
            }else{
                return;
            }
           
            
        }
    } fail:^(NSError * _Nonnull error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void) setUpTableSection {
     UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
       //create a temp sectionArray
       NSUInteger numberOfSections = [[collation sectionTitles] count];
       NSMutableArray *newSectionArray =  [[NSMutableArray alloc]init];
       for (NSUInteger index = 0; index<numberOfSections; index++) {
           [newSectionArray addObject:[[NSMutableArray alloc]init]];
       }
      // insert Persons info into newSectionArray
       for (CityModel *model in self.dataArray) {
           NSUInteger sectionIndex = [collation sectionForObject:model collationStringSelector:@selector(name)];
           [newSectionArray[sectionIndex] addObject:model];
       }
       //sort the person of each section
       for (NSUInteger index=0; index<numberOfSections; index++) {
           NSMutableArray *personsForSection = newSectionArray[index];
           NSArray *sortedPersonsForSection = [collation sortedArrayFromArray:personsForSection collationStringSelector:@selector(name)];
           newSectionArray[index] = sortedPersonsForSection;
       }
    NSMutableArray *temp = [NSMutableArray new];
       [newSectionArray enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
           if (arr.count == 0) {
               [temp addObject:arr];
           } else {
               [self.sectionTitlesArray addObject:[collation sectionTitles][idx]];
           }
       }];
       [newSectionArray removeObjectsInArray:temp];
       self.sectionArray = newSectionArray;
    [self.sectionTitlesArray insertObject:@"#" atIndex:0];
    [self.tableview reloadData];
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)setSearchVC{
     kWeakSelf
    if (@available(iOS 13.0, *)) {
        weakSelf.search = [[UISearchTextField alloc]init];
        weakSelf.search.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
//           weakSelf.search.backgroundColor = [UIColor lightGrayColor];
        weakSelf.search.delegate = weakSelf;
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
         NSTextAlignment  alignment = NSTextAlignmentCenter;
        style.alignment = alignment;
        NSAttributedString *attri = [[NSAttributedString alloc] initWithString:@"Search the city" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:style}];
        weakSelf.search.attributedPlaceholder = attri;
//        weakSelf.search.textAlignment = NSTextAlignmentCenter;
           [weakSelf.navView addSubview:weakSelf.search];
        [weakSelf.search mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.navView).offset(-15);
            make.width.equalTo(@(UIWidth-120));
            make.height.equalTo(@30);
            make.bottom.equalTo(self.navView).offset(-8);
        }];
    } else {
        // Fallback on earlier versions
    }
//    weakSelf.search.backgroundColor = [UIColor blueColor];
    weakSelf.resultsViewController = [[GMSAutocompleteResultsViewController alloc] init];
    weakSelf.resultsViewController.delegate = weakSelf;
    GMSAutocompleteFilter *autocompleteFilter = [[GMSAutocompleteFilter alloc] init];
    NSLocale *currentLocalestr = [NSLocale currentLocale];
       NSString * countryCode = [currentLocalestr objectForKey:NSLocaleCountryCode];
    autocompleteFilter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;
    autocompleteFilter.country = countryCode;
    weakSelf.resultsViewController.autocompleteFilter = autocompleteFilter;
    weakSelf.searchController = [[UISearchController alloc]
                         initWithSearchResultsController:weakSelf.resultsViewController];
    _searchController.searchResultsUpdater = weakSelf.resultsViewController;
    // Put the search bar in the navigation bar.
    [_searchController.searchBar sizeToFit];
//    weakSelf.navigationItem.titleView = weakSelf.searchController.searchBar;
    // When UISearchController presents the results view, present it in
    // this view controller, not one further up the chain.
    weakSelf.definesPresentationContext = YES;
    // Prevent the navigation bar from being hidden when searching.
    _searchController.hidesNavigationBarDuringPresentation = NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    kWeakSelf
    if (textField == weakSelf.search) {
        [textField becomeFirstResponder];
        self.iscancel = NO;
//        [weakSelf presentViewController:weakSelf.searchController animated:YES completion:nil];
    }
}
- (void)textFieldDidChangeSelection:(UITextField *)textField{
    if (textField == self.search) {
        if(textField.text.isNotBlank) {
            [self.setting setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
            _setting.userInteractionEnabled = YES;
            [self.search becomeFirstResponder];
        }else{
            [self.setting setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _setting.userInteractionEnabled = NO;
            [self.search resignFirstResponder];
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    kWeakSelf
    if (textField == weakSelf.search) {
        [textField resignFirstResponder];
    }
    if (textField.text.isNotBlank) {
        if (!self.iscancel) {
             self.keyword = self.search.text;
            //       self.iscount = YES;
            self.cityid = @"";
                   [self.sectionTitlesArray removeAllObjects];
                   [self.sectionArray removeAllObjects];
                   [self.hotCity removeAllObjects];
                   [self.dataArray removeAllObjects];
                   [self loadpopularcity];
//                   [self.search resignFirstResponder];
//                   self.search.text = @"";
        }
       }
}
- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
  didAutocompleteWithPlace:(GMSPlace *)place {
    _searchController.active = NO;
    // Do something with the selected place.
}
- (void)cancelsearch{
    self.iscancel = YES;
    [self.search resignFirstResponder];
    self.search.text = @"";
    self.keyword = @"";
    self.setting.userInteractionEnabled = NO;
    [self.setting setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.cityid = @"";
    //       self.iscount = YES;
           [self.sectionTitlesArray removeAllObjects];
           [self.sectionArray removeAllObjects];
           [self.hotCity removeAllObjects];
           [self.dataArray removeAllObjects];
           [self loadpopularcity];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        popularTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"popularTableViewCell" forIndexPath:indexPath];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.userInteractionEnabled = NO;
        if (cell == nil) {
            cell = [[popularTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"popularTableViewCell"];
        }
        cell.delegate = self;
        if (indexPath.row == 0) {
            cell.title.text = @"Used City";
            
//            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"historylocation"] != nil) {
//                cell.history = [[NSUserDefaults standardUserDefaults]objectForKey:@"historylocation"];
//            }
//            NSLog(@"%@",self.historyCity);
            if (self.historyCity != nil) {
                historyModel * model = self.historyCity;
                cell.model = model;
                cell.click = ^{
                    self.cityid = model.Id;
                };
            }
        }else{
            UIButton * btn = cell.firstcity;
            UIButton * btn2 = cell.secondcity;
            UIButton * btn3 = cell.thirdcity;
            cell.title.text = @"Popular City";
            cell.hotcity = self.hotCity;
            cell.click = ^{
                if (btn.selected) {
                    self.cityid = self.hotCity[0].Id;
                }
                if (btn2.selected) {
                    self.cityid = self.hotCity[1].Id;
                }
                if (btn3.selected) {
                    self.cityid = self.hotCity[2].Id;
                }
            };
        }
        return cell;
    }else{
        CityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CityTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[CityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CityTableViewCell"];
        }
        NSUInteger section = indexPath.section;
        NSUInteger row = indexPath.row;
        if (self.sectionArray.count > 0) {
            CityModel * model = self.sectionArray[section-1][row];
            cell.model = model;
            
        }
        
        return cell;
    }
      
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (self.historyCity != nil) {
                return 80;
            }else{
                return 0;
            }
        }
        return 80;
    }
    return 30;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return self.sectionTitlesArray.count;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return [self.sectionArray[section-1] count];
}
-(void)clickTest:(NSString *)tag{
//    NSLog(@"%@",tag);
    self.search.text = tag;
     [self.setting setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    _setting.userInteractionEnabled = YES;
//    RidingViewContrller * vc = [[RidingViewContrller alloc]init];
//    [vc.topView.startBtn setUserInteractionEnabled:YES];
    self.keyword = tag;
     [self.sectionTitlesArray removeAllObjects];
                      [self.sectionArray removeAllObjects];
                      [self.hotCity removeAllObjects];
                      [self.dataArray removeAllObjects];
                      [self loadpopularcity];
//                      [self.search resignFirstResponder];
//                      self.search.text = @"";
//    vc.isjump = YES;
//    vc.name = tag;
//    if (tag.isNotBlank) {
//         [self.navigationController pushViewController:vc animated:YES];
//    }
//
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIWidth, 43)];
        view.backgroundColor = [UIColor whiteColor];
        UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location003"]];
        image.frame = CGRectMake(30, 10, 16, 16);
        [view addSubview:image];
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(30, view.height-1, UIWidth-61, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
        [view addSubview:line];
        UILabel * location = [[UILabel alloc]init];
        location.text = self->currentCity;
        location.font = [UIFont systemFontOfSize:15.0f weight:UIFontWeightMedium];
        [view addSubview:location];
        [location mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(image).offset(30);
            make.centerY.equalTo(image);
            make.height.equalTo(@30);
        }];
        return view;
    }
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIWidth, 43)];
    UILabel * title = [[UILabel alloc]init];
    title.frame = CGRectMake(41, 0, UIWidth, view.height-1);
    title.backgroundColor = [UIColor whiteColor];
    title.textColor = [UIColor colorWithHexString:@"#838383"];
    title.font = [UIFont systemFontOfSize:15.0f weight:UIFontWeightMedium];
    if (self.sectionTitlesArray.count > 0) {
        title.text = [self.sectionTitlesArray objectAtIndex:section];
    }
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(30, view.height-1, UIWidth-61, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [view addSubview:line];
    [view addSubview:title];
    return view;
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionTitlesArray;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NSUInteger section = indexPath.section;
           NSUInteger row = indexPath.row;
    if (section == 0) {
        return;
         
    }else{
        if (self.sectionArray.count > 0) {
            CityModel * model = self.sectionArray[section-1][row];
            NSLog(@"id---------------%@",model.Id);
            self.cityid = model.Id;
             self.search.text = model.name;
             [self.setting setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
             _setting.userInteractionEnabled = YES;
            if (model.h_id == nil) {
               [self.sectionTitlesArray removeAllObjects];
                                    [self.sectionArray removeAllObjects];
                                    [self.hotCity removeAllObjects];
                                    [self.dataArray removeAllObjects];
                                    [self loadpopularcity];
//                                    [self.search resignFirstResponder];
//                                    self.search.text = @"";
            }else{
                 RidingViewContrller * vc = [[RidingViewContrller alloc]init];
                                                       [vc.topView.startBtn setUserInteractionEnabled:YES];
                                                       vc.isjump = YES;
                                                 vc.name = model.name;
                             if (model.name.isNotBlank) {
                                                       [self.navigationController pushViewController:vc animated:YES];
                        }else{
                            return;
                        }
            }
//
                
             }
    }
          
   
}
@end
