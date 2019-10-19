//
//  MyCustomCell.h
//  OcrSdkDemo
//
//  Created by Vincent DiGiovanni on 6/23/19.
//  Copyright © 2019 ABBYY. All rights reserved.
//
#import <UIKit/UIKit.h>
//#import "CZPickerView.h"
@protocol CellDelegate <NSObject>
- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withData:(id)data;
@end


@interface MyCustomCell : UITableViewCell
@property (weak, nonatomic) id<CellDelegate>delegate;
@property (assign, nonatomic) NSInteger cellIndex;
@property (weak, nonatomic) IBOutlet UIButton *assign;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkmark;

- (IBAction)initialSelect:(id)sender;

@end
