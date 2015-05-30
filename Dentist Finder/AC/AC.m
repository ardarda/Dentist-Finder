//
//  AC.m
//
//  Created by Arda CICEK on 28/12/13.
//  Copyright (c) 2013 Arda CICEK. All rights reserved.
//

#import "AC.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"
//#import "DetailedLogFormatter.h"
#import "ACNetworkManager.h"

@implementation AC

+(AC *) sharedInstance
{
    static dispatch_once_t pred;
    static AC *_sharedInstance = nil;
    dispatch_once(&pred, ^{
        _sharedInstance = [[AC alloc] init];
    });
    return _sharedInstance;
}

- (void)      initWithBaseURL:(NSString *) url
                 testFlightID:(NSString *) tfID
                      FBAppID:(NSString *) FBID
                encryptionKey:(NSString *) key
             encryptionVector:(NSString *) vector
{
    self.baseURL = url;
    self.appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    self.versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    self.testflightID = tfID;
    self.FBAppID = FBID;
    self.encryptionKey = key;
    self.encryptionVector = vector;
    self.udid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    
    //init loggers
//    [DDASLLogger sharedInstance].logFormatter = [[DetailedLogFormatter alloc] init];
//    [DDTTYLogger sharedInstance].logFormatter = [[DetailedLogFormatter alloc] init];
    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    // And then enable colors
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];

}


@end
