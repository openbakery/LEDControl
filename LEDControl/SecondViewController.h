//
//  SecondViewController.h
//  LEDControl
//
//  Created by Rene Pirringer on 22.01.14.
//  Copyright (c) 2014 Rene Pirringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArduinoControllerService;

@interface SecondViewController : UIViewController

@property (nonatomic, strong) ArduinoControllerService *arduinoControllerService;

@property (nonatomic, strong) IBOutlet UIButton *connectButton;

@end
