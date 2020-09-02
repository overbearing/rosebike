//
//  GlobalControlManger.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/23.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "GlobalControlManger.h"
#import <CommonCrypto/CommonDigest.h>

@implementation GlobalControlManger

+ (NSString *)enStr:(NSString *)enStr geStr:(NSString *)geStr{
    if ([Languagemanger shareManger].isEn) {
        return NSLocalizedString(enStr, nil);
        }else{
        return NSLocalizedString(geStr, nil);
    }
}

+ (UIColor *)lightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor{
    return [UIColor whiteColor];
}

+ (NSString *)reversalString:(NSString *)originString{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for (int i = 0;i < 15;i ++) {
        NSRange range = NSMakeRange(i * 2, 2);
        NSString *str = [originString substringWithRange:range];
        [data addObject:str];
    }
    NSMutableArray *strRevArray = [NSMutableArray array];
    for (NSString *str in [data reverseObjectEnumerator]) {
        [strRevArray addObject:str];
    }
    
    [strRevArray exchangeObjectAtIndex:1 withObjectAtIndex:strRevArray.count - 2];
    [strRevArray exchangeObjectAtIndex:2 withObjectAtIndex:strRevArray.count - 1];
    
    NSString *result = [strRevArray componentsJoinedByString:@""];
    
//    NSString *resultStr = @"";
//    for (NSInteger i = originString.length -1; i >= 0; i--) {
//      NSString *indexStr = [originString substringWithRange:NSMakeRange(i, 1)];
//      resultStr = [resultStr stringByAppendingString:indexStr];
//    }
  return result;
}

+(NSString *)replaceString:(NSString *)originString {
    NSString *resultStr = @"";
    NSString *aa = [originString substringWithRange:NSMakeRange(1, 2)];
    NSString *bb = [originString substringWithRange:NSMakeRange(originString.length - 2, 2)];
    NSString *a = [originString stringByReplacingCharactersInRange:NSMakeRange(1, 2) withString:bb];
    resultStr = [a stringByReplacingCharactersInRange:NSMakeRange(originString.length - 2, 2) withString:aa];
    return resultStr;
}


+ (NSString *) sha1:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
 
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
 
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

@end
