//
//  MainViewController.m
//  Coco
//
//  Created by Raphael Kuchta on 23.08.11.
//  Copyright 2011 Raphael Kuchta. All rights reserved.
//

#import "MainViewController.h"


@implementation MainViewController

@synthesize rgbR, rgbG, rgbB;
@synthesize cmykC, cmykM, cmykY, cmykK;
@synthesize hex;
@synthesize colorDemo;


- (void)viewDidLoad {
	[super viewDidLoad];
}


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}

/**
 *	Switch to the options menue view.
 */
- (IBAction)showInfo:(id)sender {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

/**
 *	Hides the keyboard if user taps on background.
 *	(So no text fields are under the keyboard.)
 */
- (IBAction)hideKeyboard:(id)sender {
	
	[rgbR resignFirstResponder];
	[rgbG resignFirstResponder];
	[rgbB resignFirstResponder];
	
	[cmykC resignFirstResponder];
	[cmykM resignFirstResponder];
	[cmykY resignFirstResponder];
	[cmykK resignFirstResponder];
	
	[hex resignFirstResponder];
}


/**
 *	One of the RGB values has been changed.
 *	Convert rgb to cmyk, and hex. And update the text fields with the new values,
 *	and the color in the color demo area.
 */
- (IBAction)rgbChanged:(id)sender {
	// first validate the textfields and make them valid
	NSString *sValidRgbR = [Coco makeValidRgb:[rgbR text]];
	NSString *sValidRgbG = [Coco makeValidRgb:[rgbG text]];
	NSString *sValidRgbB = [Coco makeValidRgb:[rgbB text]];
	
	// pass the valid rgb value string back to the textfields
	[rgbR setText:sValidRgbR];
	[rgbG setText:sValidRgbG];
	[rgbB setText:sValidRgbB];
	
	// build an array with all 3 rgb values to pass them as one argument to the converting methods
	NSArray *aRgb = [NSArray arrayWithObjects:sValidRgbR, sValidRgbG, sValidRgbB, nil];
	
	// convert rgb to cmyk
	NSArray *aCmyk = [Coco rgb2cmyk:aRgb];
	
	// output the cmyk values
	[cmykC setText:[aCmyk objectAtIndex:0]];
	[cmykM setText:[aCmyk objectAtIndex:1]];
	[cmykY setText:[aCmyk objectAtIndex:2]];
	[cmykK setText:[aCmyk objectAtIndex:3]];
	
	// convert rgb to hex
	NSString * sHex = [Coco rgb2hex:aRgb];
	
	// output the hex value
	[hex setText:sHex];
	
	// update the color in the demo area
	[self updateColorDemo:aRgb];
}

/**
 *	One of the CMYK values has been changed.
 *	The cmyk value will be converted to rgb, and the rgb value will be convertet to hex.
 *	Than we update the input fields with the new values,
 *	and also update the color demo area to show the resulting color to the user.
 */
- (IBAction)cmykChanged:(id)sender {
	// validate the values and make them valid, if they are not
	NSString *sValidCmykC = [Coco makeValidCmyk:[cmykC text]];
	NSString *sValidCmykM = [Coco makeValidCmyk:[cmykM text]];
	NSString *sValidCmykY = [Coco makeValidCmyk:[cmykY text]];
	NSString *sValidCmykK = [Coco makeValidCmyk:[cmykK text]];
	
	// pass the validated strings back to th textfields
	[cmykC setText:sValidCmykC];
	[cmykM setText:sValidCmykM];
	[cmykY setText:sValidCmykY];
	[cmykK setText:sValidCmykK];
	
	// create an array containing the cmyk values
	NSArray *aCmyk = [NSArray arrayWithObjects:sValidCmykC, sValidCmykM, sValidCmykY, sValidCmykK, nil];
	
	// convert cmyk to rgb
	NSArray *aRgb = [Coco cmyk2rgb:aCmyk];
	
	// output the rgb values
	[rgbR setText:[aRgb objectAtIndex:0]];
	[rgbG setText:[aRgb objectAtIndex:1]];
	[rgbB setText:[aRgb objectAtIndex:2]];
	
	// convert the rgb values to hex
	NSString *sHex = [Coco rgb2hex:aRgb];
	
	// output the hex value
	[hex setText:sHex];
	
	// update the color in the demo area
	[self updateColorDemo:aRgb];
}


/**
 *	User finished editing the HEX value,
 *	lets convert the new hex value to rgb, and the rgb value to cmyk.
 *	Than output the new values to the text fields and also update the demo of the resulting color.
 */
- (IBAction)hexChanged:(id)sender {
	
	// move the view back to its original position
	[self moveView: NO];
	
	// validate the hex value and make it valid, if it is not
	//[sender setText:[Coco makeValidHex:[sender text]]];
	NSString *sValidHex = [Coco makeValidHex:[sender text]];
	if (sValidHex == WRONG_HEX_INPUT) {
		// user entered a totaly wrong hex value, show him an error message
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fehler"
														message:@"Der HEX Wert kan mit # beginnen und muss 6, oder 3 Zeichen lang sein."
													   delegate:nil
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	// output valid hex value
	[sender setText:sValidHex];
	
	// convert the hex value to rgb values
	NSArray *aRgb = [Coco hex2rgb:sValidHex];
	
	// output the rgb values
	[rgbR setText:[aRgb objectAtIndex:0]];
	[rgbG setText:[aRgb objectAtIndex:1]];
	[rgbB setText:[aRgb objectAtIndex:2]];
	
	// convert the rgb values to cmyk values
	NSArray *aCmyk = [Coco rgb2cmyk:aRgb];
	
	// output the cmyk values
	[cmykC setText:[aCmyk objectAtIndex:0]];
	[cmykM setText:[aCmyk objectAtIndex:1]];
	[cmykY setText:[aCmyk objectAtIndex:2]];
	[cmykK setText:[aCmyk objectAtIndex:3]];
	
	// update the color in the demo area
	[self updateColorDemo:aRgb];
}

/**
 *	Updates the color in the demo area
 *
 *	@param	{NSArray*}	The color as RGB value in an array
 */
- (void)updateColorDemo:(NSArray *)rgbColor {
	
	// create UIColor object (the values need to be converted from rgb (0-255) to CGFloat (0.0 - 1.0)
	UIColor *color = [UIColor colorWithRed:[Coco rgb2cgfloat:[[rgbColor objectAtIndex:0] intValue]] 
									 green:[Coco rgb2cgfloat:[[rgbColor objectAtIndex:1] intValue]] 
									  blue:[Coco rgb2cgfloat:[[rgbColor objectAtIndex:2] intValue]] 
									 alpha:1.0f];
	
	// set the new color for the background
	[colorDemo setBackgroundColor:color];
}


/**
 *	User is editing the HEX value, move the view, so he can see the text field
 */
- (IBAction)hexEditStarted:(id)sender {
	[self moveView:YES];
}


/**
 *	Moves the view up, if user is editing the HEX value,
 *	(so he can see what he is typing),
 *	and moves it back, if the user finished typing
 *
 *	@param	{BOOL}	move	Move the view up (YES) or down (NO)?
 */
- (void)moveView:(BOOL)move {
	
	// determin if we move the view up, or down
	int move_dir = (move ? -VIEW_MOVE_RANGE : VIEW_MOVE_RANGE);
	// move the view smooth up, or down
    [UIView beginAnimations: @"moveView" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: VIEW_MOVE_ANIMATION_TIME];
    self.view.frame = CGRectOffset(self.view.frame, 0, move_dir);
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[super viewDidUnload];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (void)dealloc {
	[rgbR release];
	[rgbG release];
	[rgbB release];
	
	[cmykC release];
	[cmykM release];
	[cmykY release];
	[cmykK release];
	
	[hex release];
	
	[colorDemo release];
	
    [super dealloc];
}

@end
