//
//  Context.h
//
//
//  Created by Arda CICEK on 28/12/13.
//  Copyright (c) 2013 Arda CICEK. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface ACContext : NSObject

- (NSString *) readValueForKey:(NSString *)key;
- (void) writeValue:(id) value forKey:(NSString *) key;

@end
