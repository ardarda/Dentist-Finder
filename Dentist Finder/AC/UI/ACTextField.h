//
//  ACTextField.h
//  EKolayIPhone
//
//  Created by Arda CICEK on 19/01/14.
//  Copyright (c) 2014 Mobven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kACTextFieldTypeEmail,
    kACTextFieldTypePhone,
    kACTextFieldTypeName,
    kACTextFieldTypeSurname,
    kACTextFieldTypeNameSurname,
    kACTextFieldTypeUserName,
    kACTextFieldTypePassword,
    kACTextFieldTypeAddress,
    kACTextFieldTypeYear,
    kACTextFieldTypeURL,
    kACTextFieldTypeCurrency
}kACTextFieldType;

@interface ACTextField : UITextField

@property (nonatomic) kACTextFieldType type;

- (BOOL) isValid;



@end
