//
//  CheckoutViewController.h
//  OcrSdkDemo
//
//  Created by Vincent DiGiovanni on 7/5/19.
//  Copyright © 2019 ABBYY. All rights reserved.
//
#import <UIKit/UIKit.h>

#import <CZPicker.h>
#import "CheckoutCell.h"
@protocol CheckoutViewControllerDelegate;

@interface CheckoutViewController : UITableViewController<CheckoutCellDelegate, UITextFieldDelegate>

@property (nonatomic, weak) id<CheckoutViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *expandedCells;
@property(nonatomic, retain)NSMutableArray *initialsSelected;
@property(nonatomic, retain)NSMutableArray *masterContributions;
@property(nonatomic, retain)NSMutableArray *fruits;
@property(nonatomic, retain)NSNumber *total;
@property(nonatomic, retain)NSMutableArray *array;
@property(nonatomic, retain)NSMutableArray *pickerMenu;
@property(nonatomic, retain)NSMutableArray *initials;
@property(nonatomic, retain)NSMutableArray *prices;
@property(nonatomic, retain)NSMutableArray *initialsFinal;
@property(nonatomic, retain)NSMutableArray *priceFinal;
@property (weak, nonatomic) IBOutlet UITextField *taxes;
@property (weak, nonatomic) IBOutlet UITextField *tip;
@property(nonatomic, retain)NSMutableArray *totals;
@end

