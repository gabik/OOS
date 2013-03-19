//
//  UserSignupVC.m
//  MyService
//
//  Created by ohad shultz on 02/03/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//

#import "UserSignupVC.h"
#import <QuartzCore/QuartzCore.h>
#import "DAL.h"



@interface  UserSignupVC()

@end

@implementation UserSignupVC
@synthesize SignUpTable;
@synthesize tapRecognizer;
@synthesize datePicker;
@synthesize datePickerDoneButton;

NSArray *parametersNameArray;
NSArray *parametersArray;
NSMutableArray *valuesArray;
UIView *datePickerView;
UIDatePicker *datePicker;
UIPickerView *pickerView;
NSDictionary *areaDictionary;

float cellHight;
float hightDiffrecne;
float keyboardPosition;
bool isTableUp;

- (void)viewDidLoad
{
    [super viewDidLoad];

    keyboardPosition = [self.view frame].size.height -216-70;
    isTableUp = NO;
    parametersArray = [[NSArray alloc]initWithObjects:@"User Name",@"Email",@"Password",@"Verify Password",@"First Name",@"Last Name",@"Phone Number",@"Extra Phone Number",@"Address", @"Birthday",@"Area", nil];
    
    parametersNameArray =[[NSArray alloc]initWithObjects:@"username",@"email",@"password1",@"password2",@"firstname",@"lastname",@"phone_num1",@"phone_num2",@"address",@"birthday",@"area_id",@"level",nil];
    //create the right upper button.
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Signup!"
                                                                    style:UIBarButtonSystemItemDone target:self action:@selector(postSignUp)];
    self.navigationItem.rightBarButtonItem = rightButton;
    // alloc pickerview
    pickerView = [[UIPickerView alloc]init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    //get Area_id dictionary from server
    areaDictionary = [[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:@"1",@"2",@"3",nil] forKeys:[NSArray arrayWithObjects:@"merkaz",@"darom",@"zafon",nil]];
}

