//
//  NetworkManager.m
//  Arazi Ol 2
//
//  Created by Arda CICEK on 28/12/13.
//  Copyright (c) 2013 Arda CICEK. All rights reserved.
//

#import "ACNetworkManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "BaseResponse.h"
#import "AC.h"
#import "AppDelegate.h"
#import "UIImage+GIF.h"



@implementation ACNetworkManager

@synthesize loaderView;
@synthesize connectionType;


- (void) initManagers{
    _operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[AC sharedInstance].baseURL]];
    _operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    _operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //SSL 1012 error workaround!
#warning safety! No.
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    _operationManager.securityPolicy = securityPolicy;
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(HTTPOperationDidStart:)
                                                 name:AFNetworkingOperationDidStartNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(HTTPOperationDidFinish:)
                                                 name:AFNetworkingOperationDidFinishNotification
                                               object:nil];
    
    __weak typeof(self) weakSelf = self;
    [_operationManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSString *reachabilityStr = @"";
        if(status == AFNetworkReachabilityStatusNotReachable){
            weakSelf.connectionType = kECConnectionTypeNOTConnected;
            [weakSelf pauseAllQueues];
            reachabilityStr = @"Not Reachable";
        }
        else if(status == AFNetworkReachabilityStatusUnknown){
            weakSelf.connectionType = kECConnectionTypeUnknown;
            [weakSelf pauseAllQueues];
            reachabilityStr = @"Unknown";
        }
        else if(status == AFNetworkReachabilityStatusReachableViaWiFi){
            weakSelf.connectionType = kECConnectionTypeWifi;
            [weakSelf resumeAllQueues];
            reachabilityStr = @"Wifi";
        }
        else if(status == AFNetworkReachabilityStatusReachableViaWWAN){
            weakSelf.connectionType = kECConnectionType3G;
            [weakSelf resumeAllQueues];
            reachabilityStr = @"WWAN";
            
        }
        DDLogInfo(@"Reachability changed to %@ %ld", reachabilityStr, status);
    }];
    
    
    //create the loader
    
    loaderView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    loaderView.backgroundColor = [UIColor colorWithRed:.2 green:.2 blue:.2 alpha:.4];
    
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.frame = CGRectMake((loaderView.frame.size.width - 50)/2.0f, (loaderView.frame.size.height - 50)/2.0f, 50, 50);
    [activity startAnimating];
    
