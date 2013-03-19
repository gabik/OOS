//
//  ProviderSignup.m
//  MyService
//
//  Created by ohad shultz on 01/03/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//

#import "ProviderSignup.h"
#import <QuartzCore/QuartzCore.h>
#import "DAL.h"



@interface  ProviderSignup()

@end

@implementation ProviderSignup
@synthesize isClient;
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
UIToolbar* numberToolbar;
NSString *postTo;
NSInteger currentRow;
CGRect originTableFrame;
 
float cellHight;
float hightDiffrecne;
float keyboardPosition;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //MARK: coloring
    [SignUpTable setBackgroundColor:globalTableBgColor];
    [self.view setBackgroundColor:globalBgColor];
    //MARK: end coloring
    
    //set keyboard start position
    keyboardPosition = [self.view frame].size.height -216-70;
    
    //determine if need to show client table or provider table
    if (isClient)
    {
        parametersArray = [[NSArray alloc]initWithObjects:@"User Name",@"Email",@"Password",@"Verify Password",@"First Name",@"Last Name",@"Phone Number",@"Extra Phone Number",@"Address", @"Birthday",@"Area", nil];
        
        postTo = @"Pnew";
    }
    else
    {
        parametersArray = [[NSArray alloc]initWithObjects:@"Business Name",@"Email",@"Password",@"Verify Password",@"First Name",@"Last Name",@"Phone Number",@"Extra Phone Number",@"Address", @"Birthday",@"Area",@"Profession", nil];
    
        postTo = @"Pnew_prov";
    }
    //init values array
    valuesArray = [[NSMutableArray alloc]init];
    for (int i=0; i<parametersArray.count; i++)
    {
        [valuesArray addObject:@" "];
    }
    //init table frame
    originTableFrame = CGRectMake(SignUpTable.frame.origin.x, SignUpTable.frame.origin.y, SignUpTable.frame.size.width, SignUpTable.frame.size.height);
    //initiate the POST parameters, they are the same for client and provider.
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
    
    //create the customized done button for datePicker and pickerView
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(endSelectingDate:)],
                           nil];
    [numberToolbar sizeToFit];
}
-(void)viewDidAppear:(BOOL)animated
{
    //create and add the datepicker.
    [datePicker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];    
}
-(void)postSignUp
{

    //create valuesArray.
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
            [valuesArray addObject:@" "];
        }
    }
    
    //send signUp request and get the answer.
    BOOL signUpResult = [DAL Signup:valuesArray parametersArray:parametersNameArray postTo:postTo];
    if (signUpResult)
    {
        //if everything ok, go back to login screen.
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    cell.textLabel.textColor = globalMainTextColor;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    //cell.backgroundColor = [UIColor lightGrayColor];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, (SignUpTable.frame.size.width-30), cell.frame.size.height/5*3)];
    //cell.textLabel.text=[parametersArray objectAtIndex:indexPath.row];
    if ([[valuesArray objectAtIndex:indexPath.row] isEqual:@" "])
    {
        textField.placeholder = [parametersArray objectAtIndex:indexPath.row];
    }
    else
    {
        textField.text = [valuesArray objectAtIndex:indexPath.row];
    }
    textField.delegate = self;
    [textField setReturnKeyType:UIReturnKeyDone];
    textField.font = [UIFont systemFontOfSize:15];
    textField.textColor = [UIColor blueColor];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.backgroundColor = globalTextFieldBgColor;
    textField.layer.borderColor = [[UIColor clearColor]CGColor];
    textField.layer.borderWidth = 1.0;
    textField.returnKeyType = UIReturnKeyNext;
    [textField.layer setCornerRadius:8.0f];
    [textField.layer setMasksToBounds:YES];
    textField.tag = indexPath.row;
    if (indexPath.row ==1)
    {
        [textField setKeyboardType:UIKeyboardTypeEmailAddress];
    }
    else if (indexPath.row ==6 || indexPath.row==7)
    {
        [textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    }
    else if (indexPath.row == 9)
    {
        datePicker.maximumDate = [NSDate date];
        textField.inputView = datePicker;
        textField.inputAccessoryView = numberToolbar;
    }
    else if (indexPath.row == 10)
    {
        textField.inputView = pickerView;
        textField.inputAccessoryView = numberToolbar;
    }
    cell.accessoryView = textField;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)   indexPath{
    cellHight = 32;
    return cellHight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.25f];
    [SignUpTable setFrame:CGRectMake(SignUpTable.frame.origin.x, SignUpTable.frame.origin.y, SignUpTable.frame.size.width, self.view.frame.size.height-keyboardPosition-50)];
    [UIView commitAnimations];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentRow = textField.tag;
    if (currentRow == 9)
    {
        [datePicker setHidden:NO];
    }
    NSIndexPath *scrollToPath = [NSIndexPath indexPathForRow:currentRow-2 inSection:0];
    [SignUpTable scrollToRowAtIndexPath:scrollToPath atScrollPosition:UITableViewScrollPositionTop animated:NO];

//    float originalPosition = (cellHight*(textField.tag+1));
//    float currentPosition = SignUpTable.frame.origin.y+originalPosition;
//    NSLog(@"the original position is %f, the current position is %f",originalPosition,currentPosition);
//    if((originalPosition-keyboardPosition)>0)
//    {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationBeginsFromCurrentState:NO];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDuration:0.25f];
//        float hightDiff = currentPosition-keyboardPosition+50;
//        SignUpTable.frame = CGRectMake(SignUpTable.frame.origin.x, SignUpTable.frame.origin.y-hightDiff, SignUpTable.frame.size.width, SignUpTable.frame.size.height);
//        [UIView commitAnimations];
//    }
//    else
//    {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationBeginsFromCurrentState:NO];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDuration:0.52f];
//        SignUpTable.frame = CGRectMake(SignUpTable.frame.origin.x, 0, SignUpTable.frame.size.width, SignUpTable.frame.size.height);
//        [UIView commitAnimations];
//    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![textField.text isEqual:@""])
    {
        [valuesArray setObject:textField.text atIndexedSubscript:textField.tag];
    }
    if (textField.tag == [parametersArray count]-1)
    {
        SignUpTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        NSIndexPath *scrollip = [NSIndexPath indexPathForRow:0 inSection:0];
        [SignUpTable scrollToRowAtIndexPath:scrollip atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [textField resignFirstResponder];
    }
    else
    {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:textField.tag+1 inSection:0];
        UITextField *nexttextField = (UITextField *)[[[SignUpTable cellForRowAtIndexPath:ip]accessoryView] viewWithTag:textField.tag+1];
        [nexttextField becomeFirstResponder];
    }
    return YES;
}

