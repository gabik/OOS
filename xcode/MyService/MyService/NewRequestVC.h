//
//  NewRequestVC.h
//  MyService
//
//  Created by ohad shultz on 07/02/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  NewRequestVC: UIViewController <UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>;

-(IBAction)TakeNewPhoto:(id)sender;
-(IBAction)SelectExistingPicture:(id)sender;

@property (strong, nonatomic) IBOutlet UIPickerView *infoPicker;
@property (strong, nonatomic) IBOutlet UITableView *infoTable;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property NSInteger *currentIndex;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeGustereReco;
@property (strong, nonatomic) IBOutlet UIView *secondView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITableView *valuesTable;
@property (strong, nonatomic) IBOutlet UIImageView *swipeImage;
@property (strong, nonatomic) IBOutlet UIImageView *swipeImage2;
@property (strong, nonatomic) IBOutlet UILabel *SwipeLabel;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *FreeText;
@property (strong, nonatomic) IBOutlet NSArray *infoArray;
@end