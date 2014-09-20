//
//  LedControllerService.m
//  BLEChat
//
//  Created by Cheong on 15/8/12.
//  Copyright (c) 2012 RedBear Lab., All rights reserved.
//

#import "ArduinoControllerService.h"
#import "RedBearBLEShield.h"

NSString * const NotificationLedControllerConnected = @"NotificationLedControllerConnected";
NSString * const NotificationLedControllerDisconnected = @"NotificationLedControllerDisconnected";


@interface ArduinoControllerService ()

@property(nonatomic, strong) NSTimer *timer;
@end

@implementation ArduinoControllerService
{
	//BLE *bleShield;
	RedBearBLEShield *readBearBLEShield;
	BOOL _isConnected;
}

- (id)init
{
	self = [super init];
	if (self) {
		//bleShield = [[BLE alloc] initWithDelegate:self];
		//[bleShield controlSetup];

		readBearBLEShield = [[RedBearBLEShield alloc] initWithDelegate:self];
		_isConnected = NO;
	}
	return self;
}

- (void)shieldDidConnect {
	_isConnected = YES;
	[[NSNotificationCenter defaultCenter] postNotificationName:NotificationLedControllerConnected object:nil];
}

- (void)shieldDidDisconnect {
	_isConnected = NO;
	[[NSNotificationCenter defaultCenter] postNotificationName:NotificationLedControllerDisconnected object:nil];
}

- (void)shieldDidReceiveData:(NSData *)data {
	NSString *dataAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"received data %@", dataAsString);

}


// Called when scan period is over to connect to the first found peripheral
- (void)connectionTimer:(NSTimer *)timer {
	/*
	if (bleShield.peripherals.count > 0) {
		[bleShield connectPeripheral:[bleShield.peripherals objectAtIndex:0]];
	}
	*/
}


- (void)bleDidReceiveData:(unsigned char *)data length:(int)length {
	NSData *d = [NSData dataWithBytes:data length:length];
	NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
	NSLog(@"received data %@", s);
}

/*
- (void)readRSSITimer:(NSTimer *)timer {
	[bleShield readRSSI];
}
*/

- (void)bleDidDisconnect {
	[[NSNotificationCenter defaultCenter] postNotificationName:NotificationLedControllerDisconnected object:nil];

	[self.timer invalidate];
}

/*
- (void)shieldDidConnect {
	[[NSNotificationCenter defaultCenter] postNotificationName:NotificationLedControllerConnected object:nil];

	// Schedule to read RSSI every 1 sec.
	//self.timer = [NSTimer scheduledTimerWithTimeInterval:(float) 1.0 target:self selector:@selector(readRSSITimer:) userInfo:nil repeats:YES];
}
*/
- (void)bleDidUpdateRSSI:(NSNumber *)rssi {
	//self.labelRSSI.text = rssi.stringValue;
}

- (void)sendData:(NSData *)data; {

	[readBearBLEShield sendData:data];
	//[bleShield sendData:data];
}


- (void)connect {
	[readBearBLEShield connect];
	//[bleShield findBLEPeripherals:3];

	/*
	if (bleShield.activePeripheral) {
		if (bleShield.activePeripheral.isConnected) {
			[[bleShield CM] cancelPeripheralConnection:[bleShield activePeripheral]];
			return;
		}
	}

	if (bleShield.peripherals) {
		bleShield.peripherals = nil;
	}

	[bleShield findBLEPeripherals:3];

	[NSTimer scheduledTimerWithTimeInterval:(float) 3.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
	*/
}


- (void)setColorRed:(CGFloat)red blue:(CGFloat)blue green:(CGFloat)green {
    char bytes[5];
    bytes[0] = (char)61;
    bytes[1] = (char)(red*255);
    bytes[2] = (char)(green*255);
    bytes[3] = (char)(blue*255);
    bytes[4] = (char)0;
    NSData *data = [NSData dataWithBytes:bytes length:5];
    [self  sendData:data];

}

- (void)playTone:(int)tone {
    if (tone < 0 && tone >2) {
        return;
    }
     char bytes[5];
     bytes[0] = (char)(62+tone);
     bytes[1] = (char)0;
     bytes[2] = (char)0;
     bytes[3] = (char)0;
     bytes[4] = (char)0;
     NSData *data = [NSData dataWithBytes:bytes length:5];
     [self sendData:data];
}


- (void)disconnect {
	[readBearBLEShield disconnect];

}

- (BOOL)isConnected {
	//return bleShield.isConnected;
	return _isConnected;
}

@end
