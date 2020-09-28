//
//  NetworkingManger.m
//  RoseRiding
//
//  Created by MR_THT on 2020/3/23.
//  Copyright © 2020 MR_THT. All rights reserved.
//

#import "NetworkingManger.h"
#import "LoginController.h"
@interface NetworkingManger ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation NetworkingManger
+ (NetworkingManger *)shareManger{
    static NetworkingManger *manger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[NetworkingManger alloc] init];
    });
    return manger;
}

- (instancetype)init {
    if (self == [super init]) {
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:configuration];
        
        //接收参数类型
        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        
       AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.removesKeysWithNullValues = YES;
        self.sessionManager.responseSerializer = responseSerializer;
        [self.sessionManager.requestSerializer setValue:@"1" forHTTPHeaderField:@"DeviceType"];
        self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"text/plain", @"image/gif", @"text/html; charset=utf-8", @"application/json; charset=utf-8", nil];
        
        //设置超时时间
        [self.sessionManager requestSerializer].timeoutInterval = 30;
        //安全策略
        self.sessionManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    }
    return self;
}

- (void)getDataWithUrl:(NSString *)url para:(NSDictionary * _Nullable)dic success:(void (^)(NSDictionary * _Nonnull))success fail:(void (^)(NSError * _Nonnull))fail{
    
    [[NetworkingManger shareManger].sessionManager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
    }];
}
- (void)postDataWithUrl:(NSString *)url para:( NSDictionary * _Nullable)dic success:(void (^)(NSDictionary * _Nonnull))success fail:(void (^)(NSError * _Nonnull))fail{
    
    NSMutableDictionary * dics = [[NSMutableDictionary alloc] initWithDictionary:dic];
    //统一添加一个TOKEN
  
       if ([UserInfo shareUserInfo].token != nil) {
           [dics setValue:[UserInfo shareUserInfo].token forKey:@"token"];
//           NSLog(@"token--------------%@",[UserInfo shareUserInfo].token);
       }
    [dics setValue:@"leopard_dev" forKey:@"app_name"];
    if([Languagemanger shareManger].isEn){
         [dics setValue:@"1"forKey:@"language"];
    }else{
         [dics setValue:@"2" forKey:@"language"];
    }
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    // 获取指定时区的名称
    NSString *strZoneName = [zone name];
//    NSString *zoneAbbreviation1 = [zone abbreviation];
//    NSString * timezone = [zoneAbbreviation1 stringByReplacingOccurrencesOfString:@"GMT" withString:@""];
    [dics setValue:strZoneName forKey:@"Timezone"];
//    NSLog(@"%@", [dics objectForKey:@"language"]);
    [[NetworkingManger shareManger].sessionManager POST:url parameters:dics progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
//            if ([[responseObject objectForKey:@"code"] intValue] == 10000) {
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"loginfailed" object:nil];
//            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
            return;
        }
    }];
}

- (void)uploadFile:(NSString *)url para:(NSDictionary *)dic data:(NSData *)fileData fileName:(NSString *)fileName mimetype:(NSString *)mimetype success:(void (^)(NSDictionary * _Nonnull))success fail:(void (^)(NSError * _Nonnull))fail{
    [[NetworkingManger shareManger].sessionManager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:fileName fileName:fileName mimeType:mimetype];
    } progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //打印看下返回的是什么东西
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            fail(error);
             return;
        }
    }];
}

@end
