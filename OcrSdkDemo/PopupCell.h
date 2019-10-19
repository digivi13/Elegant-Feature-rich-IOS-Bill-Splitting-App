//
//  PopupCell.h
//  OcrSdkDemo
//
//  Created by Vincent DiGiovanni on 8/3/19.
//  Copyright © 2019 ABBYY. All rights reserved.
//


@protocol PopupCellDelegate <NSObject>
- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withData:(id)data;
@end

@interface PopupCell : UITableViewCell
@property (weak, nonatomic) id<PopupCellDelegate>delegate;
@property (assign, nonatomic) NSInteger cellIndex;
@property (assign, nonatomic) float itemprice;
@property(nonatomic, retain)NSMutableArray *prices;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UITextField *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UITextField *middleLabel;




@end
