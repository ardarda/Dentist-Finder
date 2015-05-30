//
//  UIView+OPCloning.m
//  Giftolyo
//
//  Created by Arda Cicek on 10/01/15.
//  Copyright (c) 2015 bolumyolu. All rights reserved.
//

#import "UIView+OPCloning.h"

@implementation UIView (OPCloning)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) clone {
    NSData *archivedViewData = [NSKeyedArchiver archivedDataWithRootObject: self];
    id clone = [NSKeyedUnarchiver unarchiveObjectWithData:archivedViewData];
    return clone;
}


@end
