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

NSArray *parametersArray;
NSArray *userDetailsArray;
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
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Signup!"
                                                                    style:UIBarButtonSystemItemDone target:self action:@selector(postSignUp)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(void)postSignUp
{
    //TODO: create userDetailsArray.
    //
    
    BOOL signUpUser = [DAL userSignup:userDetailsArray parametersArray:parametersArray];
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
        float hightDiff = currentPosition-keyboardPosition;
        SignUpTable.frame = CGRectMake(SignUpTable.frame.origin.x, SignUpTable.frame.origin.y-hightDiff, SignUpTable.frame.size.width, SignUpTable.frame.size.height);
        [UIView commitAnimations];
    }
    else
    {
        SignUpTable.frame = CGRectMake(SignUpTable.frame.origin.x, 0, SignUpTable.frame.size.width, SignUpTable.frame.size.height);
        [UIView commitAnimations];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
