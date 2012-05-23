//
//  Coco.h
//  Coco
//
//  Created by Raphael Kuchta on 23.08.11.
//  Copyright 2011 Raphael Kuchta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionsStore.h"


// error codes
#define WRONG_HEX_INPUT @"0"


@interface Coco : NSObject {
	// no ivars
}

+ (NSString *)makeValidRgb:(NSString *)rgbString;
+ (NSString *)makeValidCmyk:(NSString *)cmykString;
+ (NSString *)makeValidHex:(NSString *)hexString;

+ (NSArray *)rgb2cmyk:(NSArray *)aRgb;
+ (NSArray *)cmyk2rgb:(NSArray *)aCmyk;
+ (NSString *)rgb2hex:(NSArray *)aRgb;
+ (NSArray *)hex2rgb:(NSString *)sHex;

+ (CGFloat)rgb2cgfloat:(NSInteger)iRgb;

+ (BOOL)isHexSharp;
+ (BOOL)isCmykPercent;

@end
