#import "RecognitionViewController.h"
#import "AppDelegate.h"
#import "CardIO.h"
#import "MyCustomCell.h"
#import "PopupView.h"
#import "ViewController.h"
//#error Provide Application ID and Password
// To create an application and obtain a password,
// register at https://cloud.ocrsdk.com/Account/Register
// More info on getting your application id and password at
// https://ocrsdk.com/documentation/faq/#faq3

// Url of processing service. Change to https://cloud-westus.ocrsdk.com
// if your application was created in US location
static NSString* ProcessingServiceUrl = @"https://cloud-westus.ocrsdk.com";
// Name of application you created
static NSString* MyApplicationID = @"RestaurantAI";
// Password should be sent to your e-mail after application was created
static NSString* MyPassword = @"xCxYIHyy4IrLPLu14PysG+cz";

@interface RecognitionViewController ()
//add fab button property
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property NSString *placeholder;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property NSInteger cellindex;
@property NSString *name;
@property NSString *initialforcell;

@property NSMutableArray *fruitImages;
@property CZPickerView *pickerWithImage;
@end

@implementation RecognitionViewController
@synthesize initialsSelected;
@synthesize fruits;
@synthesize pickerMenu;
@synthesize initials;
@synthesize total;
@synthesize array;
@synthesize prices;
@synthesize textView;
@synthesize statusLabel;
@synthesize statusIndicator;
@synthesize detectedLabel;
//Parser
@synthesize marrXMLData;
@synthesize iarrXMLData;
@synthesize mstrXMLString;
@synthesize istrXMLString;
@synthesize mdictXMLPart;
@synthesize idictXMLPart;
@synthesize nameLabel = _nameLabel;
@synthesize masterContributions;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
   
}


- (void)viewWillAppear:(BOOL)animated
{
	textView.hidden = YES;
	statusLabel.hidden = NO;
    //self.fruits = self.initials;
	statusIndicator. hidden = NO;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSString *totalString = [NSString stringWithFormat:@"Receipt Total: $ %.02f", self.total.floatValue];
    statusLabel.text = (@"$ %@", totalString);
    [self detectedTotal:self];

    NSLog(@"$ %@", totalString);
    NSLog(@"array of interest 1 %@", self.masterContributions);
	//UIImage* image = [(AppDelegate*)[[UIApplication sharedApplication] delegate] imageToProcess];
	
	//Client *client = [[Client alloc] initWithApplicationID:MyApplicationID password:MyPassword serviceUrl:ProcessingServiceUrl];
	//[client setDelegate:self];
	
	//ProcessingParams* params = [[ProcessingParams alloc] init];
	
	//[client processImage:image withParams:params];
	
	//statusLabel.text = @"Uploading image...";
	
    [super viewDidAppear:animated];
}


