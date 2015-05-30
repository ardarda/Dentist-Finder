//
//  Context.m
//  Arazi Ol 2
//
//  Created by Arda CICEK on 28/12/13.
//  Copyright (c) 2013 Arda CICEK. All rights reserved.
//

#import "ACContext.h"

@implementation ACContext

- (NSString *) readValueForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}
- (void) writeValue:(id) value forKey:(NSString *) key{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *) getDocumentsPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

@end