//    UIImageView *loaderGif = [[UIImageView alloc] initWithImage:[UIImage sd_animatedGIFNamed:@"365_preloader"]];
//    loaderGif.frame = CGRectMake((loaderView.frame.size.width - 65.5)/2.0f, (loaderView.frame.size.height - 65.5)/2.0f, 65.5, 65.5);
    [loaderView addSubview:activity];
    
    
    AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
    
}
#pragma mark - Notification Handlers
- (void)HTTPOperationDidStart:(NSNotification *)notification {
    AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *)[notification object];
    NSURLRequest *request = operation.request;
    NSString *path = request.URL.absoluteString;
    
    //do not block interface for image downloads
    if([path rangeOfString:@".png" options:NSCaseInsensitiveSearch].location == NSNotFound &&
       [path rangeOfString:@".jpg" options:NSCaseInsensitiveSearch].location == NSNotFound &&
       [path rangeOfString:@".jpeg" options:NSCaseInsensitiveSearch].location == NSNotFound){
        
        ++blockingOperationCount;
        [self showLoader];
    }
}
- (void)HTTPOperationDidFinish:(NSNotification *)notification {
    AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *)[notification object];
    NSURLRequest *request = operation.request;
    NSString *path = request.URL.absoluteString;
    
    //do not block interface for image downloads
    if([path rangeOfString:@".png" options:NSCaseInsensitiveSearch].location == NSNotFound &&
       [path rangeOfString:@".jpg" options:NSCaseInsensitiveSearch].location == NSNotFound &&
       [path rangeOfString:@".jpeg" options:NSCaseInsensitiveSearch].location == NSNotFound){
        
        --blockingOperationCount;
    }
    if(blockingOperationCount < 1)
        [self hideLoader];
}
#pragma mark - Overrides
- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    void (^newFail)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *op, NSError *err)
    {
        failure(op, err);
    };
    void (^newSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *op, id resp)
    {
        NSError *error = nil;
        BaseResponse *response = [[BaseResponse alloc] initWithDictionary:resp error:&error];
        
        if(error){
            DDLogError(@"BaseResponse conversion failed! %@", error.description);
            newFail(op, error);
        }
        
//        if(!response.Success){
//            NSMutableDictionary* details = [NSMutableDictionary dictionary];
//            [details setValue:[NSString stringWithFormat:@"%@", response.Message] forKey:NSLocalizedDescriptionKey];
//            
//            if(response.Status == 5){
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"kGFAuthorizationRequired" object:nil];
//            }
//            else{
//                NSError *newErr = [NSError errorWithDomain:@"ECErrorDomain" code:response.Status userInfo:details];
//                newFail(op, newErr);
//            }
//        }
        else{
            success(op, resp);
        }
        
    };

    return [_operationManager POST:URLString
                       parameters:parameters
                          success:newSuccess
                          failure:newFail];
}
- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    void (^newFail)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *op, NSError *err)
    {
        failure(op, err);
    };
    void (^newSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *op, id resp)
    {
        NSError *error = nil;
        BaseResponse *response = [[BaseResponse alloc] initWithDictionary:resp error:&error];
        
        if(error){
            DDLogError(@"BaseResponse conversion failed! %@", error.description);
            newFail(op, error);
        }
        
//        if(!response.Success){
//            NSMutableDictionary* details = [NSMutableDictionary dictionary];
//            [details setValue:[NSString stringWithFormat:@"%@", response.Message] forKey:NSLocalizedDescriptionKey];
//            
//            if(response.Status == 5){
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"kGFAuthorizationRequired" object:nil];
//            }
//            else{
//                NSError *newErr = [NSError errorWithDomain:@"ECErrorDomain" code:response.Status userInfo:details];
//                newFail(op, newErr);
//            }
//        }
        else{
            success(op, resp);
            
//            if(response.NextWebViewUrl.length > 0){
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                    [app showWebpagePopup:response.NextWebViewUrl];
//                    
//                });
//            }
        }
        
    };
    
    
    return [_operationManager GET:URLString
                       parameters:parameters
                          success:newSuccess
                          failure:newFail];
}

- (AFHTTPRequestOperation *)DELETE:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    void (^newFail)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *op, NSError *err)
    {
        failure(op, err);
    };
    void (^newSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *op, id resp)
    {
        NSError *error = nil;
        BaseResponse *response = [[BaseResponse alloc] initWithDictionary:resp error:&error];
        
        if(error){
            DDLogError(@"BaseResponse conversion failed! %@", error.description);
            newFail(op, error);
        }
        
        //        if(!response.Success){
        //            NSMutableDictionary* details = [NSMutableDictionary dictionary];
        //            [details setValue:[NSString stringWithFormat:@"%@", response.Message] forKey:NSLocalizedDescriptionKey];
        //
        //            if(response.Status == 5){
        //                [[NSNotificationCenter defaultCenter] postNotificationName:@"kGFAuthorizationRequired" object:nil];
        //            }
        //            else{
        //                NSError *newErr = [NSError errorWithDomain:@"ECErrorDomain" code:response.Status userInfo:details];
        //                newFail(op, newErr);
        //            }
        //        }
        else{
            success(op, resp);
            
            //            if(response.NextWebViewUrl.length > 0){
            //                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            //                    [app showWebpagePopup:response.NextWebViewUrl];
            //
            //                });
            //            }
        }
        
    };
    
    
    return [_operationManager DELETE:URLString
                       parameters:parameters
                          success:newSuccess
                          failure:newFail];
}


