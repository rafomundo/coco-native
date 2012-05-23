//
//  OptionsStore.h
//  Coco
//
//  Created by Rafomundo on 14.09.11.
//  Copyright 2011 Raphael Kuchta. All rights reserved.
//

#import <Foundation/Foundation.h>

// keys for values in UserDefaults
#define HEX_SHARP_KEY @"hexSharp"
#define CMYK_PERCENT_KEY @"cmykPercent"


@interface OptionsStore : NSObject {
	// no ivars
}

+ (void)saveValue:(BOOL)value forKey:(NSString *)key;
+ (BOOL)getValueForKey:(NSString *)key;

@end
