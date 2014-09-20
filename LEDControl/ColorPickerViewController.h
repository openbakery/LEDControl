//
//  ColorPickerViewController.h
//  LEDControl
//
//  Created by Rene Pirringer on 22.01.14.
//  Copyright (c) 2014 Rene Pirringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArduinoControllerService;

@interface ColorPickerViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) IBOutlet UIView *colorView;

@property (nonatomic, strong) IBOutlet UILabel *redLabel;
@property (nonatomic, strong) IBOutlet UILabel *greenLabel;
@property (nonatomic, strong) IBOutlet UILabel *blueLabel;

@property (nonatomic, strong) IBOutlet UILabel *redValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *greenValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *blueValueLabel;

@property (nonatomic, strong) IBOutlet UISlider *redSlider;
@property (nonatomic, strong) IBOutlet UISlider *greenSlider;
@property (nonatomic, strong) IBOutlet UISlider *blueSlider;


@property(nonatomic, strong) UIColor *color;


@property (nonatomic, strong) ArduinoControllerService *arduinoControllerService;

@end
