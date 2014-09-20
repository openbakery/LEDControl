//
// ELO 
//
// Created by rene on 05.07.13.
// Copyright 2013 Drobnik.com. All rights reserved.
//
// 
//


#import <Foundation/Foundation.h>

@interface NSObject (Injector)

- (void)injectDependenciesTo:(NSObject *)injectTo;
- (void)injectDependencies;

@end