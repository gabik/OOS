//
//  datePickerVC.h
//  MyService
//
//  Created by ohad shultz on 15/02/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewRequestVC.h"

@interface datePickerVC : UIViewController;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)changeTableView:(id)sender;

@end

