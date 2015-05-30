//
//  UIFont+Traits.h
//  EKolayIPhone
//
//  Created by Arda CICEK on 27/03/14.
//  Copyright (c) 2014 Mobven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface UIFont (Traits)

- (CTFontSymbolicTraits)traits;

- (BOOL)isBold;
- (BOOL)isItalic;

@end