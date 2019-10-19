#import "Venmo.h"
#import <VENCore/NSDictionary+VENCore.h>

#import "VENDefines_Internal.h"
#import "NSURL+VenmoSDK.h"
#import "NSDictionary+VenmoSDK.h"
#import "VENTransaction+VenmoSDK.h"
#import "VENRequestDecoder.h"

@interface VENUser (VENTransaction_VenmoSDK)
@property (copy, nonatomic, readwrite) NSString *externalId;
@end


@interface VENTransaction ()
@property (copy, nonatomic, readwrite) NSString *transactionID;
@property (strong, nonatomic, readwrite) VENTransactionTarget *target;
@property (copy, nonatomic, readwrite) NSString *note;
@property (copy, nonatomic, readwrite) VENUser *actor;
@property (assign, nonatomic, readwrite) VENTransactionType transactionType;
@property (assign, nonatomic, readwrite) VENTransactionStatus status;
@property (assign, nonatomic, readwrite) VENTransactionAudience audience;
@end


@implementation VENTransaction (VenmoSDK)

+ (instancetype)transactionWithURL:(NSURL *)url {
    @try {
        NSString *signedRequest = [[url queryDictionary] stringForKey:@"signed_request"];
        DLog(@"signedRequest: %@", signedRequest);

        NSArray *decodedSignedRequest = [VENRequestDecoder decodeSignedRequest:signedRequest withClientSecret:[[Venmo sharedInstance] appSecret]];
        DLog(@"decodedSignedRequest: %@", decodedSignedRequest);
        return [VENTransaction transactionWithSignedRequestDictionary:decodedSignedRequest[0]];
    }
    @catch (NSException *exception) {
        DLog(@"Exception! %@: %@. %@", exception.name, exception.reason, exception.userInfo);
        return nil;
    }
}


+ (NSString *)amountString:(NSUInteger)amount {
    if (amount < 1) {
        return @"";
    }
    CGFloat dollarAmount = amount / 100.0f;
    NSString *amountStr = [NSString stringWithFormat:@"%.2f", dollarAmount];
    return amountStr;
}


+ (NSString *)typeString:(VENTransactionType)type {
    if (type == VENTransactionTypePay) {
        return VENTransactionTypeStrings[VENTransactionTypePay];
    }
    else {
        return VENTransactionTypeStrings[VENTransactionTypeCharge];
    }
}

#pragma mark - Private
+ (instancetype)transactionWithSignedRequestDictionary:(NSDictionary *)dictionary {
    DLog(@"transaction Dictionary: %@", dictionary);
    if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSDictionary *cleanDictionary = [dictionary dictionaryByCleansingResponseDictionary];

    VENTransaction *transaction = [[VENTransaction alloc] init];
    transaction.transactionID = cleanDictionary[@"id"];
    NSString *transactionType = cleanDictionary[@"action"];
    // Set transaction type enumeration
    if ([transactionType isEqualToString:VENTransactionTypeStrings[VENTransactionTypeCharge]]) {
        transaction.transactionType = VENTransactionTypeCharge;
    }
    else if ([transactionType isEqualToString:VENTransactionTypeStrings[VENTransactionTypePay]]) {
        transaction.transactionType = VENTransactionTypePay;
    }
    else {
        transaction.transactionType = VENTransactionTypeUnknown;
    }

    NSString *actorUserID = cleanDictionary[@"actor"][@"id"];
    VENUser *actor = [[VENUser alloc] init];
    actor.externalId = actorUserID;
    transaction.actor = actor;

    NSDictionary *targetDictionary = cleanDictionary[@"target"];
    NSString *targetHandle;
    if (targetDictionary[@"user"]) {
        targetHandle = targetDictionary[@"user"][@"id"];
    } else if (targetDictionary[@"phone"]) {
        targetHandle = targetDictionary[@"phone"];
    } else if (targetDictionary[@"email"]) {
        targetHandle = targetDictionary[@"email"];
    }
    NSInteger amount = [[cleanDictionary stringForKey:@"amount"] floatValue] * 100;
    VENTransactionTarget *target = [[VENTransactionTarget alloc] initWithHandle:targetHandle amount:amount];
    transaction.target = target;
    transaction.note = cleanDictionary[@"note"];

    BOOL success = [cleanDictionary[@"success"] boolValue];
    if (success) {
        transaction.status = VENTransactionStatusSettled;
    }
    else {
        transaction.status = VENTransactionStatusFailed;
    }
    return transaction;
}


@end