-(void)pickerChanged:(id)selector
{
    UITextField *textField = [[UITextField alloc]init];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:currentRow inSection:0];
    textField = (UITextField *)[[[SignUpTable cellForRowAtIndexPath:ip]accessoryView] viewWithTag:currentRow];
    //create date string from datepicker.
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:[datePicker date]];
    //write the date in table.
    textField.text = stringFromDate;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UITextField *textField = [[UITextField alloc]init];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:currentRow inSection:0];
    textField = (UITextField *)[[[SignUpTable cellForRowAtIndexPath:ip]accessoryView] viewWithTag:currentRow];
    textField.text = [[areaDictionary allKeys]objectAtIndex:[pickerView selectedRowInComponent:0]];
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
    [SignUpTable setFrame:CGRectMake(SignUpTable.frame.origin.x, 0, SignUpTable.frame.size.width, SignUpTable.frame.size.height)];
}
- (IBAction)endSelectingDate:(id)sender
{
    //go to specific textField.
    NSIndexPath *ip = [NSIndexPath indexPathForRow:currentRow inSection:0];
    UITextField *textField = (UITextField *)[[[SignUpTable cellForRowAtIndexPath:ip]accessoryView] viewWithTag:currentRow];
    
    if ([textField isFirstResponder])
    {
        if (currentRow == 9)
        {
            //create date string from datepicker.
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *stringFromDate = [formatter stringFromDate:[datePicker date]];
            //write the date in table.
            textField.text = stringFromDate;
            //update valueArray.
            [valuesArray setObject:stringFromDate atIndexedSubscript:currentRow];
            //go to next text field.
            ip = [NSIndexPath indexPathForRow:10 inSection:0];
            textField = (UITextField *)[[[SignUpTable cellForRowAtIndexPath:ip]accessoryView] viewWithTag:10];
            [textField becomeFirstResponder];
        }
        else if (currentRow == 10)
        {
            textField.text = [[areaDictionary allKeys]objectAtIndex:[pickerView selectedRowInComponent:0]];
            [valuesArray setObject:[textField text] atIndexedSubscript:currentRow];
            if(isClient)
            {
                SignUpTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                [UIView commitAnimations];
                NSIndexPath *scrollip = [NSIndexPath indexPathForRow:0 inSection:0];
                [SignUpTable scrollToRowAtIndexPath:scrollip atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [textField resignFirstResponder];
            }
            else
            {
                NSIndexPath *NextIP = [NSIndexPath indexPathForRow:11 inSection:0];
                UITextField *nextTextField = (UITextField *)[[[SignUpTable cellForRowAtIndexPath:NextIP]accessoryView] viewWithTag:11];
                [nextTextField becomeFirstResponder];
            }
            
        }
        
    }
}
@end
