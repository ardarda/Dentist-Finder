//
//  FormContainerView.h
//  EKolayIPhone
//
//  Created by Arda CICEK on 12/01/14.
//  Copyright (c) 2014 Mobven. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface ACFormContainerView : UIView<UITextFieldDelegate, UITextViewDelegate>


@property (nonatomic, strong) NSMutableArray *controls;
@property (nonatomic, strong) UIView *activeControl;


@property (nonatomic) BOOL shouldMoveToKeyboard;
@property (nonatomic, weak) NSArray *invalidTextFields;

@property (nonatomic, strong) NSDictionary *keyboardInfo;

@property (nonatomic, weak) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic) float currentOffset;
@property (nonatomic) BOOL isShowingKeyboard;

@property (nonatomic, strong) NSLayoutConstraint *constraintToAnimate;

@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic) CGRect endFrame;


//ATA Specific
@property (nonatomic) CGFloat prevTextViewHeight;

- (void) resign;

- (void) showPicker:(UIView *) picker;
- (void) hidePicker;

- (void) showModalView:(UIView *) view;
- (void) hideModalView;

- (void) addNotifications;
- (void) removeNotifications;

//not safe but need workaround
- (void) initialize;



@end
