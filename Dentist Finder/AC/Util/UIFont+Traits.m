//
//  UIFont+Traits.m
//  EKolayIPhone
//
//  Created by Arda CICEK on 27/03/14.
//  Copyright (c) 2014 Mobven. All rights reserved.
//

#import "UIFont+Traits.h"

@implementation UIFont (Traits)

- (CTFontSymbolicTraits)traits
{
    CTFontRef fontRef = (__bridge CTFontRef)self;
    CTFontSymbolicTraits symbolicTraits = CTFontGetSymbolicTraits(fontRef);
    return symbolicTraits;
}

- (BOOL)isBold
{
    CTFontSymbolicTraits symbolicTraits = [self traits];
    return (symbolicTraits & kCTFontBoldTrait);
}

- (BOOL)isItalic
{
    CTFontSymbolicTraits symbolicTraits = [self traits];
    return (symbolicTraits & kCTFontItalicTrait);
}

@end
