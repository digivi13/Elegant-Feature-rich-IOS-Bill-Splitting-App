#import "ImageViewController.h"
#import "AppDelegate.h"
#import "CZPickerView.h"
#import <BlinkReceipt/BlinkReceipt.h>
#import "RecognitionViewController.h"
#import "ViewController.h"
#import "ConfirmPayment.h"
#import "PopupDialog-Swift.h"

@interface ImageViewController ()
@property NSString *placeholder;
@property NSNumber *total;

@property NSMutableArray *array1;
@property NSMutableArray *fruits;
@property NSMutableArray *fruitImages;
@property NSMutableArray *item;
@property CZPickerView *pickerWithImage;

@end
@implementation ImageViewController
@synthesize initialsSelected;
@synthesize pickerMenu;
@synthesize subArray;
@synthesize initialslist;
@synthesize initials;
@synthesize total;
@synthesize imageView;
@synthesize array0;
@synthesize prices;
@synthesize masterContributions;
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.imageView.image = [(AppDelegate*)[[UIApplication sharedApplication] delegate] imageToProcess];
    
    self.array0 = [[NSMutableArray alloc] init];//initialize arrays
    self.prices =[[NSMutableArray alloc] init];
    self.initials =[[NSMutableArray alloc] init];
    self.initialsSelected =[[NSMutableArray alloc] init];
    self.masterContributions = [[NSMutableArray alloc] init];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)takePhoto:(id)sender 
{
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];

	imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;

	imagePicker.delegate = self;
	
	[self presentViewController:imagePicker animated:YES completion:nil];
}

/** delegate method for picking multiple items,
 implement this method if allowMultipleSelection is YES,
 rows is an array of NSNumbers
 */
- (IBAction)backTo:(id)sender {
    [self performSegueWithIdentifier:@"view1.5" sender:self];
}
- (IBAction)btnTouched:(id)sender {
    BRScanOptions *scanOptions = [BRScanOptions new];

    [[BRScanManager sharedManager] startStaticCameraFromController:self
                                                       scanOptions:scanOptions
                                                      withDelegate:self];
    
    //BRCameraViewController  *CamControlOptions = [[BRCameraViewController alloc]init];
    //[CamControlOptions setTorch:true];
    
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	
	[picker dismissViewControllerAnimated:YES completion:nil];
	
	self.imageView.image = image;
	[(AppDelegate*)[[UIApplication sharedApplication] delegate] setImageToProcess:image];
}

