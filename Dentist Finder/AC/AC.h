//
//  AC.h
//
//  Created by Arda CICEK on 28/12/13.
//  Copyright (c) 2013 Arda CICEK. All rights reserved.
//

#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_ERROR;
#endif

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)

@interface AC : NSObject

@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *versionString;
@property (nonatomic, strong) NSString *testflightID;
@property (nonatomic, strong) NSString *FBAppID;
@property (nonatomic, strong) NSString *encryptionKey;
@property (nonatomic, strong) NSString *encryptionVector;
@property (nonatomic, strong) NSString *udid;

+(AC *) sharedInstance;

- (void)      initWithBaseURL:(NSString *) url
                 testFlightID:(NSString *) tfID
                      FBAppID:(NSString *) FBID
                encryptionKey:(NSString *) key
             encryptionVector:(NSString *) vector;


@end
