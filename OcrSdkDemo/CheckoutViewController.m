//
//  CheckoutViewController.m
//  OcrSdkDemo
//
//  Created by Vincent DiGiovanni on 7/5/19.
//  Copyright © 2019 ABBYY. All rights reserved.
//
#import <MessageUI/MFMessageComposeViewController.h>
#import <UIKit/UIKit.h>
#import <CZPicker.h>
#import <Foundation/Foundation.h>
#import "CheckoutViewController.h"
#import "ViewController1.h"
#import "MVMPaymentViewController.h"
#import "MVMLoggedOutViewController.h"


@interface CheckoutViewController () <UITextFieldDelegate>
@property NSInteger cellindex;
@property NSString *name;
@property NSString *initialforcell;
@property NSNumber *total1;
@property NSNumber *total2;
@property NSMutableArray *fruitImages;
@property CZPickerView *pickerWithImage;


@end

@implementation CheckoutViewController
@synthesize initialsSelected;
@synthesize fruits;
@synthesize pickerMenu;
@synthesize initials;
@synthesize total;
@synthesize totals;
@synthesize array;
@synthesize prices;
@synthesize masterContributions;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    NSLog(@"%@", masterContributions);
    [self calculatetotals:self];
    self.totals = [[NSMutableArray alloc] init];
    //[self.tableView reloadData];
    self.total = 0;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_taxes addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_tip addTarget:self action:@selector(textFieldDidChange1:) forControlEvents:UIControlEventEditingChanged];
    //[self.tableView reloadData];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    
    //textView.hidden = YES;
    //statusLabel.hidden = NO;
    //self.fruits = self.initials;
    //statusIndicator. hidden = NO;

    [super viewWillAppear:animated];
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
    
    int arraySize = [self.initials count];
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
    static NSString *CellIdentifier;
    
    // use a single Cell Identifier for re-use!
    CellIdentifier  = @"checkoutCell";

    CheckoutCell * cell = [tableView dequeueReusableCellWithIdentifier:@"checkoutCell"];
    if (cell == nil)
    {
        //cell = [[CheckoutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"checkoutCell"] ;
        [tableView registerNib:[UINib nibWithNibName:@"CheckoutCell" bundle:nil] forCellReuseIdentifier:@"checkoutCell"];
        //cell = [[CheckoutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"checkoutCell"] ;
        cell = [tableView dequeueReusableCellWithIdentifier:@"checkoutCell"];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        cell.delegate = self;
        cell.cellIndex = indexPath.row;
        cell.prices = self.prices;
        cell.masterContributions = self.masterContributions;
        cell.array = self.array;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        int j = [cell.prices count];
        for (int i = 0; i < j; i++)
        {
            int a = indexPath.row;
            //NSLog(@"%@", self.masterContributions[a]);
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30 , 50 + (30 * i) , 100 , 100)];

            if ([cell.masterContributions[i] isKindOfClass:[NSMutableArray class]])
            {
                while ([cell.masterContributions[i] count] < [self.initialsSelected count])
                {
                    [cell.masterContributions[i] addObject:@"0.00"];
                }
                
   
                NSString *str = [NSString stringWithFormat:@"%@", cell.masterContributions[i][a]];
                float a = str.floatValue;
                label.text = [NSString stringWithFormat:@"$ %.02f", a];
                label.tag = i;

                NSLog(@"number of subviews is %lu",(unsigned long)[cell.subviews count]);
                 if([cell.subviews count] < ([cell.prices count] * 3)) {
                     [cell addSubview:label];
                 }
            }
            else
            {
                NSLog(@"number of subviews is %lu",(unsigned long)[cell.subviews count]);
                label.tag = i;
                label.text = [NSString stringWithFormat:@"$ 0.00"];
                
                if([cell.subviews count] < ([cell.prices count] * 3)) {
                    [cell addSubview:label];
                }
            }
            UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(130 , 50 + (30 * i) , 100 , 100)];
            //label2.text = (@"item is %@", item);
            NSString *str2 = [NSString stringWithFormat:@"%@", [cell.prices objectAtIndex:i]];
            float b = str2.floatValue;
            label2.text = [NSString stringWithFormat:@"$ %.02f", b];
        
            [cell addSubview:label2];
            UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(200 , 50 + (30 * i) , 200 , 100)];
            label3.text = [NSString stringWithFormat:@"%@", [cell.array objectAtIndex:i]];
            //label2.text = (@"item is %@", item);
            
            [cell addSubview:label3];
            if (i == (j-1)){
                
                if ([_taxes.text floatValue] >= 0)
                {
                    float taxedtotal = ([_taxes.text floatValue] / 100 ) * [self.total floatValue];
                    self.total1 = [NSNumber numberWithFloat:taxedtotal];
                    NSString *realtotal = [self.total1 stringValue];
                    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(170, 60 + (30 * (i+2)) , 100 , 30)];
                    label4.backgroundColor = [UIColor whiteColor];
                    label4.opaque = false;
                    label4.adjustsFontSizeToFitWidth = YES;
                    label4.text = NULL;
                    label4.text = [NSString stringWithFormat:@"Tax $ %.02f",[self.total1 floatValue]];
                    //[label4 setNeedsDisplay];
                    //label2.text = (@"item is %@", item);
                    [cell addSubview:label4];
                    
                    
                }
                if ([_tip.text floatValue] >= 0)
                {
                    float taxedtotal = ([_tip.text floatValue] / 100 ) * [self.total floatValue];
                    self.total2 = [NSNumber numberWithFloat:taxedtotal];
                    NSString *realtotal = [self.total2 stringValue];
                    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(30 , 60 + (30 * (i+2)) , 100 , 30)];
                    label5.backgroundColor = [UIColor whiteColor];
                    label5.opaque = false;
                    label5.adjustsFontSizeToFitWidth = YES;
                    label5.text = NULL;
                    label5.text = [NSString stringWithFormat:@"Tip $ %.02f",[self.total2 floatValue]];
                    //label2.text = (@"item is %@", item);
                    [cell addSubview:label5];
                }
            }
            
            if (i == (j-1))
            {
                int f = ([cell.prices count] + 2);
                UIButton *but= [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [but addTarget:self action:@selector(text:) forControlEvents:UIControlEventTouchUpInside];
                [but setFrame:CGRectMake(120 , 65 + (30 * f + 2) , 130 , 40)];
                [but setTitle:@"Text to a friend" forState:UIControlStateNormal];
                [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [but setExclusiveTouch:YES];
                [but setBackgroundColor:({UIColor* color = [UIColor blueColor];
                    color;
                })];
                [cell addSubview:but];
                
            }
        }
    
    float taxedtotal = 0.0;
    float tiptotal = 0.0;
    if ([_taxes.text floatValue] >= 0)
    {
        taxedtotal = ([_taxes.text floatValue] / 100 ) * [self.total floatValue];
        //self.total = [NSNumber numberWithFloat:taxedtotal];
    }
    if ([_tip.text floatValue] >= 0)
    {
        tiptotal = ([_tip.text floatValue] / 100 ) * [self.total floatValue];
        //self.total = [NSNumber numberWithFloat:tiptotal];
    }
    self.total = [NSDecimalNumber numberWithFloat:(tiptotal + taxedtotal + [self.total floatValue])];
    
    NSString *realtotal = [NSString stringWithFormat:@"%.02f", self.total.floatValue];
    self.total = [NSDecimalNumber numberWithFloat:[realtotal floatValue]];
    cell.middleLabel.text = (@"$ %@", realtotal);
    NSString *stringtotal = [self.total stringValue];
    
    //[self.totals addObject:realtotal];
    NSLog(@"Totals is %@", self.totals);
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


- (void)tableView:(UITableView *)tableView willDisplayCell:(CheckoutCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //self.initialforcell = [self.initials objectAtIndex:indexPath.row];
    //self.assignments = [@"", ]
    //convert float value to string object that can be used in cell labe
    NSString *myString = [NSString stringWithFormat:@"%@", [self.initials objectAtIndex:indexPath.row]];
    //NSString *middleString = [NSString stringWithFormat:@"$ %@", [self.initialsSelected objectAtIndex:indexPath.row]];
    //cell.leftLabel.text = (@"%@", self.name);
    cell.rightLabel.text = (@"$ %@", myString);
    //cell.middleLabel.text = (@"%s", self.initialsFinal[indexPath.row]);
    
    self.total = 0;
    for (id item in masterContributions) {
        if ([item isKindOfClass:[NSMutableArray class]]) {
            
            NSLog(@"item is %@", item);
            int a = indexPath.row;
            NSString *value = item[a];
            NSLog(@"values is %@", value);
            CGFloat itemCost = [value floatValue];
            NSLog(@"values2 is %.1f", itemCost);
            float newtotal = self.total.floatValue + itemCost;
            NSLog(@"newtotal is %.1f", newtotal);
            NSNumber *decimaltotal = [NSNumber numberWithFloat:newtotal];
            NSLog(@"newtotal is %@", decimaltotal);
            self.total = decimaltotal;
            NSLog(@"finaltotal is %@", self.total);
        }
        
    }
    //if ([_taxes.text floatValue] > 0)
    //{
    //   float taxedtotal = ([_taxes.text floatValue] / 100 ) * [self.total floatValue] + [self.total floatValue];
    //    self.total = [NSNumber numberWithFloat:taxedtotal];
    //}
    //if ([_tip.text floatValue] > 0)
    //{
    //    float tiptotal = ([_tip.text floatValue] / 100 ) * [self.total floatValue] + [self.total floatValue];
    //    self.total = [NSNumber numberWithFloat:tiptotal];
    //}
    //NSString *realtotal = [self.total stringValue];
    
    //cell.middleLabel.text = (@"$ %@", realtotal);
    //NSString *stringtotal = [self.total stringValue];
    
    //[self.totals addObject:stringtotal];
    NSLog(@"Totals is %@", self.totals);
    //NSLog(@"initial selected is %@", self.initials[indexPath.row]);


    float taxedtotal = 0.0;
    float tiptotal = 0.0;
    if ([_taxes.text floatValue] >= 0)
    {
        taxedtotal = ([_taxes.text floatValue] / 100 ) * [self.total floatValue];
        //self.total = [NSNumber numberWithFloat:taxedtotal];
    }
    if ([_tip.text floatValue] >= 0)
    {
        tiptotal = ([_tip.text floatValue] / 100 ) * [self.total floatValue];
        //self.total = [NSNumber numberWithFloat:tiptotal];
    }
    self.total = [NSDecimalNumber numberWithFloat:(tiptotal + taxedtotal + [self.total floatValue])];
    
    NSString *realtotal = [NSString stringWithFormat:@"%.02f", self.total.floatValue];
    self.total = [NSDecimalNumber numberWithFloat:[realtotal floatValue]];
    cell.middleLabel.text = (@"$ %@", realtotal);
    NSString *stringtotal = [self.total stringValue];
    
    [self.totals addObject:realtotal];
    NSLog(@"Totals is %@", self.totals);
}
static UIImage* CreateImageFromView(UITableView *view)
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.contentSize.width, view.contentSize.height), NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect previousFrame = view.frame;
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.contentSize.width, view.contentSize.height);
    [view.layer renderInContext:context];
    view.frame = previousFrame;
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(UIImage *)captureScreenInRect:(CGRect)captureFrame
{
    CALayer *layer;
    layer = self.tableView.layer;
    UIGraphicsBeginImageContext(self.tableView.bounds.size);
    CGContextClipToRect (UIGraphicsGetCurrentContext(),captureFrame);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenImage;
}

