//
//  datePickerVC.c
//  MyService
//
//  Created by ohad shultz on 15/02/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//

//
//  BusinessNewRequestVC.m
//  MyService
//
//  Created by ohad kazav on 14/02/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//

#import "datePickerVC.h"
#import "NewRequestVC.h"

@interface datePickerVC()

@end

@implementation datePickerVC
@synthesize datePicker;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:userEndDate];
    [datePicker setDate:dateFromString];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonSystemItemDone target:self action:@selector(backToNewRequestVC)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeTableView:(id)sender {

}
-(void)backToNewRequestVC
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:[datePicker date]];
    userEndDate = stringFromDate;
    [self.navigationController popViewControllerAnimated:YES];
}
@end

