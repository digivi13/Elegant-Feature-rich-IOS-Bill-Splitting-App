//
//  CheckoutCell.h
//  OcrSdkDemo
//
//  Created by Vincent DiGiovanni on 7/4/19.
//  Copyright © 2019 ABBYY. All rights reserved.
//

#import "CheckoutCell.h"
#import "MyCustomCell.h"
@protocol CheckoutCellDelegate <NSObject>
- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withData:(id)data;
@end

@interface CheckoutCell : UITableViewCell <CheckoutCellDelegate>
@property (strong, nonatomic) IBOutletCollection(UITableView) NSArray *tableView2;
//@property (weak, nonatomic) UITableView *tableView2;
@property(nonatomic, retain)UITableView *tableView1;
@property(nonatomic, retain)NSMutableArray *initialsSelected;
@property (nonatomic,strong) NSMutableArray *masterContributions;
@property(nonatomic, retain)NSMutableArray *prices;
@property (weak, nonatomic) id<CheckoutCellDelegate>delegate;
@property (assign, nonatomic) NSInteger cellIndex;
@property(nonatomic, retain)NSMutableArray *array;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property NSString *name;


@end
