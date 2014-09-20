//
// LEDControl 
//
// Created by rene on 24.01.14.
// Copyright 2014 Drobnik.com. All rights reserved.
//
// 
//


#import "RedBearBLEShield.h"

#define REDBEAR_BLE_SHIELD_SERVICE_UUID [CBUUID UUIDWithString:@"713D0000-503E-4C75-BA94-3148F18D941E"]
#define REDBEAR_BLE_SHIELD_CHARACTERISTICS_TX_UUID [CBUUID UUIDWithString:@"713D0002-503E-4C75-BA94-3148F18D941E"]
#define REDBEAR_BLE_SHIELD_CHARACTERISTICS_RX_UUID [CBUUID UUIDWithString:@"713D0003-503E-4C75-BA94-3148F18D941E"]



@interface RedBearBLEShield () <CBCentralManagerDelegate>
@property(nonatomic, strong) CBCentralManager *centralManager;
@property(nonatomic, strong) NSMutableArray *shieldPeripherals;
@property(nonatomic, strong) NSObject<RedBearBLEShieldDelegate> *shieldDelegate;
@end

@implementation RedBearBLEShield {

}

- (id)initWithDelegate:(NSObject<RedBearBLEShieldDelegate> *)delegate {
	self = [super init];
	if (self) {
		self.shieldDelegate = delegate;
	}
	return self;
}

- (void)connect {
	//NSDictionary *options = @{CBCentralManagerOptionRestoreIdentifierKey: @"RedBearBLE"};
	NSDictionary *options = nil;
	self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:options];
	self.shieldPeripherals = [[NSMutableArray alloc] init];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {

	if (central.state == CBCentralManagerStatePoweredOn) {
		[self.centralManager scanForPeripheralsWithServices:@[REDBEAR_BLE_SHIELD_SERVICE_UUID] options:nil];

		// if we were restored, subscribe for updates
		/*
		for (CBPeripheral *peripheral in self.shieldPeripherals) {
			if (peripheral.state == CBPeripheralStateConnected) {
				[self checkServiceForPeripheral:peripheral];
			}
		}
		*/
	} else {
		[self.shieldPeripherals removeAllObjects];
	}

}

/*
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)state {


	NSArray *peripherals = state[CBCentralManagerRestoredStatePeripheralsKey];
	for (CBPeripheral *peripheral in peripherals) {
		[self.shieldPeripherals addObject:peripheral];
		peripheral.delegate = self;
	}
}




- (void)checkCharacteristicsForPeripheral:(CBPeripheral *)peripheral withIndex:(NSUInteger)serviceIndex {
	CBService *service = peripheral.services[serviceIndex];
	NSUInteger characteristicsIndex = [service.characteristics indexOfObjectPassingTest:^BOOL(CBCharacteristic *characteristic, NSUInteger idx, BOOL *stop) {
		return [characteristic.UUID isEqual:REDBEAR_BLE_SHIELD_CHARACTERISTICS_RX_UUID];
	}];

	if (characteristicsIndex == NSNotFound) {
		[peripheral discoverCharacteristics:@[REDBEAR_BLE_SHIELD_CHARACTERISTICS_RX_UUID] forService:service];
		return;
	}

	CBCharacteristic *characteristic = service.characteristics[characteristicsIndex];
	if (characteristic.isNotifying) {
		[peripheral setNotifyValue:YES forCharacteristic:characteristic];
	}
}

- (void)checkServiceForPeripheral:(CBPeripheral *)peripheral {
	NSUInteger serviceIndex = [peripheral.services indexOfObjectPassingTest:^BOOL(CBService* service, NSUInteger idx, BOOL *stop) {
		return [service.UUID isEqual:REDBEAR_BLE_SHIELD_SERVICE_UUID];
	}];

	if (serviceIndex == NSNotFound) {
		[peripheral discoverServices:@[REDBEAR_BLE_SHIELD_SERVICE_UUID]];
		return;
	}

	[self checkCharacteristicsForPeripheral:peripheral withIndex:serviceIndex];

}
*/


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
	if (![self.shieldPeripherals containsObject:peripheral]) {
		[self.shieldPeripherals addObject:peripheral];

		NSLog(@"connect to peripheral: %@", peripheral);

		NSDictionary *options = @{ CBConnectPeripheralOptionNotifyOnDisconnectionKey: @YES };

		[self.centralManager connectPeripheral:peripheral options:options];
	}



}


- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
	if (error) {
		NSLog(@"error discovering characteristics for service: %@", [error localizedDescription]);
		return;
	}

	NSLog(@"didDisconnectPeripheral: %@", peripheral);
	if ([self.shieldPeripherals containsObject:peripheral]) {

		[self.shieldPeripherals removeObject:peripheral];

		if ([self.shieldDelegate respondsToSelector:@selector(shieldDidDisconnect)]) {
			[self.shieldDelegate shieldDidDisconnect];
		}
	}

}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
	NSLog(@"didConnectPeripheral to peripheral: %@", peripheral);

	peripheral.delegate = self;
	[peripheral discoverServices:@[REDBEAR_BLE_SHIELD_SERVICE_UUID]];


}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
	if (error) {
		NSLog(@"error discovering service: %@", [error localizedDescription]);
		[self.centralManager cancelPeripheralConnection:peripheral];
		return;
	}

	NSLog(@"didDiscoverServices to services");


	for (CBService *service in peripheral.services) {
		if ([service.UUID isEqual:REDBEAR_BLE_SHIELD_SERVICE_UUID]) {

			NSLog(@"service found %@", service.UUID);

			[peripheral discoverCharacteristics:@[REDBEAR_BLE_SHIELD_CHARACTERISTICS_TX_UUID, REDBEAR_BLE_SHIELD_CHARACTERISTICS_RX_UUID] forService:service];
			return;
		}
	}

}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
	if (error) {
		NSLog(@"error discovering characteristics for service: %@", [error localizedDescription]);
		[self.centralManager cancelPeripheralConnection:peripheral];
		return;
	}
	NSLog(@"didDiscoverCharacteristicsForService for services %@", service);


	for (CBCharacteristic *characteristic in service.characteristics) {

		NSLog(@"characteristic.UUID %@", characteristic.UUID);


		if ([characteristic.UUID isEqual:REDBEAR_BLE_SHIELD_CHARACTERISTICS_TX_UUID]) {
			[peripheral setNotifyValue:YES forCharacteristic:characteristic];

			NSLog(@"Notify values for characteristic");

			if ([self.shieldDelegate respondsToSelector:@selector(shieldDidConnect)]) {
				[self.shieldDelegate shieldDidConnect];
			}
		}


		/*
		if ([characteristic.UUID isEqual:REDBEAR_BLE_SHIELD_CHARACTERISTICS_RX_UUID]) {
			[peripheral setNotifyValue:YES forCharacteristic:characteristic];
		}
		*/
	}

}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
	if (error) {
		NSLog(@"error didUpdateNotificationStateForCharacteristic: %@", [error localizedDescription]);
		return;
	}
	NSLog(@"didUpdateNotificationStateForCharacteristic for characteristic %@", characteristic);


}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
	if (error) {
		NSLog(@"error discovering didUpdateValueForCharacteristic: %@", [error localizedDescription]);
		[self.centralManager cancelPeripheralConnection:peripheral];
		return;
	}
	NSLog(@"didUpdateValueForCharacteristic for characteristic %@", characteristic);


	if ([characteristic.UUID isEqual:REDBEAR_BLE_SHIELD_CHARACTERISTICS_TX_UUID]) {
		NSData *data = characteristic.value;

		if ([self.shieldDelegate respondsToSelector:@selector(shieldDidReceiveData:)]) {
			[self.shieldDelegate shieldDidReceiveData:data];
		}

	}
}


