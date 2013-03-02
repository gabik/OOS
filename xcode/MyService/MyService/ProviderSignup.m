//
//  ProviderSignup.m
//  MyService
//
//  Created by ohad shultz on 01/03/13.
//  Copyright (c) 2013 ohad kazav. All rights reserved.
//

#import "ProviderSignup.h"
#import <QuartzCore/QuartzCore.h>



@interface ProviderSignup ()

@end

@implementation ProviderSignup
@synthesize SignUpTable;

NSArray *SignUpArray;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SignUpArray = [[NSArray alloc]initWithObjects:@"Business Name",@"Email",@"Password",@"Verify Password",@"First Name",@"Last Name",@"Phone Number",@"Extra Phone Number",@"Address",@"area",@"Profession", nil];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return [SignUpArray count];
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
    cell.textLabel.text = [SignUpArray objectAtIndex:indexPath.row];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, (SignUpTable.frame.size.width/2), cell.frame.size.height/2)];
    textField.placeholder = [SignUpArray objectAtIndex:indexPath.row];
    textField.delegate = self;
    [textField setReturnKeyType:UIReturnKeyDone];
    textField.font = [UIFont systemFontOfSize:12];
    textField.textColor = [UIColor blueColor];
    textField.layer.borderColor = [[UIColor whiteColor]CGColor];
    cell.accessoryView = textField;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)   indexPath{
    return ([SignUpTable frame].size.height-20)/[SignUpArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{ 
    SignUpTable.frame = CGRectMake(SignUpTable.frame.origin.x, SignUpTable.frame.origin.y-216,SignUpTable.frame.size.width, SignUpTable.frame.size.height); //resize
    [UIView setAnimationsEnabled:YES];
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField { //keyboard will hide
    SignUpTable.frame = CGRectMake(SignUpTable.frame.origin.x, SignUpTable.frame.origin.y,SignUpTable.frame.size.width, SignUpTable.frame.size.height + 215 - 50); //resize
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end






