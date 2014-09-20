//
//  SecondViewController.m
//  LEDControl
//
//  Created by Rene Pirringer on 22.01.14.
//  Copyright (c) 2014 Rene Pirringer. All rights reserved.
//

#import "SecondViewController.h"
#import "NSObject+Injector.h"
#import "ArduinoControllerService.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)awakeFromNib {
	[super awakeFromNib];
	[self injectDependenciesTo:self];
}


- (void)viewDidLoad
{
	[super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ledControllerConnected:) name:NotificationLedControllerConnected object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ledControllerDisconnected:) name:NotificationLedControllerDisconnected object:nil];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)ledControllerDisconnected:(id)ledControllerDisconnected {
	[self.connectButton setTitle:@"Connect" forState:UIControlStateNormal];
}

- (void)ledControllerConnected:(id)ledControllerConnected {
	[self.connectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connect:(id)sender {

	if (self.arduinoControllerService.isConnected) {
		[self.arduinoControllerService disconnect];
	} else {
		[self.arduinoControllerService connect];
	}



}

@end
