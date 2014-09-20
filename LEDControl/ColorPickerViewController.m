//
//  ColorPickerViewController.m
//  LEDControl
//
//  Created by Rene Pirringer on 22.01.14.
//  Copyright (c) 2014 Rene Pirringer. All rights reserved.
//

#import "ColorPickerViewController.h"
#import "ArduinoControllerService.h"
#import "NSObject+Injector.h"

@interface ColorPickerViewController ()

@end

@implementation ColorPickerViewController

- (void)awakeFromNib {
	[super awakeFromNib];
	[self injectDependenciesTo:self];
}


- (void)viewDidLoad {
	[super viewDidLoad];
	self.color = [UIColor redColor];


	[self.redSlider addTarget:self action:@selector(valueChangedAction:) forControlEvents:UIControlEventValueChanged];
	[self.greenSlider addTarget:self action:@selector(valueChangedAction:) forControlEvents:UIControlEventValueChanged];
	[self.blueSlider addTarget:self action:@selector(valueChangedAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)valueChangedAction:(id)valueChangedAction {

	self.color = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1.0];


}


- (void)setColor:(UIColor *)color {
	_color = color;

	self.colorView.backgroundColor = _color;

	CGFloat red, green, blue, alpha;
	[color getRed:&red green:&green blue:&blue alpha:&alpha];

	self.redSlider.value = red;
	self.greenSlider.value = green;
	self.blueSlider.value = blue;

	self.redValueLabel.text = [NSString stringWithFormat:@"%d", (int)(red*255)];
	self.greenValueLabel.text = [NSString stringWithFormat:@"%d", (int)(green*255)];
	self.blueValueLabel.text = [NSString stringWithFormat:@"%d", (int)(blue*255)];


	if (red < 0.5 && blue < 0.5 && green < 0.5) {
		self.titleLabel.textColor = [UIColor whiteColor];
	} else {
		self.titleLabel.textColor = [UIColor blackColor];
	}
/*
	char bytes[5];
	bytes[0] = (char)61;
	bytes[1] = (char)(red*255);
	bytes[2] = (char)(green*255);
	bytes[3] = (char)(blue*255);
	bytes[4] = (char)0;
	NSData *data = [NSData dataWithBytes:bytes length:5];
	[self.arduinoControllerService sendData:data];
 */
    [self.arduinoControllerService setColorRed:red blue:green green:blue];
    
    
/*
	NSString *string = [NSString stringWithFormat:@"%@\r\n", @"hello"];
  NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
*/
	//[self.arduinoControllerService sendData:data];

}

- (IBAction)toneButtonPressed:(id)sender {

    [self.arduinoControllerService playTone:0];
}


@end
