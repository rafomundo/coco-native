//
//  Coco.m
//  Coco
//
//  Created by Raphael Kuchta on 23.08.11.
//  Copyright 2011 Raphael Kuchta. All rights reserved.
//

#import "Coco.h" 


@implementation Coco

/**
 *	Returns a valid single rgb value from a given string
 *
 *	@param	rgbString	{NSString*}	Single rgb value
 *
 *	@return				{NSString*}	The valid single rgb value
 */
+ (NSString *)makeValidRgb:(NSString *)rgbString {
	// extract the integer value from the string
	NSInteger iValidRgb = [rgbString integerValue];
	
	// if the value is out of the rgb range (0 - 255), set it to the lowest, or highest rgb value
	if (iValidRgb < 0) {
		return [NSString stringWithFormat:@"%d", 0];
	}
	if (iValidRgb > 255) {
		return [NSString stringWithFormat:@"%d", 255];
	}
	return [NSString stringWithFormat:@"%d", iValidRgb];
}


/**
 *	Returns a valid single cmyk value from a given string
 *
 *	@param	cmykString	{NSString*}	Single cmyk value
 *
 *	@return				{NSString*}	The valid single cmyk value
 */
+ (NSString *)makeValidCmyk:(NSString *)cmykString {
	// replace ',' with '.' 
	cmykString = [cmykString stringByReplacingOccurrencesOfString:@"," withString:@"."];
	
	// extract the float value from the string
	float fValidCmyk = [cmykString floatValue];
	
	if ([Coco isCmykPercent]) {
		if (fValidCmyk < 0) return @"0 %";
		if (fValidCmyk > 100) return @"100 %";
		return [NSString stringWithFormat:@"%.0f %%", fValidCmyk];
	}
	else {
		// if the value is out of the cmyk range (0 - 1) set it to the lowest, or highest cmyk value
		if (fValidCmyk < 0.0) return @"0.000";
		if (fValidCmyk > 1.0) return @"1.000";
		return [NSString stringWithFormat:@"%.3f", fValidCmyk];
	}
}


/**
 *	Returns a valid hex value from a given string
 *
 *	@param	hexString	{NSString*}	The hex value
 *
 *	@return				{NSString*}	The valid hex value
 */
+ (NSString *)makeValidHex:(NSString *)sHex {
	
	// exit if string is empty
	if ([sHex length] == 0) {
		return WRONG_HEX_INPUT;
	}
	
	// remove the # character
	if ([sHex characterAtIndex:0] == '#') {
		sHex = [sHex substringWithRange:NSMakeRange(1, [sHex length] - 1)];
	}
	
		
	// extend the hex string
	if ([sHex length] == 3) {
		sHex = [NSString stringWithFormat:@"%C%C%C%C%C%C",
					 [sHex characterAtIndex:0],
					 [sHex characterAtIndex:0],
					 [sHex characterAtIndex:1],
					 [sHex characterAtIndex:1],
					 [sHex characterAtIndex:2],
					 [sHex characterAtIndex:2]];
	}
	// or trim the hex string if it is too long
	else if ([sHex length] > 6) {
		sHex = [sHex substringWithRange:NSMakeRange(0, 6)];
	}
	
	// now validate the hex string
	NSString *regexp = @"[0-9abcdefABCDEF]{6}";
	NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexp];
	
	// exit if test failed
	if ([test evaluateWithObject:sHex] == NO) {
		return WRONG_HEX_INPUT;
	}
	
	// change the hex string to upper case
	sHex = [sHex uppercaseString]; 
	
	// return the hex value with # symbol if user set the option
	if ([Coco isHexSharp]) {
		return [NSString stringWithFormat:@"#%@", sHex];
	}
	return sHex;
}


/**
 *	Converts rgb values to cmyk values.
 *	(Both values are stored in arrays.)
 *
 *	@param	aRgb	{NSArray*}	An array containing the rgb values
 *
 *	@return			{NSArray*}	An array containing the cmyk values
 */
