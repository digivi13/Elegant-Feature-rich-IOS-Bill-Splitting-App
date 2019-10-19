//
//  PopupView.h
//  OcrSdkDemo
//
//  Created by Vincent DiGiovanni on 8/3/19.
//  Copyright © 2019 ABBYY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CZPicker.h>
#import "PopupCell.h"
@protocol senddataProtocol <NSObject>

-(void)sendDataToA:(NSArray *)array; //I am thinking my data is NSArray, you can use another object for store your information.
@end
@interface PopupViewController : UITableViewController<PopupCellDelegate>

@property(nonatomic, retain)NSMutableArray *initialsSelected;
@property(nonatomic, retain)NSMutableArray *fruits;
@property(nonatomic, retain)NSMutableArray *contributions;
@property(nonatomic, retain)NSNumber *total;
@property(nonatomic, retain)NSMutableArray *array;
@property(nonatomic, retain)NSMutableArray *pickerMenu;
@property(nonatomic, retain)NSMutableArray *initials;
@property(nonatomic, retain)NSMutableArray *prices;
@property(nonatomic, retain)NSMutableArray *initialsFinal;
@property(nonatomic, retain)NSMutableArray *priceFinal;
@property NSInteger cellindex;
@property(nonatomic,assign)id delegate;

@end
