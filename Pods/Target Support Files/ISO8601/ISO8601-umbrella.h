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

#import "ISO8601Serialization.h"
#import "NSDate+ISO8601.h"
#import "ISO8601.h"

FOUNDATION_EXPORT double ISO8601VersionNumber;
FOUNDATION_EXPORT const unsigned char ISO8601VersionString[];

