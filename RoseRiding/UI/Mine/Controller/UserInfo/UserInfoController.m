//
//  UserInfoController.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/30.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "UserInfoController.h"
#import "UserInfoHeadView.h"
#import "UserInfoMenuCell.h"

@interface UserInfoController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UserInfoHeadView *headView;

@end

@implementation UserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self setupUI];
    self.barStyle = NavigationBarStyleWhite;
    // Do any additional setup after loading the view.
}
- (void)setupUI{

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavHeight);
    }];
# ifdef __IPHONE_11_0
    if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
    if (@available(iOS 11.0, *)) {
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    _tableView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0 );
        
       //属性的解释
        /* When contentInsetAdjustmentBehavior allows, UIScrollView may incorporate
        its safeAreaInsets into the adjustedContentInset.
        @property(nonatomic, readonly) UIEdgeInsets adjustedContentInset API_AVAILABLE(ios(11.0),tvos(11.0));
        */
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    }
    }
    
#endif
    
    self.extendedLayoutIncludesOpaqueBars = YES;

    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoMenuCell" bundle:nil] forCellReuseIdentifier:@"UserInfoMenuCell"];
    UserInfoHeadView *headView = [[UserInfoHeadView alloc] initWithFrame: CGRectMake(0, 0, UIWidth, Device_iPhone5 ? 180 : 280)];
    self.headView = headView;
    kWeakSelf
    headView.submit = ^(NSString * _Nullable str) {
        if (str != nil) {
            [weakSelf changeNickName:str];
        }
    };
    headView.changeHeadImg = ^{
        [weakSelf changeHeadImg];
    };
    headView.nick.text = [UserInfo shareUserInfo].nickname;
    [headView.headImg sd_setImageWithURL:[NSURL URLWithString:[UserInfo shareUserInfo].headimg] placeholderImage:[UIImage imageNamed:@"defaulticon"]];
    self.tableView.tableHeaderView = headView;
    self.tableView.scrollEnabled = NO;
    [headView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    [self.view bringSubviewToFront:self.navView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Adaptive(75);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
if ([cell respondsToSelector:@selector(setSeparatorInset:)])
{
[cell setSeparatorInset:UIEdgeInsetsZero];
}
if ([cell respondsToSelector:@selector(setLayoutMargins:)])
{
[cell setLayoutMargins:UIEdgeInsetsZero];
}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserInfoMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoMenuCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        [cell configureCellWithIndexpath:indexPath rightContent:[UserInfo shareUserInfo].userid];
    }else if(indexPath.row == 1){
        NSString *sex;
        if ([[UserInfo shareUserInfo].sex isEqualToString:@"0"]) {
            sex = @"male";
        }else if([[UserInfo shareUserInfo].sex isEqualToString:@"1"]){
            sex = @"female";
        }else if([[UserInfo shareUserInfo].sex isEqualToString:@"2"]){
            sex = @"diverse";
        }else{
            sex = @"";
        }
        [cell configureCellWithIndexpath:indexPath rightContent:sex];
    }else{
        [cell configureCellWithIndexpath:indexPath rightContent:[UserInfo shareUserInfo].email];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        //性别设置
        [self changeSex];
    }else if(indexPath.row == 2){
        
    }
    
}

- (void)tapAction:(UITapGestureRecognizer *)gesture{
    
    
}

- (void)changeSex{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"male" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self changeSexWithType:@"0"];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"female" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self changeSexWithType:@"1"];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"diverse" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [self changeSexWithType:@"2"];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)changeSexWithType:(NSString *)type{
    [[NetworkingManger shareManger] postDataWithUrl:host(@"user/sex") para:@{@"id":[UserInfo shareUserInfo].Id,@"token":[UserInfo shareUserInfo].token,@"sex":type} success:^(NSDictionary * _Nonnull result) {
        NSInteger stateCode = [result[@"code"] integerValue];
        if (stateCode != 1) {
            [Toast showToastMessage:result[@"msg"] inview:self.view];
            return;
        }
         [Toast showToastMessage:result[@"msg"] inview:self.view];
        [UserInfo shareUserInfo].sex = type;
        [self.tableView reloadData];
    } fail:^(NSError * _Nonnull error) {
        
    }];
}

- (void)changeNickName:(NSString *)nickname{
    [[NetworkingManger shareManger] postDataWithUrl:host(@"user/nickname") para:@{@"id":[UserInfo shareUserInfo].Id,@"token":[UserInfo shareUserInfo].token,@"nickname":nickname} success:^(NSDictionary * _Nonnull result) {
        NSInteger stateCode = [result[@"code"] integerValue];
        if (stateCode != 1) {
            [Toast showToastMessage:result[@"msg"] inview:self.view];
            return;
        }
         [Toast showToastMessage:result[@"msg"] inview:self.view];
        [UserInfo shareUserInfo].nickname = nickname;
        self.headView.nick.text = nickname;
    } fail:^(NSError * _Nonnull error) {

    }];
}

