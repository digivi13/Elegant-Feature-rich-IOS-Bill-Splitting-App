//
//  PopupCell.m
//  OcrSdkDemo
//
//  Created by Vincent DiGiovanni on 8/3/19.
//  Copyright © 2019 ABBYY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CZPicker.h>
#import <Foundation/Foundation.h>
#import "PopupView.h"
#import "ViewController1.h"
#import "MVMPaymentViewController.h"


@interface PopupViewController ()

@property NSString *name;
@property float item_price;
@property float splittotal;
@property NSString *initialforcell;
@property double splitAll;
@property NSMutableArray *fruitImages;
@property CZPickerView *pickerWithImage;

@end

@implementation PopupViewController
@synthesize initialsSelected;
@synthesize fruits;
@synthesize pickerMenu;
@synthesize initials;
@synthesize total;
@synthesize array;
@synthesize prices;
@synthesize splitAll;
@synthesize cellindex;
@synthesize delegate;
@synthesize contributions;



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    
    [self calculatetotals:self];
    int a = cellindex;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ $ %@", self.array[a], self.prices[a]];
    self.splitAll = 0.0;
    self.item_price = [self.prices[a]floatValue];
    [self.tableView reloadData];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    //textView.hidden = YES;
    //statusLabel.hidden = NO;
    //self.fruits = self.initials;
    //statusIndicator. hidden = NO;
    [super viewWillAppear:animated];
    int a = cellindex;
    self.navigationItem.title = [NSString stringWithFormat:@"%@ $ %@", self.array[a], self.prices[a]];
 
}

- (void)viewDidAppear:(BOOL)animated
{
    //NSString *totalString = [NSString stringWithFormat:@"Receipt Total: $ %@", self.total];
    //statusLabel.text = (@"$ %@", totalString);
    //[self detectedTotal:self];
    //NSLog(@"$ %@", totalString);
    //UIImage* image = [(AppDelegate*)[[UIApplication sharedApplication] delegate] imageToProcess];
    
    //Client *client = [[Client alloc] initWithApplicationID:MyApplicationID password:MyPassword serviceUrl:ProcessingServiceUrl];
    //[client setDelegate:self];
    
    //ProcessingParams* params = [[ProcessingParams alloc] init];
    
    //[client processImage:image withParams:params];
    
    //statusLabel.text = @"Uploading image...";
    
    [super viewDidAppear:animated];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int arraySize = [self.priceFinal count];
    NSLog(@"array is of size %d", arraySize);
    return [self.initials count];
}

//logic for swipe to delete
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//  if (editingStyle == UITableViewCellEditingStyleDelete) {
//      [self.array removeObjectAtIndex:indexPath.row];
//     [self.prices removeObjectAtIndex:indexPath.row];
//     [self.initialsSelected removeObjectAtIndex:indexPath.row];
//    [self detectedTotal:self];
//   [tableView reloadData];

