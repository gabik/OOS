//
//  UserSignupVC.h
//  MyService
//
//  Created by ohad shultz on 02/03/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserSignupVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>;
@property (strong, nonatomic) IBOutlet UITableView *SignUpTable;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;
- (IBAction)tapRecognition:(id)sender;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIButton *datePickerDoneButton;
- (IBAction)endSelectingDate:(id)sender;

@end