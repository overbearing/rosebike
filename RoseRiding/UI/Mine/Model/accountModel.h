//
//  accountModel.h
//  RoseRiding
//
//  Created by 蜡笔小新 on 2020/9/21.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface accountModel : NSObject
@property (nonatomic,strong)NSString * Id;
@property (nonatomic,strong)NSString * headimg;
@property (nonatomic,strong)NSString * userid;
@property (nonatomic,strong)NSString * nickname;
@property (nonatomic,strong)NSString * email;
@property (nonatomic,strong)NSString * type;
@property (nonatomic,strong)NSString * pwd;

@end

NS_ASSUME_NONNULL_END
