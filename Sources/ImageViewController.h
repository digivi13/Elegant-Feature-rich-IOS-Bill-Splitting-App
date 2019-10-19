#import <UIKit/UIKit.h>
#import <CZPicker.h>
#import <BlinkReceipt/BlinkReceipt.h>
#import "ConfirmPayment.h"
#import "PopupDialog-Swift.h"

@interface ImageViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate, CZPickerViewDataSource, CZPickerViewDelegate,BRScanResultsDelegate,UITextFieldDelegate>
{
    NSMutableArray *array0;
    NSMutableArray *prices;
}
@property (nonatomic,retain) NSMutableArray *initialsSelected;
@property (nonatomic,retain) NSMutableArray *initialslist;
@property (nonatomic,retain) NSMutableArray *subArray;
@property (nonatomic,retain) NSMutableArray *masterContributions;
@property (nonatomic,retain) NSMutableArray *pickerMenu;
@property (nonatomic,retain) NSMutableArray *initials;
@property (nonatomic,retain) NSMutableArray *prices;
@property (nonatomic,retain) NSMutableArray *array0;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) UIStoryboardSegue *view1;
- (IBAction)takePhoto:(id)sender;
- (IBAction)showWithImages:(id)sender;

- (IBAction)showWithMultipleSelection:(id)sender;
- (IBAction)btnTouched:(id)sender;
- (IBAction)backTo:(id)sender;
- (void)setTorch:(BOOL)torchOn;
@end
