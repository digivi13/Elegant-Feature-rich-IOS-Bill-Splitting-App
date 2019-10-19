//
//  ConfirmPayment.h
//  OcrSdkDemo
//
//  Created by Vincent DiGiovanni on 7/3/19.
//  Copyright © 2019 ABBYY. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "RecognitionViewController.h"
#import <Stripe/Stripe.h>
@protocol ConfirmPaymentControllerDelegate;

@interface ConfirmPaymentController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id<ConfirmPaymentControllerDelegate> delegate;
//@end

//@interface ConfirmPaymentController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cardNumberField;
@property (weak, nonatomic) IBOutlet UITextField *expiryField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *cvvField;
@property (weak, nonatomic) IBOutlet UITextField *enteredAmount;
@property (nonatomic, retain) NSString *paymentnote;
@property (nonatomic, retain) NSString *cardNumber;
@property (nonatomic, retain) NSString *expiry;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *total;
@property(nonatomic)NSString *month;
@property(nonatomic)NSString *year;

@end
