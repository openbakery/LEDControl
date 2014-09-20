//
// ELO 
//
// Created by rene on 05.07.13.
// Copyright 2013 Drobnik.com. All rights reserved.
//
// 
//


#import <Foundation/Foundation.h>


@interface DTInjector : NSObject


- (void)injectDependenciesTo:(NSObject *)injectTo;

- (void)registerProperty:(NSString *)property withInstance:(id<NSObject>)instance;


@end