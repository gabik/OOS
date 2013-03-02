//
//  ViewControllerPro.h
//  MyService
//
//  Created by ohad kazav on 26/12/12.
//  Copyright (c) 2012 ohad kazav. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface  ViewControllerCarsDetailes: UIViewController
{

      IBOutlet UIButton *cameraButton;
}

@property (nonatomic,retain) UIButton *cameraButton;

-(IBAction)getCameraPicture:(id)sender;
-(IBAction)selectExitingPicture;

@end

