//
//  NetworkManager.h
//  Dentist Finder
//
//  Created by Arda Cicek on 29/05/15.
//  Copyright (c) 2015 Arda Cicek. All rights reserved.
//

#import "ACNetworkManager.h"
#import "Context.h"

@interface NetworkManager : ACNetworkManager
+(instancetype) sharedNetworkManager;

@end
