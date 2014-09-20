//
//  AppDelegate.h
//  LEDControl
//
//  Created by Rene Pirringer on 22.01.14.
//  Copyright (c) 2014 Rene Pirringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTInjector;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong) DTInjector *injector;
@end
