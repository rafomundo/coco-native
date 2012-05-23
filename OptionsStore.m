//
//  OptionsStore.m
//  Coco
//
//  Created by Rafomundo on 14.09.11.
//  Copyright 2011 Raphael Kuchta. All rights reserved.
//

#import "OptionsStore.h"


@implementation OptionsStore


/**
 *	Saves the value for a given key to the user defaults.
 *
 *	@param	value	{BOOL}		The bool value we want to save
 *	@param	key		{NSString*}	The key we want to assosiate with this value (see define constants)
 */
+ (void)saveValue:(BOOL)value forKey:(NSString *)key {
	// get user defaults object
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	// save new settings
	[defaults setBool:value forKey:key];
	// save defaults back to disk
	[defaults synchronize];
}

/**
 *	Loads the value for a given key from the user defaults.
 *
 *	@param	key		{NSString*}	The key for the saved value
 *
 *	@return			{BOOL}		The bool value for the given key
 */
+ (BOOL)getValueForKey:(NSString *)key {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults boolForKey:key];
}

@end
