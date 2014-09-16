//
//  IAPHandler.h
//  IAPEcPurchase

//  Created by WO on 13-3-25.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#define IAPDidReceivedProducts                      @"IAPDidReceivedProducts"
#define IAPDidFailedTransaction                     @"IAPDidFailedTransaction"
#define IAPDidRestoreTransaction                    @"IAPDidRestoreTransaction"
#define IAPDidCompleteTransaction                   @"IAPDidCompleteTransaction"
#define IAPDidCompleteTransactionAndVerifySucceed   @"IAPDidCompleteTransactionAndVerifySucceed"
#define IAPDidCompleteTransactionAndVerifyFailed    @"IAPDidCompleteTransactionAndVerifyFailed"

#import "ECPurchase.h"

@interface IAPHandler : NSObject

+ (void)initECPurchaseWithHandler;
@end