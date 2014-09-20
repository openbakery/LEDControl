//
//  LedControllerService.h
//  BLEChat
//
//  Created by Cheong on 15/8/12.
//  Copyright (c) 2012 RedBear Lab., All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedBearBLEShield.h"

extern NSString * const NotificationLedControllerConnected;
extern NSString * const NotificationLedControllerDisconnected;


@interface ArduinoControllerService : NSObject <RedBearBLEShieldDelegate> {
}

@property(nonatomic, readonly) BOOL isConnected;

- (void)connect;

- (void)setColorRed:(CGFloat)red blue:(CGFloat)blue green:(CGFloat)green;

/**
 * valid values are 0,1,2
 */
- (void)playTone:(int)tone;

- (void)disconnect;
@end
