//
//  NetworkManager.h
//  Arazi Ol 2
//
//  Created by Arda CICEK on 28/12/13.
//  Copyright (c) 2013 Arda CICEK. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"

typedef enum {kECConnectionTypeNOTConnected = 0,
    kECConnectionTypeUnknown = 1,
    kECConnectionType3G = 2,
    kECConnectionTypeWifi = 3} kECConnectionType;

@interface ACNetworkManager : NSObject{
    AFHTTPSessionManager *sessionManager;

    NSMutableDictionary* queueDict;
    NSOperationQueue *failedOperationsQueue;
    
    int blockingOperationCount;
}

@property (nonatomic, strong) UIView* loaderView;
@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;
@property (nonatomic) BOOL isShowingNetworkAlert;
@property (nonatomic) kECConnectionType connectionType;

- (void) initManagers;

#pragma mark - Queue management
- (BOOL) addOperation:(AFURLConnectionOperation *) operation toQueue:(NSString *) queueName;
- (BOOL) pauseQueue:(NSString *) queueName;
- (BOOL) resumeQueue:(NSString *) queueName;
- (BOOL) cancelQueue:(NSString *) queueName;
- (void) pauseAllQueues;
- (void) resumeAllQueues;
- (void) cancelAllQueues;

#pragma mark - Overrides
- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (AFHTTPRequestOperation *)DELETE:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



#pragma mark - Util
- (void) showLoader;
- (void) hideLoader;
- (UIAlertView *) showErrorMsg:(NSString *)msg;


@end
