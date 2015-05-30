//
//  FeedbackViewController.m
//
//  Created by Arda CICEK on 22/11/13.
//  Copyright (c) 2013 Arda CICEK. All rights reserved.
//

#import "ECFeedbackViewController.h"
#import "AC.h"

@interface ECFeedbackViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tvMsg;

@end

@implementation ECFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id) initWithRelevantNib{
    NSString *nibName;
    
    if(IS_IPHONE && IS_IPHONE_5)
    {
        nibName = [NSString stringWithFormat:@"%@%@", NSStringFromClass([self class]), @""];
    }
    else if(IS_IPHONE)
    {
        nibName = [NSString stringWithFormat:@"%@%@", NSStringFromClass([self class]), @"_4"];
    }
    else
    {
        nibName = [NSString stringWithFormat:@"%@%@", NSStringFromClass([self class]), @"_ipad"];
    }
    
    self = [super initWithNibName:nibName bundle:nil];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendButtonHandler:(id)sender {
    /*
    NSString *className = NSStringFromClass([self.presentingViewController class]);
    NSString *msg = [NSString stringWithFormat:@"%@\r\n%@", className, _tvMsg.text];
    
    [TestFlight submitFeedback:msg];
    [[[UIAlertView alloc] initWithTitle:@""
                                message:@"Feedback Gönderildi"
                               delegate:nil
                      cancelButtonTitle:@"Tamam"
                      otherButtonTitles:nil, nil] show];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
     */
}

@end
