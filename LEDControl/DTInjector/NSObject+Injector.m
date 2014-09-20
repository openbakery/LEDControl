//
// ELO 
//
// Created by rene on 05.07.13.
// Copyright 2013 Drobnik.com. All rights reserved.
//
// 
//


#import "NSObject+Injector.h"
#import "DTInjector.h"


@implementation NSObject (Injector)


- (void)injectDependenciesTo:(NSObject *)injectTo {
	NSObject<UIApplicationDelegate> *delegate = [UIApplication sharedApplication].delegate;

	if ([delegate respondsToSelector:@selector(injector)]) {
		DTInjector *injector = (DTInjector *)[delegate valueForKey:@"injector"];
		[injector injectDependenciesTo:injectTo];
	}
	else
	{
		NSAssert(NO, @"delegate is not of expected class ELOAppDelegate");
	}
}

- (void)injectDependencies
{
	[self injectDependenciesTo:self];
}


@end