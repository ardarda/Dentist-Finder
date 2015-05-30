//
//  ACBaseViewController.h
//
//  Created by Arda CICEK on 28/12/13.
//  Copyright (c) 2013 Arda CICEK. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface ACBaseViewController : UIViewController

- (id) initWithRelevantNib;
- (id) initWithRelevantNib:(NSString *) nibName;

- (void) setHeight:(float) height forView:(UIView *) view animated:(BOOL) animated;

@end
