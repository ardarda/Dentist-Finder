//
//  FormContainerView.m
//  EKolayIPhone
//
//  Created by Arda CICEK on 12/01/14.
//  Copyright (c) 2014 Mobven. All rights reserved.
//

#import "ACFormContainerView.h"
#import "ACTextField.h"
#import "HTAutocompleteTextField.h"
#import "UtilityMethods.h"
//#import "Constants.h"
#define kVerticalPadding 0

@implementation ACFormContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}
- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
    
}

- (void) initialize{
    _currentOffset = 0;
    _isShowingKeyboard = NO;
    _shouldMoveToKeyboard = YES;
    
    _controls = [NSMutableArray array];
    
    for (UIView *view in self.subviews) {
        //add if this is a uicontrol
        if([self viewIsUIControl:view]){
            [_controls addObject:view];
        }
        else{
            //if not uicontrol, go one level deeper
            for (UIView *subview in view.subviews) {
                if([self viewIsUIControl:subview]){
                    [_controls addObject:subview];
                } else {
                    //if not uicontrol, go one more level deeper
                    for (UIView *subSubview in subview.subviews) {
                        if([self viewIsUIControl:subSubview]){
                            [_controls addObject:subSubview];
                        } else {
                            //if not uicontrol, go one more! level deeper
                            
                            for (UIView *subSubSubview in subSubview.subviews) {
                                if([self viewIsUIControl:subSubSubview]){
                                    [_controls addObject:subSubSubview];
                                } else {
                                    //if not uicontrol, go one more! level deeper
                                    
                                    for (UIView *subSubSubXview in subSubSubview.subviews) {
                                        if([self viewIsUIControl:subSubSubXview]){
                                            [_controls addObject:subSubSubXview];
                                        } else {
                                            //if not uicontrol, go one more! level deeper
                                            
                                            for (UIView *subSubSubXXview in subSubSubXview.subviews) {
                                                if([self viewIsUIControl:subSubSubXXview]){
                                                    [_controls addObject:subSubSubXXview];
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapHandler)];
    if (!_tapRecognizer) {
        _tapRecognizer = tap;
        [self addGestureRecognizer:tap];
    }
}
- (void) addNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (void) removeNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self backgroundTapHandler];
}
- (BOOL) viewIsUIControl:(UIView *) view{
    
    if([view isKindOfClass:[UITextField class]]){
        UITextField *tf = (UITextField *) view;
        tf.delegate = self;
        return YES;
    }
    else if([view isKindOfClass:[UITextView class]]){
        UITextView *tf = (UITextView *) view;
        tf.delegate = self;
        return YES;
    }
    else if ([view isKindOfClass:[UIPickerView class]]){
        return  YES;
    }
    else if([view isKindOfClass:[UIDatePicker class]]){
        return YES;
    }
    
    return NO;
}
- (void) backgroundTapHandler{
    [self resign];
}
- (void) resign{
    [self hideModalView];
    [self hidePicker];
    for (UIView *control in _controls) {
        if([control respondsToSelector:@selector(resignFirstResponder)])
            [control performSelector:@selector(resignFirstResponder) withObject:nil];
    }
}
- (void) moveBy:(float) diffY{
    _currentOffset += diffY;
    double keyboardAnimationDuration = [_keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSArray *constraints = self.superview.constraints;
    NSLayoutConstraint *yConstraintTop;
    NSLayoutConstraint *yConstraintBottom;
    
    for (NSLayoutConstraint *constraint in constraints) {
        if (constraint.firstItem == self || constraint.secondItem == self) {
            if(constraint.secondAttribute == NSLayoutAttributeTop /*|| constraint.firstAttribute == NSLayoutAttributeBottom|| constraint.firstAttribute == NSLayoutAttributeCenterY*/){
                yConstraintBottom = constraint;
                
            } else if(constraint.secondAttribute == NSLayoutAttributeBottom /*|| constraint.firstAttribute == NSLayoutAttributeBottom|| constraint.firstAttribute == NSLayoutAttributeCenterY*/){
                yConstraintTop = constraint;
            }
        }
    }
    
    if(yConstraintTop){
        //        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        yConstraintBottom.constant += diffY;
        yConstraintTop.constant += diffY;
        
        //        yConstraint.constant = -100;
        
        [UIView animateWithDuration:0.25 delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             //                             [self setTranslatesAutoresizingMaskIntoConstraints:NO];
                             
                             [self.superview layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    else{
        [UIView animateWithDuration:keyboardAnimationDuration delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.frame = CGRectOffset(self.frame, 0, diffY);
                             [self.superview updateConstraints];
                         } completion:^(BOOL finished) {
                             
                         }];
        
    }
}

- (void) moveToView:(UIView *) view{
    if(!view) return;
    CGRect beginFrame;
    CGRect endFrame;
    
    [[_keyboardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&beginFrame];
    [[_keyboardInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
    if (!_isShowingKeyboard) {
        endFrame = CGRectMake(0, 315, 320, 253);
    }
    
    UIView *viewWithNoSuperView = self;
    while (viewWithNoSuperView.superview) {
        viewWithNoSuperView = viewWithNoSuperView.superview;
    }
    CGPoint tfCenterGlobal = [view convertPoint:view.bounds.origin toView:viewWithNoSuperView];
    
    //is the tf under keyboard?
    if(endFrame.origin.y < tfCenterGlobal.y + view.frame.size.height){
        float diffY = endFrame.origin.y - tfCenterGlobal.y - view.frame.size.height - kVerticalPadding;
        [self moveBy:diffY];
    }
    //is the default position ok for this tf?
    else if(tfCenterGlobal.y - _currentOffset + kVerticalPadding <endFrame.origin.y){
        [self moveBy:-_currentOffset];
    }
}

#pragma mark - Keyboard handlers
- (void)keyboardWillShow:(NSNotification *)notification
{
    if(((UITextField *) _activeControl).keyboardType == UIKeyboardTypeNumberPad){
        //        [self numpadWillShow:notification];
        
    }
    _isShowingKeyboard = YES;
    _keyboardInfo = [notification userInfo];
    
    /* Duplicate Textfield delegate already assigned
     
     if(_shouldMoveToKeyboard){
     [self moveToView:_activeControl];
     }
     */
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    _isShowingKeyboard = NO;
    _keyboardInfo = [notification userInfo];
    
    [self moveBy:-_currentOffset];
}
#pragma mark - Numpad stuff
- (void) addDoneButton{
    [self removeDoneButton];
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _doneButton.frame = CGRectMake(0, 50, 106, 53);
    _doneButton.adjustsImageWhenHighlighted = NO;
    _doneButton.titleLabel.textColor = [UIColor darkTextColor];
    _doneButton.tintColor = [UIColor darkTextColor];
    [_doneButton setTitle:@"GEÇ" forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(dismissNumpad) forControlEvents:UIControlEventTouchUpInside];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *keyboardView = [[[[[UIApplication sharedApplication] windows] objectAtIndex:1] subviews] firstObject];
            [_doneButton setFrame:CGRectMake(0, keyboardView.frame.size.height - 53, 106, 53)];
            [keyboardView addSubview:_doneButton];
            [keyboardView bringSubviewToFront:_doneButton];
        });
    }else {
        // locate keyboard view
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
            UIView* keyboard;
            for(int i=0; i<[tempWindow.subviews count]; i++) {
                keyboard = [tempWindow.subviews objectAtIndex:i];
                // keyboard view found; add the custom button to it
                if([[keyboard description] hasPrefix:@"UIKeyboard"] == YES)
                    [keyboard addSubview:_doneButton];
            }
        });
    }
}
- (void) removeDoneButton{
    if(_doneButton){
        [_doneButton removeFromSuperview];
        _doneButton = nil;
    }
}
- (void) dismissNumpad{
    [self textFieldShouldReturn:(UITextField *)_activeControl];
}
#pragma mark - UITextView delegate

- (void) textViewDidBeginEditing:(UITextView *)textView{
    _activeControl = textView;
    if(_shouldMoveToKeyboard /*&&_isShowingKeyboard*/){
        [self moveToView:_activeControl];
    }
}
- (void) textViewDidEndEditing:(UITextView *)textView{
    _activeControl = nil;
}
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.tag == 112233) {
        CGSize newSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, CGFLOAT_MAX)];
        if ( newSize.height > _prevTextViewHeight && newSize.height < 70) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kATATEXTVIEWSHOULDRISE object:nil];
        }
        _prevTextViewHeight = newSize.height;
    }
}
#pragma mark - UITextField delegate
- (void) textFieldDidBeginEditing:(UITextField *)textField{
    
    _activeControl = textField;
    
    if(_shouldMoveToKeyboard /*&& _isShowingKeyboard*/){
        [self moveToView:_activeControl];
    }
    
    if(textField.keyboardType == UIKeyboardTypeNumberPad){
        [self addDoneButton];
    }
    else{
        [self removeDoneButton];
    }
}
- (void) textFieldDidEndEditing:(UITextField *)textField{
    _activeControl = nil;
    [self removeDoneButton];
}
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    int index = [_controls indexOfObject:textField];
    if(index<_controls.count-1){
        
        UIView *next = [_controls objectAtIndex:index+1];
        
        if([next isKindOfClass:[UIDatePicker class]]){
            [self showModalView:next];
            return YES;
        }
        else if([next isKindOfClass:[UIPickerView class]]){
            [self showPicker:(UIPickerView *)next];
            return YES;
        }
        else if([next respondsToSelector:@selector(becomeFirstResponder)]){
            [next becomeFirstResponder];
            _activeControl = next;
        }
        
        /*
         if([next respondsToSelector:@selector(becomeFirstResponder)]){
         [next becomeFirstResponder];
         _activeControl = next;
         }
         */
    }
    else{
        [textField resignFirstResponder];
    }
    return NO;
}

#pragma mark - Restrictions
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([textField isKindOfClass:[ACTextField class]] ) {
        ACTextField *tf = (ACTextField *) textField;
        if(tf.type == kACTextFieldTypePhone){
            NSString* totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];
            //remove the first 0
            if([[totalString substringToIndex:1] isEqualToString:@"0"]){
                totalString = [totalString substringFromIndex:1];
            }
            if (range.length == 1) {
                // Delete button was hit.. so tell the method to delete the last char.
                textField.text = [self formatPhoneNumber:totalString deleteLastChar:YES];
            } else {
                textField.text = [self formatPhoneNumber:totalString deleteLastChar:NO ];
            }
            return false;
        }
        else if(tf.type == kACTextFieldTypeName || tf.type == kACTextFieldTypeNameSurname){
            NSMutableCharacterSet  *set= [NSMutableCharacterSet letterCharacterSet];
            [set formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([string rangeOfCharacterFromSet:[set invertedSet]].location == NSNotFound) {
                return YES;
            } else {
                return NO;
            }
        }
        else if(tf.type == kACTextFieldTypeYear){
            NSMutableCharacterSet  *set= [NSMutableCharacterSet decimalDigitCharacterSet];
            if ([string rangeOfCharacterFromSet:[set invertedSet]].location == NSNotFound) {
                if(string.length + tf.text.length < 5)
                    return YES;
                else
                    return NO;
            } else {
                return NO;
            }
        }
        else if(tf.type == kACTextFieldTypeCurrency){
            NSString *simpleNumber = [tf.text stringByAppendingString:string];
            if(range.length == 1)
                simpleNumber = [simpleNumber substringToIndex:simpleNumber.length-1];
            
            NSString *newString = [UtilityMethods formatNumberString:simpleNumber];
            
            tf.text = newString;
            return NO;
        }
    }
    
    return YES;
}
-(NSString*) formatPhoneNumber:(NSString*) simpleNumber deleteLastChar:(BOOL)deleteLastChar {
    
    if(simpleNumber.length==0) return @"";
    // use regex to remove non-digits(including spaces) so we are left with just the numbers
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]" options:NSRegularExpressionCaseInsensitive error:&error];
    simpleNumber = [regex stringByReplacingMatchesInString:simpleNumber options:0 range:NSMakeRange(0, [simpleNumber length]) withTemplate:@""];
    
    // check if the number is to long
    if(simpleNumber.length>10) {
        // remove last extra chars.
        simpleNumber = [simpleNumber substringToIndex:10];
    }
    
    if(deleteLastChar) {
        // should we delete the last digit?
        simpleNumber = [simpleNumber substringToIndex:[simpleNumber length] - 1];
    }
    
    // 123 456 7890
    // format the number.. if it's less then 7 digits.. then use this regex.
    
    if(simpleNumber.length < 1)
        simpleNumber = @"";
    else if(simpleNumber.length < 4)
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"(\\d{%d})", simpleNumber.length]
                                                               withString:@"0($1)"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    else if(simpleNumber.length<7)
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d+)"
                                                               withString:@"0($1) $2"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    
    else   // else do this one..
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{3})(\\d+)"
                                                               withString:@"0($1) $2 $3"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    
    return simpleNumber;
}
#pragma mark - Validation
- (NSArray *) invalidTextFields{
    //dismiss keyboard here!
    [self resign];
    
    NSMutableArray *result = [NSMutableArray array];
    for (UIView *tempTF in _controls) {
        if([tempTF isKindOfClass:[ACTextField class]]){
            ACTextField *ecTF = (ACTextField *) tempTF;
            if(!ecTF.isValid) [result addObject:ecTF];
        }
        else if([tempTF isKindOfClass:[HTAutocompleteTextField class]]){
            HTAutocompleteTextField *htTf = (HTAutocompleteTextField *) tempTF;
            if(![htTf isValid]) [result addObject:htTf];
        }
    }
    if(result.count < 1) result = nil;
    
    return result;
}
- (void) showPicker:(UIView *) picker{
    [self backgroundTapHandler];
    
    if([picker respondsToSelector:@selector(reloadAllComponents)]){
        [picker performSelector:@selector(reloadAllComponents)];
    }
    //    [picker reloadAllComponents];
    UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    UIView *pickerContainer = [[UIView alloc] initWithFrame:rootView.frame];
    
    pickerContainer.backgroundColor = [UIColor clearColor];
    pickerContainer.tag = 198;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerBgTap:)];
    [pickerContainer addGestureRecognizer:tap];
    
    /*
     UIView *pickerBg = [[UIView alloc] initWithFrame:CGRectMake((pickerContainer.frame.size.width - picker.frame.size.width)/2.0f,
     pickerContainer.frame.size.height - picker.frame.size.height,
     picker.frame.size.width,
     picker.frame.size.height+30)];
     pickerBg.backgroundColor = [UIColor whiteColor];
     
     UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
     closeButton.frame = CGRectMake(270, 0, 50, 30);
     closeButton.adjustsImageWhenHighlighted = NO;
     closeButton.titleLabel.textColor = [UIColor darkTextColor];
     closeButton.tintColor = [UIColor darkTextColor];
     [closeButton setTitle:@"Kapat" forState:UIControlStateNormal];
     [closeButton addTarget:self action:@selector(pickerBgTap:) forControlEvents:UIControlEventTouchUpInside];
     [pickerBg addSubview:closeButton];
     
     picker.frame = CGRectMake(0, 30, picker.frame.size.width, picker.frame.size.height);
     
     [pickerBg addSubview:picker];
     [pickerContainer addSubview:pickerBg];
     */
    picker.frame = CGRectMake((pickerContainer.frame.size.width - picker.frame.size.width)/2.0f,
                              pickerContainer.frame.size.height - picker.frame.size.height,
                              picker.frame.size.width,
                              picker.frame.size.height+30);
    
    self.endFrame = picker.frame;
    [pickerContainer addSubview:picker];
    
    pickerContainer.frame = CGRectMake(0, pickerContainer.frame.size.height,
                                       pickerContainer.frame.size.width, pickerContainer.frame.size.height);
    
    [rootView addSubview:pickerContainer];
    [self moveToView:_activeControl];
    
    [UIView animateWithDuration:.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         pickerContainer.frame = CGRectMake(0, 0, pickerContainer.frame.size.width, pickerContainer.frame.size.height);
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void) hidePicker{
    UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    UIView *pickerContainer = [rootView viewWithTag:198];
    [self moveBy:-_currentOffset];
    
    if(pickerContainer){
        [UIView animateWithDuration:.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             pickerContainer.frame = CGRectMake(0, pickerContainer.frame.size.height, pickerContainer.frame.size.width, pickerContainer.frame.size.height);
                         } completion:^(BOOL finished) {
                             [pickerContainer removeFromSuperview];
                             _activeControl = nil;
                         }];
        
    }
}
- (void) pickerBgTap:(id) sender{
    //    [self hidePicker];
    [self resign];
}
- (void) showModalView:(UIView *) view{
    
    [self backgroundTapHandler];
    
    UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    UIView *modalContainer = [[UIView alloc] initWithFrame:rootView.frame];
    //    modalContainer.backgroundColor = [UIColor colorWithRed:.3 green:.3 blue:.3 alpha:.4];
    modalContainer.backgroundColor = [UIColor clearColor];
    modalContainer.tag = 199;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerBgTap:)];
    [modalContainer addGestureRecognizer:tap];
    
    UIView *pickerBg = [[UIView alloc] initWithFrame:CGRectMake((modalContainer.frame.size.width - view.frame.size.width)/2.0f,
                                                                modalContainer.frame.size.height - view.frame.size.height,
                                                                view.frame.size.width,
                                                                view.frame.size.height+30)];
    pickerBg.backgroundColor = [UIColor whiteColor];
    
    [pickerBg addSubview:view];
    view.frame = CGRectMake(0, 30, view.frame.size.width, view.frame.size.height);
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake(270, 0, 50, 30);
    closeButton.adjustsImageWhenHighlighted = NO;
    closeButton.titleLabel.textColor = [UIColor darkTextColor];
    closeButton.tintColor = [UIColor darkTextColor];
    [closeButton setTitle:@"Kapat" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(pickerBgTap:) forControlEvents:UIControlEventTouchUpInside];
    [pickerBg addSubview:closeButton];
    
    
    [modalContainer addSubview:pickerBg];
    
    modalContainer.frame = CGRectMake(0, modalContainer.frame.size.height,
                                      modalContainer.frame.size.width, modalContainer.frame.size.height);
    
    [rootView addSubview:modalContainer];
    
    
    [UIView animateWithDuration:.4
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         modalContainer.frame = CGRectMake(0, 0, modalContainer.frame.size.width, modalContainer.frame.size.height);
                     } completion:^(BOOL finished) {
                         
                     }];
    
}
- (void) hideModalView{
    UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    UIView *modaContainer = [rootView viewWithTag:199];
    if(modaContainer){
        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             modaContainer.frame = CGRectMake(0, modaContainer.frame.size.height, modaContainer.frame.size.width, modaContainer.frame.size.height);
                         } completion:^(BOOL finished) {
                             [modaContainer removeFromSuperview];
                             //                             _activeControl = nil;
                         }];
        
    }
}

@end