+ (NSArray *)rgb2cmyk:(NSArray *)aRgb {
	
	// extract the float values from the strings in the array
	float fC = 1 - ([[aRgb objectAtIndex:0] floatValue] / 255);
	float fM = 1 - ([[aRgb objectAtIndex:1] floatValue] / 255);
	float fY = 1 - ([[aRgb objectAtIndex:2] floatValue] / 255);
	float fK = 1;
	
	// set fK (black) to smallest color value
	if (fC < fK) fK = fC;
	if (fM < fK) fK = fM;
	if (fY < fK) fK = fY;
	
	// pure black?
	if (fK == 1) {
		fC = 0;
		fM = 0;
		fY = 0;
	}
	else {
		// cmy -> cmyk
		fC = (fC - fK) / (1 - fK);
		fM = (fM - fK) / (1 - fK);
		fY = (fY - fK) / (1 - fK);
	}
	NSString *sC;
	NSString *sM;
	NSString *sY;
	NSString *sK;
	
	// make string objects from the float values 
	if ([Coco isCmykPercent]) {
		sC = [NSString stringWithFormat:@"%.0f %%", (fC * 100)];
		sM = [NSString stringWithFormat:@"%.0f %%", (fM * 100)];
		sY = [NSString stringWithFormat:@"%.0f %%", (fY * 100)];
		sK = [NSString stringWithFormat:@"%.0f %%", (fK * 100)];
	}
	else {
		sC = [NSString stringWithFormat:@"%.3f", fC];
		sM = [NSString stringWithFormat:@"%.3f", fM];
		sY = [NSString stringWithFormat:@"%.3f", fY];
		sK = [NSString stringWithFormat:@"%.3f", fK];
	}
	// put the string objects in an array to return it to the caller
	NSArray *aCmyk = [NSArray arrayWithObjects:sC, sM, sY, sK, nil];
	
	//[aCmyk autorelease];
	
	return aCmyk;
}

/**
 *	Converts cmyk values to rgb values.
 *	Both values are stored in arrays
 *
 *	@param	aCmyk	{NSArray*}	An array containing the cmyk values
 *
 *	@return			{NSArray*}	An array containing the rgb values
 */
+ (NSArray *)cmyk2rgb:(NSArray *)aCmyk {
	// extract float values from string objects
	float fC = [[aCmyk objectAtIndex:0] floatValue];
	float fM = [[aCmyk objectAtIndex:1] floatValue];
	float fY = [[aCmyk objectAtIndex:2] floatValue];
	float fK = [[aCmyk objectAtIndex:3] floatValue];
	
	// if we used percent values compute them back to float values
	if ([Coco isCmykPercent]) {
		fC = fC / 100;
		fM = fM / 100;
		fY = fY / 100;
		fK = fK / 100;
	}
	
	// convert cmyk to cmy
	fC = fC * (1 - fK) + fK;
	fM = fM * (1 - fK) + fK;
	fY = fY * (1 - fK) + fK;
	
	// convert cmy to rgb and store them in string objects
	NSString *sR = [NSString stringWithFormat:@"%d", lroundf((1 - fC) * 255)];
	NSString *sG = [NSString stringWithFormat:@"%d", lroundf((1 - fM) * 255)];
	NSString *sB = [NSString stringWithFormat:@"%d", lroundf((1 - fY) * 255)];
	
	// create array with rgb values 
	NSArray *aRgb = [NSArray arrayWithObjects:sR, sG, sB, nil];
	
	return aRgb;
}

/**
 *	Converts rgb values to hex values.
 *
 *	@param	aRgb	{NSArray*}	An array containing the rgb values
 *
 *	@return			{NSString*} A string containing the hex value
 */
