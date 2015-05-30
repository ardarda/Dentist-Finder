//
//  RegisterViewController.m
//  Dentist Finder
//
//  Created by Arda Cicek on 29/05/15.
//  Copyright (c) 2015 Arda Cicek. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfSurname;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)validateForm {
    return YES;
}

- (IBAction)btnSignUpHandler:(id)sender {
    
}

@end