-(void)viewDidAppear:(BOOL)animated
{
    //create and add the datepicker.
    [datePicker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
    //add the datePickerView to self.    
}
-(void)postSignUp
{
    [UIView animateWithDuration:0.25f animations:^{datePickerView.frame = CGRectMake(100, 100, self.view.frame.size.width, datePickerView.frame.size.height);}];
    //TODO: create valuesArray.
    //
    valuesArray = [[NSMutableArray alloc]init];
    for (int i=0; i<[parametersArray count]; i++)
    {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
        UITextField *textField = (UITextField *)[[[SignUpTable cellForRowAtIndexPath:ip]accessoryView] viewWithTag:i];
        if(textField.text.length >0)
        {
            if(i==10)
            {
                [valuesArray addObject:[areaDictionary valueForKey:[textField text]]];
            }
            else
            {
                [valuesArray addObject:[textField text]];
            }
        }
        else
        {
            [valuesArray addObject:@"NULL"];
        }
    }
    //BOOL signUpUser = [DAL userSignup:valuesArray parametersArray:parametersNameArray];
  
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return [parametersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = globalMainTextColor;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [parametersArray objectAtIndex:indexPath.row];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, (SignUpTable.frame.size.width/2), cell.frame.size.height/2)];
    textField.placeholder = [parametersArray objectAtIndex:indexPath.row];
    textField.delegate = self;
    [textField setReturnKeyType:UIReturnKeyDone];
    textField.font = [UIFont systemFontOfSize:12];
    textField.textColor = [UIColor blueColor];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.borderColor = [[UIColor grayColor]CGColor];
    textField.layer.borderWidth = 1.0;
    [textField.layer setCornerRadius:8.0f];
    [textField.layer setMasksToBounds:YES];
    textField.tag = indexPath.row;
    if (indexPath.row == 9)
    {
        textField.inputView = datePicker;
        textField.inputAccessoryView = datePickerDoneButton;
    }
    else if (indexPath.row == 10)
    {
        textField.inputView = pickerView;
        textField.inputAccessoryView = datePickerDoneButton;
    }
    cell.accessoryView = textField;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)   indexPath{
    cellHight = ([SignUpTable frame].size.height-20)/[parametersArray count];
    return cellHight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    float originalPosition = (cellHight*(textField.tag+1));
    float currentPosition = SignUpTable.frame.origin.y+originalPosition;
    NSLog(@"the original position is %f, the current position is %f",originalPosition,currentPosition);
    if((originalPosition-keyboardPosition)>0)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:NO];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.25f];
        float hightDiff = currentPosition-keyboardPosition;
        SignUpTable.frame = CGRectMake(SignUpTable.frame.origin.x, SignUpTable.frame.origin.y-hightDiff, SignUpTable.frame.size.width, SignUpTable.frame.size.height);
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:NO];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.52f];
        SignUpTable.frame = CGRectMake(SignUpTable.frame.origin.x, 0, SignUpTable.frame.size.width, SignUpTable.frame.size.height);
        [UIView commitAnimations];
    }
    switch (textField.tag)
    {
        case 1:
            [textField setKeyboardType:UIKeyboardTypeEmailAddress];
            break;
        case 6:
            [textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            break;
        case 7:
            [textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            break;
        case 9:
            datePicker.maximumDate = [NSDate date];
            datePicker.hidden = NO;
            break;
        default:
            break;
    }
    //    if (!isTableUp) {
    //        float cellPosition = (cellHight*(textField.tag+1));
    //
    //        hightDiffrecne = (cellPosition - keyboardPosition);
    //        if (hightDiffrecne > 0)
    //        {
    //            SignUpTable.frame = CGRectMake(SignUpTable.frame.origin.x, SignUpTable.frame.origin.y-hightDiffrecne, SignUpTable.frame.size.width, SignUpTable.frame.size.height);
    //            [UIView commitAnimations];
    //            isTableUp = YES;
    //        }
    //    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSIndexPath *ip = [NSIndexPath indexPathForRow:textField.tag+1 inSection:0];
    UITextField *nexttextField = (UITextField *)[[[SignUpTable cellForRowAtIndexPath:ip]accessoryView] viewWithTag:textField.tag+1];
    [nexttextField becomeFirstResponder];
    return YES;
}

-(void)pickerChanged:(id)sender
{
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[areaDictionary allKeys]count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        tView.font = [UIFont systemFontOfSize:16.0];
        tView.textColor = globalMainTextColor;
        tView.textAlignment = NSTextAlignmentCenter;
        tView.backgroundColor = [UIColor clearColor];
    }
    // Fill the label text here
    tView.text = [[areaDictionary allKeys] objectAtIndex:row];
    return tView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)tapRecognition:(id)sender
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [SignUpTable setFrame:CGRectMake(0, 0, SignUpTable.frame.size.width, SignUpTable.frame.size.height)];
}
- (IBAction)endSelectingDate:(id)sender
{
    //go to specific textField.
    NSIndexPath *ip = [NSIndexPath indexPathForRow:9 inSection:0];
    UITextField *textField = (UITextField *)[[[SignUpTable cellForRowAtIndexPath:ip]accessoryView] viewWithTag:9];
    
    if ([textField isFirstResponder])
    {
    //create date string from datepicker.
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:[datePicker date]];
    //write the date in table.
    textField.text = stringFromDate;
    
    //go to next text field.
     ip = [NSIndexPath indexPathForRow:10 inSection:0];
     textField = (UITextField *)[[[SignUpTable cellForRowAtIndexPath:ip]accessoryView] viewWithTag:10];
    [textField becomeFirstResponder];
    }
    else
    {
    ip = [NSIndexPath indexPathForRow:10 inSection:0];
    textField = (UITextField *)[[[SignUpTable cellForRowAtIndexPath:ip]accessoryView] viewWithTag:10];
        if ([textField isFirstResponder])
        {
            textField.text = [[areaDictionary allKeys]objectAtIndex:[pickerView selectedRowInComponent:0]];
            [SignUpTable setFrame:CGRectMake(0, 0, SignUpTable.frame.size.width, SignUpTable.frame.size.height)];
            [textField resignFirstResponder];
        }
    }
}
@end