//}
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PopupCell * cell = [tableView dequeueReusableCellWithIdentifier:@"popupCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"PopupCell" bundle:nil] forCellReuseIdentifier:@"popupCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"popupCell"];
    }
    
    cell.prices = self.prices;
    cell.itemprice = self.item_price;
    return cell;
}
- (void)detectedTotal:(id)sender {
    float sum = 0;
    for (NSNumber * n in self.prices) {
        sum += [n floatValue];
        
    }
    NSString *sum1 = [NSString stringWithFormat:@"Detected Total: $ %f", sum];
    // self.detectedLabel.text = sum1;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"view6"]){
        MVMPaymentViewController *venmo = [[MVMPaymentViewController alloc] init];
        //venmo.amountTextField  = self.priceFinal[self.cellindex];
    }
    if([segue.identifier isEqualToString:@"unwindpopup"]){
        RecognitionViewController *controller = [segue destinationViewController];
        int a = cellindex;
        controller.masterContributions[a] = self.contributions;
    }
    if([segue.identifier isEqualToString:@"popup"]){
        PopupCell *controller1 = [[PopupCell alloc] init];
        controller1.prices = self.prices;
        controller1.itemprice = self.item_price;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(PopupCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //self.initialforcell = [self.initials objectAtIndex:indexPath.row];
    //self.assignments = [@"", ]
    //convert float value to string object that can be used in cell label
    NSString *myString = [NSString stringWithFormat:@"%@", [self.initials objectAtIndex:indexPath.row]];
    //NSString *middleString = [NSString stringWithFormat:@"$ %@", [self.initialsSelected objectAtIndex:indexPath.row]];
    NSString *splitstring = [NSString stringWithFormat:@"%0.02f", (double)self.splitAll];
    cell.leftLabel.text = splitstring;
    cell.rightLabel.text = (@"%@", myString);
    //cell.middleLabel.text = (@"%s", self.initialsFinal[indexPath.row]);
    //NSLog(@"initial selected is %@", self.initials[indexPath.row]);
    cell.delegate = self;
    cell.cellIndex = indexPath.row;
    
    cell.slider.value = self.splitAll;
    NSString *splitstring1 = [NSString stringWithFormat:@"%0.02f", (double)self.splittotal];
    cell.middleLabel.text = splitstring1;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
 
    
}
- (IBAction)splitEveryone:(id)sender {
    double divider = [self.initials count];
    NSLog(@"divider equals %f",divider);
    self.splitAll = 1 / divider;
    self.splittotal = self.item_price * self.splitAll;
    
    [self.tableView reloadData];
    
    
}


- (IBAction)markDone:(id)sender {
    NSArray *cells = [self.tableView visibleCells];
    NSMutableArray *contributions = [[NSMutableArray alloc] init];

    //loop through all the cells and get the label with the contribution value
    int a = cellindex;
    for (PopupCell *cell in cells)
    {
        UILabel *names = [cell rightLabel];
        UILabel *contribution = [cell leftLabel];
        NSDecimalNumber *contributionValue = [NSDecimalNumber decimalNumberWithString:[contribution text]];
        NSLog(@"%@", [contribution text]);
        //NSString *currentprice = [NSString stringWithFormat:@"%@", ]
        NSString *currentPrice = [NSString stringWithFormat:@"%@", self.prices[a]];
        NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:currentPrice];//self.prices[cellindex])
        float individualCost = contributionValue.floatValue * price.floatValue;
        NSNumber *cost = [NSNumber numberWithFloat:individualCost];
        NSLog(@"individual cost is %f", individualCost);
        //add the contribution to a master array of contributions
        [contributions addObject:cost];
    }

    self.contributions = contributions;
    NSLog(@"array of interest 2%@", contributions);
    
    //now we need to replace the placeholder value in the master contributions array at the current cell index
    
    //for (id tempObject in contributions) {
    //    NSLog(@"Single element: %@", tempObject);
    //}

    [self performSegueWithIdentifier:@"unwindpopup" sender:self];
    
}


- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withData:(id)data
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:cellIndex inSection:0];
    // Do additional actions as required.
    self.cellindex = cellIndex;
    
    MVMPaymentViewController *venmo = [[MVMPaymentViewController alloc] init];
    venmo.amountTextField.text = (@"%@", [self.priceFinal objectAtIndex:cellIndex]);
    // [self prepareForSegue:@"view6" sender:self];
    [self performSegueWithIdentifier:@"view6" sender:self];
    
    
    //[self.tableView reloadData];;
    // [self.tableView endUpdates];
    
    //UITableViewCell *cell=(UITableViewCell *)[UITableView cellForRowAtIndexPath:indexPath.row];
    //cell.(whatever your label property).textColor=[UIColor greenColor];
    
}
-(void)calculatetotals:(id)sender {
    //get unique values of initials in the list of initials lpaced on items
    NSMutableArray* uniqueValues = [self.initialsSelected valueForKeyPath:[NSString stringWithFormat:@"@distinctUnionOfObjects.%@", @"self"]];
    NSString *string = @" ";
    //self.initialsSelected = [NSMutableArray arrayWithArray:uniqueValues];
    
    NSLog(@"%lu", [self.initialsSelected count]);
    __block NSNumber *individualTotal = @0;
    //enumerate over the list of ubique initials
    __block NSMutableArray *finalTotals = [[NSMutableArray alloc] init];
    __block NSMutableArray *allTotals = [[NSMutableArray alloc] init];
    [uniqueValues enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        // get indexes of all items with those intials
        NSIndexSet *indexes = [self.initialsSelected indexesOfObjectsPassingTest:^BOOL (id obj, NSUInteger idx, BOOL *stop) {
            __block NSMutableArray *allTotals = [[NSMutableArray alloc] init];
            return [obj isEqualToString:object];
        }];
        __block NSNumber *individualTotal_block = (@"%f", 0);
        //use the list of item indexes to get the price and add it to the individial total
        [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber *itemPrice = self.prices[idx];
            
            individualTotal_block = [NSNumber numberWithFloat:([individualTotal_block doubleValue] + [itemPrice doubleValue])];
            
        }];
        
        individualTotal = individualTotal_block;
        [allTotals addObject:individualTotal];
        //NSLog(@"%@", individualTotal);
        finalTotals = allTotals;
        
    }];
    self.priceFinal= finalTotals;
    self.initialsFinal = [NSMutableArray arrayWithArray:uniqueValues];
    
    NSLog(@"%@", finalTotals);
    [self.initialsSelected isEqualToArray:self.initialsFinal];
    [self.prices isEqualToArray:self.priceFinal];
    //NSLog(@"%@", individualTotal);
}

@end
