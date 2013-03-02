//
//  Header.h
//  MyService
//
//  Created by ohad kazav on 26/12/12.
//  Copyright (c) 2012 ohad kazav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerCars : UIViewController
{
    IBOutlet UITextField *manText;
    IBOutlet UITextField *yearText;
    IBOutlet UITextField *modelText;
    IBOutlet UIButton *cameraButton;
    
}

@property (nonatomic,retain) UIButton *cameraButton;
@property (nonatomic,retain) UITextField *manText;
@property (nonatomic,retain) UITextField *yearText;
@property (nonatomic,retain) UITextField *modelText;

//-(IBAction)screentouch:(id)sender;
//-(IBAction)getCameraPicture:(id)sender;
//-(IBAction)selectExitingPicture;
//-(IBAction)textFieldFinished:(id)sender;
//- (void)textFieldDidBeginEditing:(UITextField *)textField;
@end