#pragma mark - ClientDelegate implementation



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int arraySize = [self.array count];
    NSLog(@"array is of size %d", arraySize);
    return [self.array count];
}
//logic for swipe to delete
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"%@", masterContributions);
        [self.array removeObjectAtIndex:indexPath.row];
        [self.prices removeObjectAtIndex:indexPath.row];
        [self.initialsSelected removeObjectAtIndex:indexPath.row];
        [self.masterContributions removeObjectAtIndex:indexPath.row];
        [self detectedTotal:self];
        NSLog(@"%@", masterContributions);
        [tableView reloadData];
        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCustomCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"MyCustomCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.checkmark.hidden = TRUE;
    return cell;
}
- (void)detectedTotal:(id)sender {
    float sum = 0;
    for (NSNumber * n in self.prices) {
        sum += [n floatValue];
        
    }
    NSString *sum1 = [NSString stringWithFormat:@"Detected Items: $ %.02f", sum];
    self.detectedLabel.text = sum1;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(MyCustomCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.name = [self.array objectAtIndex:indexPath.row];

    if ([self.initialsSelected count] < [self.prices count])  {
        
        [self.initialsSelected addObject:(@" ")];
        [self.masterContributions addObject:@" "];
    }
    //self.initialforcell = [self.initials objectAtIndex:indexPath.row];
    //self.assignments = [@"", ]
    //convert float value to string object that can be used in cell label
    NSString *myString = [NSString stringWithFormat:@"%@", [self.prices objectAtIndex:indexPath.row]];
    float b = myString.floatValue;
    cell.rightLabel.text = [NSString stringWithFormat:@"$ %.02f", b];
    NSString *middleString = [NSString stringWithFormat:@"%@", [self.masterContributions objectAtIndex:indexPath.row]];
    cell.leftLabel.text = (@"%@", self.name);
    cell.middleLabel.text = (@"%s", self.initialsSelected[indexPath.row]);
    int a = self.cellindex;
    NSLog(@"string is %@", middleString);
    cell.checkmark.hidden = TRUE;
    if (![middleString isEqualToString:@" "]) {
        cell.checkmark.hidden = FALSE;
        //cell.middleLabel.text = @"Done";
    } else (cell.middleLabel.text = @" ");
    //NSLog(@"initial selected is %@", self.initials[indexPath.row]);
    cell.delegate = self;
    cell.cellIndex = indexPath.row;
}

- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withData:(id)data
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:cellIndex inSection:0];
    // Do additional actions as required.
    NSLog(@"Cell at Index: %d clicked.\n Data received : %@", cellIndex, data);
    self.cellindex = cellIndex;
    [self performSegueWithIdentifier:@"popup" sender:self];
    //[self showInsideContainer:self];
    NSLog(@"%ld", (long)cellIndex);
    //self.initials[3] = (@"%@", data);
    //[self.initialsSelected replaceObjectAtIndex:cellIndex withObject:self.pickerMenu[cellIndex]];
    int initcount = [self.initials count];
    
    NSLog(@"lengthof array %d", initcount);
    self.cellindex = cellIndex;
    //[self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSMutableArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView reloadData];
   // [self.tableView endUpdates];
    
    //UITableViewCell *cell=(UITableViewCell *)[UITableView cellForRowAtIndexPath:indexPath.row];
    //cell.(whatever your label property).textColor=[UIColor greenColor];
    
    
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    cell.textLabel.text = [[[marrXMLData objectAtIndex:indexPath.row] valueForKey:@"name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    cell.detailTextLabel.text = [[[marrXMLData objectAtIndex:indexPath.row] valueForKey:@"text"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
//    return cell;
//}


-(IBAction)showInsideContainer:(id)sender {
    
    [self.navigationController setNavigationBarHidden:NO];
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"ASSIGN ITEM" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Confirm"];
    picker.delegate = self;
    picker.dataSource = self;
    [self.pickerMenu removeObjectIdenticalTo:@"_"];
    self.fruits = self.pickerMenu;
    [picker showInContainer:self.view];
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
    int B = row;
    [self.initialsSelected replaceObjectAtIndex:_cellindex withObject:(@"%@", self.fruits[row])];
    NSLog(@"initial selected 1 is %@", initialsSelected[_cellindex]);
    NSIndexPath *path1 = [NSIndexPath indexPathForRow:_cellindex inSection:0];
    int initcount = [self.initials count];
    NSLog(@"New initials of array %d", initcount);
    //[self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSMutableArray arrayWithObject:path1] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];

}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemsAtRows:(NSMutableArray *)rows {
    for (NSNumber *n in rows) {
        NSInteger row = [n integerValue];
        //UITableViewCell *cell = self.fruits[row];
        NSLog(@"%@ is chosen!", self.fruits[row]);
        int B = row;
        [self.initialsSelected replaceObjectAtIndex:_cellindex withObject:(@"%@", self.fruits[row])];
        NSIndexPath *path1 = [NSIndexPath indexPathForRow:B inSection:0];
        int initcount = [self.initials count];
        NSLog(@"New initials of array %d", initcount);
       // [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:[NSMutableArray arrayWithObject:path1] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadData];
        //[self.tableView endUpdates];
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

- (IBAction)addItem:(id)sender {
    [self showNewItemEntry:self];
}
- (IBAction)addPerson:(id)sender {
    [self showaddPersonEntry:self];
}

- (void)showNewItemEntry:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter New Item" message:@"Item name is optional" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //button click event
        [self.array addObject:alert.textFields[0].text];
        [self.prices addObject:alert.textFields[1].text];
        [self.tableView reloadData];
        [self detectedTotal:self];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textfield1)   {
        textfield1.placeholder = @"Item Name";
        textfield1.keyboardAppearance = UIKeyboardAppearanceAlert;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textfield2)   {
        textfield2.placeholder = @"Item Price";
        [textfield2 setKeyboardType:UIKeyboardTypeDecimalPad];
        textfield2.keyboardAppearance = UIKeyboardAppearanceAlert;
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    //[self.initials addObject:@"_"];
    [self presentViewController:alert animated:YES completion:nil];
    [self.initialsSelected addObject:@" "];
    NSLog(@"newitem before %@", self.masterContributions);
    [self.masterContributions addObject:@" "];
    NSLog(@"newitem after %@", self.masterContributions);
    [self.initials removeObjectIdenticalTo:@"_"];
    
}
- (void)showaddPersonEntry:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter New Person" message:@"Name is required" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //button click event
        [self.initials addObject:alert.textFields[0].text];
        [self.tableView reloadData];
        [self detectedTotal:self];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textfield1)   {
        textfield1.placeholder = @"Person Name";
        textfield1.keyboardAppearance = UIKeyboardAppearanceAlert;
    }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    //[self.initials addObject:@"_"];
    [self presentViewController:alert animated:YES completion:nil];
    //[self.initialsSelected addObject:@" "];
    [self.masterContributions addObject:@" "];
    [self.initials removeObjectIdenticalTo:@"_"];
    for (id item in masterContributions)
    {
        if ([item isKindOfClass:[NSMutableArray class]])
        {
            [item addObject:@"0.0"];
        }
        
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"popup"]){
        PopupViewController *controller = [segue destinationViewController];
        controller.array = self.array;
        controller.prices = self.prices;
        controller.total = self.total;
        controller.initials = self.initials;
        controller.pickerMenu = self.pickerMenu;
        controller.initialsSelected = self.initialsSelected;
        controller.cellindex = self.cellindex;
    }
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"view2"]) {
        ViewController *controller = [segue destinationViewController];
        controller.masterContributions = self.masterContributions;
        controller.initialsSelected = self.initials;
        // do something with the AlertView's subviews here...
    }
}
-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    //self.masterContributions = masterContributions;
    [self.tableView reloadData];
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (IBAction)mybtn:(id)sender {
}
@end