+ (NSString *)rgb2hex:(NSArray *)aRgb {
	
	// extract the rgb integer values from the string objects in the array
	NSUInteger iR = [[aRgb objectAtIndex:0] integerValue];
	NSUInteger iG = [[aRgb objectAtIndex:1] integerValue];
	NSUInteger iB = [[aRgb objectAtIndex:2] integerValue];
	
	// format the hex values (so that we always get 2 characters long hex values as strings)
	NSString *sR, *sG, *sB;
	
	if (iR < 16) {
		sR = [NSString stringWithFormat:@"0%X", iR];
	}
	else {
		sR = [NSString stringWithFormat:@"%X", iR];
	}
	if (iG < 16) {
		sG = [NSString stringWithFormat:@"0%X", iG];
	}
	else {
		sG = [NSString stringWithFormat:@"%X", iG];
	}
	if (iB < 16) {
		sB = [NSString stringWithFormat:@"0%X", iB];
	}
	else {
		sB = [NSString stringWithFormat:@"%X", iB];
	}
	
	// concatenate the single hex values to a complete hex string
	NSString *sHex = [NSString stringWithFormat:@"%@%@%@", sR, sG, sB];

	// at the # sign if needed
	if ([Coco isHexSharp]) {
		sHex = [NSString stringWithFormat:@"#%@", sHex];
	}
	 
	return sHex;
}

/**
 *	Converts hex string objects to rgb values.
 *
 *	@param	sHex	{NSString*}	The hex string
 *
 *	@return			{NSArray*}	An array containing the rgb value in string objects
 */
+ (NSArray *)hex2rgb:(NSString *)sHex {
	// empty integer containers
	NSUInteger iR = 0;
	NSUInteger iG = 0;
	NSUInteger iB = 0;
	
	// remove the # symbol (string from makeValidHex has the form '#123456')
	if ([Coco isHexSharp]) {
		sHex = [sHex substringWithRange:NSMakeRange(1, 6)];
	}
	
	// extract the integer rgb value from the hex string
	NSScanner *scanner = [NSScanner scannerWithString:[sHex substringWithRange:NSMakeRange(0, 2)]];
	[scanner scanHexInt:&iR];
	
	scanner = [NSScanner scannerWithString:[sHex substringWithRange:NSMakeRange(2, 2)]];
	[scanner scanHexInt:&iG];
	
	scanner = [NSScanner scannerWithString:[sHex substringWithRange:NSMakeRange(4, 2)]];
	[scanner scanHexInt:&iB];
	
	// put the integer rgb values in string objects
	NSString *sR = [NSString stringWithFormat:@"%d", iR];
	NSString *sG = [NSString stringWithFormat:@"%d", iG];
	NSString *sB = [NSString stringWithFormat:@"%d", iB];
	
	// create an array containing the rgb values as string objects to return them
	NSArray *aRgb = [NSArray arrayWithObjects:sR, sG, sB, nil];
	
	return aRgb;
}

/**
 *	Converts single rgb values to from standard integer representation (0 - 255)
 *	to rgb values in cgfloat representation (0.0 - 1.0).
 *
 *	@param	iRGB	{NSInteger}	The single RGB value in integer representation
 *
 *	@return			{CGFloat}	The	RGB value in CGFloar representation
 */
+ (CGFloat)rgb2cgfloat:(NSInteger)iRgb {
	return (CGFloat)iRgb / 255.0f;
}

/**
 *	Tells us if we use the # symbol with hex colors.
 *
 *	@return {BOOL}	YES if we are using the # symbol, otherwise NO
 */
+ (BOOL)isHexSharp {
	return [OptionsStore getValueForKey:HEX_SHARP_KEY];
}

/**
 *	Tells us if we deal with cmyk values in percent (0 - 100) or float (0.0 - 1.0)
 *
 *	@return	{BOOL}	YES if we are using percent values for cmyk, otherwise NO
 */
+ (BOOL)isCmykPercent {
	return [OptionsStore getValueForKey:CMYK_PERCENT_KEY];
}


@end
