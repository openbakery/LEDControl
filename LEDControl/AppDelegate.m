//
//  AppDelegate.m
//  LEDControl
//
//  Created by Rene Pirringer on 22.01.14.
//  Copyright (c) 2014 Rene Pirringer. All rights reserved.
//

#import "AppDelegate.h"
#import "DTInjector.h"
#import "ArduinoControllerService.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[self configureInjector];

	NSString *storyboardName;
	if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)) {
		storyboardName = @"Main_iPhone";
	} else {
		storyboardName = @"Main_iPad";
	}
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];

	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	self.window.rootViewController = [storyboard instantiateInitialViewController];

	[self.window makeKeyAndVisible];


	return YES;
}


- (void)configureInjector {
	self.injector = [[DTInjector alloc] init];
	[self.injector registerProperty:@"arduinoControllerService" withInstance:[[ArduinoControllerService alloc] init]];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