- (NSAttributedString *)czpickerView:(CZPickerView *)pickerView
               attributedTitleForRow:(NSInteger)row{
    
    NSAttributedString *att = [[NSAttributedString alloc]
                               initWithString:self.fruits[row]
                               attributes:@{
                                            NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:18.0]
                                            }];
    return att;
}
//after scannin create arrays that can be passed to the other view controllers for displaying line item information
- (void)didFinishScanning:(UIViewController *)cameraViewController withScanResults:(BRScanResults *)scanResults {
    [cameraViewController dismissViewControllerAnimated:YES completion:nil];
    int i = 0;
    self.array0 = [[NSMutableArray alloc] init];//initialize arrays
    self.prices =[[NSMutableArray alloc] init];
    self.initials =[[NSMutableArray alloc] init];
    self.initialsSelected =[[NSMutableArray alloc] init];
    self.masterContributions = [[NSMutableArray alloc] init];
    self.placeholder = @" ";
    for (_item in scanResults.products) {//loop throught the products picked up and create separate aayas for both prices and item names
        NSLog(@"amount is %@", scanResults.products[i].productDescription.value);//debugging
        NSLog(@"amount is %f", scanResults.products[i].totalPrice);//debugging
        
        if (scanResults.products[i].productDescription.value != nil) {
        [self.array0 addObject:scanResults.products[i].productDescription.value];
        }//add object to array
        else
        {
            [self.array0 addObject:@"Unknown"];
        }
        NSNumber *num = [NSNumber numberWithFloat:scanResults.products[i].totalPrice];//array needs to made of objects, I created an NS Number object
        NSNumber *total1 = [NSNumber numberWithFloat:scanResults.total.value];
        self.total = total1;
        NSLog(@"total is %@", self.total);
        [self.prices addObject:num];
        //[self.initials addObject:self.placeholder];
        [self.initialsSelected addObject:self.placeholder];
        [self.masterContributions addObject:self.placeholder];
        NSLog(@"initials are is %@", self.initials);
        i += 1;
        int A = [self.prices count];//debugging
        NSLog(@"first count %d", A);
    }


    //RecognitionViewController *controller = [[RecognitionViewController alloc] init];
    //controller.array = self.array0;//the array you want to pass
    //controller.total = self.total;
    ViewController *controller1 = [[ViewController alloc] init];
    controller1.total = self.total;//the array you want to pass
    [self performSegueWithIdentifier:@"view1.5" sender:self];
    //NSLog(@"amount is %f", scanResults.total.value);
    //NSLog(@"amount is %@", scanResults.products[0].productDescription.value);
    //NSLog(@"amount is %@", scanResults.products[1].productDescription.value);
    //NSLog(@"amount is %@", scanResults.products[2].productDescription.value);
    //NSLog(@"amount is %@", scanResults.products[3].productDescription.value);
    //NSLog(@"amount is %@", scanResults.products[4].productDescription.value);
    //NSLog(@"amount is %@", scanResults.products[5].productDescription.value);
    //Use scan results
}
//cancel button during scanning session
- (void)didCancelScanning:(UIViewController *)cameraViewController
{
    [cameraViewController dismissViewControllerAnimated:YES completion:nil];
}
//pass arrays to other view controllers including the 
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"view1.5"]){
        ViewController *controller = [segue destinationViewController];
        if ([self.initialslist count] == 0 && [self.prices count] == 0) {
            self.array0 = [[NSMutableArray alloc] init];//initialize arrays
            self.prices =[[NSMutableArray alloc] init];
            self.initials =[[NSMutableArray alloc] init];
            self.initialsSelected =[[NSMutableArray alloc] init];
            self.masterContributions = [[NSMutableArray alloc] init];
        }
        controller.array = self.array0;
        controller.prices = self.prices;
        controller.total = self.total;
        controller.masterContributions = self.masterContributions;
        subArray = [[NSMutableArray alloc] initWithArray:self.initialslist];
        //if ([subArray count] < [self.prices count])  {
        //    [subArray addObject:(@"%@", _placeholder)];
        //}
        if ([self.initialsSelected count] > 0) {
            controller.initialsSelected = self.initialsSelected;
            controller.initials = subArray;
        }
        controller.pickerMenu = subArray;
        controller.counter = 0;
    }
    if([segue.identifier isEqualToString:@"view2"]){
       RecognitionViewController *controller = [segue destinationViewController];
        if ([subArray count] != [self.prices count])  {
            [subArray addObject:(@"%@", _placeholder)];
            
        }
        if ([masterContributions count] != [self.prices count])  {
            [masterContributions addObject:(@"%@", _placeholder)];
            
        }
        
        controller.fruits = subArray;
    
    }
}

- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row{
    return self.fruits[row];
}



- (UIImage *)czpickerView:(CZPickerView *)pickerView imageForRow:(NSInteger)row {
    if([pickerView isEqual:self.pickerWithImage]) {
        return self.fruitImages[row];
    }
    return nil;
}

- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView {
    return self.fruits.count;
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row {
    NSLog(@"%@ is chosen!", self.fruits[row]);
    [self.navigationController setNavigationBarHidden:NO];
    [self showIntialsPicker2:self];
    
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemsAtRows:(NSMutableArray *)rows {
    for (NSNumber *n in rows) {
        NSInteger row = [n integerValue];
        NSLog(@"%@ is chosen!", self.fruits[row]);
        [self showIntialsPicker2:self];
    }
}

- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView {
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"Canceled.");
}

- (void)czpickerViewWillDisplay:(CZPickerView *)pickerView {
    NSLog(@"Picker will display.");
}

- (void)czpickerViewDidDisplay:(CZPickerView *)pickerView {
    NSLog(@"Picker did display.");
}

- (void)czpickerViewWillDismiss:(CZPickerView *)pickerView {
    NSLog(@"Picker will dismiss.");
}

- (void)czpickerViewDidDismiss:(CZPickerView *)pickerView {
    NSLog(@"Picker did dismiss.");
    
}

- (IBAction)showWithImages:(id)sender {
    self.pickerWithImage = [[CZPickerView alloc] initWithHeaderTitle:@"Fruits" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Confirm"];
    self.pickerWithImage.delegate = self;
    self.pickerWithImage.dataSource = self;
    self.pickerWithImage.needFooterView = YES;
    [self.pickerWithImage show];
}

- (IBAction)showWithFooter:(id)sender {
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Fruits" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Confirm"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    [picker show];
}

- (IBAction)showWithoutFooter:(id)sender {
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Fruits" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Confirm"];
    picker.headerTitleFont = [UIFont systemFontOfSize: 40];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = NO;
    [picker show];
}

- (IBAction)showWithMultipleSelection:(id)sender {
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"SELECT GROUP SIZE" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Confirm"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.allowMultipleSelection = NO;
    self.fruits = @[@"2", @"3", @"4", @"5", @"6"];

    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"CZPicker";
    [picker show];
}
- (IBAction)showInsideContainer:(id)sender {
    
    [self showIntialsPicker2:self];
    
}
    
    
- (IBAction)showInsideContainer1:(id)sender {
    [self.navigationController setNavigationBarHidden:YES];
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"SELECT GROUP SIZE" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Confirm"];
    picker.delegate = self;
    picker.dataSource = self;
    self.fruits = @[@"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"];
    [picker showInContainer:self.view];
}

- (void)showIntialsPicker:(id)sender {
    PopupDialog *popup = [[PopupDialog alloc] initWithTitle: @"Title"
                                                    message: @"This is a message"
                                                      image: nil
                                            buttonAlignment: UILayoutConstraintAxisVertical
                                            transitionStyle: PopupDialogTransitionStyleBounceUp
                                             preferredWidth: 380
                                        tapGestureDismissal: NO
                                        panGestureDismissal: NO
                                              hideStatusBar: NO
                                                 completion: nil];
    
    DestructiveButton *delete = [[DestructiveButton alloc] initWithTitle: @"Delete"
                                                                  height: 45
                                                            dismissOnTap: YES
                                                                  action: nil];
    
    CancelButton *cancel = [[CancelButton alloc] initWithTitle: @"Cancel"
                                                        height: 45
                                                  dismissOnTap: YES
                                                        action: nil];
    
    DefaultButton *ok = [[DefaultButton alloc] initWithTitle: @"OK"
                                                      height: 45
                                                dismissOnTap: YES
                                                      action: nil];
    
    
    [popup addButtons:@[delete, cancel, ok]];
    
    [self presentViewController:popup animated:YES completion:nil];
}
- (void)showIntialsPicker2:(id)sender {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter Initials" message:@"Leave unused cells empty" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //button click event
        self.initialslist = @[alert.textFields[0].text, alert.textFields[1].text, alert.textFields[2].text, alert.textFields[3].text, alert.textFields[4].text, alert.textFields[5].text, alert.textFields[6].text, alert.textFields[7].text, alert.textFields[8].text, alert.textFields[9].text];
        subArray =[[NSMutableArray alloc] initWithArray:self.initialslist];
        NSLog(@"debug %@", subArray);
        self.initialslist = subArray;
        [self.initialslist removeObject:@""];
        //NSLog(@"debug %@", self.initialslist[1]);
        [self btnTouched:self];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textfield1)   {
        textfield1.placeholder = @"Initials 1";
        textfield1.keyboardAppearance = UIKeyboardAppearanceAlert;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textfield2)   {
        textfield2.placeholder = @"Initials 2";
        textfield2.keyboardAppearance = UIKeyboardAppearanceAlert;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textfield3)   {
        textfield3.placeholder = @"Initials 3";
        textfield3.keyboardAppearance = UIKeyboardAppearanceAlert;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textfield4)   {
        textfield4.placeholder = @"Initials 4";
        textfield4.keyboardAppearance = UIKeyboardAppearanceAlert;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textfield5)   {
        textfield5.placeholder = @"Initials 5";
        textfield5.keyboardAppearance = UIKeyboardAppearanceAlert;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textfield6)   {
        textfield6.placeholder = @"Initials 6";
        textfield6.keyboardAppearance = UIKeyboardAppearanceAlert;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textfield7)   {
        textfield7.placeholder = @"Initials 7";
        textfield7.keyboardAppearance = UIKeyboardAppearanceAlert;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textfield8)   {
        textfield8.placeholder = @"Initials 8";
        textfield8.keyboardAppearance = UIKeyboardAppearanceAlert;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textfield9)   {
        textfield9.placeholder = @"Initials 9";
        textfield9.keyboardAppearance = UIKeyboardAppearanceAlert;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textfield10)   {
        textfield10.placeholder = @"Initials 10";
        textfield10.keyboardAppearance = UIKeyboardAppearanceAlert;
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];

    //NSLog(@"%@", self.initialslist[]);
}
@end

