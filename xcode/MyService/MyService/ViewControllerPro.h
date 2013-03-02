//
//  ViewControllerPro.h
//  MyService
//
//  Created by ohad kazav on 26/12/12.
//  Copyright (c) 2012 ohad kazav. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface ViewControllerPro : UIViewController

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property(strong, nonatomic) NSMutableArray *arrayColors;
@property NSInteger indexPicker;
@end

