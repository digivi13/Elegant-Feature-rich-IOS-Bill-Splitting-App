//
//  PopupCell.m
//  OcrSdkDemo
//
//  Created by Vincent DiGiovanni on 8/3/19.
//  Copyright © 2019 ABBYY. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PopupCell.h"


@implementation PopupCell
@synthesize itemprice;
@synthesize prices;
@synthesize cellIndex;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _leftLabel.text = @"0.0";
    }
    [_leftLabel setReturnKeyType:UIReturnKeyDone];
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.leftLabel resignFirstResponder];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(IBAction)fieldchanged:(id)sender  {
    
   // if (UIControlEventEditingDidEnd) {
    _slider.value = self.leftLabel.text.floatValue;
    float cash_cost = itemprice * _slider.value;
    NSLog(@"$ %.02f", cash_cost);
    
    NSString *valueString = [NSString stringWithFormat:@"$ %.02f",cash_cost];
    //float cashvalue = _slider.value ** cashcontrib;
    self.middleLabel.text = valueString;
   // }
        
}

- (IBAction)sliderchanged:(id)sender {
    
    if (_slider.value > 0.9) {
        _slider.value = 1.0;
    }
    //NSString* formattedNumber = [NSString stringWithFormat:@"%.02f", myFloat];
    NSString *sliderString = [NSString stringWithFormat:@"%.02f", _slider.value];
    
    self.leftLabel.text = sliderString;
    
    //NSNumber *cash_value = [NSNumber numberWithChar:cashcontrib];

    NSLog(@"%@", self.prices);
    NSLog(@"%f", itemprice);
    
    float cash_cost = itemprice * _slider.value;
    NSLog(@"$ %.02f", cash_cost);
    
    NSString *valueString = [NSString stringWithFormat:@"$ %.02f",cash_cost];
    //float cashvalue = _slider.value ** cashcontrib;
    self.middleLabel.text = valueString;
    
}
-(IBAction)split:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnCellAtIndex:withData:)]) {
        [self.delegate didClickOnCellAtIndex:cellIndex withData:@"any other cell cell"];
    }
    
}
-(IBAction)card:(id)sender {
    
    
}


@end
