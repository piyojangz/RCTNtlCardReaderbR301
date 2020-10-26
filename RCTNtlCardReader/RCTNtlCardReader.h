//
//  RCTNtlCardReader.h
//  RCTNtlCardReader
//
//  Created by Breeshy Sama on 4/12/2561 BE.
//  Copyright © 2561 Ngern Tid Lor. All rights reserved.
//
#import <React/RCTBridgeModule.h>
#import "ReaderInterface.h"
@interface RCTNtlCardReader : NSObject <RCTBridgeModule,ReaderInterfaceDelegate>

+ (NSString *)moduleName;

- (void)cardInterfaceDidDetach:(BOOL)attached;

- (void)didGetBattery:(NSInteger)battery;

- (void)findPeripheralReader:(NSString *)readerName;

- (void)readerInterfaceDidChange:(BOOL)attached bluetoothID:(NSString *)bluetoothID;

@end
