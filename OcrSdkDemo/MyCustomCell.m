//
//  MyCustomCell.m
//  OcrSdkDemo
//
//  Created by Vincent DiGiovanni on 6/23/19.
//  Copyright © 2019 ABBYY. All rights reserved.
//

//
//  ViewController.m
//  CustomCellTutorial
//
//  Created by Musawir Shah on 10/17/13.
//  Copyright (c) 2013 Musawir Shah. All rights reserved.
//

#import "MyCustomCell.h"


@implementation MyCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _assign.layer.cornerRadius = _assign.bounds.size.height/2;
        // Initialization code
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (IBAction)buttonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnCellAtIndex:withData:)]) {
        [self.delegate didClickOnCellAtIndex:_cellIndex withData:@"any other cell cell"];
    }
}

@end

