//
//  CheckoutCell.m
//  OcrSdkDemo
//
//  Created by Vincent DiGiovanni on 7/4/19.
//  Copyright © 2019 ABBYY. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CheckoutCell.h"
#import "MyCustomCell.h"
@interface CheckoutCell ()
@end
@implementation CheckoutCell
@synthesize array;
@synthesize prices;
@synthesize masterContributions;
@synthesize name;
@synthesize initialsSelected;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
        
                          
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(IBAction)venmo:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnCellAtIndex:withData:)]) {
        [self.delegate didClickOnCellAtIndex:_cellIndex withData:@"any other cell cell"];
    }

}
-(IBAction)card:(id)sender {
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView2
{
    return 1;
}

- (NSInteger)tableView2:(UITableView *)tableView2 numberOfRowsInSection:(NSInteger)section
{
    
    int arraySize = [self.array count];
    NSLog(@"array is of size %d", arraySize);
    return [self.array count];
}
- (UITableViewCell *)tableView2:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCustomCell * cell = [tableView2 dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell)
    {
        [tableView2 registerNib:[UINib nibWithNibName:@"MyCustomCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView2 dequeueReusableCellWithIdentifier:@"myCell"];
    }
    
    
    return cell;
}

- (void)tableView2:(UITableView *)tableView2 willDisplayCell:(MyCustomCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    //self.initialforcell = [self.initials objectAtIndex:indexPath.row];
    //self.assignments = [@"", ]
    //convert float value to string object that can be used in cell label
    NSString *myString = [NSString stringWithFormat:@"$ %@", [self.prices objectAtIndex:indexPath.row]];
    NSString *middleString = [NSString stringWithFormat:@"%@", [self.masterContributions objectAtIndex:indexPath.row]];
    cell.leftLabel.text = (@"%@", self.name);
    cell.rightLabel.text = (@"$ %@", myString);
    cell.middleLabel.text = (@"%s", self.initialsSelected[indexPath.row]);
    int a = self.cellIndex;
    NSLog(@"string is %@", middleString);
    if (![middleString isEqualToString:@" "]) {
        cell.middleLabel.text = @"Done";
    } else (cell.middleLabel.text = @" ");
    //NSLog(@"initial selected is %@", self.initials[indexPath.row]);
    cell.delegate = self;
    cell.cellIndex = indexPath.row;
}


@end