- (CBService *)serviceForPeripheral:(CBPeripheral *)peripheral {
	NSUInteger serviceIndex = [peripheral.services indexOfObjectPassingTest:^BOOL(CBService *service, NSUInteger idx, BOOL *stop) {
		return [service.UUID isEqual:REDBEAR_BLE_SHIELD_SERVICE_UUID];
	}];

	if (serviceIndex == NSNotFound) {
		[peripheral discoverServices:@[REDBEAR_BLE_SHIELD_SERVICE_UUID]];
		return nil;
	}
	return peripheral.services[serviceIndex];
}

- (CBCharacteristic *)characteristicsForUUID:(CBUUID *)uuid forService:(CBService *)service {

	NSUInteger characteristicsIndex = [service.characteristics indexOfObjectPassingTest:^BOOL(CBCharacteristic *characteristic, NSUInteger idx, BOOL *stop) {
			return [characteristic.UUID isEqual:uuid];
	}];


	if (characteristicsIndex == NSNotFound) {
		return nil;
	}
	return service.characteristics[characteristicsIndex];
}

-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2
{
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1];
    [UUID2.data getBytes:b2];

    if (memcmp(b1, b2, UUID1.data.length) == 0)
        return 1;
    else
        return 0;
}


-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p
{
    for(int i = 0; i < p.services.count; i++)
    {
        CBService *s = [p.services objectAtIndex:i];
        if ([self compareCBUUID:s.UUID UUID2:UUID])
            return s;
    }

    return nil; //Service not found on this peripheral
}

-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service
{
    for(int i=0; i < service.characteristics.count; i++)
    {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }

    return nil; //Characteristic not found on this service
}

- (void)sendData:(NSData *)data {
/*

	CBPeripheral *peripheral = [self.shieldPeripherals firstObject];


	CBService *service = [self serviceForPeripheral:peripheral];

	if (!service) {
		NSLog(@"No service found, so cannot send data");
		return;
	}

	CBCharacteristic *characteristic = [self characteristicsForUUID:REDBEAR_BLE_SHIELD_CHARACTERISTICS_RX_UUID forService:service];
	if (!characteristic) {
		NSLog(@"Could not find characteristic with UUID %@ on service with UUID %@", REDBEAR_BLE_SHIELD_CHARACTERISTICS_RX_UUID, REDBEAR_BLE_SHIELD_SERVICE_UUID);
		return;
	}

	NSLog(@"sending data: %@ with characteristic: %@", [self dataToHexString:data], characteristic.UUID );
	[peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
*/
	CBPeripheral *p = [self.shieldPeripherals firstObject];

	//CBPeripheral *p = self.activePeripheral;

		CBService *service = [self findServiceFromUUID:REDBEAR_BLE_SHIELD_SERVICE_UUID p:p];

	    if (!service)
	    {
	        NSLog(@"Could not find service with UUID %@ on peripheral with UUID %@",
	              REDBEAR_BLE_SHIELD_SERVICE_UUID,
	              p.identifier.UUIDString);

	        return;
	    }

	    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:REDBEAR_BLE_SHIELD_CHARACTERISTICS_RX_UUID service:service];

	    if (!characteristic)
	    {
	        NSLog(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@",
	              REDBEAR_BLE_SHIELD_CHARACTERISTICS_RX_UUID,
	              REDBEAR_BLE_SHIELD_SERVICE_UUID,
	              p.identifier.UUIDString);

	        return;
	    }

			NSLog(@"write forCharacteristic %@ ", characteristic.UUID);
	    [p writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
	NSLog(@"didWriteValueForCharacteristic error: %@", error);

}

- (NSString *)dataToHexString:(NSData *)data {
	unsigned char *bytes = [data bytes];
	NSMutableString *result = [NSMutableString stringWithCapacity:[data length] * 2];
	int i;
	for (i = 0; i < [data length]; i++) {
		[result appendFormat:@"%02x ", bytes[i]];
	}
	return result;
}


- (void)disconnect {

	for (CBPeripheral *peripheral in self.shieldPeripherals) {
		[self.centralManager cancelPeripheralConnection:peripheral];
	}

	//[self.shieldPeripherals removeAllObjects];


}



@end