#pragma mark - Queue Management
- (BOOL) addOperation:(AFURLConnectionOperation *) operation toQueue:(NSString *) queueName
{
    NSOperationQueue *queue = [queueDict objectForKey:queueName];
    if(!queue){
        queue = [[NSOperationQueue alloc] init];
        [queueDict setObject:queue forKey:queueName];
    }
    [queue addOperation:operation];
    return YES;
}
- (BOOL) pauseQueue:(NSString *) queueName
{
    NSOperationQueue *queue = [queueDict objectForKey:queueName];
    
    if(!queue){
        DDLogInfo(@"There is no queue with the name %@", queueName);
        return NO;
    }
    
    [queue setSuspended:YES];
    return YES;
}
- (BOOL) resumeQueue:(NSString *) queueName
{
    if(self.connectionType == kECConnectionTypeNOTConnected){
        [self showNetworkAlert];
        return NO;
    }
    NSOperationQueue *queue = [queueDict objectForKey:queueName];
    
    if(!queue){
        DDLogInfo(@"There is no queue with the name %@", queueName);
        return NO;
    }
    
    [queue setSuspended:NO];
    return YES;
}
- (BOOL) cancelQueue:(NSString *) queueName
{
    NSOperationQueue *queue = [queueDict objectForKey:queueName];
    
    if(!queue){
        DDLogInfo(@"There is no queue with the name %@", queueName);
        return NO;
    }
    
    [queue cancelAllOperations];
    [queueDict removeObjectForKey:queueName];
    
    queue = nil;
    return YES;
}
- (void) pauseAllQueues
{
    [_operationManager.operationQueue setSuspended:YES];
    [failedOperationsQueue setSuspended:YES];
    
    NSArray *keys = [queueDict allKeys];
    for(int i = 0; i<keys.count; ++i){
        NSString *key = [keys objectAtIndex:i];
        NSOperationQueue *queue = [queueDict objectForKey:key];
        [queue setSuspended:YES];
        
        for(int j = 0; j < queue.operationCount; ++j){
            AFHTTPRequestOperation *op = [[queue operations] objectAtIndex:j];
            if(op.isExecuting) {
                AFHTTPRequestOperation *newOperation = [op copy];
                [newOperation setCompletionBlock:newOperation.completionBlock];
                [failedOperationsQueue addOperation:newOperation];
                
                [op cancel];
            }
        }
    }
}

- (void) resumeAllQueues
{
    [_operationManager.operationQueue setSuspended:NO];
    [failedOperationsQueue setSuspended:NO];
    
    NSArray *keys = [queueDict allKeys];
    for(int i = 0; i<keys.count; ++i){
        NSString *key = [keys objectAtIndex:i];
        NSOperationQueue *queue = [queueDict objectForKey:key];
        [queue setSuspended:NO];
    }
}
- (void) cancelAllQueues{
    [_operationManager.operationQueue cancelAllOperations];
    
    NSArray *keys = [queueDict allKeys];
    for(int i = 0; i<keys.count; ++i){
        NSString *key = [keys objectAtIndex:i];
        NSOperationQueue *queue = [queueDict objectForKey:key];
        [queue cancelAllOperations];
    }
}


#pragma mark - Util
- (void) showLoader
{
    if(!self.loaderView) DDLogError(@"ERROR! loaderView is nil!");
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if(topVC.presentedViewController){
        [topVC.presentedViewController.view addSubview:self.loaderView];
    }
    else{
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.loaderView];
    }
}
- (void) hideLoader
{
    if(!self.loaderView) DDLogError(@"ERROR! loaderView is nil!");
    [self.loaderView removeFromSuperview];
}
- (void) showNetworkAlert{
    if(_isShowingNetworkAlert) return;
    
    _isShowingNetworkAlert = YES;
    
    [[[UIAlertView alloc] initWithTitle:@""
                                message:@"Network Error"
                               delegate:self
                      cancelButtonTitle:@"Tamam"
                      otherButtonTitles:nil, nil] show];
}
- (UIAlertView *) showErrorMsg:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"Tamam"
                                          otherButtonTitles:nil, nil];
    [alert show];
    return alert;
}
@end