- (void)changeHeadImg{
    UIAlertController *userIconActionSheet = [UIAlertController alertControllerWithTitle:@"Choose Image" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //相册选择
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"Choose from library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //这里加一个判断，是否是来自图片库
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;            //协议
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    //系统相机拍照
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"Take a photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
               UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消

    }];
    [userIconActionSheet addAction:albumAction];
    [userIconActionSheet addAction:photoAction];
    [userIconActionSheet addAction:cancelAction];
    [self presentViewController:userIconActionSheet animated:YES completion:nil];
}

#pragma mark 调用系统相册及拍照功能实现方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];//获取到所选择的照片
    self.headView.headImg.image = img;
//    UIImage *compressImg = [self imageWithImageSimple:img scaledToSize:CGSizeMake(60, 60)];//对选取的图片进行大小上的压缩
    [self transportImgToServerWithImg:img]; //将裁剪后的图片上传至服务器
    [self dismissViewControllerAnimated:YES completion:nil];

}

//用户取消选取时调用,可以用来做一些事情
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//压缩图片方法
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


//上传图片至服务器后台
- (void)transportImgToServerWithImg:(UIImage *)img{
    NSData *imageData;
    NSString *mimetype;
  //判断图片格式
//    if (UIImagePNGRepresentation(img) != nil) {
        mimetype = @"image/png";
//        imageData = UIImagePNGRepresentation(img);
//    }else{
//        mimetype = @"image/jpeg";
       imageData = UIImageJPEGRepresentation(img, 0.05);
//    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd-HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *str =  [NSString stringWithFormat:@"%@_%@",[UserInfo shareUserInfo].Id,[formatter stringFromDate:datenow]];
    
    NSString *fileName = [[NSString alloc] init];
    if (UIImagePNGRepresentation(img) != nil) {
        fileName = [NSString stringWithFormat:@"%@.png", str];
    }else{
        fileName = [NSString stringWithFormat:@"%@.jpg", str];
    }
//    NSString *urlString = host(@"Upfiles/upload");
//    NSDictionary *params = @{@"token":[UserInfo shareUserInfo].token,@"id":[UserInfo shareUserInfo].Id};
//    [[NetworkingManger shareManger] uploadFile:urlString para:params data:imageData fileName:fileName mimetype:mimetype success:^(NSDictionary * _Nonnull result) {
//        NSInteger stateCode = [result[@"code"] integerValue];
//        if (stateCode != 1) {
//            [Toast showToastMessage:result[@"msg"] inview:self.view];
//            return;
//        }
//        @try {
//            [Toast showToastMessage:result[@"msg"] inview:self.view];
//            [UserInfo shareUserInfo].headimg = result[@"data"][@"url"];
//            [self.headView.headImg sd_setImageWithURL:[NSURL URLWithString:result[@"data"][@"url"]] placeholderImage:nil];
//            [self bindingUserHeadImgWithImageAddress:img fileName:str];
//        } @catch (NSException *exception) {
//
//        }
//
//    } fail:^(NSError * _Nonnull error) {
//
//    }];
    
    [self bindingUserHeadImgWithImageAddress:img fileName:fileName];
}

- (void)bindingUserHeadImgWithImageAddress:(UIImage *)img fileName:(NSString *)nameString{

      NSData *imageData;
      NSString *mimetype;
    //判断图片格式
//      if (UIImagePNGRepresentation(img) != nil) {
          mimetype = @"image/png";
//          imageData = UIImagePNGRepresentation(img);
//      }else{
//          mimetype = @"image/jpeg";
                     
          imageData = UIImageJPEGRepresentation(img, 0.05);
//      }
      NSString *str = @"avatar";
      NSString *fileName = [[NSString alloc] init];
      if (UIImagePNGRepresentation(img) != nil) {
          fileName = [NSString stringWithFormat:@"%@.png", str];
      }else{
          fileName = [NSString stringWithFormat:@"%@.jpg", str];
      }
      NSString *urlString = host(@"user/upload");
      NSDictionary *params = @{@"token":[UserInfo shareUserInfo].token,@"id":[UserInfo shareUserInfo].Id};
      [[NetworkingManger shareManger] uploadFile:urlString para:params data:imageData fileName:fileName mimetype:mimetype success:^(NSDictionary * _Nonnull result) {
          NSInteger stateCode = [result[@"code"] integerValue];
          if (stateCode != 1) {
              [Toast showToastMessage:result[@"msg"] inview:self.view];
              return;
          }
          [UserInfo shareUserInfo].headimg = result[@"data"][@"headimg"];
          [self.headView.headImg sd_setImageWithURL:[NSURL URLWithString:result[@"data"][@"headimg"]] placeholderImage:[UIImage imageNamed:@"defaulticon"]];
      } fail:^(NSError * _Nonnull error) {
          
      }];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
