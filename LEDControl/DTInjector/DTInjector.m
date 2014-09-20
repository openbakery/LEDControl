//
// ELO 
//
// Created by rene on 05.07.13.
// Copyright 2013 Drobnik.com. All rights reserved.
//
// 
//


#import <objc/runtime.h>
#import "DTInjector.h"


@implementation DTInjector
{
	NSMutableDictionary *_registeredProperties;
}



- (id)init {
	self = [super init];
	if (self) {
		_registeredProperties = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)injectDependenciesTo:(NSObject *)injectTo
{

	[_registeredProperties enumerateKeysAndObjectsUsingBlock:^(NSString* key, id<NSObject> object, BOOL *stop)
	{

		objc_property_t propertyClass = class_getProperty([injectTo class], [key UTF8String]);
		if (propertyClass != NULL)
		{
			const char *type = property_getAttributes(propertyClass);
			NSString *typeString = [NSString stringWithUTF8String:type];
			NSArray *attributes = [typeString componentsSeparatedByString:@","];
			NSString *typeAttribute = [attributes objectAtIndex:0];

			if ([typeAttribute hasPrefix:@"T@\""])
			{
				NSString *type = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length] - 4)];
				Class objectClass = NSClassFromString(type);
				if ([object isKindOfClass:objectClass])
				{
					[injectTo setValue:object forKey:key];
				}
			}

		}
	}];
}


- (void)registerProperty:(NSString *)property withInstance:(id <NSObject>)instance
{
	[_registeredProperties setObject:instance forKey:property];
}



@end