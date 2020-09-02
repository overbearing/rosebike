//
//  Languagemanger.h
//  RoseRiding
//
//  Created by MR_THT on 2020/3/24.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Languagemanger : NSObject

+ (Languagemanger *)shareManger;

@property (nonatomic, assign)BOOL isEn;

@property (nonatomic, strong)NSString *currentLanger;

@end

NS_ASSUME_NONNULL_END
