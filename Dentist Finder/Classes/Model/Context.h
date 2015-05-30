//
//  Context.h
//  Dentist Finder
//
//  Created by Arda Cicek on 29/05/15.
//  Copyright (c) 2015 Arda Cicek. All rights reserved.
//

#import "ACContext.h"

@interface Context : ACContext
+(Context *) sharedContext;
@property (nonatomic, weak) NSString *userToken;
@end
