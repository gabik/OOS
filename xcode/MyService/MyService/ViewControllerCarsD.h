//
//  ViewControllerCarsD.h
//  MyService
//
//  Created by ohad kazav on 03/02/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerCarsD : UIViewController
{
    IBOutlet UITextView *DText; 
    IBOutlet UIButton *cameraButton;
}


@property (nonatomic,retain) UITextView *DText;
@property (nonatomic,retain) UIButton *cameraButton;





//-(IBAction)screentouch:(id)sender;
//-(IBAction)textViewFinished:(id)sender;
//-(IBAction)getCameraPicture:(id)sender;
//-(IBAction)selectExitingPicture;
//- (void)textViewDidBeginEditing:(UITextField *)textView;




@end