-(IBAction)text:(UIButton*)sender
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    UIImage *image = CreateImageFromView(self.tableView);
    //UIImage *image = [self captureScreenInRect:CGRectMake(0, 0, screenWidth, screenHeight)];
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        //NSString * result = [self.prices description];
        controller.body = @"Your contributions to the split";
        controller.recipients = [NSArray arrayWithObjects:@"My Number",nil];
        controller.messageComposeDelegate = self;
        NSData *dataImg = UIImagePNGRepresentation(CreateImageFromView(self.tableView));//Add the image as attachment
        [controller addAttachmentData:dataImg typeIdentifier:@"public.data" filename:@"Image.png"];
        [self presentViewController:controller animated:YES completion:nil];
            
    }
    
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    // Check the result or perform other tasks.    // Dismiss the message compose view controller.
    [self dismissViewControllerAnimated:YES completion:nil];}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.expandedCells containsObject:indexPath])
    {
        [self.expandedCells removeObject:indexPath];
    }
    else
    {
        [self.expandedCells addObject:indexPath];
    }
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat kExpandedCellHeight = ([self.prices count] * 30 + 200);
    CGFloat kNormalCellHeight = 50;
    self.expandedCells = self.masterContributions;
    if ([self.expandedCells containsObject:indexPath])
    {

        return kExpandedCellHeight; //It's not necessary a constant, though
    }
    else
    {

        return kNormalCellHeight; //Again not necessary a constant
    }
}

- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withData:(id)data
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:cellIndex inSection:0];
    // Do additional actions as required.
    self.cellindex = cellIndex;
    
    MVMPaymentViewController *venmo = [[MVMPaymentViewController alloc] init];
    venmo.amountTextField.text = (@"%@", [self.totals objectAtIndex:cellIndex]);
   // [self prepareForSegue:@"view6" sender:self];
    [self performSegueWithIdentifier:@"view6" sender:self];
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
}
-(void)textFieldDidChange:(UITextField *)textField {
    self.totals = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    
    
    NSLog(@"text changed: %@", _taxes.text);
}
-(void)textFieldDidChange1:(UITextField *)textField {
    self.totals = [[NSMutableArray alloc] init];
 
    [self.tableView reloadData];
    
    
    NSLog(@"text changed: %@", self.totals);
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"view6"]){
        MVMLoggedOutViewController *venmo = (MVMLoggedOutViewController*)segue.destinationViewController;
        int a = (int)self.cellindex;
        venmo.total = [self.totals objectAtIndex:a];
        NSLog(@"cell index is  %ld",(long)self.cellindex);
        NSLog(@"value is %@", venmo.total);
    }
    
}
-(IBAction)unwindFromLoggedInVC1:(UIStoryboardSegue *)segue {
    //[[Venmo sharedInstance] logout];
}
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView endEditing:YES];
}


@end
