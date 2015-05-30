//
//  NetworkManager.m
//  Dentist Finder
//
//  Created by Arda Cicek on 29/05/15.
//  Copyright (c) 2015 Arda Cicek. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

#pragma mark - Initiation
+(instancetype) sharedNetworkManager
{
    static dispatch_once_t pred;
    static NetworkManager *_sharedInstance = nil;
    dispatch_once(&pred, ^{
        _sharedInstance = [[NetworkManager alloc] init];
        [_sharedInstance initManagers];
    });
    return _sharedInstance;
}

#pragma mark - Overrides
- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    if([Context sharedContext].userToken.length > 0)
        [self.operationManager.requestSerializer setValue:[Context sharedContext].userToken
                                       forHTTPHeaderField:@"365-Token"];
    
    
//    [self.operationManager.requestSerializer setValue:[Context sharedContext].appSecret
//                                   forHTTPHeaderField:@"365-Secret"];
    
    return [super POST:URLString
            parameters:parameters
               success:success
               failure:failure];
}

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    
    if([Context sharedContext].userToken.length > 0)
        [self.operationManager.requestSerializer setValue:[Context sharedContext].userToken
                                       forHTTPHeaderField:@"365-Token"];
    
//    [self.operationManager.requestSerializer setValue:[Context sharedContext].appSecret
//                                   forHTTPHeaderField:@"365-Secret"];
    
    return [super GET:URLString
           parameters:parameters
              success:success
              failure:failure];
}

- (AFHTTPRequestOperation *)DELETE:(NSString *)URLString
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    
    if([Context sharedContext].userToken.length > 0)
        [self.operationManager.requestSerializer setValue:[Context sharedContext].userToken
                                       forHTTPHeaderField:@"365-Token"];
    
//    [self.operationManager.requestSerializer setValue:[Context sharedContext].appSecret
//                                   forHTTPHeaderField:@"365-Secret"];
    
    return [super DELETE:URLString
              parameters:parameters
                 success:success
                 failure:failure];
}

- (void)registerDevice:(void (^)(AFHTTPRequestOperation *operation, id response))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary *params = @{@"udid":[UIDevice currentDevice].identifierForVendor.UUIDString};
    NSString *urlString = [NSString stringWithFormat:@"user/register?udid=%@", [UIDevice currentDevice].identifierForVendor.UUIDString];
    //    @"user/register?udid=%@"
    
    [self POST:@"users/new"
    parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           
//           RegisterResponse *registerResponse = [[RegisterResponse alloc] initWithDictionary:responseObject error:nil];
//           
//           [Context sharedContext].userToken = registerResponse.token;
//           [[NSNotificationCenter defaultCenter] postNotificationName:kATARegisterDidSucceed object:nil];
           
           success(operation, responseObject);
           
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           [Context sharedContext].userToken = @"";
           
           failure(operation, error);
       }];
}



@end
