#import <UIKit/UIKit.h>
#import "Client.h"
#import <CZPicker.h>
#import "MyCustomCell.h"
//@interface RecognitionViewController : UIViewController<ClientDelegate>
//initialize xml parser delegate for RecognitionViewController

@interface RecognitionViewController : UITableViewController<NSXMLParserDelegate, CZPickerViewDataSource, CZPickerViewDelegate, CellDelegate>
{
    NSMutableArray *array;
    NSMutableArray *prices;
}
@property(nonatomic, retain)NSMutableArray *initialsSelected;
@property(nonatomic, retain)NSMutableArray *fruits;
@property(nonatomic, retain)NSNumber *total;
@property(nonatomic, retain)NSMutableArray *array;
@property(nonatomic, retain)NSMutableArray *masterConstraints;
@property(nonatomic, retain)NSMutableArray *pickerMenu;
@property(nonatomic, retain)NSMutableArray *initials;
@property(nonatomic, retain)NSMutableArray *prices;
@property (nonatomic, strong) NSMutableDictionary *dictData;
@property (nonatomic,strong) NSMutableArray *marrXMLData;
@property (nonatomic,strong) NSMutableArray *iarrXMLData;
@property (nonatomic,strong) NSMutableString *mstrXMLString;
@property (nonatomic,strong) NSMutableString *istrXMLString;
@property (nonatomic,strong) NSMutableDictionary *mdictXMLPart;
@property (nonatomic,strong) NSMutableDictionary *idictXMLPart;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemname;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *statusIndicator;
@property (nonatomic, weak) IBOutlet UILabel *detectedLabel;
@property (nonatomic,strong) NSMutableArray *masterContributions;
@end






