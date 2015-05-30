//
//  ACTextField.m
//  EKolayIPhone
//
//  Created by Arda CICEK on 19/01/14.
//  Copyright (c) 2014 Mobven. All rights reserved.
//

#import "ACTextField.h"
//#import "Constants.h"

@implementation ACTextField

- (void) drawPlaceholderInRect:(CGRect)rect {
    [[UIColor whiteColor] setFill];
//    [[self placeholder] drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont fontWithName:kFontBodoniBook size:16]}];
}

- (void) setType:(kACTextFieldType)type{
    _type = type;
    
    switch (type) {
        case kACTextFieldTypeName:
            self.keyboardType = UIKeyboardTypeAlphabet;
            
            break;
        case kACTextFieldTypeSurname:
            self.keyboardType = UIKeyboardTypeAlphabet;
            
            break;
        case kACTextFieldTypeNameSurname:
            self.keyboardType = UIKeyboardTypeAlphabet;
            
            break;
        case kACTextFieldTypeUserName:
            self.keyboardType = UIKeyboardTypeDefault;
            
            break;
        case kACTextFieldTypePhone:
            self.keyboardType = UIKeyboardTypeNumberPad;
            
            break;
        case kACTextFieldTypeEmail:
            self.keyboardType = UIKeyboardTypeEmailAddress;
            
            break;
        case kACTextFieldTypePassword:
            self.keyboardType = UIKeyboardTypeDefault;
            self.secureTextEntry = YES;
            
            break;
        case kACTextFieldTypeAddress:
            self.keyboardType = UIKeyboardTypeDefault;
            
            break;
        case kACTextFieldTypeYear:
            self.keyboardType = UIKeyboardTypeNumberPad;
            
            break;
        case kACTextFieldTypeURL:
            self.keyboardType = UIKeyboardTypeDefault;
            
            break;
        case kACTextFieldTypeCurrency:
            self.keyboardType = UIKeyboardTypeNumberPad;
            
            break;
        default:
            break;
    }
}

- (BOOL) isValid{
    NSString *regex;
    NSPredicate *predicate;
    
    if(self.type == kACTextFieldTypeName || self.type == kACTextFieldTypeSurname){
        return self.text.length > 1;
    }
    else if(self.type == kACTextFieldTypeNameSurname){
        NSArray *components =[self.text componentsSeparatedByString:@" "];
        if(components.count < 2) return NO;
        NSString *name = [components objectAtIndex:0];
        NSString *surname = [components objectAtIndex:1];
        return (name.length > 1 && surname.length >1);
    }
    else if(self.type == kACTextFieldTypePhone){
        NSString *simpleNumber = self.text;
        if(simpleNumber.length < 1 ) return NO;
        if([[simpleNumber substringToIndex:1] isEqualToString:@"0"]){
            simpleNumber = [simpleNumber substringFromIndex:1];
        }
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]" options:NSRegularExpressionCaseInsensitive error:&error];
        simpleNumber = [regex stringByReplacingMatchesInString:simpleNumber options:0 range:NSMakeRange(0, [simpleNumber length]) withTemplate:@""];
        
        return (simpleNumber.length == 10);
    }
    else if(self.type == kACTextFieldTypeEmail){
        regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
        predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        return [predicate evaluateWithObject:self.text];
    }
    else if(self.type == kACTextFieldTypeUserName){
        return self.text.length > 2;
    }
    else if(self.type == kACTextFieldTypeAddress){
        return self.text.length > 10;
    }
    else if(self.type == kACTextFieldTypePassword){
        return self.text.length > 3;
    }
    else if(self.type == kACTextFieldTypeURL){
        NSString *urlRegEx =@"((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
        NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
        BOOL isValid = [urlTest evaluateWithObject:self.text];
        
        return isValid;

    }
    else if(self.type == kACTextFieldTypeCurrency){
        
    }
    return NO;
}

@end
