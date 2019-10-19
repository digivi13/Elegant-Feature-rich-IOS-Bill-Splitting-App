//
//  ConfirmPayment.m
//  OcrSdkDemo
//
//  Created by Vincent DiGiovanni on 7/3/19.
//  Copyright © 2019 ABBYY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfirmPayment.h"
#import "ViewController.h"
#import <Stripe/Stripe.h>
#import "ViewController1.h"
@interface ConfirmPaymentController () <UITextFieldDelegate, STPPaymentCardTextFieldDelegate>
@property (nonatomic) STPRedirectContext *redirectContext;
@property (weak, nonatomic) STPPaymentCardTextField *paymentTextField;
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;
@end
@implementation ConfirmPaymentController
@synthesize paymentnote;
@synthesize cardNumber;
@synthesize expiry;
@synthesize name;
@synthesize month;
@synthesize year;
@synthesize total;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    // Setup payment view
    
    //[self.view addSubview:paymentTextField];
    [self.enteredAmount setDelegate:self];
    [self.cardNumberField setDelegate:self];
    [self.expiryField setDelegate:self];
    [self.nameField setDelegate:self];
    self.enteredAmount.text = total;
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.cardNumber = self.cardNumberField.text;
    self.expiry = self.expiryField.text;
    self.paymentnote = self.nameField.text;
    
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    //textView.hidden = YES;
    //statusLabel.hidden = NO;
    //statusIndicator. hidden = NO;
    self.cardNumberField.text = self.cardNumber;
    self.expiryField.text = self.expiry;
    self.nameField.text = self.paymentnote;
    [super viewWillAppear:animated];
}
- (IBAction)ScanAgain:(id)sender {
    
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"view5"]){
        ViewController1 *controller = [segue destinationViewController];
        controller.amount= self.enteredAmount.text;
        controller.cardNumber = self.cardNumberField.text;
        if ([self.expiryField.text length] > 3) {
            self.month = [self.expiryField.text substringToIndex: 2];
            self.year = [self.expiryField.text substringFromIndex: [self.expiryField.text length] - 2];
        }
        
        controller.month = self.month;
        controller.year = self.year;
        controller.securityCode = self.cvvField.text;
        controller.paymentnote = self.paymentnote;
        
        //controller.total = self.total;
        //controller.initials = self.initials;
        //controller.pickerMenu = self.pickerMenu;
        //controller.initialsSelected = self.initialsSelected;
        //if ((int)counter < 1) {
         //   controller.fruits = self.pickerMenu;
        }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.cardNumber = self.cardNumberField.text;
    self.expiry = self.expiryField.text;
    
    [textField resignFirstResponder];
    return YES;
}

@end
