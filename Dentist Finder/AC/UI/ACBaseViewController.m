//
//  ACBaseViewController.m
//
//  Created by Arda CICEK on 28/12/13.
//  Copyright (c) 2013 Arda CICEK. All rights reserved.
//

#import "ACBaseViewController.h"
#import "ACFormContainerView.h"
#import "AC.h"

@interface ACBaseViewController ()

@end

@implementation ACBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void) initialize{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) prefersStatusBarHidden{
    return NO;
}

- (id) initWithRelevantNib{
    NSString *nibName = [self getRelevantNibName:NSStringFromClass([self class])];
    
    self = [super initWithNibName:nibName bundle:nil];
    if(self){
        [self initialize];
    }
    return self;
}
- (id) initWithRelevantNib:(NSString *) nibName{
    NSString *relevantNibName = [self getRelevantNibName:nibName];
    
    self = [super initWithNibName:relevantNibName bundle:nil];
    
    if(self){
        [self initialize];
    }
    return self;
}
- (NSString *) getRelevantNibName:(NSString *) nibName{
    NSString *result;
    
    if(IS_IPHONE && IS_IPHONE_5)
    {
        result = [NSString stringWithFormat:@"%@%@", nibName, @""];
    }
    else if(IS_IPHONE)
    {
        result = [NSString stringWithFormat:@"%@%@", nibName, @"_4"];
    }
    else
    {
        result = [NSString stringWithFormat:@"%@%@", nibName, @"_ipad"];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:result ofType:@"nib"];
    if(path == nil) result = nil;
    
    return result;
}



- (void) setHeight:(float) height forView:(UIView *) view animated:(BOOL) animated{
    view.clipsToBounds = YES;
    view.superview.autoresizesSubviews = NO;
    
    float diffY = height - view.frame.size.height;
    
    
    if(![view.superview isKindOfClass:[UIScrollView class]]){
        view.superview.frame = CGRectMake(view.superview.frame.origin.x,
                                          view.superview.frame.origin.y,
                                          view.superview.frame.size.width,
                                          view.superview.frame.size.height+diffY);
    }
    
    void (^animations)(void)  = ^void (void)
    {
        view.frame = CGRectMake(view.frame.origin.x,
                                view.frame.origin.y,
                                view.frame.size.width, MAX(0, height));
        
        
        int index = [view.superview.subviews indexOfObject:view];
        for (int i = index+1; i<view.superview.subviews.count; ++i) {
            UIView *tempView = [view.superview.subviews objectAtIndex:i];
            tempView.frame = CGRectMake(tempView.frame.origin.x,
                                        tempView.frame.origin.y+diffY,
                                        tempView.frame.size.width,
                                        tempView.frame.size.height);
        }
    };
    
    if(animated){
        [UIView animateWithDuration:.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:animations
                         completion:nil];
    }
    else{
        animations();
    }
    
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addNotificationsToFormContainersInView:self.view];
}
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeNotificationsFromFormContainersInView:self.view];
}
- (void) addNotificationsToFormContainersInView:(UIView *) view{
    if([view isKindOfClass:[ACFormContainerView class]]){
        ACFormContainerView *form = (ACFormContainerView *) view;
        [form addNotifications];
    }
    else{
        for (UIView *temp in view.subviews) {
            [self addNotificationsToFormContainersInView:temp];
        }
    }
}
- (void) removeNotificationsFromFormContainersInView:(UIView *) view{
    if([view isKindOfClass:[ACFormContainerView class]]){
        ACFormContainerView *form = (ACFormContainerView *) view;
        [form removeNotifications];
    }
    else{
        for (UIView *temp in view.subviews) {
            [self removeNotificationsFromFormContainersInView:temp];
        }
    }
}
@end
