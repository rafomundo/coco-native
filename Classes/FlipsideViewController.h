//
//  FlipsideViewController.h
//  Coco
//
//  Created by Raphael Kuchta on 23.08.11.
//  Copyright 2011 Raphael Kuchta. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UIViewController {
	id <FlipsideViewControllerDelegate> delegate;
	IBOutlet UISwitch *hexSharp;
	IBOutlet UISwitch *cmykPercent;
}

@property (nonatomic, retain) IBOutlet UISwitch *hexSharp;
@property (nonatomic, retain) IBOutlet UISwitch *cmykPercent;

- (IBAction) hexSharpSwitchChanged:(id)sender;
- (IBAction) cmykPercentSwitchChanged:(id)sender;


@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
- (IBAction)done:(id)sender;
@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

