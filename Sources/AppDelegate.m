#import "AppDelegate.h"
#import "Venmo.h"
#import <BlinkReceipt/BlinkReceipt.h>
#import <Stripe/Stripe.h>
@implementation AppDelegate

@synthesize window = _window;

@synthesize imageToProcess;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	imageToProcess = [UIImage imageNamed:@"sample.jpg"];
	[Venmo startWithAppId:@"1713" secret:@"fvY3AJTbvk7emZa3UGnMM7jAGqKyL2vR" name:@"Venmo iOS SDK Sample"];
    [BRScanManager sharedManager].licenseKey=@"2D35QY62-GAB66I5B-FDTKF634-R76EACT6-7Z3BT2YE-RKG6WBEK-RXVQIKQ4-U4B4DUVW";
    [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:@"pk_test_xob2UDyPfPGvuSjSxiM729wU00F3RiI0Oe"];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[Venmo sharedInstance] handleOpenURL:url]) {
        return YES;
    }
    return NO;
}

@end
