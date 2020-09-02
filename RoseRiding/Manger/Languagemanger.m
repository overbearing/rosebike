//
//  Languagemanger.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/24.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "Languagemanger.h"

@implementation Languagemanger

+ (Languagemanger *)shareManger{
    static dispatch_once_t onceToken;
    static Languagemanger *manger;
    dispatch_once(&onceToken, ^{
        manger = [[Languagemanger alloc] init];
    });
    return manger;
}

- (BOOL)isEn{
    NSArray *languages = [NSLocale preferredLanguages];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"LanguageIndex"]!= nil) {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"LanguageIndex"] isEqualToString:@"Deutsch"]) {
            return NO;
        }else{
            return YES;
        }
    }else{
    if ([languages.firstObject isEqual:@"de-CN"]||[languages.firstObject isEqual:@"de-US"]) {
        return NO;
    }else{
        return YES;
    }
        
    }
}



@end
