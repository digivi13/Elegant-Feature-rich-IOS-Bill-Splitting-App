#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSArray+VENCore.h"
#import "NSDictionary+VENCore.h"
#import "NSError+VENCore.h"
#import "NSString+VENCore.h"
#import "UIDevice+VENCore.h"
#import "VENCreateTransactionRequest.h"
#import "VENTransaction.h"
#import "VENTransactionPayloadKeys.h"
#import "VENTransactionTarget.h"
#import "VENUser.h"
#import "VENUserPayloadKeys.h"
#import "VENHTTP.h"
#import "VENHTTPResponse.h"
#import "VENCore.h"

FOUNDATION_EXPORT double VENCoreVersionNumber;
FOUNDATION_EXPORT const unsigned char VENCoreVersionString[];

