//
//  MoreVC.m
//  MyService
//
//  Created by ohad shultz on 01/03/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//

#import "MoreVC.h"
#import "Globals.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>



@interface MoreVC ()

@end

@implementation MoreVC
@synthesize TellFrindButton;
@synthesize PickerViewContainer;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
}

-(void) viewDidAppear:(BOOL)animated
{
    PickerViewContainer.frame = CGRectMake(0, 460, 320, 261);

}

-(IBAction)TellFrindButton:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    PickerViewContainer.frame = CGRectMake(0, [self.view frame].size.height-[PickerViewContainer frame].size.height, 320, 261);
    [UIView commitAnimations];
}

-(IBAction)DoneButton:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    PickerViewContainer.frame = CGRectMake(0, 460, 320, 261);
    [UIView commitAnimations];
}
    


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end










