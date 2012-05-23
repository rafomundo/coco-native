//
//  MainViewController.h
//  Coco
//
//  Created by Raphael Kuchta on 23.08.11.
//  Copyright 2011 Raphael Kuchta. All rights reserved.
//

#import "FlipsideViewController.h"
#import <Foundation/Foundation.h>
#import "Coco.h"



#define VIEW_MOVE_RANGE 80
#define VIEW_MOVE_ANIMATION_TIME 0.4f

@interface MainViewController : UIViewController 
<FlipsideViewControllerDelegate> {
	
	IBOutlet UITextField *rgbR;
	IBOutlet UITextField *rgbG;
	IBOutlet UITextField *rgbB;
	
	IBOutlet UITextField *cmykC;
	IBOutlet UITextField *cmykM;
	IBOutlet UITextField *cmykY;
	IBOutlet UITextField *cmykK;
	
	IBOutlet UITextField *hex;
	
	IBOutlet UITextView *colorDemo;
}

@property (nonatomic, retain) IBOutlet UITextField *rgbR;
@property (nonatomic, retain) IBOutlet UITextField *rgbG;
@property (nonatomic, retain) IBOutlet UITextField *rgbB;

@property (nonatomic, retain) IBOutlet UITextField *cmykC;
@property (nonatomic, retain) IBOutlet UITextField *cmykM;
@property (nonatomic, retain) IBOutlet UITextField *cmykY;
@property (nonatomic, retain) IBOutlet UITextField *cmykK;

@property (nonatomic, retain) IBOutlet UITextField *hex;

@property (nonatomic, retain) IBOutlet UITextView *colorDemo;


- (IBAction)showInfo:(id)sender;
- (IBAction)hideKeyboard:(id)sender;

- (IBAction)rgbChanged:(id)sender;
- (IBAction)cmykChanged:(id)sender;
- (IBAction)hexChanged:(id)sender;

- (IBAction)hexEditStarted:(id)sender;
- (void)moveView:(BOOL)move;

- (void)updateColorDemo:(NSArray *)rgbColor;


@end

