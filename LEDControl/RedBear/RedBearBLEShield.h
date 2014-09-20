//
// LEDControl 
//
// Created by rene on 24.01.14.
// Copyright 2014 Drobnik.com. All rights reserved.
//
// 
//


#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


@protocol RedBearBLEShieldDelegate
@optional
-(void) shieldDidConnect;
-(void) shieldDidDisconnect;
-(void) shieldDidReceiveData:(NSData *)data;
@required
@end

@interface RedBearBLEShield : NSObject <CBPeripheralDelegate>

- (id)initWithDelegate:(id<RedBearBLEShieldDelegate>)delegate;

- (void)connect;


- (void)sendData:(NSData *)data;

- (void)disconnect;
@end