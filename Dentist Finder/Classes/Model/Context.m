//
//  Context.m
//  Dentist Finder
//
//  Created by Arda Cicek on 29/05/15.
//  Copyright (c) 2015 Arda Cicek. All rights reserved.
//

#import "Context.h"

@implementation Context

+(Context *) sharedContext
{
    static dispatch_once_t pred;
    static Context *_sharedInstance = nil;
    dispatch_once(&pred, ^{
        _sharedInstance = [[Context alloc] init];
    });
    return _sharedInstance;
}


- (void) setUserToken:(NSString *)userToken{
    [[NSUserDefaults standardUserDefaults] setObject:userToken forKey:@"DFUserToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *) userToken{
    NSString *result = [[NSUserDefaults standardUserDefaults] objectForKey:@"DFUserToken"];
    if(!result) result = @"";
    return result;
}
@end
