//
//  ViewController.h
//  MyService
//
//  Created by ohad kazav on 26/12/12.
//  Copyright (c) 2012 ohad kazav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIGestureRecognizerDelegate, UITextFieldDelegate>;

- (IBAction)signUp:(id)sender;
- (IBAction)SignIn;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) IBOutlet UITableView *signInTable;
@property (strong, nonatomic) IBOutlet UIButton *ProviderSignupButton;
- (IBAction)ProviderSignup:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *signIn;
@end
