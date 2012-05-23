//
//  FlipsideViewController.m
//  Coco
//
//  Created by Raphael Kuchta on 23.08.11.
//  Copyright 2011 Raphael Kuchta. All rights reserved.
//

#import "FlipsideViewController.h"
#import "OptionsStore.h"


@implementation FlipsideViewController

@synthesize delegate;

@synthesize hexSharp, cmykPercent;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	// load saved default values
	hexSharp.on = [OptionsStore getValueForKey:HEX_SHARP_KEY];
	cmykPercent.on = [OptionsStore getValueForKey:CMYK_PERCENT_KEY];
	
    //self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];      
}


- (IBAction)done:(id)sender {
	[self.delegate flipsideViewControllerDidFinish:self];	
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

// update saved defaults on hex switch change
- (IBAction)hexSharpSwitchChanged:(id)sender {
	// hexSharp.on could be YES, NO, or undefined
	// (so we check explicit if it is YES)
	[OptionsStore saveValue:(hexSharp.on == YES) forKey:HEX_SHARP_KEY];
}

// update saved defaults on cmyk switch change
- (IBAction)cmykPercentSwitchChanged:(id)sender {
	// cmykPercent.on could be YES, NO, or undefined
	[OptionsStore saveValue:(cmykPercent.on == YES) forKey:CMYK_PERCENT_KEY];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
	[hexSharp release];
	[cmykPercent release];
    [super dealloc];
}


@end
