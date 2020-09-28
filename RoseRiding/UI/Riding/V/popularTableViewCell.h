//
//  popularTableViewCell.h
//  RoseRiding
//
//  Created by 蜡笔小新 on 2020/7/30.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hotCityModel.h"
#import "historyModel.h"

@protocol popularTableViewCellDelegate <NSObject>
- (void)clickTest:(NSString *_Nonnull)tag;
@end

NS_ASSUME_NONNULL_BEGIN
typedef void(^popularTableViewCellClick)(void);
@interface popularTableViewCell : UITableViewCell
@property (nonatomic , strong)NSMutableArray <hotCityModel *>*hotcity;
@property (nonatomic , strong)NSMutableArray <historyModel *>*hiscity;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *firstcity;
@property (weak, nonatomic) IBOutlet UIButton *secondcity;
@property (weak, nonatomic) IBOutlet UIButton *thirdcity;
//@property (nonatomic, strong) NSMutableArray *history;
@property (nonatomic, copy)popularTableViewCellClick click;
@property (nonatomic, weak) id<popularTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
