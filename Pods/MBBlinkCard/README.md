<p align="center" >
  <img src="https://raw.githubusercontent.com/wiki/blinkid/blinkid-ios/Images/logo-microblink.png" alt="MicroBlink" title="MicroBlink">
</p>

[![Build Status](https://travis-ci.org/blinkcard/blinkcard-ios.svg?branch=master)](https://travis-ci.org/blinkcard/blinkcard-ios)
[![Pod Version](http://img.shields.io/cocoapods/v/MBBlinkCard.svg?style=flat)](http://cocoadocs.org/docsets/MBBlinkCard/)

# BlinkCard SDK for payment card scanning

BlinkCard SDK is a delightful component for quick and easy scanning of payment cards. The SDK is powered with [Microblink's](http://www.microblink.com) industry-proven and world leading OCR, and offers:

- integrated camera management
- layered API, allowing everything from simple integration to complex UX customizations.
- lightweight and no internet connection required
- enteprise-level security standards

BlinkCard is a part of family of SDKs developed by [Microblink](http://www.microblink.com) for optical text recognition, barcode scanning, ID document, payment card scanning and many others. 
# Table of contents

- [Requirements](#requirements)
- [Quick Start](#quick-start)
- [Advanced BlinkCard integration instructions](#advanced-integration)
	- [Built-in overlay view controllers and overlay subviews](#ui-customizations)
		- [Using `MBBlinkCardOverlayViewController`](#using-blinkcard-overlay-viewcontroller)
		- [Custom overlay view controller](#using-custom-overlay-viewcontroller)
	- [Direct processing API](#direct-api-processing)
		- [Using Direct API for `NSString` recognition (parsing)](#direct-api-string-processing)
- [`MBRecognizer` and available recognizers](#recognizer)
- [List of available recognizers](#available-recognizers)
	- [Frame Grabber Recognizer](#frame-grabber-recognizer)
	- [Success Frame Grabber Recognizer](#success-frame-grabber-recognizer)
	- [BlinkCard recognizers ](#blinkcard-recognizers)
		- [Payment / Debit card combined recognizer](#payment-card-recognizers)
		- [Elite Payment / Debit card combined recognizer](#elite-payment-card-recognizers)
- [Troubleshooting](#troubleshooting)
	- [Integration problems](#troubleshooting-integration-problems)
	- [SDK problems](#troubleshooting-sdk-problems)
		- [Licencing problems](#troubleshooting-licensing-problems)
		- [Other problems](#troubleshooting-other-problems)
	- [Frequently asked questions and known problems](#troubleshooting-faq)
- [Additional info](#info)


# <a name="requirements"></a> Requirements

SDK package contains Microblink framework and one or more sample apps which demonstrate framework integration. The framework can be deployed in iOS 8.0 or later, iPhone 4S or newer and iPad 2 or newer.

SDK performs significantly better when the images obtained from the camera are focused. Because of that, the SDK can have lower performance on iPad 2 and iPod Touch 4th gen devices, which [don't have camera with autofocus](http://www.adweek.com/socialtimes/ipad-2-rear-camera-has-tap-for-auto-exposure-not-auto-focus/12536). 
 
# <a name="quick-start"></a> Quick Start

## Getting started with BlinkCard SDK

This Quick Start guide will get you up and performing OCR scanning as quickly as possible. All steps described in this guide are required for the integration.

This guide sets up basic Raw OCR parsing and price parsing at the same time. It closely follows the BlinkOCR-sample app. We highly recommend you try to run the sample app. The sample app should compile and run on your device, and in the iOS Simulator. 

The source code of the sample app can be used as the reference during the integration.

### 1. Initial integration steps

#### Using CocoaPods

- If you wish to use version v1.2.0 or above, you need to install [Git Large File Storage](https://git-lfs.github.com) by running these comamnds:
```shell
brew install git-lfs
git lfs install
```

- **Be sure to restart your console after installing Git LFS**
- **Note:** if you already did try adding SDK using cocoapods and it's not working, first install the git-lfs and then clear you cocoapods cache. This should be sufficient to force cocoapods to clone BlinkCard SDK, if it still doesn't work, try deinitializing your pods and installing them again.
- Project dependencies to be managed by CocoaPods are specified in a file called `Podfile`. Create this file in the same directory as your Xcode project (`.xcodeproj`) file.

- If you don't have podfile initialized run the following in your project directory.
```
pod init
```

- Copy and paste the following lines into the TextEdit window:  

```ruby
platform :ios, '9.0'
target 'Your-App-Name' do
    pod 'MBBlinkCard', '~> 1.0.1'
end
```

- Install the dependencies in your project:

```shell 
$ pod install
``` 

- From now on, be sure to always open the generated Xcode workspace (`.xcworkspace`) instead of the project file when building your project:

```shell 
open <YourProjectName>.xcworkspace
```
   
#### Integration without CocoaPods


-[Download](https://github.com/BlinkCard/blinkcard-ios/releases) latest release (Download .zip or .tar.gz file starting with BlinkID. DO NOT download Source Code as GitHub does not fully support Git LFS)

OR

Clone this git repository:

- If you wish to clone version v1.4.0 or above, you need to install [Git Large File Storage](https://git-lfs.github.com) by running these comamnds:
```shell
brew install git-lfs
git lfs install
```

- **Be sure to restart your console after installing Git LFS**

- To clone, run the following shell command:

```shell
git clone git@github.com:BlinkCard/blinkcard-ios.git
```

- Copy Microblink.framework and Microblink.bundle to your project folder.

- In your Xcode project, open the Project navigator. Drag the Microblink.framework and Microblink.bundle files to your project, ideally in the Frameworks group, together with other frameworks you're using. When asked, choose "Create groups", instead of the "Create folder references" option.

![Adding Microblink.embedded framework to your project](https://raw.githubusercontent.com/wiki/blinkocr/blinkocr-ios/Images/01%20-%20Add%20Framework.jpg)

- Since Microblink.framework is a dynamic framework, you also need to add it to embedded binaries section in General settings of your target.

![Adding Microblink.framework to embedded binaries](https://raw.githubusercontent.com/wiki/blinkocr/blinkocr-ios/Images/03%20-%20Embed%20Binaries.png)

- Include the additional frameworks and libraries into your project in the "Linked frameworks and libraries" section of your target settings. 

    - AudioToolbox.framework
    - AVFoundation.framework
    - CoreMedia.framework
    - libc++.tbd
    - libiconv.tbd
    - libz.tbd
    
![Adding Apple frameworks to your project](https://raw.githubusercontent.com/wiki/blinkocr/blinkocr-ios/Images/02%20-%20Add%20Libraries.jpg)
    
### 2. Referencing header file
    
In files in which you want to use scanning functionality place import directive.

Swift

```swift
import MicroBlink
```

Objective-C

```objective-c
#import <MicroBlink/MicroBlink.h>
```
    
### 3. Initiating the scanning process
    
To initiate the scanning process, first decide where in your app you want to add scanning functionality. Usually, users of the scanning library have a button which, when tapped, starts the scanning process. Initialization code is then placed in touch handler for that button. Here we're listing the initialization code as it looks in a touch handler method.

Also, for initialization purposes, the ViewController which initiates the scan have private properties for [`MBRawParser`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRawParser.html), [`MBParserGroupProcessor`](http://blinkcard.github.io/blinkcard-ios//Classes/MBParserGroupProcessor.html) and [`MBBlinkInputRecognizer`](http://blinkcard.github.io/blinkcard-ios//Classes/MBBlinkInputRecognizer.html), so we know how to obtain result.

Swift

```swift
class ViewController: UIViewController, MBDocumentOverlayViewControllerDelegate  {
    
    var rawParser: MBRawParser?
    var parserGroupProcessor: MBParserGroupProcessor?
    var blinkInputRecognizer: MBBlinkInputRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapScan(_ sender: AnyObject) {
        
        let settings = MBDocumentOverlaySettings()
        rawParser = MBRawParser()
        parserGroupProcessor = MBParserGroupProcessor(parsers: [rawParser!])
        blinkInputRecognizer = MBBlinkInputRecognizer(processors: [parserGroupProcessor!])
        
        let recognizerList = [self.blinkInputRecognizer!]
        let recognizerCollection = MBRecognizerCollection(recognizers: recognizerList)
        
        /** Create your overlay view controller */
        let documentOverlayViewController = MBDocumentOverlayViewController(settings: settings, recognizerCollection: recognizerCollection, delegate: self)
        
        /** Create recognizer view controller with wanted overlay view controller */
        let recognizerRunnerViewController: UIViewController = MBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: documentOverlayViewController)
        
        /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
        present(recognizerRunnerViewController!, animated: true, completion: nil)
    }
}
```

Objective-C

```objective-c
@interface ViewController () <MBDocumentOverlayViewControllerDelegate>

@property (nonatomic, strong) MBRawParser *rawParser;
@property (nonatomic, strong) MBParserGroupProcessor *parserGroupProcessor;
@property (nonatomic, strong) MBBlinkInputRecognizer *blinkInputRecognizer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)didTapScan:(id)sender {
    
    MBDocumentOverlaySettings* settings = [[MBDocumentOverlaySettings alloc] init];

    self.rawParser = [[MBRawParser alloc] init];
    self.parserGroupProcessor = [[MBParserGroupProcessor alloc] initWithParsers:@[self.rawParser]];
    self.blinkInputRecognizer = [[MBBlinkInputRecognizer alloc] initWithProcessors:@[self.parserGroupProcessor]];

    /** Create recognizer collection */
    MBRecognizerCollection *recognizerCollection = [[MBRecognizerCollection alloc] initWithRecognizers:@[self.blinkInputRecognizer]];
    
    MBDocumentOverlayViewController *overlayVC = [[MBDocumentOverlayViewController alloc] initWithSettings:settings recognizerCollection:recognizerCollection delegate:self];
    UIViewController<MBRecognizerRunnerViewController>* recognizerRunnerViewController = [MBViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:overlayVC];
    
    /** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
    [self presentViewController:recognizerRunnerViewController animated:YES completion:nil];

}

@end
```
    
### 4. License key

A valid license key is required to initalize scanning. You can generate a free demo license key, after you register, at [Microblink developer dashboard](https://microblink.com/login).

You can include the license key in your app by passing a string or a file with license key. 
**Note** that you need to set the license key before intializing scanning. Ideally in `AppDelegate` or `viewDidLoad` before initializing any recognizers.

#### License key as string
You can pass the license key as a string, the following way:

Swift

```swift
MBMicroblinkSDK.sharedInstance().setLicenseKey("LICENSE-KEY")
```

Objective-C

```objective-c
[[MBMicroblinkSDK sharedInstance] setLicenseKey:@"LICENSE-KEY"];
```

#### License key as file
Or you can include the license key, with the code below. Please make sure that the file that contains the license key is included in your project and is copied during **Copy Bundle Resources** build phase.

Swift

```swift
MBMicroblinkSDK.sharedInstance().setLicenseResource("license-key-file", withExtension: "txt", inSubdirectory: "directory-to-license-key", for: Bundle.main)
```

Objective-C

```objective-c
[[MBMicroblinkSDK sharedInstance] setLicenseResource:@"license-key-file" withExtension:@"txt" inSubdirectory:@"" forBundle:[NSBundle mainBundle]];
```

### 5. Registering for scanning events
    
In the previous step, you instantiated [`MBDocumentOverlayViewController`](http://blinkcard.github.io/blinkcard-ios//Classes/MBDocumentOverlayViewController.html) object with a delegate object. This object gets notified on certain events in scanning lifecycle. In this example we set it to `self`. The protocol which the delegate has to implement is [`MBDocumentOverlayViewControllerDelegate`](http://blinkcard.github.io/blinkcard-ios//Protocols/MBDocumentOverlayViewControllerDelegate.html) protocol. It is necessary to conform to that protocol. We will discuss more about protocols in [Advanced integration section](#advanced-integration). You can use the following default implementation of the protocol to get you started.

Swift

```swift
func documentOverlayViewControllerDidFinishScanning(_ documentOverlayViewController: MBDocumentOverlayViewController, state: MBRecognizerResultState) {

    // this is done on background thread
    // check for valid state
    if state == .valid {

        // first, pause scanning until we process all the results
        documentOverlayViewController.recognizerRunnerViewController?.pauseScanning()

        DispatchQueue.main.async(execute: {() -> Void in
            // All UI interaction needs to be done on main thread
        })
    }
}

func documentOverlayViewControllerDidTapClose(_ documentOverlayViewController: MBDocumentOverlayViewController) {
    // Your action on cancel 
}
```
    
Objective-C

```objective-c  
- (void)documentOverlayViewControllerDidFinishScanning:(MBDocumentOverlayViewController *)documentOverlayViewController state:(MBRecognizerResultState)state {
    
    // this is done on background thread
    // check for valid state
    if (state == MBRecognizerResultStateValid) {
        
        // first, pause scanning until we process all the results
        [documentOverlayViewController.recognizerRunnerViewController pauseScanning];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // All UI interaction needs to be done on main thread
        });
    }
}

- (void)documentOverlayViewControllerDidTapClose:(MBDocumentOverlayViewController *)documentOverlayViewController {
    // Your action on cancel 
}
```

# <a name="advanced-integration"></a> Advanced BlinkCard integration instructions
This section covers more advanced details of BlinkInput integration.

1. [First part](#ui-customizations) will cover the possible customizations when using UI provided by the SDK.
2. [Second part](#custom-overyal-view-controller) will describe how to embed [`MBRecognizerRunnerViewController's delegates`](http://blinkcard.github.io/blinkcard-ios/Protocols.html) into your `UIViewController` with the goal of creating a custom UI for scanning, while still using camera management capabilites of the SDK.
3. [Third part](#direct-processing-api) will describe how to use the [`MBRecognizerRunner`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizerRunner.html) (Direct API) for recognition directly from `UIImage` without the need of camera or to recognize camera frames that are obtained by custom camera management.
4. [Fourth part](#recognizer) will describe recognizer concept and available recognizers.


## <a name="ui-customizations"></a> Built-in overlay view controllers and overlay subviews

Within BlinkCard SDK there are several built-in overlay view controllers and scanning subview overlays that you can use to perform scanning. 
### <a name="using-blinkcard-overlay-viewcontroller"></a> Using `MBBlinkCardOverlayViewController`

[`MBBlinkCardOverlayViewController`](http://blinkcard.github.io/blinkcard-ios/Classes/MBBlinkCardOverlayViewController.html) is overlay view controller best suited for performing scanning of payment cards for both front and back side. It has [`MBBlinkCardOverlayViewControllerDelegate`](http://blinkcard.github.io/blinkcard-ios/Protocols/MBBlinkCardOverlayViewControllerDelegate.html) delegate which can be used out-of-the-box to perform scanning using the default UI. Here is an example how to use and initialize [`MBBlinkCardOverlayViewController`](http://blinkcard.github.io/blinkcard-ios/Classes/MBBlinkCardOverlayViewController.html):

Swift

```swift
/** Create your overlay view controller */
let blinkCardViewController : MBBlinkCardOverlayViewController = MBBlinkCardOverlayViewController(settings: blinkCardSettings, recognizerCollection: recognizerCollection, delegate: self)

/** Create recognizer view controller with wanted overlay view controller */
let recognizerRunneViewController : UIViewController = MBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: blinkCardViewController)

/** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
self.present(recognizerRunneViewController, animated: true, completion: nil)
```

Objective-C

```objective-c
MBDocumentVerificationOverlayViewController *overlayVC = [[MBBlinkCardOverlayViewController alloc] initWithSettings:settings recognizerCollection: recognizerCollection delegate:self];
UIViewController<MBRecognizerRunnerViewController>* recognizerRunnerViewController = [MBViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:overlayVC];

/** Present the recognizer runner view controller. You can use other presentation methods as well (instead of presentViewController) */
[self presentViewController:recognizerRunnerViewController animated:YES completion:nil];
```

As you can see, when initializing [`MBDocumentVerificationOverlayViewController`](http://blinkcard.github.io/blinkcard-ios/Classes/MBDocumentVerificationOverlayViewController.html), we are sending delegate property as `self`. To get results, we need to conform to [`MBDocumentVerificationOverlayViewControllerDelegate`](http://blinkcard.github.io/blinkcard-ios/Protocols/MBDocumentVerificationOverlayViewControllerDelegate.html) protocol.
### <a name="using-custom-overlay-viewcontroller"></a> Custom overlay view controller

Please check our pdf417-sample-Swift for custom implementation of overlay view controller.

Overlay View Controller is an abstract class for all overlay views.

It's responsibility is to provide meaningful and useful interface for the user to interact with.
 
Typical actions which need to be allowed to the user are:

- intuitive and meaniningful way to guide the user through scanning process. This is usually done by presenting a "viewfinder" in which the user need to place the scanned object
- a way to cancel the scanning, typically with a "cancel" or "back" button
- a way to power on and off the light (i.e. "torch") button
 
BlinkID SDK always provides it's own default implementation of the Overlay View Controller for every specific use. Your implementation should closely mimic the default implementation as it's the result of thorough testing with end users. Also, it closely matches the underlying scanning technology. 

For example, the scanning technology usually gives results very fast after the user places the device's camera in the expected way above the scanned object. This means a progress bar for the scan is not particularly useful to the user. The majority of time the user spends on positioning the device's camera correctly. That's just an example which demonstrates careful decision making behind default camera overlay view.

### 1. Initialization
 
To use your custom overlay with Microblink's camera view, you must first subclass [`MBCustomOverlayViewController`](http://blinkcard.github.io/blinkcard-ios/Classes/MBCustomOverlayViewController.html) and implement the overlay behaviour conforming wanted protocols.

### 2. Protocols

There are five [`MBRecognizerRunnerViewController`](http://blinkcard.github.io/blinkcard-ios/Protocols/MBRecognizerRunnerViewController.html) protocols and one overlay protocol [`MBOverlayViewControllerInterface`](http://blinkcard.github.io/blinkcard-ios/Protocols/MBOverlayViewControllerInterface.html).

Five `RecognizerRunnerView` protocols are:
- [`MBScanningRecognizerRunnerViewControllerDelegate`](http://blinkcard.github.io/blinkcard-ios/Protocols/MBScanningRecognizerRunnerViewControllerDelegate.html)
- [`MBDetectionRecognizerRunnerViewControllerDelegate`](http://blinkcard.github.io/blinkcard-ios/Protocols/MBDetectionRecognizerRunnerViewControllerDelegate.html)
- [`MBOcrRecognizerRunnerViewControllerDelegate`](http://blinkcard.github.io/blinkcard-ios/Protocols/MBOcrRecognizerRunnerViewControllerDelegate.html)
- [`MBDebugRecognizerRunnerViewControllerDelegate`](http://blinkcard.github.io/blinkcard-ios/Protocols/MBDebugRecognizerRunnerViewControllerDelegate.html)
- [`MBRecognizerRunnerViewControllerDelegate`](http://blinkcard.github.io/blinkcard-ios/Protocols/MBRecognizerRunnerViewControllerDelegate.html)

In `viewDidLoad`, other protocol conformation can be done and it's done on `recognizerRunnerViewController` property of [`MBOverlayViewController`](http://blinkcard.github.io/blinkcard-ios/Classes/MBOverlayViewController.html), for example:

Swift and Objective-C
```swift
self.scanningRecognizerRunnerViewControllerDelegate = self;
```

### 3. Overlay subviews
The SDK contains various subviews you can use to notify users of the state of scanning. If you want to use built-in implementation we recommend to use [`MBModernViewfinderSubview`](http://blinkcard.github.io/blinkcard-ios/Classes/MBModernViewfinderSubview.html). In can be initialized in `viewDidLoad` method:

Swift
```swift
viewfinderSubview = MBModernViewfinderSubview()
viewfinderSubview.frame = view.frame
viewfinderSubview.moveable = true
view.addSubview(viewfinderSubview)
```

Objective-C
```objective-c
self.viewfinderSubview = [[MBModernViewfinderSubview alloc] init];
self.viewfinderSubview.frame = self.view.frame;
self.viewfinderSubview.delegate = self.overlaySubviewsDelegate;
self.viewfinderSubview.moveable = YES;
[self.view addSubview:self.viewfinderSubview];
```

To use this subview you'll need to implement `MBDetectionRecognizerRunnerViewControllerDelegate`(http://blinkcard.github.io/blinkcard-ios/Protocols/MBDetectionRecognizerRunnerViewControllerDelegate.html) then in the `-recognizerRunnerViewController:didFinishDetectionWithDisplayableQuad:` notify subview of detection changes.

Swift
```swift
func recognizerRunnerViewController(_ recognizerRunnerViewController: Any!, didFinishDetectionWithDisplayableQuad displayableQuad: MBDisplayableQuadDetection) {
    viewfinderSubview.detectionFinished(withDisplayableQuad: displayableQuad)
}
```
Objective-C
```objective-c
- (void)recognizerRunnerViewController: (nonnull UIViewController<MBRecognizerRunnerViewController> *) recognizerRunnerViewController didFinishDetectionWithDisplayableQuad: (nonnull MBDisplayableQuadDetection *)displayableQuad {
    [self.viewfinderSubview detectionFinishedWithDisplayableQuad:displayableQuad];
}
```

### 4. Initialization
In [Quick Start](#quick-start) guide it is shown how to use a default overlay view controller. You can now swap default view controller with your implementation of `CustomOverlayViewController`

Swift
```swift
let recognizerRunnerViewController : UIViewController = MBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: CustomOverlayViewController)
```

Objective-C
```objective-c
UIViewController<MBRecognizerRunnerViewController>* recognizerRunnerViewController = [MBViewControllerFactory recognizerRunnerViewControllerWithOverlayViewController:CustomOverlayViewController];
```


## <a name="direct-api-processing"></a> Direct processing API

This guide will in short present you how to process UIImage objects with BlinkCard SDK, without starting the camera video capture.

With this feature you can solve various use cases like:
	- recognizing text on images in Camera roll
	- taking full resolution photo and sending it to processing
	- scanning barcodes on images in e-mail etc.

DirectAPI-sample demo app here will present UIImagePickerController for taking full resolution photos, and then process it with Microblink SDK to get scanning results using Direct processing API.

Direct processing API is handled with [`MBRecognizerRunner`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizerRunner.html). That is a class that handles processing of images. It also has protocols as [`MBRecognizerRunnerViewController`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizerRunnerViewController.html).
Developer can choose which protocol to conform:

- [`MBScanningRecognizerRunnerDelegate`](http://blinkcard.github.io/blinkcard-ios/Protocols/MBScanningRecognizerRunnerDelegate.html)
- [`MBDetectionRecognizerRunnerDelegate`](http://blinkcard.github.io/blinkcard-ios/Protocols/MBDetectionRecognizerRunnerDelegate.html)
- [`MBDebugRecognizerRunnerDelegate`](http://blinkcard.github.io/blinkcard-ios/Protocols/MBDebugRecognizerRunnerDelegate.html)
- [`MBOcrRecognizerRunnerDelegate`](http://blinkcard.github.io/blinkcard-ios/Protocols/MBOcrRecognizerRunnerDelegate.html)

In example, we are conforming to [`MBScanningRecognizerRunnerDelegate`](http://blinkcard.github.io/blinkcard-ios/Protocols/MBScanningRecognizerRunnerDelegate.html) protocol.

To initiate the scanning process, first decide where in your app you want to add scanning functionality. Usually, users of the scanning library have a button which, when tapped, starts the scanning process. Initialization code is then placed in touch handler for that button. Here we're listing the initialization code as it looks in a touch handler method.

Swift
```swift
func setupRecognizerRunner() {
    var recognizers = [MBRecognizer]()
    pdf417Recognizer = MBPdf417Recognizer()
    recognizers.append(pdf417Recognizer!)
    let recognizerCollection = MBRecognizerCollection(recognizers: recognizers)
    recognizerRunner = MBRecognizerRunner(recognizerCollection: recognizerCollection)
    recognizerRunner?.scanningRecognizerRunnerDelegate = self
}

func processImageRunner(_ originalImage: UIImage) {
    var image: MBImage? = nil
    if let anImage = originalImage {
        image = MBImage(uiImage: anImage)
    }
    image?.cameraFrame = true
    image?.orientation = MBProcessingOrientation.left
    let _serialQueue = DispatchQueue(label: "com.microblink.DirectAPI-sample-swift")
    _serialQueue.async(execute: {() -> Void in
        self.recognizerRunner?.processImage(image!)
    })
}

func recognizerRunner(_ recognizerRunner: MBRecognizerRunner, didFinishScanningWith state: MBRecognizerResultState) {
    if blinkInputRecognizer.result.resultState == MBRecognizerResultStateValid {
        // Handle result
    }
}
```

Objective-C
```objective-c
- (void)setupRecognizerRunner {
    NSMutableArray<MBRecognizer *> *recognizers = [[NSMutableArray alloc] init];
    
    self.blinkInputRecognizer = [[MBBlinkInputRecognizer alloc] init];
    
    [recognizers addObject:self.blinkInputRecognizer];
    
    MBRecognizerCollection *recognizerCollection = [[MBRecognizerCollection alloc] initWithRecognizers:recognizers];
    
    self.recognizerRunner = [[MBRecognizerRunner alloc] initWithRecognizerCollection:recognizerCollection];
    self.recognizerRunner.scanningRecognizerRunnerDelegate = self;
}

- (void)processImageRunner:(UIImage *)originalImage {
    MBImage *image = [MBImage imageWithUIImage:originalImage];
    image.cameraFrame = YES;
    image.orientation = MBProcessingOrientationLeft;
    dispatch_queue_t _serialQueue = dispatch_queue_create("com.microblink.DirectAPI-sample", DISPATCH_QUEUE_SERIAL);
    dispatch_async(_serialQueue, ^{
        [self.recognizerRunner processImage:image];
    });
}

#pragma mark - MBScanningRecognizerRunnerDelegate
- (void)recognizerRunner:(nonnull MBRecognizerRunner *)recognizerRunner didFinishScanningWithState:(MBRecognizerResultState)state {
    if (self.blinkInputRecognizer.result.resultState == MBRecognizerResultStateValid) {
        // Handle result
    }
}
```

Now you've seen how to implement the Direct processing API.

In essence, this API consists of two steps:

- Initialization of the scanner.
- Call of `- (void)processImage:(MBImage *)image;` method for each UIImage or CMSampleBufferRef you have.


### <a name="direct-api-string-processing"></a> Using Direct API for `NSString` recognition (parsing)

Some recognizers support recognition from `NSString`. They can be used through Direct API to parse given `NSString` and return data just like when they are used on an input image. When recognition is performed on `NSString`, there is no need for the OCR. Input `NSString` is used in the same way as the OCR output is used when image is being recognized. 
Recognition from `String` can be performed in the same way as recognition from image. 
The only difference is that user should call `- (void)processString:(NSString *)string;` on [`MBRecognizerRunner`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizerRunner.html).

# <a name="recognizer"></a> `MBRecognizer` and available recognizers

## The `MBRecognizer` concept

The [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) is the basic unit of processing within the SDK. Its main purpose is to process the image and extract meaningful information from it. As you will see [later](#available-recognizers), the SDK has lots of different [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) objects that have various purposes.

Each [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) has a [`MBRecognizerResult`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizerResult.html) object, which contains the data that was extracted from the image. The [`MBRecognizerResult`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizerResult.html) object is a member of corresponding [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) object its lifetime is bound to the lifetime of its parent [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) object. If you need your `MBRecognizerRecognizer` object to outlive its parent [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) object, you must make a copy of it by calling its method `copy`.

While [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) object works, it changes its internal state and its result. The [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) object's [`MBRecognizerResult`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizerResult.html) always starts in `Empty` state. When corresponding [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) object performs the recognition of given image, its [`MBRecognizerResult`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizerResult.html) can either stay in `Empty` state (in case [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html)failed to perform recognition), move to `Uncertain` state (in case [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) performed the recognition, but not all mandatory information was extracted) or move to `Valid` state (in case [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) performed recognition and all mandatory information was successfully extracted from the image).

As soon as one [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) object's [`MBRecognizerResult`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizerResult.html) within [`MBRecognizerCollection`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizerCollection.html) given to `MBRecognizerRunner` or `MBRecognizerRunnerViewController` changes to `Valid` state, the `onScanningFinished` callback will be invoked on same thread that performs the background processing and you will have the opportunity to inspect each of your [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) objects' [`MBRecognizerResult`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizerResult.html) to see which one has moved to `Valid` state.

As soon as `onScanningFinished` method ends, the `MBRecognizerRunnerViewController` will continue processing new camera frames with same [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) objects, unless `paused`. Continuation of processing or `reset` recognition will modify or reset all [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) objects's [`MBRecognizerResult`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizerResult.html). When using built-in activities, as soon as `onScanningFinished` is invoked, built-in activity pauses the `MBRecognizerRunnerViewController` and starts finishing the activity, while saving the [`MBRecognizerCollection`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizerCollection.html) with active [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html).

## `MBRecognizerCollection` concept

The [`MBRecognizerCollection`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizerCollection.html) is is wrapper around [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) objects that has array of [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) objects that can be used to give [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) objects to `MBRecognizerRunner` or `MBRecognizerRunnerViewController` for processing.

The [`MBRecognizerCollection`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizerCollection.html) is always constructed with array `[[MBRecognizerCollection alloc] initWithRecognizers:recognizers]` of [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) objects that need to be prepared for recognition (i.e. their properties must be tweaked already). 

The [`MBRecognizerCollection`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizerCollection.html) manages a chain of [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) objects within the recognition process. When a new image arrives, it is processed by the first [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) in chain, then by the second and so on, iterating until a [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) object's [`MBRecognizerResult`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizerResult.html) changes its state to `Valid` or all of the [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) objects in chain were invoked (none getting a `Valid` result state).

You cannot change the order of the [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) objects within the chain - no matter the order in which you give [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) objects to [`MBRecognizerCollection`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizerCollection.html), they are internally ordered in a way that provides best possible performance and accuracy. Also, in order for SDK to be able to order [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) objects in recognition chain in a best way possible, it is not allowed to have multiple instances of [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) objects of the same type within the chain. Attempting to do so will crash your application.

# <a name="available-recognizers"></a> List of available recognizers

This section will give a list of all [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) objects that are available within BlinkCard SDK, their purpose and recommendations how they should be used to get best performance and user experience.

## <a name="frame-grabber-recognizer"></a> Frame Grabber Recognizer

The [`MBFrameGrabberRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBFrameGrabberRecognizer.html) is the simplest recognizer in SDK, as it does not perform any processing on the given image, instead it just returns that image back to its `onFrameAvailable`. Its result never changes state from empty.

This recognizer is best for easy capturing of camera frames with `MBRecognizerRunnerViewController`. Note that [`MBImage`](http://blinkcard.github.io/blinkcard-ios/Classes/MBImage.html) sent to `onFrameAvailable` are temporary and their internal buffers all valid only until the `onFrameAvailable` method is executing - as soon as method ends, all internal buffers of [`MBImage`](http://blinkcard.github.io/blinkcard-ios/Classes/MBImage.html) object are disposed. If you need to store [`MBImage`](http://blinkcard.github.io/blinkcard-ios/Classes/MBImage.html) object for later use, you must create a copy of it by calling `copy`.

## <a name="success-frame-grabber-recognizer"></a> Success Frame Grabber Recognizer

The [`MBSuccessFrameGrabberRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBSuccessFrameGrabberRecognizer.html) is a special `MBecognizer` that wraps some other [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) and impersonates it while processing the image. However, when the [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) being impersonated changes its [`MBRecognizerResult`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizerResult.html) into `Valid` state, the [`MBSuccessFrameGrabberRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBSuccessFrameGrabberRecognizer.html) captures the image and saves it into its own [`MBSuccessFrameGrabberRecognizerResult`](http://blinkcard.github.io/blinkcard-ios/Classes/MBSuccessFrameGrabberRecognizerResult.html) object.

Since [`MBSuccessFrameGrabberRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBSuccessFrameGrabberRecognizer.html)  impersonates its slave [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) object, it is not possible to give both concrete [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) object and `MBSuccessFrameGrabberRecognizer` that wraps it to same `MBRecognizerCollection` - doing so will have the same result as if you have given two instances of same [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) type to the [`MBRecognizerCollection`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizerCollection.html) - it will crash your application.

This recognizer is best for use cases when you need to capture the exact image that was being processed by some other [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizer.html) object at the time its [`MBRecognizerResult`](http://blinkcard.github.io/blinkcard-ios/Classes/MBRecognizerResult.html) became `Valid`. When that happens, `MBSuccessFrameGrabberRecognizer's` `MBSuccessFrameGrabberRecognizerResult` will also become `Valid` and will contain described image.

## <a name="blinkcard-recognizers"></a> BlinkCard recognizers 
Payment card recognizers are used to scan payment cards.

### <a name="payment-card-recognizers"></a> Payment / Debit card combined recognizer
The [`MBBlinkCardRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBBlinkCardRecognizer.html)is used for scanning the [front and back side of Payment / Debit card](https://en.wikipedia.org/wiki/Payment_card).

### <a name="elite-payment-card-recognizers"></a> Elite Payment / Debit card combined recognizer
The [`MBBlinkCardEliteRecognizer`](http://blinkcard.github.io/blinkcard-ios/Classes/MBBlinkCardEliteRecognizer.html) scans back side of elite Payment / Debit card after scanning the front side and combines data from both sides.
# Creating customized build of BlinkID SDK

If your final app size is too large, you can create a customised build of _MicroBlink.framework_ and _MicroBlink.bundle_ which will contain only features and resources that you really need.

In order to create customised build of BlinkID SDK, you first need to download the static distribution of BlinkID SDK. A valid production licence key is required in order to gain access to the download link of BlinkID SDK static distribution. Once you have a valid production licence key, please contact our [support team](http://help.microblink.com) and ask them to provide you with the download link. After they give you access to the static distribution of BlinkID SDK, you will be able to download it from you account at [MicroBlink Developer Dashboard](https://www.microblink.com/login).

The static distribution of BlinkID SDK is a large zip file (several hundred megabytes) which contains static libraries of BlinkID SDK's native code, all assets and resources and a script which will create the customised build for you.

### Prerequisites for creating customised build

In order to create customised build of BlinkCard SDK, you will need following tools:

- XCode and latest iOS SDK
- CMake - you can install it from Homebrew with `brew install cmake`, or you can download it from [official page](https://cmake.org/download/)
	- please note that command-line version of CMake is required, so if you have downloaded CMake from official page, make sure you install command-line support as well

### Steps for creating customised build

1. Obtain the static distribution of BlinkID SDK by [contacting us](http://help.microblink.com)
2. Download the zip from link that you will be provided
3. Unzip the file into an empty folder
4. Edit the file `enabled-features.cmake`
	- you should enable only features that you need to use by setting appropriate variables to `ON`. 
	- the list of all possible feature variables can be found in `features.cmake` 
		- for each `feature_option` command, first parameter defines the feature variable, and the second is the description of the feature, i.e. what it provides. Other parameters are information for script to work correctly.
	- you should not edit any file except `enabled-features.cmake` (except if instructed so by our support team) to ensure creation of customised build works well
5. Open terminal and navigate to folder with zip's contents.
6. Execute command `./create-custom-build.sh` and select whether you want static or dynamic frameowk.
	- when asked, enter `s` to build static framework or `d` to build dynamic framework
7. After several minutes (depedending of CPU speed of your computer), customised build will appear in the `Release` folder. Use that bundle and framework in your app instead of default one.

#### Warning:

Attempt to use feature within your app which was not enabled in customised build will cause a linker error when linking against the customised framework.

### Troubleshooting:

#### Getting `unrecognized selector sent to instance` when using customised static framework, while everything works OK with dynamic framework

This happens when your app has not been linked with `-ObjC` flag against static framework. The problem is related to using Objective C categories within static library which are thrown away by linker. You can see more information in [official Apple documentation](https://developer.apple.com/library/content/qa/qa1490/_index.html).

#### App crashing when scanning starts with log message _Failed to load resource XX. The program will now crash._

This means that a required resource was not packaged into final app. This usually indicates a bug in our script that makes the customised build. Please [contact us](http://help.microblink.com) and send your version of `enabled-features.cmake` and crash log.

#### CMake error while running script.

You probably have a typo in `enabled-features.cmake`. CMake is very sensitive language and will throw an non-understandable error if you have a typo or invoke any of its commands with wrong number of parameters.

#### Linker error while running the script.

This sometimes happens when XCode's link time optimizer runs out of memory. Usually running the script again solves the problem. Please reboot your Mac if this keeps happening.

#### Keeping only `FEATURE_MRTD` creates rather large `MicroBlink.bundle`

`FEATURE_MRTD` marks the _MRTD recognizer_. However, _MRTD recognizer_ can also be used in _Templating API_ mode where non-MRZ data can be scanned. To perform OCR of non-MRZ data, a rather large OCR model must be used, which supports all fonts. If you only plan to scan MRZ part of the document, you can edit the `features.cmake` in following way:

- find the following line:

```
feature_resources( FEATURE_MRTD model_mrtd model_general_blink_ocr model_micr model_arabic )
```

- keep only `model_mrtd` in the list, i.e. modify the line so that it will be like this:

```
feature_resources( FEATURE_MRTD model_mrtd )
```

This will keep only support for reading MRZ zone in OCR - you will not be able to scan non-MRZ data with such configuration using _MRTD recognizer_, however you will reduce the `MicroBlink.bundle` and then final app size by more than 4MB.

##### More information about OCR models in `FEATURE_MRTD`

- `model_mrtd` is OCR model for performing OCR of MRZ zone
- `model_arabic` is OCR model for performing OCR of digits used in arabic languages - text scanning is not supported
- `model_micr` is OCR model for performing OCR of [Magnetic Ink Characters](https://en.wikipedia.org/wiki/Magnetic_ink_character_recognition)
- `model_general_blink_ocr` is OCR model for performing general-purpose OCR. This model is usually required for performing OCR of non-MRZ text on documents.

# <a name="troubleshooting"></a> Troubleshooting

## <a name="troubleshooting-integration-problems"></a> Integration problems

In case of problems with integration of the SDK, first make sure that you have tried integrating it into XCode by following [integration instructions](#quick-start).

If you have followed [XCode integration instructions](#quick-start) and are still having integration problems, please contact us at [help.microblink.com](http://help.microblink.com).

## <a name="troubleshooting-sdk-problems"></a> SDK problems

In case of problems with using the SDK, you should do as follows:

### <a name="troubleshooting-licensing-problems"></a> Licencing problems

If you are getting "invalid licence key" error or having other licence-related problems (e.g. some feature is not enabled that should be or there is a watermark on top of camera), first check the console. All licence-related problems are logged to error log so it is easy to determine what went wrong.

When you have determine what is the licence-relate problem or you simply do not understand the log, you should contact us [help.microblink.com](http://help.microblink.com). When contacting us, please make sure you provide following information:

* exact Bundle ID of your app (from your `info.plist` file)
* licence that is causing problems
* please stress out that you are reporting problem related to iOS version of PDF417.mobi SDK
* if unsure about the problem, you should also provide excerpt from console containing licence error

### <a name="troubleshooting-other-problems"></a> Other problems

If you are having problems with scanning certain items, undesired behaviour on specific device(s), crashes inside PDF417.mobi SDK or anything unmentioned, please do as follows:
	
* Contact us at [help.microblink.com](http://help.microblink.com) describing your problem and provide following information:
	* log file obtained in previous step
	* high resolution scan/photo of the item that you are trying to scan
	* information about device that you are using
	* please stress out that you are reporting problem related to iOS version of PDF417.mobi SDK

## <a name="troubleshooting-faq"></a> Frequently asked questions and known problems
Here is a list of frequently asked questions and solutions for them and also a list of known problems in the SDK and how to work around them.

#### In demo everything worked, but after switching to production license I get `NSError` with `MBMicroblinkSDKRecognizerErrorDomain` and `MBRecognizerFailedToInitalize` code as soon as I construct specific [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/docs/Classes/MBRecognizer.html) object

Each license key contains information about which features are allowed to use and which are not. This `NSError` indicates that your production license does not allow using of specific `MBRecognizer` object. You should contact [support](http://help.microblink.com) to check if provided licence is OK and that it really contains all features that you have purchased.

#### I get `NSError` with `MBMicroblinkSDKRecognizerErrorDomain` and `MBRecognizerFailedToInitalize` code with trial license key

Whenever you construct any [`MBRecognizer`](http://blinkcard.github.io/blinkcard-ios/docs/Classes/MBRecognizer.html) object or, a check whether license allows using that object will be performed. If license is not set prior constructing that object, you will get `NSError` with `MBMicroblinkSDKRecognizerErrorDomain` and `MBRecognizerFailedToInitalize` code. We recommend setting license as early as possible in your app.

#### Undefined Symbols on Architecture armv7

Make sure you link your app with iconv and Accelerate frameworks as shown in [Quick start](#quick-start). 
If you are using Cocoapods, please be sure that you've installed `git-lfs` prior to installing pods. If you are still getting this error, go to project folder and execute command `git-lfs pull`.

#### In my `didFinish` callback I have the result inside my `MBRecognizer`, but when scanning activity finishes, the result is gone

This usually happens when using [`MBRecognizerRunnerViewController`](http://blinkcard.github.io/blinkcard-ios/docs/Classes/MBRecognizerRunnerViewController.html) and forgetting to pause the [`MBRecognizerRunnerViewController`](http://blinkcard.github.io/blinkcard-ios/docs/Classes/MBRecognizerRunnerViewController.html) in your `didFinish` callback. Then, as soon as `didFinish` happens, the result is mutated or reset by additional processing that `MBRecognizer` performs in the time between end of your `didFinish` callback and actual finishing of the scanning activity. For more information about statefulness of the `MBRecognizer` objects, check [this section](#recognizer-concept).

#### Unsupported architectures when submitting app to App Store

Microblink.framework is a dynamic framework which contains slices for all architectures - device and simulator. If you intend to extract .ipa file for ad hoc distribution, you'll need to preprocess the framework to remove simulator architectures. 

Ideal solution is to add a build phase after embed frameworks build phase, which strips unused slices from embedded frameworks.

Build step is based on the one provided here: http://ikennd.ac/blog/2015/02/stripping-unwanted-architectures-from-dynamic-libraries-in-xcode/

```shell
APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"

# This script loops through the frameworks embedded in the application and
# removes unused architectures.
find "$APP_PATH" -name '*.framework' -type d | while read -r FRAMEWORK
do
FRAMEWORK_EXECUTABLE_NAME=$(defaults read "$FRAMEWORK/Info.plist" CFBundleExecutable)
FRAMEWORK_EXECUTABLE_PATH="$FRAMEWORK/$FRAMEWORK_EXECUTABLE_NAME"
echo "Executable is $FRAMEWORK_EXECUTABLE_PATH"

EXTRACTED_ARCHS=()

for ARCH in $ARCHS
do
echo "Extracting $ARCH from $FRAMEWORK_EXECUTABLE_NAME"
lipo -extract "$ARCH" "$FRAMEWORK_EXECUTABLE_PATH" -o "$FRAMEWORK_EXECUTABLE_PATH-$ARCH"
EXTRACTED_ARCHS+=("$FRAMEWORK_EXECUTABLE_PATH-$ARCH")
done

echo "Merging extracted architectures: ${ARCHS}"
lipo -o "$FRAMEWORK_EXECUTABLE_PATH-merged" -create "${EXTRACTED_ARCHS[@]}"
rm "${EXTRACTED_ARCHS[@]}"

echo "Replacing original executable with thinned version"
rm "$FRAMEWORK_EXECUTABLE_PATH"
mv "$FRAMEWORK_EXECUTABLE_PATH-merged" "$FRAMEWORK_EXECUTABLE_PATH"

done
```

# <a name="info"></a> Additional info

Complete API reference can be found [here](http://blinkcard.github.io/blinkcard-ios/index.html). 

For any other questions, feel free to contact us at [help.microblink.com](http://help.microblink.com).