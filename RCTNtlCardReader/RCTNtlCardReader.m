//
//  RCTNtlCardReader.m
//  RCTNtlCardReader
//
//  Created by Breeshy Sama on 4/12/2561 BE.
//  Copyright © 2561 Ngern Tid Lor. All rights reserved.
//

#import "RCTNtlCardReader.h"
#import "hex.h"
#import "winscard.h"
#import "ft301u.h"

//buffer    char [20]    "bR301"
//_readerName    __NSCFString *    @"FT_3481F433F880"    0x00000002835044b0
static id myobject;
SCARDCONTEXT gContxtHandle;
    BOOL _autoConnect;
SCARDHANDLE gCardHandle;
NSString *gBluetoothID;
static NSString *autoConnectKey = @"autoConnect";
typedef NS_ENUM(NSInteger, FTReaderType) {
    FTReaderiR301 = 0,
    FTReaderbR301 = 1,
    FTReaderbR301BLE = 2,
    FTReaderbR500 = 3,
    FTReaderBLE = 4
};
 

@implementation RCTNtlCardReader
{
    NSMutableArray *_deviceList;
    BOOL _isAutoConnect;
    NSMutableArray *_readers;
    NSString *_selectedReader;
    FTReaderType _readerType;
    NSString *_selectedDeviceName;
    NSInteger _itemHW;
    NSInteger _itemCountPerRow;
    NSMutableArray *_displayedItem;
     ReaderInterface *interface;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE();


RCT_EXPORT_METHOD(initCard)
{
    interface = [[ReaderInterface alloc] init];
   interface.delegate = self;
        ULONG ret = SCardEstablishContext(SCARD_SCOPE_SYSTEM,NULL,NULL,&gContxtHandle);
        if(ret != 0){
//            [[Tools shareTools] showError:[[Tools shareTools] mapErrorCode:ret]];
        } 
//
//    interface = [[ReaderInterface alloc] init];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self initReaderInterface];
//    });
    
    //get reader name
     _readerType = FTReaderbR301;
    _deviceList = [NSMutableArray array];
    
//    [self startRefreshThread];
}


RCT_EXPORT_METHOD(initDidMount){
//    interface = [[ReaderInterface alloc] init];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self initReaderInterface];
//    });
    
//     _readerType = FTReaderbR301;
//    _deviceList = [NSMutableArray array];
//    _autoConnect = YES;
    
}


RCT_EXPORT_METHOD(getSN: (RCTResponseSenderBlock)callback) {
    char buffer[16] = {0};
    unsigned int length = 0;
     
    
    DWORD ret = FtGetSerialNum(gContxtHandle, &length, buffer);
    if(ret == SCARD_S_SUCCESS){
        NSData *data = [NSData dataWithBytes:buffer length:length];
        NSString *str = [NSString stringWithFormat:@"Serial Number: %@", data];
         callback(@[[NSNull null], str]);
    }
    else{
          callback(@[[NSNull null], @"error"]);
    }
}



RCT_EXPORT_METHOD(connectCardReader) {
//    interface = [[ReaderInterface alloc] init];
//    [interface setDelegate:self];
     [self connectCard];
}


-(void)getReaderName
{
//    unsigned int length = 0;
//    char buffer[20] = {0};
//    LONG ret = FtGetReaderName(gContxtHandle, &length, buffer);
//    if (ret != SCARD_S_SUCCESS || length == 0) {
////        [self showMsg:errorMsg];
//        return;
//    }
//
//    NSString *readerName = [NSString stringWithUTF8String:buffer];
//
//
//    if ([readerName isEqualToString:@"bR301"]) {
//        _readerType = FTReaderbR301;
//
//    }else if ([readerName isEqualToString:@"iR301"]) {
//        _readerType = FTReaderiR301;
//
//    }else if ([readerName isEqualToString:@"bR301BLE"]) {
//        _readerType = FTReaderbR301BLE;
//
//    }else if ([readerName isEqualToString:@"bR500"]) {
//        _readerType = FTReaderbR500;
//    }
    
}

RCT_EXPORT_METHOD(sendCommand: (RCTResponseSenderBlock)callback) {
{
    unsigned  int capdulen;
    unsigned char capdu[2048 + 128];
    memset(capdu, 0, 2048 + 128);
    unsigned char resp[2048 + 128];
    memset(resp, 0, 2048 + 128);
    unsigned int resplen = sizeof(resp) ;
    unsigned char bytes[] = {0x00, 0xC0, 0x00, 0x00 ,0x08,0xA0,0X00,0x00,0x00,0x54,0x48,0x00,0x01};
    
    
    
    //3.send data
    SCARD_IO_REQUEST pioSendPci;
    DWORD iRet = SCardTransmit(gContxtHandle, &pioSendPci, (unsigned char*)capdu, capdulen, NULL, resp, &resplen);
    if (iRet != 0) {
       callback(@[[NSNull null], @"iRet != 0"]);
    }else {
        NSMutableData *RevData = [NSMutableData data];
        [RevData appendBytes:resp length:resplen];
        NSString *str = [NSString stringWithFormat:@"%@%@\n",NSLocalizedString(@"Rev:", nil),[RevData description]];
        callback(@[[NSNull null],str]);
    }
}
}


//init readerInterface and card context
- (void)initReaderInterface
{
    NSNumber *value = [[NSUserDefaults standardUserDefaults] valueForKey:autoConnectKey];
    if (value == nil) {
        _autoConnect = NO;
    }
    _autoConnect = value.boolValue;
//    [interface setAutoPair:_autoConnect];
//     [interface setDelegate:self];
    
    //set support device type, default support all readers;
    //    [FTDeviceType setDeviceType:(FTDEVICETYPE)(IR301_AND_BR301 | BR301BLE_AND_BR500)];
    
    ULONG ret = SCardEstablishContext(SCARD_SCOPE_SYSTEM,NULL,NULL,&gContxtHandle);
    if(ret != 0){
//        [[Tools shareTools] showError:[[Tools shareTools] mapErrorCode:ret]];
    }
}





//connect card
- (void)connectCard {
    DWORD dwActiveProtocol = -1;
    NSString *reader = @"FT_3481F433F880";
    
    LONG ret = SCardConnect(gContxtHandle, [reader UTF8String], SCARD_SHARE_SHARED,SCARD_PROTOCOL_T0 | SCARD_PROTOCOL_T1, &gCardHandle, &dwActiveProtocol);
    
    if(ret != 0){
//        NSString *errorMsg = [[Tools shareTools] mapErrorCode:ret];
//        [[Tools shareTools] showError:errorMsg];
        return;
    }
    
    unsigned char patr[33] = {0};
    DWORD len = sizeof(patr);
    ret = SCardGetAttrib(gCardHandle,NULL, patr, &len);
    if(ret != SCARD_S_SUCCESS)
    {
        NSLog(@"SCardGetAttrib error %08x",ret);
    }
}


- (NSString *)getReaderList
{
    DWORD readerLength = 0;
    LONG ret = SCardListReaders(gContxtHandle, nil, nil, &readerLength);
    if(ret != 0){
        return nil;
    }
    
    LPSTR readers = (LPSTR)malloc(readerLength * sizeof(LPSTR));
    ret = SCardListReaders(gContxtHandle, nil, readers, &readerLength);
    if(ret != 0){
        return nil;
    }
    
    return [NSString stringWithUTF8String:readers];
}



- (void)cardInterfaceDidDetach:(BOOL)attached {
    if (attached) {
        NSLog(@"card present");
        
    }else {
        NSLog(@"card not present");
    }
}

- (void)didGetBattery:(NSInteger)battery {
    
}

- (void)findPeripheralReader:(NSString *)readerName {
    
}

- (void)readerInterfaceDidChange:(BOOL)attached bluetoothID:(NSString *)bluetoothID {
    if (attached) {
        gBluetoothID = bluetoothID;
        
        
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSString *reader = [self getReaderList];
            if (reader.length == 0 || reader == nil) {
                return ;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                _readerNameLabel.text = reader;
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (_autoConnect) {
                    _selectedDeviceName = [self getReaderList];
                }  });
        });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
//            _readerNameLabel.text = @"No reader detected";
        });
    }
}

@end
