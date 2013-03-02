//
//  MoreVC.h
//  MyService
//
//  Created by ohad shultz on 01/03/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>

@interface MoreVC : UIViewController;
@property (strong, nonatomic) IBOutlet UIButton *TellFrindButton;

- (IBAction)DoneButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *PickerViewContainer;


@end
